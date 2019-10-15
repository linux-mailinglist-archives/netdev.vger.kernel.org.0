Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F71D7A17
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 17:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733237AbfJOPny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 11:43:54 -0400
Received: from fourcot.fr ([217.70.191.14]:37546 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbfJOPnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 11:43:53 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 11:43:53 EDT
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        Romain Bellan <romain.bellan@wifirst.fr>
Subject: [PATCH iproute2] man: remove "defaut group" sentence on ip link
Date:   Tue, 15 Oct 2019 17:35:50 +0200
Message-Id: <20191015153550.29010-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, all devices are listed, not only the default group.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
---
 man/man8/ip-link.8.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d2..31051c52 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2364,7 +2364,6 @@ Commands:
 .BI dev " NAME " (default)
 .I NAME
 specifies the network device to show.
-If this argument is omitted all devices in the default group are listed.
 
 .TP
 .BI group " GROUP "
-- 
2.20.1

