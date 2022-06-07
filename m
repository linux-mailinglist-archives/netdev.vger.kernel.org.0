Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF67853F6A5
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 08:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiFGG45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 02:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiFGG44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 02:56:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573B7BA54B;
        Mon,  6 Jun 2022 23:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1654585014; x=1686121014;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rfXrKiFGD0AlQe3r4r6Rd9SATgPVEgPxA7mb2k6vpY8=;
  b=CeOeBZhynbgKU0B7f39owdeSte+HbDWdQQkI64h4VbjddWjTDewhgAxN
   TdnycLwgI9OiKg+8xKAf1Q+cPXILTXGTfeX+il/TlauVa9ilEPcoHmLTY
   /bKDApWfXKUX+KDwCF5GEZrKvZElQdLHpscY9MqJ8PRGYILER4nPgDGSc
   zzZx8PO9A+ZESmRuh+939yHG78vJAXC/HZaX2tE3AeVd/swn9V/1sZXcD
   aUPI5Co3IzkwMW2+dNN2AH6/+L/7AwmkY/OZGYZcWCDgby6tjaTQ7sDFQ
   uoR0wOAIt1GquqUEBivMGX3IHD1oKaIHFCUb/31VAqeY5jVLYr6apGIQO
   A==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="167365805"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2022 23:56:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 6 Jun 2022 23:56:53 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 6 Jun 2022 23:56:50 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Palmer Dabbelt <palmer@dabbelt.com>
CC:     Conor Dooley <conor.dooley@microchip.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: [PATCH net-next 0/2] Document PolarFire SoC can controller
Date:   Tue, 7 Jun 2022 07:54:58 +0100
Message-ID: <20220607065459.2035746-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,
When adding the dts for PolarFire SoC, the can controllers were omitted,
so here they are...

Thanks,
Conor.

Conor Dooley (2):
  dt-bindings: can: mpfs: document the mpfs can controller
  riscv: dts: microchip: add mpfs's can controllers

 .../bindings/net/can/microchip,mpfs-can.yaml  | 45 +++++++++++++++++++
 .../boot/dts/microchip/microchip-mpfs.dtsi    | 18 ++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml

-- 
2.36.1

