Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19D50DC57
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiDYJVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiDYJTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:19:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB86122513;
        Mon, 25 Apr 2022 02:16:35 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Mon, 25 Apr 2022 11:16:27 +0200
Message-Id: <20220425091631.109320-1-pablo@netfilter.org>
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

1) Fix incorrect printing of memory size of IPVS connection hash table,
   from Pengcheng Yang.

2) Fix spurious EEXIST errors in nft_set_rbtree.

3) Remove leftover empty flowtable file, from  Rongguang Wei.

4) Fix ip6_route_me_harder() with vrf driver, from Martin Willi.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 4cf35a2b627a020fe1a6b6fc7a6a12394644e474:

  net: mscc: ocelot: fix broken IP multicast flooding (2022-04-19 10:33:33 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 8ddffdb9442a9d60b4a6e679ac48d7d21403a674:

  netfilter: Update ip6_route_me_harder to consider L3 domain (2022-04-25 11:09:20 +0200)

----------------------------------------------------------------
Martin Willi (1):
      netfilter: Update ip6_route_me_harder to consider L3 domain

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion

Pengcheng Yang (1):
      ipvs: correctly print the memory size of ip_vs_conn_tab

Rongguang Wei (1):
      netfilter: flowtable: Remove the empty file

 net/ipv4/netfilter/nf_flow_table_ipv4.c |  0
 net/ipv6/netfilter.c                    | 10 ++++++++--
 net/netfilter/ipvs/ip_vs_conn.c         |  2 +-
 net/netfilter/nft_set_rbtree.c          |  6 +++++-
 4 files changed, 14 insertions(+), 4 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
