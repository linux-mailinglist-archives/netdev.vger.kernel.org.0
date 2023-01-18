Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2399C67199C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjARKtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjARKsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:48:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C13032E0EA;
        Wed, 18 Jan 2023 01:54:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/1] Netfilter fixes for net
Date:   Wed, 18 Jan 2023 10:54:23 +0100
Message-Id: <20230118095424.885014-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix syn-retransmits until initiator gives up when connection is re-used
   due to rst marked as invalid, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1f3bd64ad921f051254591fbed04fd30b306cde6:

  net: stmmac: fix invalid call to mdiobus_get_phy() (2023-01-17 13:33:19 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c410cb974f2ba562920ecb8492ee66945dcf88af:

  netfilter: conntrack: handle tcp challenge acks during connection reuse (2023-01-17 23:00:06 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: handle tcp challenge acks during connection reuse

 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
