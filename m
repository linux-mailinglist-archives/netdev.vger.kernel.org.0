Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628A1337C69
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCKSWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCKSWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:22:06 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B6FC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 10:22:05 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lKPVb-0008Vo-93; Thu, 11 Mar 2021 18:54:03 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 0/6] net: dsa: hellcreek: Add support for dumping tables
Date:   Thu, 11 Mar 2021 18:53:38 +0100
Message-Id: <20210311175344.3084-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615486926;af263bb0;
X-HE-SMSGID: 1lKPVb-0008Vo-93
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

add support for dumping the VLAN and FDB table via devlink. As the driver uses
internal VLANs and static FDB entries, this is a useful debugging feature. Also
report the current memory and descriptor usage.

Thanks,
Kurt

Kurt Kanzenbach (6):
  net: dsa: hellcreek: Report RAM usage
  net: dsa: hellcreek: Report META data usage
  net: dsa: hellcreek: Add devlink VLAN region
  net: dsa: hellcreek: Use boolean value
  net: dsa: hellcreek: Move common code to helper
  net: dsa: hellcreek: Add devlink FDB region

 drivers/net/dsa/hirschmann/hellcreek.c | 293 +++++++++++++++++++++----
 drivers/net/dsa/hirschmann/hellcreek.h |  11 +
 2 files changed, 258 insertions(+), 46 deletions(-)

-- 
2.30.2

