Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6EC4DCF4E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiCQU05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiCQU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:26:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D92941546A1;
        Thu, 17 Mar 2022 13:25:38 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CE85760196;
        Thu, 17 Mar 2022 21:23:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Thu, 17 Mar 2022 21:25:31 +0100
Message-Id: <20220317202534.41530-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix PPPoE and QinQ with flowtable inet family.

2) Missing register validation in nf_tables.

3) Initialize registers to avoid stack memleak to userspace.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit dea2d93a8ba437460c5f21bdfa4ada57fa1d2179:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2022-03-16 10:07:43 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 4c905f6740a365464e91467aa50916555b28213d:

  netfilter: nf_tables: initialize registers in nft_do_chain() (2022-03-17 15:50:27 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: flowtable: Fix QinQ and pppoe support for inet table
      netfilter: nf_tables: validate registers coming from userspace.
      netfilter: nf_tables: initialize registers in nft_do_chain()

 include/net/netfilter/nf_flow_table.h | 18 ++++++++++++++++++
 net/netfilter/nf_flow_table_inet.c    | 17 +++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      | 18 ------------------
 net/netfilter/nf_tables_api.c         | 22 +++++++++++++++++-----
 net/netfilter/nf_tables_core.c        |  2 +-
 5 files changed, 53 insertions(+), 24 deletions(-)
