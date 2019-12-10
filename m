Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF7119234
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfLJUhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:37:21 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:43473 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfLJUhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:37:21 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N2lzA-1hijXp0e9U-0135X3; Tue, 10 Dec 2019 21:37:13 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency
Date:   Tue, 10 Dec 2019 21:36:54 +0100
Message-Id: <20191210203710.2987983-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zJ2ZnfctRkGrEmmQCsTswUN3CkKSHq1z6wDjKHcvncBqdAp5pu9
 Fc91qBajfNX/VAvcjRirsXJEWtk20Hjj2CsC+LuKMY987U6YhW0KRxlEzE3wzEoSyAst8m6
 ycVJaUHJsiiLRvtGE8g4eQlklWuB9S/gndxdGaj8f3x/WGeUfTm0G6vw6ACENDxQpVwh/C6
 YatDKbVEe+dE9+mZOa4Gg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/oWooy0CdaA=:LmtZVsHikqzQlV95reccN3
 KGxYNc/zPXeOjbYvNnBQ/JKVgXndvMBhHFKtkrjOPQgAG8pfWACWQoqz4E0FQ//L4Mj2dPJYw
 EKZ8GWp5AI1U95rPFF0BZGcPx7AAaHF2mtYaDZR7RI5PECoxXlKsEqt52ju/yZz3ffFz+RZkA
 U3SpQBcmihPlRmyaRjNE6KrKKSlnZC6vEfFCb2QSMdOz3ieqIKtDgMeEpM1S+D7PonSpcXmEL
 hG7IBOd/5EcYUaKBAasv+UlJQ0ffClD1+pNdBNVQnsNdr53/IZGuBbGkVoGCUztnYTak6jtLP
 XFvWYGeSe3iSwZJLooflerubE/JAUe9ZvVlN9ak7w+109kGGTIj1JunLBVpQkOqfwFZf2KwMq
 6bj8C8xr98llq1+zQMBT17OES2DBtydhU9rA7/KC4AOn7xrZqxvmPPTuii/ECAyvAiC8ZKXay
 z/FlQaoRWGEB8zP6PWCGDHMhNAhS4wmdZciHZqF8+LjOdaemJX8n/yU4iONNtN04sL16HFSI4
 X9rHUlJR6sdGQMDhz/BuhjTrFQQu+rXexeLB6l7h79vOeFJAKoocXXDszSFewIM0wWVIJjyQv
 TCqiQUmvzX1m3LDK73xd9ygYKg4cdOcg2HTuMtfBYad3tqiyK25zdZqkWO7A9TetvRV0Rt8No
 mzVR8J07TkKi5VMCW5QbIzkEsNbfCL7q0CSxXtfVpW1v9vKLDfazL7VSVTlcQwM2eXAOr4l0l
 WU8DBQlhnstG5WnK3fFMySk6U3SUiC17wbMNj5QkEfgdHLuOXQyXGqT6iuGnAoFJfMbZ/rYfp
 4HTo7bX1xmlqbs3AMOU3HjO20CwcAA2RDLEGV6oytvzVxkkYxPakO3f2WBW8ZbZPXZKzFHukn
 wPcXoQlU2nCKe2oN0UEw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
is disabled:

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
  Selected by [m]:
  - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]

Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
CONFIG_NETDEVICES.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/ocelot/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca814346..6f9804093150 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -2,6 +2,7 @@
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
+	depends on NET_VENDOR_MICROSEMI
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	help
-- 
2.20.0

