Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407F465E618
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjAEHaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjAEHaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:30:07 -0500
Received: from out29-55.mail.aliyun.com (out29-55.mail.aliyun.com [115.124.29.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF49D4BD59;
        Wed,  4 Jan 2023 23:30:05 -0800 (PST)
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.662929|-1;BR=01201311R901b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_system_inform|0.0318161-0.00018597-0.967998;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.QktmAfL_1672903792;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QktmAfL_1672903792)
          by smtp.aliyun-inc.com;
          Thu, 05 Jan 2023 15:30:01 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v1 0/3] add dts for yt8521 and yt8531s, add driver for yt8531
Date:   Thu,  5 Jan 2023 15:30:21 +0800
Message-Id: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dts support for yt8521 and yt8531s, add driver for yt8531. These patches have
been tested on our AM335x platform (motherboard) which has one RGMII interface.
It can connect to daughter boards like yt8531s or yt8521 board.
Passed all test cases.

Frank (3):
  dt-bindings: net: Add Motorcomm yt8xxx ethernet phy Driver bindings
  net: phy: Add dts support for Motorcomm yt8521/yt8531s gigabit
    ethernet phy
  net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy

 .../bindings/net/motorcomm,yt8xxx.yaml        | 180 +++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   1 +
 drivers/net/phy/Kconfig                       |   2 +-
 drivers/net/phy/motorcomm.c                   | 638 +++++++++++++++---
 5 files changed, 740 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml

-- 
2.34.1

