Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E05E13AC36
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgANOYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:24:06 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49798 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgANOXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:23:55 -0500
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id ED8146206C;
        Tue, 14 Jan 2020 15:23:52 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/7] batman-adv: Strip dots from variable macro kerneldoc
Date:   Tue, 14 Jan 2020 15:23:46 +0100
Message-Id: <20200114142351.26622-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114142351.26622-1-sw@simonwunderlich.de>
References: <20200114142351.26622-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit 43756e347f21 ("scripts/kernel-doc: Add support for named
variable macro arguments") changed the handling of variable macro
parameters. The three dots of the argument must no longer be added to the
kernel doc. The support for the old format is scheduled to be removed in
the future.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/log.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/log.h b/net/batman-adv/log.h
index 741cfa3719ff..41fd900121c5 100644
--- a/net/batman-adv/log.h
+++ b/net/batman-adv/log.h
@@ -74,7 +74,7 @@ __printf(2, 3);
  * @bat_priv: the bat priv with all the soft interface information
  * @ratelimited: whether output should be rate limited
  * @fmt: format string
- * @arg...: variable arguments
+ * @arg: variable arguments
  */
 #define _batadv_dbg(type, bat_priv, ratelimited, fmt, arg...)		\
 	do {								\
@@ -98,7 +98,7 @@ static inline void _batadv_dbg(int type __always_unused,
  * batadv_dbg() - Store debug output without ratelimiting
  * @type: type of debug message
  * @bat_priv: the bat priv with all the soft interface information
- * @arg...: format string and variable arguments
+ * @arg: format string and variable arguments
  */
 #define batadv_dbg(type, bat_priv, arg...) \
 	_batadv_dbg(type, bat_priv, 0, ## arg)
@@ -107,7 +107,7 @@ static inline void _batadv_dbg(int type __always_unused,
  * batadv_dbg_ratelimited() - Store debug output with ratelimiting
  * @type: type of debug message
  * @bat_priv: the bat priv with all the soft interface information
- * @arg...: format string and variable arguments
+ * @arg: format string and variable arguments
  */
 #define batadv_dbg_ratelimited(type, bat_priv, arg...) \
 	_batadv_dbg(type, bat_priv, 1, ## arg)
@@ -116,7 +116,7 @@ static inline void _batadv_dbg(int type __always_unused,
  * batadv_info() - Store message in debug buffer and print it to kmsg buffer
  * @net_dev: the soft interface net device
  * @fmt: format string
- * @arg...: variable arguments
+ * @arg: variable arguments
  */
 #define batadv_info(net_dev, fmt, arg...)				\
 	do {								\
@@ -130,7 +130,7 @@ static inline void _batadv_dbg(int type __always_unused,
  * batadv_err() - Store error in debug buffer and print it to kmsg buffer
  * @net_dev: the soft interface net device
  * @fmt: format string
- * @arg...: variable arguments
+ * @arg: variable arguments
  */
 #define batadv_err(net_dev, fmt, arg...)				\
 	do {								\
-- 
2.20.1

