Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A24E4978
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439101AbfJYLM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:12:27 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33356 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJYLM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:12:27 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 164F025B820;
        Fri, 25 Oct 2019 22:12:25 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 71847376C; Fri, 25 Oct 2019 13:12:20 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
Subject: [GIT PULL] IPVS fixes for v5.4
Date:   Fri, 25 Oct 2019 13:12:03 +0200
Message-Id: <20191025111205.30555-1-horms@verge.net.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

please consider these IPVS fixes for v5.4.

* Eric Dumazet resolves a race condition in switching the defense level

* Davide Caratti resolves a race condition in module removal

This pull request is based on nf.


The following changes since commit 085461c8976e6cb4d5b608a7b7062f394c51a253:

  netfilter: nf_tables_offload: restore basechain deletion (2019-10-23 13:14:50 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git tags/ipvs-fixes-for-v5.4

for you to fetch changes up to c24b75e0f9239e78105f81c5f03a751641eb07ef:

  ipvs: move old_secure_tcp into struct netns_ipvs (2019-10-24 11:56:02 +0200)

----------------------------------------------------------------
Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Eric Dumazet (1):
      ipvs: move old_secure_tcp into struct netns_ipvs

 include/net/ip_vs.h              |  1 +
 net/netfilter/ipvs/ip_vs_app.c   | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 29 +++++++++++------------------
 net/netfilter/ipvs/ip_vs_pe.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c  | 13 ++++++++++---
 6 files changed, 36 insertions(+), 25 deletions(-)
