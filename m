Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B3339D66
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 10:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhCMJkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 04:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhCMJkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 04:40:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F538C061763
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 01:40:01 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lL0kW-0002vy-T4; Sat, 13 Mar 2021 10:39:56 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v2 0/4] net: dsa: hellcreek: Add support for dumping tables
Date:   Sat, 13 Mar 2021 10:39:35 +0100
Message-Id: <20210313093939.15179-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615628402;59b7f840;
X-HE-SMSGID: 1lL0kW-0002vy-T4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

add support for dumping the VLAN and FDB table via devlink. As the driver uses
internal VLANs and static FDB entries, this is a useful debugging feature.

Changes since v1:

 * Drop memory reporting as there are better APIs to expose this
 * Move comment to VLAN patch

Previous versions:

 * https://lkml.kernel.org/netdev/20210311175344.3084-1-kurt@kmk-computers.de/

Thanks,
Kurt

Kurt Kanzenbach (4):
  net: dsa: hellcreek: Add devlink VLAN region
  net: dsa: hellcreek: Use boolean value
  net: dsa: hellcreek: Move common code to helper
  net: dsa: hellcreek: Add devlink FDB region

 drivers/net/dsa/hirschmann/hellcreek.c | 223 ++++++++++++++++++++-----
 drivers/net/dsa/hirschmann/hellcreek.h |   7 +
 2 files changed, 187 insertions(+), 43 deletions(-)

-- 
2.30.2

