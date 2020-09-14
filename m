Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA04B26974D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINVCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:02:43 -0400
Received: from mout.gmx.net ([212.227.17.21]:58703 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgINVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117318;
        bh=QHRWJuRlj/bvqBByfA9FjYd/nrb9BYbZ9INfSiB7BXs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LCDXWNiGx/f7/F4o7aqtOnMSKb34Xb+dfPP7o7uu1cxRUx9p+sUlqVzH5i4VVUgGp
         Qzw2Vr/3MN+TH+CIKf4XTporbt+7t3PvZXRZaZwNkU0iggi5ulJ2nmWDSHabJFqVh3
         juh3MsHtSG4q0S2B/i2Ef83tT+ZYzS4YXACW15uQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MI5QF-1kKQKH0dq3-00F91d; Mon, 14 Sep 2020 23:01:58 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 5/6] 8390: Fix coding style issues
Date:   Mon, 14 Sep 2020 23:01:27 +0200
Message-Id: <20200914210128.7741-6-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ri1w2zKnw7gCApQlk74mLpgD0AE4ax/5r8acAEDmHrsHUvxdur5
 kaQkL/qsY4rtIdhcNbUVcelflOW+muYpVvjUzcFqTLr+j3/OFxHvm6m5SfAmmQfpDwkXFYu
 7SGZ2xshQCA9UCOzO9HLCeAYa7UgGvtaaSZ8AKBBwSfQcWlqnCoXCWdILZ4OAnndzH7ra5s
 OqA8Q/Fwlp8JfB6L06GfQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tHtwH6qc0TM=:+tY09QU2yV5UvJRe8JNn7G
 ex/AWwqcbfce2PnNRbPz86qODOf46yeYDlUaOzmyZM8YmtRZXo5SKx/SzJt6yYh2loWJxJPCT
 xrmRW9K7LvLumRa9dbE6NAsqcpHV+4Aqb9TIqL4xjySUH4lCRefQmZA9aOMNnQ8vG8W52PcL6
 BxALnFzuLvvakE2yBMJLdTgf/FozM4UjW6FA6ITz/5HWRU0uNpdZQTRS6z71ZAHFiCFbOqa20
 0AM3IsAoun+doMAWIePCxnL9CO7e9Yq9FaEDlrPpuyCTUixn9OkbYx/dmX2bH/yR44WM9wZ5T
 2+J3ju25Q4MhXi3SfVtP+o4GDw2ssvtIKQvumGK/xpRZSaVnNROjZ58d0pwVOFaNll/ERO4lH
 W2mX0XOvXqDRzvy3Mr7OihDmVTYs85S2hAbjbY+dWTae+Rn9jOScpvAsuXJrY4Gery62Jqo8J
 rwTlo6GFM2lAs8Nauzcv3QlHr1cIi4R9dTLsOY070nhhmyzh5Vs4y1Tiv1dA9+fb2okxKcrK3
 tyJYrfBA+PLRtPldP/dSypSLSudG32b5jk5qOwyXryYsIx0sX8t5Zh/K4n5BGItKJt+p98oGk
 S1La2VgKzYMtJsTzsE6AXI7ljsmsi3sFnVBxw9PNp44xPcfPR1OqyFYgLzSN6Hzw3y8t8XEt4
 dWpo3cBfycoquoZVIUbNaZYsGHrghgyd4woZOcyZFJSbqxyQ8T2FG+pHOP6zb/RUlGTK29Ef6
 hYqE5j/4M7naB466icR+qL7qqnEeLfs05gmB4uVoJwka3OWmwTSEQvQeU1r5cJOCYRFBCaWpa
 s8irFrnjTjgQxG/KHbBYmklUiK5ByukEuzLswZru1qDHd8fpBbdpPh9m2vxJ+kFyXmRcC84LG
 ybf1+Q/I1V4Krrc+TZEm/Yyb5YxN2wKnALAbFK2LLutqkd+1bOJwf1Um6TKceWI1ixTuyQK8q
 ASv4DfbxuSj2nXsMoW4hqtxpH5eWNrLXRwE6yqOHP2kDMa0hg/1n92CFG8CFdldDd7HTNRbB2
 aBZCj8JCY74GG6SYV0MnLLb93GLXnIHxrlrP2ge3emo6a3pQzhGvurqovEpwUFkte2MxvkXi3
 ExMJqz61xvrAKu4fvhR/WeqPBprkSqvv9VWHp+F8MrP+OOy0oEZ42+DjWkdffCHrgU3kfi0A3
 KrFbD2MRN6ImiuCWf9+wIK56iv1ielvj+x1c2rnvtqI6zmI0E7uul/DdQWAOSXcpnegg0UWCn
 RMN0nqbt0u2yNTL4M
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two minor coding style issues.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/8390.c b/drivers/net/ethernet/8390/=
8390.c
index 911fad7af3bd..735d5e84f73b 100644
=2D-- a/drivers/net/ethernet/8390/8390.c
+++ b/drivers/net/ethernet/8390/8390.c
@@ -73,7 +73,7 @@ const struct net_device_ops ei_netdev_ops =3D {
 	.ndo_get_stats		=3D ei_get_stats,
 	.ndo_set_rx_mode	=3D ei_set_multicast_list,
 	.ndo_validate_addr	=3D eth_validate_addr,
-	.ndo_set_mac_address 	=3D eth_mac_addr,
+	.ndo_set_mac_address	=3D eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	=3D ei_poll,
 #endif
@@ -83,6 +83,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
 struct net_device *__alloc_ei_netdev(int size)
 {
 	struct net_device *dev =3D ____alloc_ei_netdev(size);
+
 	if (dev)
 		dev->netdev_ops =3D &ei_netdev_ops;
 	return dev;
=2D-
2.20.1

