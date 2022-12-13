Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39F564B6EB
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiLMOKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiLMOJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:09:57 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D727121267;
        Tue, 13 Dec 2022 06:09:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter/IPVS fixes for net
Date:   Tue, 13 Dec 2022 15:09:20 +0100
Message-Id: <20221213140923.154594-1-pablo@netfilter.org>
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

The following patchset contains fixes for Netfilter/IPVS:

1) Fix NAT IPv6 flowtable hardware offload, from Qingfang DENG.

2) Add a safety check to IPVS socket option interface report a
   warning if unsupported command is seen, this. From Li Qiong.

3) Document SCTP conntrack timeouts, from Sriram Yagnaraman.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f8bac7f9fdb0017b32157957ffffd490f95faa07:

  net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing() (2022-12-08 09:38:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to f9645abe4255bd79e4c63799634c996dd53db321:

  netfilter: conntrack: document sctp timeouts (2022-12-13 12:25:45 +0100)

----------------------------------------------------------------
Li Qiong (1):
      ipvs: add a 'default' case in do_ip_vs_set_ctl()

Qingfang DENG (1):
      netfilter: flowtable: really fix NAT IPv6 offload

Sriram Yagnaraman (1):
      netfilter: conntrack: document sctp timeouts

 Documentation/networking/nf_conntrack-sysctl.rst | 33 ++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_ctl.c                   |  5 ++++
 net/netfilter/nf_flow_table_offload.c            |  6 ++---
 3 files changed, 41 insertions(+), 3 deletions(-)
