Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D2F3935CF
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhE0TC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:02:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38812 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhE0TCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:02:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 70BC364502;
        Thu, 27 May 2021 21:00:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/5] Netfilter/IPVS fixes for net
Date:   Thu, 27 May 2021 21:01:10 +0200
Message-Id: <20210527190115.98503-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix incorrect sockopts unregistration from error path,
   from Florian Westphal.

2) A few patches to provide better error reporting when missing kernel
   netfilter options are missing in .config.

3) Fix dormant table flag updates.

4) Memleak in IPVS  when adding service with IP_VS_SVC_F_HASHED flag.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 04c26faa51d1e2fe71cf13c45791f5174c37f986:

  tipc: wait and exit until all work queues are done (2021-05-17 14:07:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 56e4ee82e850026d71223262c07df7d6af3bd872:

  ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service (2021-05-27 13:06:48 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: unregister ipv4 sockopts on error unwind

Julian Anastasov (1):
      ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Pablo Neira Ayuso (3):
      netfilter: nf_tables: missing error reporting for not selected expressions
      netfilter: nf_tables: extended netlink error reporting for chain type
      netfilter: nf_tables: fix table flag updates

 include/net/netfilter/nf_tables.h  |  6 ---
 net/netfilter/ipvs/ip_vs_ctl.c     |  2 +-
 net/netfilter/nf_conntrack_proto.c |  2 +-
 net/netfilter/nf_tables_api.c      | 84 ++++++++++++++++++++++++++------------
 4 files changed, 59 insertions(+), 35 deletions(-)
