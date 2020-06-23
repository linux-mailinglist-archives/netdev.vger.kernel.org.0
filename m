Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F455204D8A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgFWJIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:08:38 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:49195 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731860AbgFWJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592903317; x=1624439317;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Hf1oiWAZW47J1FDqvjaGVKeQoXmDU3F9JmfEwLpOK8A=;
  b=mNMCpDFQ/ZlUK35Xj75Q6McXc5Aua3ghekcAFyjU4ujMco7N9BfjX21m
   m57kg8sOQB+wuj69QVrRQt6TmSDA+PXNF7U763w06rlP32ZG7P/ZVTzRz
   zHrD5YhZztOpvb3NhbEJeXJu2BJ3DPmsNCwHHA2GaEx7pZWpHgEEqEIwh
   JvQqSvCCaYdsqpJ1lZUz9jGIx/+gv1qw7MeahAU7d4w1/WkQucZJFh0VI
   AzJwoxrGIxdJsq/x8SoSeeh0Ptc1Gpo9F2V3hHS3TeujlbGzVsse6jwAN
   c3LAndnisSKSM5t6PLkypZITWFuFby5xG16Srr4RciCwLysdK5EiaNGZN
   w==;
IronPort-SDR: bAhNFfnu/8crGk787M99eNYA9w+l0xyHYdtsp5D4SrMsOMrq/6I365Ggvw21oPBRnpsk18eHbV
 h7uaw5r7dckQA0mFLaG5GhkO5y+PPbGZI1mzvrxRPnficwBB/5ft8VT99ZeM47zoP6YlSoMP/A
 iMvTosg9kA3WlDdRwzfe98tQSwhm1gJjg2ige+TVLOJdKw0AuPFiKeUTBmi22J0pxm9ksQYutN
 N5OenKFSSdE5V4pcgKMbG8fxQPS9JbXfR/9L/cbYG6PckSB8CCrR8VlHd43k4eoRJwv9QJtZps
 CaQ=
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="79436702"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jun 2020 02:08:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 02:08:25 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 23 Jun 2020 02:08:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 0/2] bridge: mrp: Update MRP_PORT_ROLE
Date:   Tue, 23 Jun 2020 11:05:39 +0200
Message-ID: <20200623090541.2964760-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series does the following:
- fixes the enum br_mrp_port_role_type. It removes the port role none(0x2)
  because this is in conflict with the standard. The standard defines the
  interconnect port role as value 0x2.
- adds checks regarding current defined port roles: primary(0x0) and
  secondary(0x1).

v2:
 - add the validation code when setting the port role.

Horatiu Vultur (2):
  bridge: uapi: mrp: Fix MRP_PORT_ROLE
  bridge: mrp: Validate when setting the port role

 include/uapi/linux/mrp_bridge.h |  1 -
 net/bridge/br_mrp.c             | 10 ++++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.26.2

