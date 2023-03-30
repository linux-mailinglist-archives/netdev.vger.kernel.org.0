Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4F6D1001
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjC3U3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjC3U3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:29:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E8610AB5;
        Thu, 30 Mar 2023 13:29:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1phyu0-0000hS-Dv; Thu, 30 Mar 2023 22:29:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Matthieu De Beule <matthieu.debeule@proton.ch>
Subject: [PATCH net-next 3/4] netfilter: Correct documentation errors in nf_tables.h
Date:   Thu, 30 Mar 2023 22:29:27 +0200
Message-Id: <20230330202928.28705-4-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330202928.28705-1-fw@strlen.de>
References: <20230330202928.28705-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu De Beule <matthieu.debeule@proton.ch>

NFTA_RANGE_OP incorrectly says nft_cmp_ops instead of nft_range_ops.
NFTA_LOG_GROUP and NFTA_LOG_QTHRESHOLD claim NLA_U32 instead of NLA_U16
NFTA_EXTHDR_SREG isn't documented as a register

Signed-off-by: Matthieu De Beule <matthieu.debeule@proton.ch>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c6f02c26054..c4d4d8e42dc8 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -685,7 +685,7 @@ enum nft_range_ops {
  * enum nft_range_attributes - nf_tables range expression netlink attributes
  *
  * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
- * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_range_ops)
  * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
  * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
  */
@@ -878,7 +878,7 @@ enum nft_exthdr_op {
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
  * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  * @NFTA_EXTHDR_OP: option match type (NLA_U32)
- * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
+ * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -1262,10 +1262,10 @@ enum nft_last_attributes {
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
- * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
+ * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U16)
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
- * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U16)
  * @NFTA_LOG_LEVEL: log level (NLA_U32)
  * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
-- 
2.39.2

