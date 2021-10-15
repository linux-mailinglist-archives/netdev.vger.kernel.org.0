Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E3A42FDF7
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbhJOWTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234582AbhJOWTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FE06115C;
        Fri, 15 Oct 2021 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336220;
        bh=CUXWYsSE1DcHFADWvZC2PXXgm+dgjFSAhnmxL5GZs1c=;
        h=From:To:Cc:Subject:Date:From;
        b=t2pfVxRNyJ0tcfsbazsh72Hpyj948HQqTFSR9VFFnrq8nYP37pI571JyvNVfRLsGl
         Xgyfwva3UF+IJTTx+fp7/wezNGVyADAJjG7yzeiNPQWuvwVqFjS4Ae9S2td/LmqJi3
         Z5JwYb7nf35N/PUAl3iKoeo5f/cBUB6/LosWJyk4PgBeDBkEgtyYNV21UP6R/BBK23
         E0HE+pnwdO2ijvNwiMT8+4ftMuISC5dfWB5/wj6FbhKOHeNpHRWxWGQ45BRvQOayRA
         N5xDDBsPGI7qLnM/nAC2G7sAUbrtgkb6TfafOB39OjMnkIq1W1mW2H+GRFkPpAWeEK
         LW3OfGKts+eHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] ethernet: manual netdev->dev_addr conversions (part 1)
Date:   Fri, 15 Oct 2021 15:16:40 -0700
Message-Id: <20211015221652.827253-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manual conversions of drivers writing directly
to netdev->dev_addr (part 1 out of 3).

Jakub Kicinski (12):
  ethernet: adaptec: use eth_hw_addr_set()
  ethernet: aeroflex: use eth_hw_addr_set()
  ethernet: alteon: use eth_hw_addr_set()
  ethernet: amd: use eth_hw_addr_set()
  ethernet: aquantia: use eth_hw_addr_set()
  ethernet: bnx2x: use eth_hw_addr_set()
  ethernet: bcmgenet: use eth_hw_addr_set()
  ethernet: enic: use eth_hw_addr_set()
  ethernet: ec_bhf: use eth_hw_addr_set()
  ethernet: enetc: use eth_hw_addr_set()
  ethernet: ibmveth: use ether_addr_to_u64()
  ethernet: ixgb: use eth_hw_addr_set()

 drivers/net/ethernet/adaptec/starfire.c         |  4 +++-
 drivers/net/ethernet/aeroflex/greth.c           |  6 +++---
 drivers/net/ethernet/alteon/acenic.c            | 14 ++++++++------
 drivers/net/ethernet/amd/amd8111e.c             |  4 +++-
 drivers/net/ethernet/amd/pcnet32.c              | 13 +++++++++----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c |  6 ++++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c    | 16 +++++++++++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |  8 ++++++--
 drivers/net/ethernet/cisco/enic/enic_main.c     |  5 +++--
 drivers/net/ethernet/ec_bhf.c                   |  4 +++-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h |  6 +++++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c |  2 +-
 drivers/net/ethernet/ibm/ibmveth.c              | 17 +++--------------
 drivers/net/ethernet/intel/ixgb/ixgb_main.c     |  8 ++++++--
 15 files changed, 69 insertions(+), 46 deletions(-)

-- 
2.31.1

