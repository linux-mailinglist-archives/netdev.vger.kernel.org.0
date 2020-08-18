Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EB248D89
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHRRzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:55:22 -0400
Received: from mout.gmx.net ([212.227.17.20]:41509 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgHRRzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 13:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597773282;
        bh=ThYSr0h07PGP1iFZ6rJ9QbxAVk1GY6nk6qUL/FemZjQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ZD/HUFz6g7LsjEF68Pf72sBJy6F4o4HegT7T6oCNs66tsD490C5Oq6ZF6WvVPyOa+
         x9u1GMMo1fsn+utxxRdeQw06U0RzzG7jNzwcEdwJhOA9InImLUFHRplDyDTsA2nitS
         CaBeqk/46dKifXD/NfBYnkTW6F1UMXHb52E4EFU0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.53.43.192] ([185.53.43.192]) by web-mail.gmx.net
 (3c-app-gmx-bs30.server.lan [172.19.170.82]) (via HTTP); Tue, 18 Aug 2020
 19:54:41 +0200
MIME-Version: 1.0
Message-ID: <trinity-fb75beca-fce7-4d9e-b427-0e3e261ef8ca-1597773281910@3c-app-gmx-bs30>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        dqfext@gmail.com, Landen Chao <landen.chao@mediatek.com>
Subject: Aw: [PATCH net-next v2 0/7] net-next: dsa: mt7530: add support for
 MT7531
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 18 Aug 2020 19:54:41 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <cover.1597729692.git.landen.chao@mediatek.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Ds7VLClrKGTh8K23luUtZMtW5sd/BqVZ/QNFG8icOaN//D2sZPAPHdI401Z6MtEtACOkM
 VZax2EdaXstWLv+op9BWiVSjga+IuK3OVvw4bazTpeIyWGzp3V2nSFk2ZPa3H1t0cXMQXjK3oa3g
 dDCIWWlrAsWSKRsQYqwRhlAz9VfEbn2PAPSGiHX2UHC47xQqMD1/BXMgEdoTYQPkzJySeXhJgCa9
 QEMpMC7X4AwLQB0A/+r/DMv1nLio3QOlGuDPEjGKJeANp5DEfgMocu2TSqshfeXKqp+LB/X/9Qx6
 co=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TOaPV0uW0Dc=:NACFWz84xXR+Lpez06ygpx
 +3G9O8E0XVmC48ZtdOUS5XPxVVEHH+gNGvU0vn2PeZa1pujoqz66bys8kEXcaBf0CQlBXTzgp
 mKIkFe6+YgUjQYlDCEdok/JqijoEpqg47fhSmufqe2qdKmCwcF3vKpcJzvABi76oYVo/xCMgk
 Xy2CPhgqoMcfNUbqFfptGyi/jCj1A9Lyv+wB9oCqMUihkw5/+3vYM7N03b5DJku2KW8kVmLKX
 +8lAqbW2uwupsesREbGvooYM0EIN2Oy8/Q0qRhBwtk9X9gn54ZomN7M6LRtf0sWGYUU9y7YI6
 u/qSnQKWIrnRKI7J6wmONMkQeCK8j0DEXOxPQk4tzrhSWeQLAXUWbu0da+5pTQ50cPahtiuxI
 Ihebagt6WchvWhoChbCjxbJ/9Gco4UXdR3x+7dMNXsEU0c/M+fxxfW8ScuhNJu+qZ1bxIuUEW
 1MQMZa9GdW8H0yfG82LKqYnVOjtZazrB/y4Ff6Y3qUxOszRq9ZXaPtMFEHMCb/nMbj1ERNW5/
 aGSWh3/NOuHIlE6tgUOIL5mCO3ieblGH9RH17iusS6fYbBwWsdpVlzqhDQpCH1kWa0e92sApd
 Nptz2mHh24s+GtTZghsQLYl3q4W9gGbBZ3meUw2Bda26K09kVUx6n9kr6bmjCQuaLobKZ07uN
 1DwUtFN3m9Hu4/RxtkXwJa+gb0TFHySv7hRoZz6fnd3OtMjJied1n72jCVFijl7tCbc8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested full series on Bananapi-R2+R64 with5.9-rc1 (iperf3 no retransmitts, Throughput >900Mbit/s)

Tested-By: Frank Wunderlich <frank-w@public-files.de>

maybe you can include the port_change_mtu callback you've send me? or do you want to send it separately

regards Frank
