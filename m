Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3CD431FAC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhJROcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232461AbhJROb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0628260FC3;
        Mon, 18 Oct 2021 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567388;
        bh=sM6/cr/+QAe/6ahXxVerTElmE+dV26tDjzwDcKrMJNE=;
        h=From:To:Cc:Subject:Date:From;
        b=IBOBOrgVRVxZPWNekaiItFIlJMknCa5np2dNKheSxTyJ01rB6x78CKImSikX85GGx
         96Tjla/XsWwz5vm6+M6kEhRqoqV2aWWOldP6GVVi22CQFTuqkNxwLX1F8Gnw1TgGH9
         hBz8M14rFpWoleV9Aertmf0cGatDhQ2rEzqXBhNWLfJ79j32pCYmI7LGpunR4nmRkm
         yQb2fQAWn6ALgYQq1AP3uFyOapsKuCGFpIVXblOmySu1tNEpqxkafBF7W+qU+HYHzt
         7UUGbNh0EmnvLm+uBiSdWnjZhYGJJ4l1QKoduHdcIBlkEQjCy32FZ8Rpr1xAdQjsX9
         c4aO6AexrZRYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] ethernet: manual netdev->dev_addr conversions (part 2)
Date:   Mon, 18 Oct 2021 07:29:20 -0700
Message-Id: <20211018142932.1000613-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manual conversions of Ethernet drivers writing directly
to netdev->dev_addr (part 2 out of 3).

Jakub Kicinski (12):
  ethernet: mv643xx: use eth_hw_addr_set()
  ethernet: sky2/skge: use eth_hw_addr_set()
  ethernet: lpc: use eth_hw_addr_set()
  ethernet: netxen: use eth_hw_addr_set()
  ethernet: r8169: use eth_hw_addr_set()
  ethernet: renesas: use eth_hw_addr_set()
  ethernet: rocker: use eth_hw_addr_set()
  ethernet: sxgbe: use eth_hw_addr_set()
  ethernet: sis190: use eth_hw_addr_set()
  ethernet: sis900: use eth_hw_addr_set()
  ethernet: smc91x: use eth_hw_addr_set()
  ethernet: smsc: use eth_hw_addr_set()

 drivers/net/ethernet/marvell/mv643xx_eth.c     | 10 +++++++---
 drivers/net/ethernet/marvell/skge.c            |  4 +++-
 drivers/net/ethernet/marvell/sky2.c            |  9 ++++++---
 drivers/net/ethernet/nxp/lpc_eth.c             |  4 +++-
 .../ethernet/qlogic/netxen/netxen_nic_main.c   |  4 +++-
 drivers/net/ethernet/realtek/r8169_main.c      |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c       | 16 +++++++++-------
 drivers/net/ethernet/renesas/sh_eth.c          | 16 +++++++++-------
 drivers/net/ethernet/rocker/rocker_main.c      |  8 +++++---
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c    |  9 ++++++---
 drivers/net/ethernet/sis/sis190.c              |  4 +++-
 drivers/net/ethernet/sis/sis900.c              |  4 +++-
 drivers/net/ethernet/smsc/smc911x.c            |  4 +++-
 drivers/net/ethernet/smsc/smc91x.c             |  4 +++-
 drivers/net/ethernet/smsc/smsc911x.c           | 16 +++++++++-------
 drivers/net/ethernet/smsc/smsc9420.c           | 18 ++++++++++--------
 16 files changed, 84 insertions(+), 49 deletions(-)

-- 
2.31.1

