Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769D5D7029
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfJOHc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:32:59 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOHc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:32:59 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 7423825B818;
        Tue, 15 Oct 2019 18:32:54 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 6BF3AE2046E; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
Subject: [PATCH 0/6] [GIT PULL ipvs-next] IPVS updates for v5.5
Date:   Tue, 15 Oct 2019 09:32:06 +0200
Message-Id: <20191015073212.19394-1-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

Please consider these IPVS updates for v5.5.

As there are a few more changes than usual I'm sending a pull request
rather than asking you to apply the patches directly.

This pull request is based on nf-next.

The following changes since commit f8615bf8a3dabd84bf844c6f888929495039d389:

  netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c. (2019-10-07 23:59:02 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git tags/ipvs-next-for-v5.5

for you to fetch changes up to 176a52043ab853f1db7581ed02e1096aba78b4d1:

  selftests: netfilter: add ipvs tunnel test case (2019-10-11 10:05:27 +0200)

----------------------------------------------------------------
Haishuang Yan (5):
      ipvs: batch __ip_vs_cleanup
      ipvs: batch __ip_vs_dev_cleanup
      selftests: netfilter: add ipvs test script
      selftests: netfilter: add ipvs nat test case
      selftests: netfilter: add ipvs tunnel test case

zhang kai (1):
      ipvs: no need to update skb route entry for local destination packets.

 include/net/ip_vs.h                        |   2 +-
 net/netfilter/ipvs/ip_vs_core.c            |  47 +++---
 net/netfilter/ipvs/ip_vs_ctl.c             |  12 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |  18 +--
 tools/testing/selftests/netfilter/Makefile |   2 +-
 tools/testing/selftests/netfilter/ipvs.sh  | 228 +++++++++++++++++++++++++++++
 6 files changed, 273 insertions(+), 36 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/ipvs.sh

-- 
2.11.0

