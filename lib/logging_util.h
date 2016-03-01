/******************************************************************************
 * Copyright (C) 2016 Kitsune Ral <kitsune-ral@users.sf.net>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

/**
 * @file logging_util.h - a collection of utilities to facilitate debug logging.
 */

#pragma once

#include <QtCore/QDebug>

namespace QMatrixClient {

// Check-and-log/Log-if-not stuff

/**
 * Checks the condition and logs to os if the condition holds.
 *
 * Checks the condition exactly once.
 * Works with any stream that has operator<<()
 * Non-reentrant if condition is non-reentrant.
 * @return the result of the condition check.
 */
template <typename _ScopeStrT, typename _LogStrT, typename _OutputStreamT>
inline bool check_and_log(bool condition, _ScopeStrT scope,
                          _LogStrT log_str, _OutputStreamT os )
{
    if (condition)
    {
        os << scope << log_str;
        return true;
    }
    return false;
}

/**
 * Checks the condition and logs to log_object if it holds.
 * if ( CHECK_AND_LOG(qDebug(), 0 < 1) )
 * {
 *   // condition holds
 * }
 * See check_and_log() for details.
 */
#define CHECK_AND_LOG(log_object, cond) \
    QMatrixClient::check_and_log( \
        (cond), __func__, " assertion failed: " #cond, (log_object) )

// QDebug manipulators

using QDebugManip = QDebug (*)(QDebug);

/**
 * @brief QDebug manipulator to setup the stream for JSON output.
 *
 * Originally made to encapsulate the change in QDebug behavior in Qt 5.4
 * and the respective addition of QDebug::noquote().
 * Together with the operator<<() helper, the proposed usage is
 * (similar to std:: I/O manipulators):
 *
 * @example qDebug() << formatJson << json_object; // (QJsonObject, or QJsonValue, etc.)
 */
static QDebugManip formatJson = [](QDebug debug_object) {
#if QT_VERSION < QT_VERSION_CHECK(5, 4, 0)
        return debug_object;
#else
        return debug_object.noquote();
#endif
    };

/**
 * @brief A helper operator to facilitate using formatJson (and possibly other manipulators)
 *
 * @param debug_object to output the json to
 * @param qdm a QDebug manipulator
 * @return a copy of debug_object that has its mode altered by qdm
 */
inline QDebug operator<< (QDebug debug_object, QDebugManip qdm) {
    return qdm(debug_object);
}

}

