Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A184C6E85
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiB1Nti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbiB1Nth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:49:37 -0500
Received: from bergelmir.uberspace.de (bergelmir.uberspace.de [185.26.156.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B7C45527
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:48:57 -0800 (PST)
Received: (qmail 9341 invoked by uid 989); 28 Feb 2022 13:48:56 -0000
Authentication-Results: bergelmir.uberspace.de;
        auth=pass (plain)
From:   Daniel Braunwarth <daniel@braunwarth.dev>
To:     netdev@vger.kernel.org
Cc:     daniel@braunwarth.dev
Subject: [PATCH iproute2-next 2/2] tc: bash-completion: Add profinet and ethercat to procotol completion list
Date:   Mon, 28 Feb 2022 14:45:20 +0100
Message-Id: <20220228134520.118589-3-daniel@braunwarth.dev>
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

Add the 'profinet' and 'ethercat' protocols to bash completion.

Signed-off-by: Daniel Braunwarth <daniel@braunwarth.dev>
---
 bash-completion/tc | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/bash-completion/tc b/bash-completion/tc
index 086cb7f6..9f16d0d4 100644
--- a/bash-completion/tc
+++ b/bash-completion/tc
@@ -127,10 +127,10 @@ _tc_direct_complete()
         protocol) # list comes from lib/ll_proto.c
             COMPREPLY+=( $( compgen -W ' 802.1Q 802.1ad 802_2 802_3 LLDP aarp \
                 all aoe arp atalk atmfate atmmpoa ax25 bpq can control cust \
-                ddcmp dec diag dna_dl dna_rc dna_rt econet ieeepup ieeepupat \
-                ip ipv4 ipv6 ipx irda lat localtalk loop mobitex ppp_disc \
-                ppp_mp ppp_ses ppptalk pup pupat rarp sca snap tipc tr_802_2 \
-                wan_ppp x25' -- "$cur" ) )
+                ddcmp dec diag dna_dl dna_rc dna_rt econet ethercat ieeepup \
+                ieeepupat ip ipv4 ipv6 ipx irda lat localtalk loop mobitex \
+                ppp_disc ppp_mp ppp_ses ppptalk profinet pup pupat rarp sca \
+                snap tipc tr_802_2 wan_ppp x25' -- "$cur" ) )
             return 0
             ;;
         prio)
--
2.35.1
