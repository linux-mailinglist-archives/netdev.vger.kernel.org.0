Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36783096CF
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhA3Qgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhA3OVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:21:37 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6868C0613ED
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:20:24 -0800 (PST)
Received: from p548daeed.dip0.t-ipconnect.de ([84.141.174.237] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1l5qnR-0001w1-F7; Sat, 30 Jan 2021 15:00:17 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 0/2] net: dsa: hellcreek: Report tables sizes
Date:   Sat, 30 Jan 2021 14:59:32 +0100
Message-Id: <20210130135934.22870-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1612016424;0b1932c6;
X-HE-SMSGID: 1l5qnR-0001w1-F7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Florian, Andrew and Vladimir suggested at some point to use devlink for
reporting tables, features and debugging counters instead of using debugfs and
printk.

So, start by reporting the VLAN and FDB table sizes.

Thanks,
Kurt

Kurt Kanzenbach (2):
  net: dsa: hellcreek: Report VLAN table occupancy
  net: dsa: hellcreek: Report FDB table occupancy

 drivers/net/dsa/hirschmann/hellcreek.c | 99 ++++++++++++++++++++++++--
 drivers/net/dsa/hirschmann/hellcreek.h |  6 ++
 2 files changed, 101 insertions(+), 4 deletions(-)

-- 
2.26.2

