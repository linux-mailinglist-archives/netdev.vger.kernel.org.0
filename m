Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907F52DD924
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgLQTJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQTJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:09:33 -0500
Date:   Thu, 17 Dec 2020 11:08:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608232132;
        bh=c/cxrTjW+7xbFJ6g/nVPp5oNBveIiHB6q+RTtPW5b68=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=XMUQJyyZGnbABRzDrhaINgr/so06gpwLMuKSgKGShi2+MU9Dit1ZZEgxxNn0H4GDK
         na49b2ciSBUD/twqUfnrUEXUWgtxd+/6KpAKDXX5Zx1PwcLE8NBkmF+WcOlJRjaVgb
         BLs5TTiOLs+aIBL9tLrsQBPCOgelklPWHbDUTLn4NEyU/hdhQ/3rqoCI5d8OTqS2SN
         9Hxwtp8iWdjAvkKhPO5J23w0jtYmelikm37zuAzcVcChJsmPVCwujPmnESejLdaZbO
         wzsOrpEmBQAADzay2CAzCba8dVAguCdWzF37KJVL82pvejb9yuLn1/OeQQ/9VoEvg9
         gwegoV5bIDe4Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v9 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201217110851.4a059426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201217115330.28431-4-l.stelmach@samsung.com>
References: <20201217115330.28431-1-l.stelmach@samsung.com>
        <CGME20201217115342eucas1p125292db8ba7c23ee71e252d7e1695e0e@eucas1p1.samsung.com>
        <20201217115330.28431-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 12:53:30 +0100 =C5=81ukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
>=20
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
>=20
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
>=20
> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104;6=
5;86&PLine=3D65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-=
artik/
>=20
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>=20
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

drivers/net/ethernet/asix/ax88796c_main.c: In function =E2=80=98ax88796c_tx=
_fixup=E2=80=99:
drivers/net/ethernet/asix/ax88796c_main.c:248:6: warning: variable =E2=80=
=98tol_len=E2=80=99 set but not used [-Wunused-but-set-variable]
  248 |  u16 tol_len, pkt_len;
      |      ^~~~~~~
