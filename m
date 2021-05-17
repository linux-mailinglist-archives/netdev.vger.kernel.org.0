Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7223837B7
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbhEQPql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:46:41 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbhEQPmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:42:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id C04171F423BA
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Chen-Yu Tsai <wens213@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 net-next 0/4] net: stmmac: RK3568
Date:   Mon, 17 May 2021 12:40:33 -0300
Message-Id: <20210517154037.37946-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's the third version of this patchset, taking
the feedback from Heiko and Chen-Yu Tsai.

Although this solution is a tad ugly as it hardcodes
the register addresses, we believe it's the most robust approach.

See:

https://lore.kernel.org/netdev/CAGb2v67ZBR=XDFPeXQc429HNu_dbY__-KN50tvBW44fXMs78_w@mail.gmail.com/

This is tested on RK3566 EVB2 and seems to work well.
Once the RK3568 devicetree lands upstream, we'll post
patches to add network support for RK3566 and RK3568.

Thanks!

David Wu (2):
  net: stmmac: dwmac-rk: Check platform-specific ops
  net: stmmac: Add RK3566/RK3568 SoC support

Ezequiel Garcia (2):
  net: stmmac: Don't set has_gmac if has_gmac4 is set
  dt-bindings: net: rockchip-dwmac: add rk3568 compatible string

 .../bindings/net/rockchip-dwmac.yaml          |  30 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 158 +++++++++++++++++-
 2 files changed, 173 insertions(+), 15 deletions(-)

-- 
2.30.0

