Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E456335DF0
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfFENam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:30:42 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:44108 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727936AbfFENal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:30:41 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BEFD6C00D5;
        Wed,  5 Jun 2019 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559741451; bh=UhTawoCdKVO1mzPVVGAymhkIq1eb9QymySNnrhn2TNI=;
        h=From:To:Cc:Subject:Date:From;
        b=RoF9qG4c4kadyU3NLa1zb5OZ4T800SHI489ZNakns+wGbwBjbtWGT90n1wg8BDMYr
         LTRgSbF565MeC5bsMZRKI/N6/n0VAPeuseodT8j89/GZ7gMyOrTMFomg3YcbN5Ux3d
         dPJ28FmBlQKpyOBLf0bdPiNTT8yGQfPxutcLISFmtBlm8ThpNXicbJly3nO+rPHb8e
         LNhvF2uf+aVnpRre6OtRCAVtW6Jjaor9m5NcJTUctvqXOCEbi35rJVfQtjeMQqqF3e
         6UQTKEMGOAeAjPBRXFkyGn5JgegwSWm1MZ7XgBb998Ev2p5FJThluQJHwBbMWddPf4
         b3WIX1MDnxkZw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3DDD6A0232;
        Wed,  5 Jun 2019 13:30:39 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id DD7783FEC6;
        Wed,  5 Jun 2019 15:30:38 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [RFC net-next 0/2] net: stmmac: Convert to phylink
Date:   Wed,  5 Jun 2019 15:30:27 +0200
Message-Id: <cover.1559741195.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For review and testing only.

This converts stmmac to use phylink. Besides the code redution this will
allow to gain more flexibility.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>

Jose Abreu (2):
  net: stmmac: Prepare to convert to phylink
  net: stmmac: Convert to phylink

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  72 +---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 389 +++++++++------------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  21 +-
 5 files changed, 189 insertions(+), 300 deletions(-)

-- 
2.7.4

