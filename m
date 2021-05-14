Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D58B380900
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhENL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhENL4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:56:16 -0400
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29C1C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 04:55:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id E778422259F;
        Fri, 14 May 2021 13:36:54 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id huFPOxgVzXK9; Fri, 14 May 2021 13:36:52 +0200 (CEST)
From:   Tobias Schramm <t.schramm@manjaro.org>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Wu <david.wu@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tobias Schramm <t.schramm@manjaro.org>
Subject: [PATCH 0/3] Add support for RK3308 gmac
Date:   Fri, 14 May 2021 13:38:10 +0200
Message-Id: <20210514113813.2093534-1-t.schramm@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rockchip RK3308 SoC features an internal gmac. Only the signals
required for RMII are exposed so it is limited to 10/100 Mbit/s operation.
This patchset adds support for it.
I've tested the patchset on a Rock Pi S, works fine.

Cheers,
Tobias

Tobias Schramm (3):
  dt-bindings: net: rockchip-dwmac: add rk3308 gmac compatible
  net: stmmac: dwmac-rk: add support for rk3308 gmac
  arm64: dts: rockchip: add gmac to rk3308 dts

 .../bindings/net/rockchip-dwmac.yaml          |  2 +
 arch/arm64/boot/dts/rockchip/rk3308.dtsi      | 22 +++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 49 +++++++++++++++++++
 3 files changed, 73 insertions(+)

-- 
2.31.1

