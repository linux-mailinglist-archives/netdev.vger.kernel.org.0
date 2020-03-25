Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559A3192999
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCYN1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:27:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38213 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726842AbgCYN1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:27:01 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 25 Mar 2020 15:26:58 +0200
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02PDQwW3010156;
        Wed, 25 Mar 2020 15:26:58 +0200
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next 0/2] Devlink health auto attributes refactor
Date:   Wed, 25 Mar 2020 15:26:22 +0200
Message-Id: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactors the auto-recover health reporter flag to be
explicitly set by the devlink core.
In addition, add another flag to control auto-dump attribute, also
to be explicitly set by the devlink core.

After reporter registration, both flags can be altered be administrator
only.

Eran Ben Elisha (2):
  devlink: Implicitly set auto recover flag when registering health
    reporter
  devlink: Add auto dump flag to health reporter

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  6 ++--
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  4 +--
 drivers/net/netdevsim/health.c                |  4 +--
 include/net/devlink.h                         |  3 +-
 include/uapi/linux/devlink.h                  |  2 ++
 net/core/devlink.c                            | 35 +++++++++++++------
 8 files changed, 37 insertions(+), 21 deletions(-)

-- 
2.17.1

