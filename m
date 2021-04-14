Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059D835FE51
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhDNXQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhDNXQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BABD6121E;
        Wed, 14 Apr 2021 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442171;
        bh=EUe8qvPKyH7h1DhQS1eEwvbghGk2uIgrjw607hzltVg=;
        h=From:To:Cc:Subject:Date:From;
        b=kGYex+lA6/F/uPDRTsc3juxVOsJBgBUmXFX3B1rDxh6ssYSdy56Udz+MbPrJBb8hD
         PnkQh5Mqr4XWZSjOM9WQn2emeuq0h2nr1MhvrUXQFH8V3tJLHUV/a9UCHXW6P9Cenm
         00dPsxlZVZ/I2SBb3nKgh1p252h2nJQisSoPJftGBHSPrwAQI8zh2Ns6f+YwcS/fOi
         7RWJI/S5b4ALZaW+LOSC6CNlmLW33ZYyiRm7PN47zFT/QIvi0AKPVsIZFkAFsKniIJ
         0H81C6sU0n14dLgbVRRJv8XNJ261zmw9jqS9yYrpqnfoLTfSKpi9PmhECXT9s+HDiv
         05sDVXuEci3cQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/3] mlx5 fixes 2021-04-14
Date:   Wed, 14 Apr 2021 16:16:07 -0700
Message-Id: <20210414231610.136376-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi  Dave, Jakub,

This series provides 3 small fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 2afeec08ab5c86ae21952151f726bfe184f6b23d:

  xen-netback: Check for hotplug-status existence before watching (2021-04-13 15:24:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-04-14

for you to fetch changes up to e3e0f9b279705154b951d579dc3d8b7041710e24:

  net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta (2021-04-14 16:13:00 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-04-14

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Fix setting of devlink traps in switchdev mode
      net/mlx5e: Fix setting of RS FEC mode

wenxu (1):
      net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 23 ++++-------------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   |  3 +++
 3 files changed, 12 insertions(+), 19 deletions(-)
