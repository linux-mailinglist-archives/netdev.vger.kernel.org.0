Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9987E4C6E84
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiB1Nth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiB1Ntg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:49:36 -0500
Received: from bergelmir.uberspace.de (bergelmir.uberspace.de [185.26.156.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD13045512
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:48:57 -0800 (PST)
Received: (qmail 9333 invoked by uid 989); 28 Feb 2022 13:48:56 -0000
Authentication-Results: bergelmir.uberspace.de;
        auth=pass (plain)
From:   Daniel Braunwarth <daniel@braunwarth.dev>
To:     netdev@vger.kernel.org
Cc:     daniel@braunwarth.dev
Subject: [PATCH iproute2-next 1/2] lib: add profinet and ethercat as link layer protocol names
Date:   Mon, 28 Feb 2022 14:45:19 +0100
Message-Id: <20220228134520.118589-2-daniel@braunwarth.dev>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228134520.118589-1-daniel@braunwarth.dev>
References: <20220228134520.118589-1-daniel@braunwarth.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999999)
X-Rspamd-Score: -5.599999
Received: from unknown (HELO unkown) (::1)
        by bergelmir.uberspace.de (Haraka/2.8.28) with ESMTPSA; Mon, 28 Feb 2022 14:48:56 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the llproto_names array to allow users to reference the PROFINET
and EtherCAT protocols with the names 'profinet' and 'ethercat'.

Signed-off-by: Daniel Braunwarth <daniel@braunwarth.dev>
---
 lib/ll_proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 78179311..342ea2ee 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -75,7 +75,9 @@ __PF(CONTROL,control)
 __PF(IRDA,irda)
 __PF(ECONET,econet)
 __PF(TIPC,tipc)
+__PF(PROFINET,profinet)
 __PF(AOE,aoe)
+__PF(ETHERCAT,ethercat)
 __PF(8021Q,802.1Q)
 __PF(8021AD,802.1ad)
 __PF(MPLS_UC,mpls_uc)
--
2.35.1
