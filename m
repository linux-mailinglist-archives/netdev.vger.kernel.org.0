Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8191DB120
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgETLLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:11:19 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4072 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589973078; x=1621509078;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JsYCUzXlsDfKtKNFoYWxhgyWbE9JFx+fChYZvOyLb/8=;
  b=SUYQ1pucnAgYEwtQuj2gjBGZwjgXq454vsILk42bKqWu5a8oNbqXd6J6
   PZlBny0nuZciH4T2iTdqjARlNajgkMi6iZom5p9xgDlmpl5pAA3PsgtbX
   v/poxcSekk8fig4KObsS1toDVxctS0Mdb3EbPFW0kWCzrR3LS8+xzx/Nb
   dTmcS7MP3yB95pc+u7ngDp8rLjVXPGP5rKrnyViBt8J+8v+Tida0esDiN
   NNBFojgowf53pZfBoPoHo0KiKlUoqS0iJ+3FekcTTHOUtJEGp7zEfc30/
   sfARI+jno19elgLCtzckg9GwBM/9+JNNP7bqiSAxysfoPrSouuPuZ+EQ4
   A==;
IronPort-SDR: hULINyyKvQELhKkzLfoNOWo8H94vU3VkTHKWL7m5CJNyeDJEKBR7za+GwI7t1sDbkib2qZJ/PF
 Kgfgk3nhWAqlM6tijoAOM6Nr+ZL388Z2Bc6TPfwA9LX9oqrxAnIXsaJyGfm0Af2jE/+qXfaqqZ
 ogNDnJNELpXYKl9PEb2XF9f8XiCwb+1x+egtNYLCu9BYnTTdAemaynnesU2muKjdsy2hdN0CUS
 t+mKg0MJ6jF98Z3gyi5WGyad/BTjqtLM9vkkp2g1ZkJsNZbnLe3lEMzpBS21enjtOLeqmvS8zg
 6CE=
X-IronPort-AV: E=Sophos;i="5.73,413,1583218800"; 
   d="scan'208";a="77278923"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 May 2020 04:11:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 May 2020 04:11:17 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 20 May 2020 04:11:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH 0/3] net: bridge: mrp: Add small fixes to MRP
Date:   Wed, 20 May 2020 13:09:20 +0000
Message-ID: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds small fixes to MRP implementation.
The following are fixed in this patch series:
- now is not allow to add the same port to multiple MRP rings
- remove unused variable
- restore the port state according to the bridge state when the MRP instance
  is deleted

Horatiu Vultur (3):
  bridge: mrp: Add br_mrp_unique_ifindex function
  switchdev: mrp: Remove the variable mrp_ring_state
  bridge: mrp: Restore port state when deleting MRP instance

 include/net/switchdev.h |  1 -
 net/bridge/br_mrp.c     | 44 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 5 deletions(-)

-- 
2.26.2

