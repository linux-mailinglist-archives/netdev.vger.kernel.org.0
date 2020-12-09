Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA82D42AB
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732041AbgLINFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58186 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732004AbgLINFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:13 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 9 Dec 2020 15:04:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B9D4KeI022609;
        Wed, 9 Dec 2020 15:04:20 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 0/2] mlx4_en fixes
Date:   Wed,  9 Dec 2020 15:03:37 +0200
Message-Id: <20201209130339.21795-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset by Moshe contains fixes to the mlx4 Eth driver,
addressing issues in restart flow.

Patch 1 protects the restart task from being rescheduled while active.
  Please queue for -stable >= v2.6.
Patch 2 reconstructs SQs stuck in error state, and adds prints for improved
  debuggability.
  Please queue for -stable >= v3.12.

Thanks,
Tariq.


Moshe Shemesh (2):
  net/mlx4_en: Avoid scheduling restart task if it is already running
  net/mlx4_en: Handle TX error CQE

 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 21 ++++++----
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 40 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  | 12 +++++-
 3 files changed, 58 insertions(+), 15 deletions(-)

-- 
2.21.0

