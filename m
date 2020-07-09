Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1918B21A822
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGITt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:49:29 -0400
Received: from mout.gmx.net ([212.227.17.22]:58935 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgGITsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 15:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594324081;
        bh=qjjKU85vWrmvdFue2XV3Qb2IIMAX9y66v6AoZZPoc2M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=e7IvaRLpDkT/47bzRnTddtiimKHgCOu//u3jijFPYjXMYg+NwEdyW8xhh/2wlymUH
         tChSZTTaaVLRdjGn7cNFEpwFWuHkAcOSqFg5XFHSYYOh+whMzslBnIA8N7zaJom7vM
         bDPbsC3UElWQU7/ODWeeoMn3+uh5uZlNRL8KIojU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.208.213.58] ([80.208.213.58]) by web-mail.gmx.net
 (3c-app-gmx-bap65.server.lan [172.19.172.65]) (via HTTP); Thu, 9 Jul 2020
 21:48:01 +0200
MIME-Version: 1.0
Message-ID: <trinity-487c0605-faeb-462e-a373-bc393ce3dbfa-1594324081639@3c-app-gmx-bap65>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-mediatek@lists.infradead.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <landen.chao@mediatek.com>
Subject: Aw: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix mtu warning
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 9 Jul 2020 21:48:01 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200709134115.GK928075@lunn.ch>
References: <20200709055742.3425-1-frank-w@public-files.de>
 <20200709134115.GK928075@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:n4zQntLiWUydrYDQKBFrQyQq/zGUb616R6yRiuIW4EkJfjq+54nieuV/hYKY/1qyo45o+
 T2AV17jN910J1AYgwwgjqWXNF94zV6gLBYMT9Hl4WOnfgtJTvXNzcnqT/xY+bj7KTOvcfPBe2qLH
 iufWNu521oC6dI9gX0kLgb9Ft7IHy4L3NXJ8+w0rSZudmHd/G3VMlJ4H2z+UG2OBzWIm2Q5L2Glg
 rZbzX/ZP8wO9W5+MuBod2H8YjmwO4CiGt4uOWYEiWOSID3DQ8+IH6TSyRDTaIzL/nUQZcmB2n/mo
 BQ=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RyfU1bnrcBs=:QIrBsHWDa406vNbEkzdDWM
 tUp9/4HQvksPc36DfD8pCJggCEq1HLpFMZ7/stSKtdVeygNt+Y9lxt6OLVvw1xaZv2RbU7Tag
 E+21kkdjiVq7f8kNpC+/gFAUrn05JhzoawIW5TbrzE8GjMF50uCs22GqGuVSg3cJrWx375YGV
 wQkx2xFQNnLIVMGmIVLbxxnlWc/J1EFlJdYuksr4e5IOz0tuQ8/DdV3T5DyI4eYbR/UjC80/T
 4aoGD8Si03yFjIOl5qiW8CsqmO8v0HCQzKfPp4P/oYq8iZ9oCNUtFl+ltDcNtK58geEcS2UHw
 vDJYXH+3VBpKRfWuylYykkNYowZGoKSMjiWrs6O+Qujl9IuHf0HUGdY+XaDO6MMYW4D3DbSuP
 ME+TY3YICgPwVLz+6JmG2F1J+8T4Wm4/EBIh9hDf3LrfanI1SENfD0iYP3ivPVqLrIJRifAaG
 fiTazWXG5d12bqqs9u+yKR73kvLIA1wGeyB8hREZf+94XoJe5mw6npVuvXI+EmxNkiyRkHz3Q
 YnVQGnw3vmJI1Iv8oK0uRTZD/uudXQNQxvdOa2e/kVmUpw3V5cO7wR30jP2AejfrmaxHr1ZdL
 QWbXmCoyHuQ67WV28L+oyZuzVS4C98uUsZDamcYVFORyri17iJcAOiOM0oe9P6IZ5Fjf406fr
 +ou5Av5QPvuUnc4CJmeCTwbubuDE48AmBESyFn4O0+cahSCSQ5Ej5hB9Ua7fNAX5mc3M=
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Donnerstag, 09. Juli 2020 um 15:41 Uhr
> Von: "Andrew Lunn" <andrew@lunn.ch>

> > +	eth->netdev[id]->max_mtu =3D 1536;
>
> I assume this is enough to make the DSA warning go away, but it is the
> true max? I have a similar patch for the FEC driver which i should
> post sometime. Reviewing the FEC code and after some testing, i found
> the real max was 2K - 64.

i tried setting only the max_mtu, but the dsa-error is still present

mt7530 mdio-bus:00: nonfatal error -95 setting MTU on port 0

but i got it too, if i revert the change...mhm, strange that these were ab=
sent last time...

the other 2 are fixed with only max_mtu.
@andrew where did you got the 2k-64 (=3D1984) information? sounds like orw=
ell ;)

-95 is EOPNOTSUPP

as so far, commit 72579e14a1d3d3d561039dfe7e5f47aaf22e3fd3 introduces the =
warning,
but the change is making it non-fatal...so i need to adjust my fixes-tag.
i guess the real problem lies in this:

bfcb813203e6 net: dsa: configure the MTU for switch ports

it looks like dsa_slave_change_mtu failes because of missing callback in m=
tk_driver (mt7530 for mt7531 in my case).

net/dsa/slave.c
1405 static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
...
1420     if (!ds->ops->port_change_mtu)
1421         return -EOPNOTSUPP;

i added an empty callback to avoid this message, but mtu should be set in =
hardware too...
here i will ne some assistance from mtk ethernet experts and mt7531 driver=
 (from landen chao) to be merged first (after some needed changes)

=2D-- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2259,6 +2259,12 @@ mt753x_phy_write(struct dsa_switch *ds, int port, i=
nt regnum, u16 val)
        return priv->info->phy_write(ds, port, regnum, val);
 }

+static int
+mt753x_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+       return 0;
+}
+
 static const struct dsa_switch_ops mt7530_switch_ops =3D {
        .get_tag_protocol       =3D mtk_get_tag_protocol,
        .setup                  =3D mt753x_setup,
@@ -2281,6 +2287,7 @@ static const struct dsa_switch_ops mt7530_switch_ops=
 =3D {
        .port_vlan_del          =3D mt7530_port_vlan_del,
        .port_mirror_add        =3D mt7530_port_mirror_add,
        .port_mirror_del        =3D mt7530_port_mirror_del,
+       .port_change_mtu        =3D mt753x_port_change_mtu,
        .phylink_validate       =3D mt753x_phylink_validate,
        .phylink_mac_link_state =3D mt7530_phylink_mac_link_state,
        .phylink_mac_config     =3D mt753x_phylink_mac_config,
