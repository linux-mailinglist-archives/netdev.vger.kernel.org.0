Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8234C6E71
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiB1Nl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiB1Nly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:41:54 -0500
Received: from bergelmir.uberspace.de (bergelmir.uberspace.de [185.26.156.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C417CDC7
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:41:13 -0800 (PST)
Received: (qmail 32099 invoked by uid 989); 28 Feb 2022 13:34:30 -0000
Authentication-Results: bergelmir.uberspace.de;
        auth=pass (plain)
From:   Daniel Braunwarth <daniel@braunwarth.dev>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, daniel@braunwarth.dev
Subject: [PATCH net-next 1/2] if_ether.h: add PROFINET Ethertype
Date:   Mon, 28 Feb 2022 14:30:28 +0100
Message-Id: <20220228133029.100913-2-daniel@braunwarth.dev>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228133029.100913-1-daniel@braunwarth.dev>
References: <20220228133029.100913-1-daniel@braunwarth.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999999)
X-Rspamd-Score: -5.599999
Received: from unknown (HELO unkown) (::1)
        by bergelmir.uberspace.de (Haraka/2.8.28) with ESMTPSA; Mon, 28 Feb 2022 14:34:30 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Ethertype for PROFINET protocol.

Signed-off-by: Daniel Braunwarth <daniel@braunwarth.dev>
---
 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index c0c2f3ed5729..4f4ed35a16db 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -86,6 +86,7 @@
 					 * over Ethernet
 					 */
 #define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
+#define ETH_P_PROFINET	0x8892		/* PROFINET			*/
 #define ETH_P_REALTEK	0x8899          /* Multiple proprietary protocols */
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_8021AD	0x88A8          /* 802.1ad Service VLAN		*/
--
2.35.1
