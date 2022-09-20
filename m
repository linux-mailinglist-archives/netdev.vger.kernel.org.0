Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD0E5BEBDC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiITR06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiITR05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:26:57 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7180658DC7;
        Tue, 20 Sep 2022 10:26:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663694782; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S2KQStHwuKEd4+hBYLoZ5gUngnG4E9dNJi7vvVnWj0tSadFLUIQmXAMvddt1j0SChdE6lHDIZOMhvxBtZCU2RaDzPq05bCMRHWL3z74muFiXyU+7a204lKVjVnIGrtmndoH6gpn0OEgdMzRdhkki9hjoCfcPvuJbI/l46AKAl8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663694782; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=loETMcYAL4ROIG1xQMzWE1mjbgbUJ8t+eJJu11sOFyI=; 
        b=UZiYNvlmjUi3L5PX4HM7seS0fLf9iAPe3lACnIXtoCZbfep6g4WALNQRAKXWCDrzm8oNNjz56JcWZzHLqof1hH0e4XHLmuKNa3IzorDIntYNoxJJrCTM7Ol1NEDVsQ40p5z0+2C6lGHdxCLLMtntBPbIsJnhiv5/+krE6FZUMFA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663694782;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=loETMcYAL4ROIG1xQMzWE1mjbgbUJ8t+eJJu11sOFyI=;
        b=BxFzmi/d14yBqIP++BxD98r4FRYTlFhMkcRY9nzLy/DnZpoBs9xn+x4yASVXly/c
        +Omd/ZZVafNOLiV56TkCKDwr4aK+yh3F4f6rmjtbZIhWNk2T5s6mWPbUA3Qo02zI4fv
        D167GusK1Bc++aY6xGMS0zxeRQqFT2lfe4MjK2Lk=
Received: from arinc9-Xeront.fusolab.local (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663694780726325.1013179736344; Tue, 20 Sep 2022 10:26:20 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v4 net-next 00/10] dt-bindings and mt7621 devicetree changes
Date:   Tue, 20 Sep 2022 20:25:46 +0300
Message-Id: <20220920172556.16557-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello there!

This patch series removes old MediaTek bindings, improves mediatek,mt7530
and mt7621 memory controller bindings and improves mt7621 DTs.

v4:
- Keep memory-controller node name.
- Change syscon to memory-controller on mt7621.dtsi.

v3:
- Explain the mt7621 memory controller binding change in more details.
- Remove explaining the remaining DTC warnings from the patch log as there
are new schemas submitted for them.

v2:
- Change memory controller node name to syscon on the schema example.
- Keep cpu compatible string and syscon on the memory controller node.
- Add Rob and Sergio's tags.

Arınç ÜNAL (10):
  dt-bindings: net: drop old mediatek bindings
  dt-bindings: net: dsa: mediatek,mt7530: change mt7530 switch address
  dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller
    description
  dt-bindings: memory: mt7621: add syscon as compatible string
  mips: dts: ralink: mt7621: fix some dtc warnings
  mips: dts: ralink: mt7621: remove interrupt-parent from switch node
  mips: dts: ralink: mt7621: change phy-mode of gmac1 to rgmii
  mips: dts: ralink: mt7621: change mt7530 switch address
  mips: dts: ralink: mt7621: fix external phy on GB-PC2
  mips: dts: ralink: mt7621: add GB-PC2 LEDs

 .../mediatek,mt7621-memc.yaml                   |  6 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml       | 34 ++++++-----
 .../bindings/net/mediatek,mt7620-gsw.txt        | 24 --------
 .../bindings/net/ralink,rt2880-net.txt          | 59 --------------------
 .../bindings/net/ralink,rt3050-esw.txt          | 30 ----------
 .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts    |  8 +--
 .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts    | 50 +++++++++++++----
 arch/mips/boot/dts/ralink/mt7621.dtsi           | 35 +++++-------
 8 files changed, 80 insertions(+), 166 deletions(-)


