Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6E40BFC7
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhIOGsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:48:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36047 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236368AbhIOGso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 02:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631688446; x=1663224446;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b9miwLBgHXOQwWRiIZNZPwoUHP8DjZe1ZcaW9BLAkqQ=;
  b=AW7N6xron5uGHn9QnZONgCXk0h+FPWkHgkediWR1tyW0T3SIi9S9q3FF
   CAf8RPyH4IhpQpQsw+OoJi0gGITIdkgSfUo2eVnjPGhVd2uEvnhL/1Jin
   dLfTXJ4lRXz+2kxRcr30CzhyiJOpPaRcGpu5MVChHX5oyA5lJFeB7Uf5g
   2+OPWdksUZtVYJcusavI3Iuz3VV/VQisDYQqYqBb8xVB1gsx+1IJ9PjUA
   csIa62RWU93vchRGDo9T36LfkM/wReknEAiNrxwR1iE6/+XCSAOw2o4km
   PoBOpYmNXBLVDTZ+cttudF5Z8cAllJEeT6MxUJiulo+CwsMyopy/MrBBk
   g==;
IronPort-SDR: KLIrH7AKjSezC7qi0Q7jlUOwshEy2hWhijt/yV6VYhQjHT6/8YG2RoIogndOHR6bjUV6HHSFXY
 +s8HKgYEnLLVTgjJVfVWlIIjjpjAhMRmGypCwRosgiiwHvNSsF9rF2Wfa8trSUHL6B6sYxjJ/k
 ojDk7VeIea04qC2IEqrcDwwPCCweS9oUA0neWMVtCMuc/T9fhwxRilZlNtxQNF+RdXlYIe/o4d
 hyFMEQYHKr+mdlq5Z2G26OaStRtfIzjTQF8WYFN19r9d48V2n5jgOJ9iGn91iRrcbZEB33x8SM
 LjC71XAeYdDYFwunOqTdknPV
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136592235"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Sep 2021 23:47:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 14 Sep 2021 23:47:25 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 14 Sep 2021 23:47:22 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 0/3] net: macb: add support for MII on RGMII interface 
Date:   Wed, 15 Sep 2021 09:47:18 +0300
Message-ID: <20210915064721.5530-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for MII mode on RGMII interface (patch 3/3).
Along with this the series also contains minor cleanups (patches 1/3, 2/3)
on macb.h.

Thank you,
Claudiu Beznea

Claudiu Beznea (3):
  net: macb: add description for SRTSM
  net: macb: align for OSSMODE offset
  net: macb: add support for mii on rgmii

 drivers/net/ethernet/cadence/macb.h      | 7 +++++--
 drivers/net/ethernet/cadence/macb_main.c | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.25.1

