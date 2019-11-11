Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4112BF8380
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKKXel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:34:41 -0500
Received: from correo.us.es ([193.147.175.20]:42968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfKKXel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:34:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F7172A2BC5
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72A74D1DBB
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:34:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 685CC66DC; Tue, 12 Nov 2019 00:34:37 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 859D2DA72F;
        Tue, 12 Nov 2019 00:34:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:34:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3DA6F42EF4E0;
        Tue, 12 Nov 2019 00:34:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeedm@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 0/7] netfilter flowtable hardware offload support
Date:   Tue, 12 Nov 2019 00:34:23 +0100
Message-Id: <20191111233430.25120-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

This patchset updates the mlx5 driver to support for the netfilter
flowtable hardware offload from Paul Blakey.

Please review and apply if you're fine with this.

Thank you.

Paul Blakey (7):
  net/mlx5: Simplify fdb chain and prio eswitch defines
  net/mlx5: Rename FDB_* tc related defines to FDB_TC_* defines
  net/mlx5: Define fdb tc levels per prio
  net/mlx5: Accumulate levels for chains prio namespaces
  net/mlx5: Refactor creating fast path prio chains
  net/mlx5: Add new chain for netfilter flow table offload
  net/mlx5: TC: Offload flow table rules

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  45 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  32 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  21 ++--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 129 +++++++++++++++------
 include/linux/mlx5/fs.h                            |   3 +-
 7 files changed, 185 insertions(+), 58 deletions(-)

-- 
2.11.0

