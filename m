Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689C43DA3BD
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbhG2NSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237407AbhG2NR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 09:17:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A652160230;
        Thu, 29 Jul 2021 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627564675;
        bh=657q3Ny5GNsQEvrnZwjQv2SsH7ghWBvOM5beSTWCFis=;
        h=From:To:Cc:Subject:Date:From;
        b=edYl6vSNTxA5ibh5bUjI13vokD2nM0eAlvDT6JvqgJa7VITT0cMTrSjPMRgxUXnVm
         JRemjZHgHVK9FCu2aY6ox3vl2b0PpsZDzmaYUaHaOKTqv8RW0uVWjhQGYK8DMKFngJ
         Z7sBNwU+ozOG6d67ZWfN1zRKjg2cS/G2ByFnJn70J32TP8b/w71hBFZwYz4J/IrWHO
         2CzXWYhJtLpRIeXOmmwpp+AtoE6FiTuIT+OMd1Lk9H1PLNjsJb2IsjJIRB3YP8H1PA
         7vSF7yyMLaII5rDERz1nm96KA2tQ1peFouWc3TH57tmLYGm1iw2yWDsJ9nKeRCKInW
         Jy8ul8RgrLf0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v1 0/2] Clean devlink net namespace operations
Date:   Thu, 29 Jul 2021 16:17:48 +0300
Message-Id: <cover.1627564383.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Patch 1:
   * Renamed function name
   * Added bool parameter to the notifier function 
 * Patch 2: 
   * added Jiri's ROB and dropped word "RAW" from the comment"
v0: https://lore.kernel.org/lkml/cover.1627545799.git.leonro@nvidia.com

-----------------------------------------------------------------------------
Hi Dave, Jakub and Jiri

This short series continues my work on devlink core code to make devlink
reload less prone to errors and harden it from API abuse.

Despite first patch being a clear fix, I would ask you to apply it to net-next
anyway, because the fixed patch is anyway old and it will help us to eliminate
merge conflicts that will arise for following patches or even for the second one.

Thanks

Leon Romanovsky (2):
  devlink: Break parameter notification sequence to be before/after
    unload/load driver
  devlink: Allocate devlink directly in requested net namespace

 drivers/net/netdevsim/dev.c |  4 +--
 include/net/devlink.h       | 14 ++++++++--
 net/core/devlink.c          | 56 ++++++++++++++++++-------------------
 3 files changed, 41 insertions(+), 33 deletions(-)

-- 
2.31.1

