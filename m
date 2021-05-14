Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322FC380C37
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhENOua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:50:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35210 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbhENOu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:50:28 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1399964151;
        Fri, 14 May 2021 16:48:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf 0/2] Netfilter fixes for net
Date:   Fri, 14 May 2021 16:49:10 +0200
Message-Id: <20210514144912.4519-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Remove the flowtable hardware refresh state, fall back to the
   existing hardware pending state instead, from Roi Dayan.

2) Fix crash in pipapo avx2 lookup when FPU is in used from user
   context, from Stefano Brivio.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit e4df1b0c24350a0f00229ff895a91f1072bd850d:

  openvswitch: meter: fix race when getting now_ms. (2021-05-13 15:54:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to f0b3d338064e1fe7531f0d2977e35f3b334abfb4:

  netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version (2021-05-14 01:42:52 +0200)

----------------------------------------------------------------
Roi Dayan (1):
      netfilter: flowtable: Remove redundant hw refresh bit

Stefano Brivio (1):
      netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version

 include/net/netfilter/nf_flow_table.h | 1 -
 net/netfilter/nf_flow_table_core.c    | 3 +--
 net/netfilter/nf_flow_table_offload.c | 7 ++++---
 net/netfilter/nft_set_pipapo.c        | 4 ++--
 net/netfilter/nft_set_pipapo.h        | 2 ++
 net/netfilter/nft_set_pipapo_avx2.c   | 3 +++
 6 files changed, 12 insertions(+), 8 deletions(-)
