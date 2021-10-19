Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42FE4330C2
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhJSIKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40839 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234791AbhJSIKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E9C05C002F;
        Tue, 19 Oct 2021 04:07:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 04:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ObOA/pmvnP3tndzAp
        +LnTgLKrkUrfu34dwPp6qDYcfc=; b=IYA95DFDqXGntWWnOclPahp5w4Es/9yuk
        btkpt0cZl0q3BezEBj2uquc1m1kHSuVvySXpAJVFifN3sywL2lsGGNY3kNV08EJO
        vqHMyEoQ+a9Vmr2VSEAwjaFOoOyDSeDA5u0623Yq7N2YiQPdoDpwHUGcQ0e9eTrR
        +25esXmqWSL5JLT6b1W+d4q7k9BagIObZa6V7ymsODDPXQhxQEZpGmvCbPY1oROH
        XHvYvyYh3ZU9UOgD1iLE/iWhIDriPy/rZUktrpivriPDldEyWw3DScvrMH9RwYgl
        y2EZVx0j9/hyk91KlBsU89/4i0QBbL9LtL9cA7sE90tZrJxty1x7Q==
X-ME-Sender: <xms:3nxuYegQvc6ZBUjffybk3mr0Tw1U3nnnG5IFlN0G1PHSJlIgYorfGg>
    <xme:3nxuYfC-hvHPnIGXuCumJYZcSNL4DG07c9kNNGl_-3XP5lIEnMTveELkjGajJWwfz
    z9txF5z66yHzHw>
X-ME-Received: <xmr:3nxuYWFEiwL-jKKj_yeJQ6FLLT4HHNFaBmCOafU5hWJyMeu9FDxFAC1iF7ku_-9gOd3gKLy-s8tAAyVnPG7EVOXlPDD4cT6mv8aP8xj2700>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3nxuYXSvCqHiIfBe6qaffjGt9grIg5v6DNs7zU8XxulRLCYxgeyZ3A>
    <xmx:3nxuYbywYr56o8zyGl2uw8EvgSK_92PF-Q18g31MgGrBNLscfzzBQA>
    <xmx:3nxuYV7EBDHE5mTPEcc3F10EhIwtcdUThoq3a726YFUwdSXxKXxyuw>
    <xmx:3nxuYSmAsEyozAljApCUNGdIkku_13Nfg2lR2ji6Ka9VbMuJ0Lrq5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:07:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Multi-level qdisc offload
Date:   Tue, 19 Oct 2021 11:07:03 +0300
Message-Id: <20211019080712.705464-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Petr says:

Currently, mlxsw admits for offload a suitable root qdisc, and its
children. Thus up to two levels of hierarchy are offloaded. Often, this is
enough: one can configure TCs with RED and TCs with a shaper on, and can
even see counters for each TC by looking at a qdisc at a sufficiently
shallow position.

While simple, the system has obvious shortcomings. It is not possible to
configure both RED and shaping on one TC. It is not possible to place a
PRIO below root TBF, which would then be offloaded as port shaper. FIFOs
are only offloaded at root or directly below, which is confusing to users,
because RED and TBF of course have their own FIFO.

This patch set lifts assumptions that prevent offloading multi-level qdisc
trees.

In patch #1, offload of a graft operation is added to TBF. Grafts are
issued as another qdisc is linked to the qdisc in question, and give
drivers a chance to react to the linking. The absence of this event was not
a major issue so far, because TBF was not considered classful, which
changes with this patchset.

The codebase currently assumes that ETS and PRIO are the only classful
qdiscs. The following patches gradually lift this assumption.

In patch #2, calculation of traffic class and priomap of a qdisc is fixed.

Patch #3 fixes handling of future FIFOs. Child FIFO qdiscs may be created
and notified before their parent qdisc exists and therefore need special
handling.

Patches #4, #5 and #6 unify, respectively, child destruction, child
grafting, and cleanup of statistics.

Patch #7 adds a function that validates whether a given qdisc topology is
offloadable.

Finally in patch #8, TBF and RED become classful. At this point, FIFO
qdiscs grafted to an offloaded qdisc should always be offloaded.

Patch #9 adds a selftest to verify some offloadable and unoffloadable qdisc
trees.

Petr Machata (9):
  net: sch_tbf: Add a graft command
  mlxsw: spectrum_qdisc: Query tclass / priomap instead of caching it
  mlxsw: spectrum_qdisc: Extract two helpers for handling future FIFOs
  mlxsw: spectrum_qdisc: Destroy children in mlxsw_sp_qdisc_destroy()
  mlxsw: spectrum_qdisc: Unify graft validation
  mlxsw: spectrum_qdisc: Clean stats recursively when priomap changes
  mlxsw: spectrum_qdisc: Validate qdisc topology
  mlxsw: spectrum_qdisc: Make RED, TBF offloads classful
  selftests: mlxsw: Add a test for un/offloadable qdisc trees

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 427 ++++++++++++++----
 include/net/pkt_cls.h                         |   2 +
 net/sched/sch_tbf.c                           |  16 +
 .../drivers/net/mlxsw/sch_offload.sh          | 276 +++++++++++
 4 files changed, 636 insertions(+), 85 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh

-- 
2.31.1

