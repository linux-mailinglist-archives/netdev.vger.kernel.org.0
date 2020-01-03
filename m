Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CB912F1FC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgACAIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:08:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:08:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B8B6157150B1
        for <netdev@vger.kernel.org>; Thu,  2 Jan 2020 16:08:19 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:08:18 -0800 (PST)
Message-Id: <20200102.160818.1273976528943190177.davem@davemloft.net>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: Correct type of tcp_syncookies sysctl.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:08:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


It can take on the values of '0', '1', and '2' and thus
is not a boolean.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 Documentation/networking/ip-sysctl.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Applied and pushed out to 'net'.

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index fd26788e8c96..48ccb1b31160 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -603,7 +603,7 @@ tcp_synack_retries - INTEGER
 	with the current initial RTO of 1second. With this the final timeout
 	for a passive TCP connection will happen after 63seconds.
 
-tcp_syncookies - BOOLEAN
+tcp_syncookies - INTEGER
 	Only valid when the kernel was compiled with CONFIG_SYN_COOKIES
 	Send out syncookies when the syn backlog queue of a socket
 	overflows. This is to prevent against the common 'SYN flood attack'
-- 
2.20.1

