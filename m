Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771C4264DAF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIJSqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgIJQNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 12:13:15 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D7A206A1;
        Thu, 10 Sep 2020 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599754351;
        bh=JhOw623KmZjBBWX0PTYpbPtOZstZZ5KRZ2j6lA39E/U=;
        h=From:To:Subject:Date:From;
        b=ClnfGNMmJjyHNJZRcZRkTbL6v51e9FpL4NSkzP8h/hIgijqenCo0olUYJQPmUg0k7
         Rig5O7O38k14zzJ15FsHkgYeZJU8oHTI+XqHi6xJ3X9LGOzYgPyZA5Ie6m9bnYTQiz
         YxZv1cb9KRiFxdhIzCa41oYtVTg/g8pT9njMlV5o=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3 0/8] nfc: s3fwrn5: Few cleanups
Date:   Thu, 10 Sep 2020 18:12:11 +0200
Message-Id: <20200910161219.6237-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes since v2:
1. Fix dtschema ID after rename (patch 1/8).
2. Apply patch 9/9 (defconfig change).

Changes since v1:
1. Rename dtschema file and add additionalProperties:false, as Rob
   suggested,
2. Add Marek's tested-by,
3. New patches: #4, #5, #6, #7 and #9.

Best regards,
Krzysztof

Krzysztof Kozlowski (8):
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

 CREDITS                                       |  4 +
 .../devicetree/bindings/net/nfc/s3fwrn5.txt   | 25 -------
 .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 73 +++++++++++++++++++
 MAINTAINERS                                   |  5 +-
 .../dts/exynos/exynos5433-tm2-common.dtsi     |  4 +-
 drivers/nfc/s3fwrn5/Kconfig                   |  1 +
 drivers/nfc/s3fwrn5/firmware.c                |  4 +-
 drivers/nfc/s3fwrn5/firmware.h                |  2 +-
 drivers/nfc/s3fwrn5/i2c.c                     | 24 +++---
 9 files changed, 101 insertions(+), 41 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml

-- 
2.17.1

