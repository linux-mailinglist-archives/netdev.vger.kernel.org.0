Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C43934C79E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhC2IQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:16:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:64571 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhC2IO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617005696; x=1648541696;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e2WFHxZxnSPuPoi26ReVTCejhaJhc4RfFUNwNTOn8HU=;
  b=Ubh8ywl1G32dxv+smYnVfnFUw9tSpB32Heo6eDopKah176G4kNstX9Oy
   2iOqTPTBcl+5QrQrP05VH73ciWfkzP0Ybq9uADlB2RPlOgSkCiC84Jj0t
   NaClgRj25Z99gdAvKA6fYZP5oUpgnjFNWULxGG1qa/48wD3cAFtdnHViu
   T3W2lIPKmbXfHjcIgOzNEsQ2GHXBvDp4OoNVbt2ya6SSjVSq953mta9Jd
   vCI69zjEP94Ft4IJl6zW/6N4985AdFPT68kPgGx3mqanTPNg/kym/buLc
   DgGXf8b5poMO8VzH8Q59siwsj28cj/jEocikmpSRiBAat6nHDq7IphFZc
   g==;
IronPort-SDR: iWQSdqQUypGYzato6mSpTdIG49u3cbQ1IoleuLXcu5qQcArvp1rVIPm4Jf1fWRckp6fzlTy/qS
 TxStjsobq9DR2ENeI2XEatMYPPzdkdxdKvYZ+VoIvyEVTw4OuprSc9oCVu7FTpkRDVil0roXE0
 9u1AbJ6nAsLv9dyG5m6/q+kPDMaHZWq2GFtWXnPvvk+bjEgA4qKlQhYDPbGfNn9Uq3xYYDLBnU
 7lcCbnsL2i7eQ3hQd6TG5D7le0BQXIDkdBavxayG0hUN+Ljt7tIt5Bt3PXepotGTLQfEr1f/+U
 3Hg=
X-IronPort-AV: E=Sophos;i="5.81,287,1610434800"; 
   d="scan'208";a="49206192"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 01:14:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 01:14:54 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 29 Mar 2021 01:14:52 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH linux-next 0/1] Sparx5 SerDes: Fixed stack frame size warning
Date:   Mon, 29 Mar 2021 10:14:37 +0200
Message-ID: <20210329081438.558885-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- The SerDes driver changes its table based register operations into direct
  register operations to avoid the large stack footprint reported by a
  kernel robot.
- The 25g reset operation was changed slightly to make it equivalent to the
  20g reset operation.

Steen Hegelund (1):
  phy: Sparx5 Eth SerDes: Use direct register operations

 drivers/phy/microchip/sparx5_serdes.c | 1869 +++++++++++++------------
 1 file changed, 951 insertions(+), 918 deletions(-)

-- 
2.31.1

