Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7915C1D04EC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgEMCaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:30:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40694 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgEMCaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 22:30:09 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B21061A1322;
        Wed, 13 May 2020 04:30:07 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 050CE1A0420;
        Wed, 13 May 2020 04:29:58 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C062C402B4;
        Wed, 13 May 2020 10:29:45 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 0/3] net: dsa: felix: tc taprio and CBS offload support
Date:   Wed, 13 May 2020 10:25:07 +0800
Message-Id: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series support tc taprio and CBS hardware offload according
to IEEE 802.1Qbv and IEEE-802.1Qav on VSC9959.

v1->v2 changes:
 - Move port_qos_map_init() function to be common felix codes.
 - Keep const for dsa_switch_ops structs, add felix_port_setup_tc
   function to call port_setup_tc of felix.info.
 - fix code style for cbs_set, rename variables.

Xiaoliang Yang (3):
  net: dsa: felix: qos classified based on pcp
  net: dsa: felix: Configure Time-Aware Scheduler via taprio offload
  net: dsa: felix: add support Credit Based Shaper(CBS) for hardware
    offload

 drivers/net/dsa/ocelot/felix.c         |  45 ++++++
 drivers/net/dsa/ocelot/felix.h         |   5 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 190 ++++++++++++++++++++++++-
 3 files changed, 239 insertions(+), 1 deletion(-)

-- 
2.17.1

