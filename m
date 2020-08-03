Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98B223A3AC
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgHCL5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:41816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgHCL5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 12538AC65
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BDD4A60754; Mon,  3 Aug 2020 13:57:15 +0200 (CEST)
Message-Id: <b16cb1bdbaf73daa7df02d7945697eb69b55f789.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 4/7] netlink: mark unused callback parameter
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:15 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function nomsg_reply_cb() is used as a callback for mnl_cb_run() but it
does not use its data parameter; mark it as unused to get rid of compiler
warning.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index 17b7788600d0..76b6e825b1d0 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -16,7 +16,7 @@
 /* Used as reply callback for requests where no reply is expected (e.g. most
  * "set" type commands)
  */
-int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data __maybe_unused)
 {
 	const struct genlmsghdr *ghdr = (const struct genlmsghdr *)(nlhdr + 1);
 
-- 
2.28.0

