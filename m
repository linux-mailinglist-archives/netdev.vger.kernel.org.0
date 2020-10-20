Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334D72933D6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391360AbgJTEOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:11 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37574 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390069AbgJTEOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 00:14:10 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AD00C2003FF;
        Tue, 20 Oct 2020 06:14:08 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 822772001E3;
        Tue, 20 Oct 2020 06:14:01 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 597D540302;
        Tue, 20 Oct 2020 06:13:52 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        Jose.Abreu@synopsys.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [RFC, net-next 0/3] net: dsa: felix: frame preemption support
Date:   Tue, 20 Oct 2020 12:04:55 +0800
Message-Id: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 supports frame preemption according to 802.1qbu and 802.3br.
This patch series use ethtool to enable and configure frame preemption,
then use tc-taprio preempt set to mark the preempt queues and express
queueus.

This series depends on series: "ethtool: Add support for frame preemption"
link: http://patchwork.ozlabs.org/project/netdev/patch/20201012235642.1384318-2-vinicius.gomes@intel.com/

Xiaoliang Yang (3):
  net: dsa: ethtool preempt ops support on slave ports
  net: dsa: felix: add preempt queues set support for vsc9959
  net: dsa: felix: tc-taprio preempt set support

 drivers/net/dsa/ocelot/felix.c         | 26 +++++++++++
 drivers/net/dsa/ocelot/felix.h         |  4 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c | 65 ++++++++++++++++++++++++++
 include/net/dsa.h                      | 12 +++++
 include/soc/mscc/ocelot.h              | 11 +++++
 include/soc/mscc/ocelot_dev.h          | 23 +++++++++
 net/dsa/slave.c                        | 26 +++++++++++
 7 files changed, 167 insertions(+)

-- 
2.18.4

