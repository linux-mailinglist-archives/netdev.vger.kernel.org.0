Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02C26E81A0
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjDSTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSTEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:04:37 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF572120;
        Wed, 19 Apr 2023 12:04:36 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppD6U-0003lT-1z;
        Wed, 19 Apr 2023 21:04:30 +0200
Date:   Wed, 19 Apr 2023 20:04:23 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH net-next 0/2] wireless offloading on MediaTek MT7981
Message-ID: <cover.1681930898.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new compatible and load appropriate wireless offloading firmware on
the MediaTek MT7981 SoC.

Daniel Golle (2):
  dt-bindings: net: mediatek: add WED RX binding for MT7981 eth driver
  net: ethernet: mtk_eth_soc: use WO firmware for MT7981

 .../bindings/arm/mediatek/mediatek,mt7622-wed.yaml         | 1 +
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c                | 7 ++++++-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h                 | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.40.0

