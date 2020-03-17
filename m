Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC218778A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCQBmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCQBmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 21:42:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BA952051A;
        Tue, 17 Mar 2020 01:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584409365;
        bh=w70Ll+ucb1UibwLZMSCLdQrLXnTlN2ZYWzhzgJAYSD4=;
        h=From:To:Cc:Subject:Date:From;
        b=mbiBGft244mZ8vMsPY0ldmhaK9VtMRHFApPpYyzkolW2bS8PRXJPWW3cT4eBcmktL
         DvJ7tQRea0eAbO5LgehrovKE18Cs2do03mh5setQ6QDX7PcnX5xpc5U3hRFMfsfulK
         MbCtpY1Nu5NsmS9JOWLDhEFVqWnpPJVqo/fGOZV4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, ecree@solarflare.com,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: rename flow_action stats and set NFP type
Date:   Mon, 16 Mar 2020 18:42:10 -0700
Message-Id: <20200317014212.3467451-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Jiri, I hope this is okay with you, I just dropped the "type" from
the helper and value names, and now things should be able to fit
on a line, within 80 characters.

Second patch makes the NFP able to offload DELAYED stats, which
is the type it supports.

Jakub Kicinski (2):
  net: rename flow_action_hw_stats_types* -> flow_action_hw_stats*
  nfp: allow explicitly selected delayed stats

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 10 ++--
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  8 +--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  4 +-
 .../ethernet/netronome/nfp/flower/action.c    |  4 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 .../stmicro/stmmac/stmmac_selftests.c         |  4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  2 +-
 include/net/flow_offload.h                    | 49 +++++++++----------
 net/dsa/slave.c                               |  4 +-
 net/sched/cls_api.c                           |  6 +--
 13 files changed, 49 insertions(+), 52 deletions(-)

-- 
2.24.1

