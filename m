Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9949CCAB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiAZOsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:48:00 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:9333 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242339AbiAZOsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 09:48:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1643208480; x=1674744480;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=te3t0V8HBo+e4s+uVGYhwvnxe+igmWMNSDOcMV+ImjM=;
  b=DdNa8M2QF4c3CG/0knymLhZy8z/5YwGEFa7zq3LCXmFykfdfzhApKnmd
   y/Z7/leRYYQE1ASk7/zAaXRoWjSgT6IJGvY/VpVIM9up6x45dIcapnXmj
   GZOJVH50CHw86xJbpevwU5Ic5y9x7su0aSmXuaG00fGcfLxBW75SiDu3K
   ziWxX9Cna3u8hIxuyLDd9VTPauOT2d4pIcpKztp7WuX6jUH10cLkEuNN9
   ka1CrYPGfy7AbRSHhMECzFP6Pimu4NuOz+pMQgljkqZWdZ4LokYLHGQYY
   z+rrHctgq/m1/yHWyh0J8yo+V+M3YDuka/nU4bS7kJXWNS7y1YBPtevX+
   A==;
X-IronPort-AV: E=Sophos;i="5.88,318,1635199200"; 
   d="scan'208";a="21726518"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 26 Jan 2022 15:47:58 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 26 Jan 2022 15:47:58 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 26 Jan 2022 15:47:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1643208478; x=1674744478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=te3t0V8HBo+e4s+uVGYhwvnxe+igmWMNSDOcMV+ImjM=;
  b=d4ubHgp4yJX/++kzRFHgWvpGrjVs5WPVax2gEPlhwyGW1KeALHWN30EW
   +S5+VJPsiW4vcvo9gWYgf1A6zuThPVgKF3E3j2ijLsr/qmyOAxO3TKr39
   4UArMmbAraxVBjUvZ/YMwkRoU/xwcH4SHDQj4E9kLxZ4H0VnhK4dniq2c
   4OdBR2MT+HA0+ehJs+1M8Te9zIkUZqQBwnIoTZgSfG7HEgVxoCdWkGrqp
   6ObtyIPb3eMv7dlgLEZWmEt8krqPaOdd0J9mt1y7Acehbt88wlodE5VrB
   cYkFm9GSGk9ST1bBFqVBbgPh8A3Il/noth0hjV8fwywLU4+PZMHF0oF8H
   w==;
X-IronPort-AV: E=Sophos;i="5.88,318,1635199200"; 
   d="scan'208";a="21726517"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 26 Jan 2022 15:47:58 +0100
Received: from steina-w.tq-net.de (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id B7F29280065;
        Wed, 26 Jan 2022 15:47:58 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells / nvmem-cell-names properties
Date:   Wed, 26 Jan 2022 15:47:48 +0100
Message-Id: <20220126144748.246073-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These properties are inherited from ethernet-controller.yaml.
This fixes the dt_binding_check warning:
imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..73616924fa29 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -121,6 +121,10 @@ properties:
 
   mac-address: true
 
+  nvmem-cells: true
+
+  nvmem-cell-names: true
+
   tx-internal-delay-ps:
     enum: [0, 2000]
 
-- 
2.25.1

