Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAC26E78B2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjDSLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjDSLel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:34:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1531C46BB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A44C360BEB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 11:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0C5C433EF;
        Wed, 19 Apr 2023 11:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681904079;
        bh=HZEcRywYRBWfrFdk+b/Phc6ph9u6Z/BHZ1i9KYGEY5k=;
        h=From:Date:Subject:To:Cc:From;
        b=NryuTitG3qWfsn2JKRwrnFIAQb/WpeLryqB+9juYfofYHM0Hjm0Rdx5mgeJ7ZGaHT
         jbUGqymB/tHtn7G7v7bE4g1HTNcya/gBNmO7uFT6e05qYN6RSBE2NUzO0qL2LLF8HQ
         kM5HOyWL4La4P5Xi2lxWdBBiCN5OFJyjqJ6RPcGca9f+dOLeZ/jlva2fT1IORiAYwN
         bhUzg3OsKNFEMFzfA3Ph+6wswX2pqAAH9RaOMF7kdP0qiiNLY5sG15n50VRgF2kr0e
         RTaF4f2WF79c41nB3hYaHiv1xvCp57+rFy8IXSuqb958J55AKK2GIYJiMjP14Fxw9/
         u4WOselH9GO/w==
From:   Simon Horman <horms@kernel.org>
Date:   Wed, 19 Apr 2023 13:34:35 +0200
Subject: [PATCH net-next] flow_dissector: Address kdoc warnings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230419-flow-dissector-kdoc-v1-1-1aa0cca1118b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMrRP2QC/x2NQQrCMBAAv1L27EIa9VC/Ih7SZGMXw0ayqRZK/
 +7icQaG2UGpMSnchh0afVi5isF4GiAuQZ6EnIzBO392l3HCXOoXE6tS7LXhK9WI3k35mlMKPge
 wcg5KOLcgcbFW1lJMvhtl3v6rOwh1FNo6PI7jB4LJ4QyEAAAA
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jon Maloy <jmaloy@redhat.com>, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address a number of warnings flagged by
./scripts/kernel-doc -none include/net/flow_dissector.h

 include/net/flow_dissector.h:23: warning: Function parameter or member 'addr_type' not described in 'flow_dissector_key_control'
 include/net/flow_dissector.h:23: warning: Function parameter or member 'flags' not described in 'flow_dissector_key_control'
 include/net/flow_dissector.h:46: warning: Function parameter or member 'padding' not described in 'flow_dissector_key_basic'
 include/net/flow_dissector.h:145: warning: Function parameter or member 'tipckey' not described in 'flow_dissector_key_addrs'
 include/net/flow_dissector.h:157: warning: cannot understand function prototype: 'struct flow_dissector_key_arp '
 include/net/flow_dissector.h:171: warning: cannot understand function prototype: 'struct flow_dissector_key_ports '
 include/net/flow_dissector.h:203: warning: cannot understand function prototype: 'struct flow_dissector_key_icmp '

Also improve indentation on adjacent lines to those changed
to address the above.

No functional changes intended.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/net/flow_dissector.h | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 5ccf52ef8809..85b2281576ed 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -14,7 +14,9 @@ struct sk_buff;
 
 /**
  * struct flow_dissector_key_control:
- * @thoff: Transport header offset
+ * @thoff:     Transport header offset
+ * @addr_type: Type of key. One of FLOW_DISSECTOR_KEY_*
+ * @flags:     Key flags. Any of FLOW_DIS_(IS_FRAGMENT|FIRST_FRAGENCAPSULATION)
  */
 struct flow_dissector_key_control {
 	u16	thoff;
@@ -36,8 +38,9 @@ enum flow_dissect_ret {
 
 /**
  * struct flow_dissector_key_basic:
- * @n_proto: Network header protocol (eg. IPv4/IPv6)
+ * @n_proto:  Network header protocol (eg. IPv4/IPv6)
  * @ip_proto: Transport header protocol (eg. TCP/UDP)
+ * @padding:  Unused
  */
 struct flow_dissector_key_basic {
 	__be16	n_proto;
@@ -135,6 +138,7 @@ struct flow_dissector_key_tipc {
  * struct flow_dissector_key_addrs:
  * @v4addrs: IPv4 addresses
  * @v6addrs: IPv6 addresses
+ * @tipckey: TIPC key
  */
 struct flow_dissector_key_addrs {
 	union {
@@ -145,14 +149,12 @@ struct flow_dissector_key_addrs {
 };
 
 /**
- * flow_dissector_key_arp:
- *	@ports: Operation, source and target addresses for an ARP header
- *              for Ethernet hardware addresses and IPv4 protocol addresses
- *		sip: Sender IP address
- *		tip: Target IP address
- *		op:  Operation
- *		sha: Sender hardware address
- *		tpa: Target hardware address
+ * struct flow_dissector_key_arp:
+ * @sip: Sender IP address
+ * @tip: Target IP address
+ * @op:  Operation
+ * @sha: Sender hardware address
+ * @tha: Target hardware address
  */
 struct flow_dissector_key_arp {
 	__u32 sip;
@@ -163,10 +165,10 @@ struct flow_dissector_key_arp {
 };
 
 /**
- * flow_dissector_key_tp_ports:
- *	@ports: port numbers of Transport header
- *		src: source port number
- *		dst: destination port number
+ * struct flow_dissector_key_ports:
+ * @ports: port numbers of Transport header
+ * @src: source port number
+ * @dst: destination port number
  */
 struct flow_dissector_key_ports {
 	union {
@@ -195,10 +197,10 @@ struct flow_dissector_key_ports_range {
 };
 
 /**
- * flow_dissector_key_icmp:
- *		type: ICMP type
- *		code: ICMP code
- *		id:   session identifier
+ * struct flow_dissector_key_icmp:
+ * @type: ICMP type
+ * @code: ICMP code
+ * @id:   Session identifier
  */
 struct flow_dissector_key_icmp {
 	struct {

