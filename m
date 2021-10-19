Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC643397B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhJSPCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhJSPCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EE860F22;
        Tue, 19 Oct 2021 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655617;
        bh=4YU0aEQxMyM0hhcWUF5fe6dSZ4P5qepd+QRwZvrs/I4=;
        h=From:To:Cc:Subject:Date:From;
        b=kPUSp7TJzgRq61FYr5ODKlTzh4a7+CmIzeUiUF5Mh2Mi6NeWUCyIvBtDYNju2Acan
         RqPlBfC9pUnt6+z1N0DcMv+EhHytGV+5F3Sw+OSFGws3eY69hyTPJv2TrGwpu197xU
         MDMOIg6g2DWl/83iC0xHYoNHfWl/kL/0Gd2mjaBJtl6MWPOJ1dq33eiQHi2baYl684
         q/7x3mss8CqN5svYeK1wQXQJqO+71HcsOJClVb9VaxiIVqb0NuruQyuFiH7CVoVDP4
         ClpE3SOgRY8gTlSSuBtg2rp+RdiyfqjyP5XwMPp0t5vug4ZU08cAMx3vp8Wokx9S1C
         d36oMHL7RU36g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] ethernet: manual netdev->dev_addr conversions (part 3)
Date:   Tue, 19 Oct 2021 08:00:05 -0700
Message-Id: <20211019150011.1355755-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manual conversions of Ethernet drivers writing directly
to netdev->dev_addr (part 3 out of 3).

Jakub Kicinski (6):
  ethernet: netsec: use eth_hw_addr_set()
  ethernet: stmmac: use eth_hw_addr_set()
  ethernet: tehuti: use eth_hw_addr_set()
  ethernet: tlan: use eth_hw_addr_set()
  ethernet: via-rhine: use eth_hw_addr_set()
  ethernet: via-velocity: use eth_hw_addr_set()

 drivers/net/ethernet/socionext/netsec.c          | 16 +++++++++-------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    |  8 ++++++--
 drivers/net/ethernet/tehuti/tehuti.c             |  6 ++++--
 drivers/net/ethernet/ti/tlan.c                   | 10 ++++++----
 drivers/net/ethernet/via/via-rhine.c             |  4 +++-
 drivers/net/ethernet/via/via-velocity.c          |  4 +++-
 6 files changed, 31 insertions(+), 17 deletions(-)

-- 
2.31.1

