Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05FE1CD163
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgEKFs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:48:29 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40160 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgEKFs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:48:28 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 14C961A0AAB;
        Mon, 11 May 2020 07:48:26 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 823161A0942;
        Mon, 11 May 2020 07:48:16 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 64A91402BC;
        Mon, 11 May 2020 13:48:04 +0800 (SGT)
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
Subject: [PATCH v1 net-next 0/3] net: dsa: felix: tc taprio and CBS offload support
Date:   Mon, 11 May 2020 13:43:29 +0800
Message-Id: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series support tc taprio and CBS hardware offload according
to IEEE 802.1Qbv and IEEE-802.1Qav on VSC9959.

Xiaoliang Yang (3):
  net: dsa: felix: qos classified based on pcp
  net: dsa: felix: Configure Time-Aware Scheduler via taprio offload
  net: dsa: felix: add support Credit Based Shaper(CBS) for hardware
    offload

 drivers/net/dsa/ocelot/felix.c         |  16 +-
 drivers/net/dsa/ocelot/felix.h         |   6 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 215 ++++++++++++++++++++++++-
 3 files changed, 235 insertions(+), 2 deletions(-)

-- 
2.17.1

