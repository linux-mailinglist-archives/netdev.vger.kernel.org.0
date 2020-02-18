Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549031630A7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBRTx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:53:28 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:39077 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgBRTx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:53:28 -0500
Received: from kiste.fritz.box ([87.123.206.145]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M9qYn-1j7jy53b6b-005oDO; Tue, 18 Feb 2020 20:53:16 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next] Documentation: fix vxlan typo in mlx5.rst
Date:   Tue, 18 Feb 2020 20:52:59 +0100
Message-Id: <20200218195259.203207-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:b6FZn3S9TXUmqKsto55EN+MZ3uwWWpeQJzGGsPymGeIVvIWL6Vy
 J6c+8B+0cbJFn1NRb1zCgJy+ceBJ6Ks/mj6bmj32T7BgMC1Jcm1Ez/KkzfFx2PP9rER7+7A
 Jw+yWQbq40ngXOv7ZIGJCK88g02YiaXapun3LSvrKE9LSvGzLfXeypq26Ar6tLEErnO6Hxi
 0XMwx2/B4NsYznkG3YO9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/bAVHqoKObg=:gFHQt73GiVWF5iLPupRM7k
 kPhmVws4aWGJE1+5VG/eZyr0hvJN2HNC4lp7zNq8lMhBQTbnch6vMwQ3KfINzE58fQC5BAX2+
 UpUUubTm1rU31CnIS0/YPXrFR1Tinqxq/eo8vfYpdJzJmKc1K/kJ71gEV2rS+FXS3PbNp6J+e
 AWijJssa6nFcQF0YInGrm2pE1Z9p9rQRCXteMEhVWUkXQ/bg/wOblp50jMo+lhcvYHvCBYee8
 TFD6LzAtaDf/rQGpuhAaGk7v3udoaZCR5or1QU+VNRsRkF3hbRYPGENB82lMts7cdhM4ATK5Q
 qqI/lJn5Jt9Sr+ZfF4S6VwBSD55vACkMvJUACFuxopEB6D8Ef/i+NDKQrKp35e7e8PK9npi1S
 iIrrGxuPzWdRAJw9QraSF2dQq0/HGhA26CfEGn1pidv668T1DoOR3qbH6qevaPRhHvtL0mAEX
 No5OpRaC1BES67ahJ/bYbdBIgKXekHKuYBuzhLYAE0jVR9R7NkRnc2tZjao8BbsHh9t4V612n
 B3X8DhnABhjRt3yb3FZ5P/4KUKrK4p6t+N7TBRhtILrIA+vrKPu5ZCFoDimXmk4yxXUuRmVOH
 o3DvG/dZBw2zabMocMvRhXrLJDNA1clzodPgaz+nZ7ZmU1BF741P9fDehXx+pCe4KlItwbbwU
 Tk29DDIvZZrKMso2p8n6fC4zBPqvCPtWMAPzSPdqxejSs4nAk1VQc7SLHliajucvUNaYMXVOX
 6P2/FSadH9fnRUQjmtJ2g2urCN707X4AxCS5OAw61vn39Q6xe8OgmjkQjQus2ioPbeKM76hmI
 H2kIMlw2IqF86HUchRi5HgrP1237pdi1N+qy3xfcMh/CGruIZrxk4CVzSrQ2CIXN70IQjCY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a vxlan typo in the mlx5 driver documentation.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 Documentation/networking/device_drivers/mellanox/mlx5.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Documentation/networking/device_drivers/mellanox/mlx5.rst
index f575a49790e8..e9b65035cd47 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -101,7 +101,7 @@ Enabling the driver and kconfig options
 **External options** ( Choose if the corresponding mlx5 feature is required )
 
 - CONFIG_PTP_1588_CLOCK: When chosen, mlx5 ptp support will be enabled
-- CONFIG_VXLAN: When chosen, mlx5 vxaln support will be enabled.
+- CONFIG_VXLAN: When chosen, mlx5 vxlan support will be enabled.
 - CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enabled (via devlink and ethtool).
 
 Devlink info
-- 
2.25.1

