Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39550FFDA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351320AbiDZOCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351317AbiDZOCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:02:18 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D20E1906B7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:59:03 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout2.routing.net (Postfix) with ESMTP id B5E135FC22;
        Tue, 26 Apr 2022 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1650980973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dSlDPKAzzaq/bDB/Mgjeeep8HHzSjpH4wNIELJEgfLY=;
        b=LBiqkBfyO3csDUhz/CIEgnSBcuuuHGsWvMRPZhVFTXREB4nAuAtBCmuvSAmJMdixMLlfwF
        yJ+gxir5TiFHoD8FZhza5dtT3Ea4ieFA88Hr5yKcLVR4uVurPxRdpyOocrR8FOuA237Mg+
        Tl1ug0CnEWkG3QuboucXbgvJlRseWSs=
Received: from localhost.localdomain (fttx-pool-80.245.77.37.bambit.de [80.245.77.37])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 5D074360630;
        Tue, 26 Apr 2022 13:49:32 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v1 0/3] Add MT7531 switch to BPI-R2Pro Board
Date:   Tue, 26 Apr 2022 15:49:21 +0200
Message-Id: <20220426134924.30372-1-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: a0cd959c-79df-41a0-9cf6-bfb567398990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

The Rockchip-Board Bananapi-R2-Pro has a Mediatek MT7531 connected to
the GMAC0.
This series changes DSA driver where needed to work on the Board and
adds necessary Devicetree node.

Frank Wunderlich (3):
  net: dsa: mt753x: make reset optional
  net: dsa: mt753x: make CPU-Port dynamic
  arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board

 .../boot/dts/rockchip/rk3568-bpi-r2-pro.dts   | 49 +++++++++++++++++
 drivers/net/dsa/mt7530.c                      | 53 ++++++++++---------
 drivers/net/dsa/mt7530.h                      |  2 +-
 3 files changed, 78 insertions(+), 26 deletions(-)

-- 
2.25.1

