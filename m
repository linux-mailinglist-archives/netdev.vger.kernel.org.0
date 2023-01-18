Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3965671CF4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjARNHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjARNGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:06:55 -0500
Received: from smtp-out-01.comm2000.it (smtp-out-01.comm2000.it [212.97.32.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF2A25B2;
        Wed, 18 Jan 2023 04:28:50 -0800 (PST)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-01.comm2000.it (Postfix) with ESMTPSA id 7968584363E;
        Wed, 18 Jan 2023 13:28:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674044926;
        bh=4m4ZjSVhmyrLuZxyd7aELjCwMdvTj2UKE2kvY4tWG0c=;
        h=From:To:Cc:Subject:Date;
        b=LuTYQmoexGrY6yfgpRzgXDrca/KHOBu9Kuh+bszKjKH/MTfs8ECtWUoz5zpXS1dJ+
         6I0rmphEaMfBdXcxn6iDlPu+RxKC5vHDT9WvSDvB1vv/1swuSMgA8IlDbVD5hzs8pj
         Zy3PxjExlNLY2Ty7Z+QTx3OpFhXsUsgMNj5tgV03vtFxKsrnTvGFDGwhQxPNFg2CuF
         BC6hgxrhon7tUfC3A/vbTBA82Px+tYiCbSOzvyNHSwrs5UZXYP8pqSUQyXfIQMu/K7
         PdVJEjV1pOBMFvBkgvirDJXo4keS896BRwzRLV1UiuPP166SoFSeV0MeYc4C9DsoWJ
         jrSzFLMf+qxHQ==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v1 0/4] Bluetooth: hci_mrvl: Add serdev support for 88W8997
Date:   Wed, 18 Jan 2023 13:28:13 +0100
Message-Id: <20230118122817.42466-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
support for changing the baud rate. The command to change the baud rate is
taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
interfaces) from NXP.

Stefan Eichenberger (4):
  dt-bindings: bluetooth: marvell: add 88W8997 DT binding
  dt-bindings: bluetooth: marvell: add max-speed property
  Bluetooth: hci_mrvl: Add serdev support for 88W8997
  arm64: dts: imx8mp-verdin: add 88W8997 serdev to uart4

 .../bindings/net/marvell-bluetooth.yaml       | 20 ++++-
 .../dts/freescale/imx8mp-verdin-wifi.dtsi     |  5 ++
 drivers/bluetooth/hci_mrvl.c                  | 88 +++++++++++++++++--
 3 files changed, 105 insertions(+), 8 deletions(-)

-- 
2.25.1

