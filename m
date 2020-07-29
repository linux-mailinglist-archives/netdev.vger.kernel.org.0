Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F92231A55
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 09:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgG2HbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 03:31:19 -0400
Received: from mout.gmx.net ([212.227.17.20]:60053 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgG2HbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 03:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596007825;
        bh=/6jwjysC3R7FYZx0gkpHIqy73Z1vAPgihqzQyWq7aQE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=TK6bTwUW8MtjJXH8EFFKJnMhOzjn29sYIwyiokDnmA54/lqyxeFBrR+yvhFZBVJ5t
         voIxkON12u8+OG0OTHGTOzyQDdrapsXfYA3Ut84WswoRi8fPnfdCsZb1AdhwBI+rlV
         +SYUXBjGBfUPnwVbgeLnf22IdX1Bl7ETCA0v9RGE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.75.74.240] ([185.75.74.240]) by web-mail.gmx.net
 (3c-app-gmx-bs12.server.lan [172.19.170.63]) (via HTTP); Wed, 29 Jul 2020
 09:30:25 +0200
MIME-Version: 1.0
Message-ID: <trinity-2271c653-26b2-4f06-95c1-f64fdc0d3499-1596007825341@3c-app-gmx-bs12>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     David Miller <davem@davemloft.net>, stable@vger.kernel.org
Cc:     dwmw2@infradead.org, sean.wang@mediatek.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Mark-MC.Lee@mediatek.com, john@phrozen.org,
        Landen.Chao@mediatek.com, steven.liu@mediatek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource@vdorst.com, linux-mediatek@lists.infradead.org
Subject: Aw: Re: [PATCH] net: ethernet: mtk_eth_soc: Always call
 mtk_gmac0_rgmii_adjust() for mt7623
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 29 Jul 2020 09:30:25 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200728.170547.454266815690646224.davem@davemloft.net>
References: <trinity-fb0cdf15-dfcf-4d60-9144-87d8fbfad5ba-1586179542451@3c-app-gmx-bap62>
 <52f10e30f62b8521fd83525a03ecff94b72d509b.camel@infradead.org>
 <20200728.170547.454266815690646224.davem@davemloft.net>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:LFOtg+/9chRHhl3e6u15HWjD5zZplHcQ/p6xFuZe2KjmcNMNo4+LXQasBIpAoe6IkOjTt
 OVlN8iD7lOjjKifkxXdQb2xRUNlKz4mK+mIV5Tp6GNbqkQFf/BdSRKNTE7y7JOrue3t4gAuAJWH9
 LGOnPPI+aTaDgv+Pjhy/Fgvz8JfNikMgzuAdJhOH6RFivRtYNMKUJqlwCU2DqLcKBGrne5sw0MHu
 7UxekuI1HDXnCNgzvOnN4JNrXZzvuBhYJNw4eF8ghwtcrqwxOAabUpd/TAsb0eclYAemBhcYcEcQ
 A0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:azLCOmZcRdE=:01GF9R4OxBLxO9kk4G/4gG
 axgxc1vEWIe+r0Y5SDS9hWWPSKI4oDf7zxab4jx76yw4EnLOJU7sVDyrCeDxtESRiC2rLIDDH
 POEU6q7kWE+Ms893KJRtuA/15Tad9Dlc8I76dvGGgLYFidg7KcpDsjwJ17FjTM8O9elaP0Qog
 cioghFsExBKs5jKYnSLSHhl/7Gno5OBxNtPs+lgaSXGuwS/zuc6eVDhC58NaSbc44frs4gKoa
 sMTxapgqi8GsIYOGtR22npk80z3r7aa9lmu5UVg3RzotCj2tp0Mi4pV4uLctlgcfFKO/FHRo2
 rigcOKPud5iFCAVALonVWUooV49nt9IINLJXjkxDGzjRZOsPIo8xGvJh4sk1vhMIDaeJ0e+xX
 1Dw4Av0DYK9RXrWWayD0K7iEMm7GFxDk40IriUkNAbCosmXG2ebbsBu4/2+RGfFTxTkODtHrX
 QuBUKBS7k07AL4yQtqjUgHjhAo8Dn9E66DkvKIwXU1lV3Cgs/wXmoo1yNa3FJjVFo4ZLaJ+rf
 GH0qKED/kbpRLrPwfrmt97XOYDyHMNzIphBuBrJKRQbBQ4EpuzmuKhVz6rp1ts+PcF4k35y72
 dJAT7ClDLKWygT+27Xh2yvcm4f7JherF3UIrDK3wDRSPpz0fqkRjCvG9ZUYCXmAdbeZsMAbHf
 06cZyZhfuXA8GNY1J+aQysqo2yEKkdtmZlo7IUPKTZJzZG4d6FBOUuavmBqyEyFGv9KA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you David's to get this finally applied. Add recipient for stable tree as TRGMII on 5.4+ is also broken without this Patch.

regards Frank


> Gesendet: Mittwoch, 29. Juli 2020 um 02:05 Uhr
> Von: "David Miller" <davem@davemloft.net>
Applied.
