Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6E35E7F8
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhDMVDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:03:15 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbhDMVDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:03:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id E1D111F424FD
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH net-next 0/3] net: stmmac: RK3566/RK3568
Date:   Tue, 13 Apr 2021 18:02:32 -0300
Message-Id: <20210413210235.489467-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Rockchip RK3566 and RK3568 SoCs.

This has been tested on a Pine64 RK3566 Quartz64 Model B board,
DHCP and iperf are looking good.

While here, I'm adding a small patch from David Wu, for some
sanity checks for dwmac-rockchip-specific non-NULL ops.

Thanks!

David Wu (2):
  net: stmmac: dwmac-rk: Check platform-specific ops
  net: stmmac: Add RK3566/RK3568 SoC support

Ezequiel Garcia (1):
  net: stmmac: Don't set has_gmac if has_gmac4 is set

 .../bindings/net/rockchip-dwmac.txt           |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 179 +++++++++++++++++-
 2 files changed, 178 insertions(+), 3 deletions(-)

-- 
2.30.0

