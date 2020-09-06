Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78EA25EEDF
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 17:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgIFPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 11:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbgIFPhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 11:37:31 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15626207BB;
        Sun,  6 Sep 2020 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599406650;
        bh=QMf/wFRc+/7EGE63iw3nhSRMSoeUHkpuvT+2XQ3Psfc=;
        h=From:To:Cc:Subject:Date:From;
        b=mZbl1KhJLMExdZBg7OuFDQ5CtaRBFiyM8L/4cV1jq2L3g2QO/44Cn40ybg46BVAU0
         ly/h7p7ZUkgQLJJeoJX2lTlhEU9XXVtG/PHKjWUxdFw/67L2tc4Cyaiw1N5deUPOcf
         mx8PmA2fQxa0k//o0FAXkJaxVM5MKcw8ZAD/DA6Y=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-nfc@lists.01.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 0/9] nfc: s3fwrn5: Few cleanups
Date:   Sun,  6 Sep 2020 17:36:45 +0200
Message-Id: <20200906153654.2925-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes since v1:
1. Rename dtschema file and add additionalProperties:false, as Rob
   suggested,
2. Add Marek's tested-by,
3. New patches: #4, #5, #6, #7 and #9.

Best regards,
Krzysztof


Krzysztof Kozlowski (9):
  dt-bindings: net: nfc: s3fwrn5: Convert to dtschema
  dt-bindings: net: nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
  nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
  nfc: s3fwrn5: Remove unneeded 'ret' variable
  nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
  nfc: s3fwrn5: Constify s3fwrn5_fw_info when not modified
  MAINTAINERS: Add Krzysztof Kozlowski to Samsung S3FWRN5 and remove
    Robert
  arm64: dts: exynos: Use newer S3FWRN5 GPIO properties in Exynos5433
    TM2
  arm64: defconfig: Enable Samsung S3FWRN5 NFC driver

 CREDITS                                       |  4 +
 .../devicetree/bindings/net/nfc/s3fwrn5.txt   | 25 -------
 .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 73 +++++++++++++++++++
 MAINTAINERS                                   |  5 +-
 .../dts/exynos/exynos5433-tm2-common.dtsi     |  4 +-
 arch/arm64/configs/defconfig                  |  3 +
 drivers/nfc/s3fwrn5/Kconfig                   |  1 +
 drivers/nfc/s3fwrn5/firmware.c                |  4 +-
 drivers/nfc/s3fwrn5/firmware.h                |  2 +-
 drivers/nfc/s3fwrn5/i2c.c                     | 24 +++---
 10 files changed, 104 insertions(+), 41 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml

-- 
2.17.1

