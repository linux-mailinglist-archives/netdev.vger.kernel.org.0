Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2504C67A148
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjAXSiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjAXSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:38:06 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBD5366B3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:37:58 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:2f4a:8573:c294:b2ce])
        by albert.telenet-ops.be with bizsmtp
        id CidZ2900356uRqi06idZVY; Tue, 24 Jan 2023 19:37:55 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAe-007HCO-Ho;
        Tue, 24 Jan 2023 19:37:33 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pKOAn-002n0c-1h;
        Tue, 24 Jan 2023 19:37:33 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 2/9] doc: phy: Document devm_of_phy_get()
Date:   Tue, 24 Jan 2023 19:37:21 +0100
Message-Id: <768d5845668f081620098a0b4479d1481e212bac.1674584626.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674584626.git.geert+renesas@glider.be>
References: <cover.1674584626.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing documentation for devm_of_phy_get(), which was forgotten
when the function was introduced.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New.
---
 Documentation/driver-api/phy/phy.rst | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/driver-api/phy/phy.rst b/Documentation/driver-api/phy/phy.rst
index 26467dd4f291505e..6cadc58f4ce07ce4 100644
--- a/Documentation/driver-api/phy/phy.rst
+++ b/Documentation/driver-api/phy/phy.rst
@@ -106,6 +106,8 @@ it. This framework provides the following APIs to get a reference to the PHY.
 	struct phy *devm_phy_get(struct device *dev, const char *string);
 	struct phy *devm_phy_optional_get(struct device *dev,
 					  const char *string);
+	struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
+				    const char *con_id);
 	struct phy *devm_of_phy_get_by_index(struct device *dev,
 					     struct device_node *np,
 					     int index);
@@ -119,10 +121,10 @@ successful PHY get. On driver detach, release function is invoked on
 the devres data and devres data is freed.
 devm_phy_optional_get should be used when the phy is optional. This
 function will never return -ENODEV, but instead returns NULL when
-the phy cannot be found.Some generic drivers, such as ehci, may use multiple
-phys and for such drivers referencing phy(s) by name(s) does not make sense. In
-this case, devm_of_phy_get_by_index can be used to get a phy reference based on
-the index.
+the phy cannot be found.
+Some generic drivers, such as ehci, may use multiple phys. In this case,
+devm_of_phy_get or devm_of_phy_get_by_index can be used to get a phy
+reference based on name or index.
 
 It should be noted that NULL is a valid phy reference. All phy
 consumer calls on the NULL phy become NOPs. That is the release calls,
-- 
2.34.1

