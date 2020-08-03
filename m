Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A4423A9B8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHCPmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgHCPmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 11:42:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4656720678;
        Mon,  3 Aug 2020 15:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596469368;
        bh=DOj9OcJtGXqqSGfHi2NyDX5MMzd5SSpeXe4VvNcvxD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MdpLej8j8YH9K8651DFKaHJxXRamG3vED0YuKHOeUmX6qeyfKOXuNtz6RWcMilpCh
         1TorbNbhIDzhJFZauhGq6hWVB9cJS2pzYjdgYA1vWETWzVn3my3JS8hKsphrCa7deh
         8QpvsYD4aW4rsq2EjFLeoqc9myr3YKVMWREzk1ks=
Date:   Mon, 3 Aug 2020 08:42:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, f.fainelli@gmail.com,
        davem@davemloft.net, kernel@pengutronix.de
Subject: Re: [PATCH v4 06/11] net: dsa: microchip: ksz8795: change drivers
 prefix to be generic
Message-ID: <20200803084247.23ceb0ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200803054442.20089-7-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
        <20200803054442.20089-7-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Aug 2020 07:44:37 +0200 Michael Grzeschik wrote:
> The driver can be used on other chips of this type. To reflect
> this we rename the drivers prefix from ksz8795 to ksz8.
>=20
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

allmodconfig:

../drivers/net/dsa/microchip/ksz8795.c:415:41: error: using member 'shifts'=
 in incomplete struct ksz8
../drivers/net/dsa/microchip/ksz8795.c:802:46: warning: incorrect type in a=
rgument 3 (different type sizes)
../drivers/net/dsa/microchip/ksz8795.c:802:46:    expected unsigned int [us=
ertype] *vlan
../drivers/net/dsa/microchip/ksz8795.c:802:46:    got unsigned short *
../drivers/net/dsa/microchip/ksz8795.c:843:46: warning: incorrect type in a=
rgument 3 (different type sizes)
../drivers/net/dsa/microchip/ksz8795.c:843:46:    expected unsigned int [us=
ertype] *vlan
../drivers/net/dsa/microchip/ksz8795.c:843:46:    got unsigned short *
../drivers/net/dsa/microchip/ksz8795.c: In function =E2=80=98ksz8_r_vlan_en=
tries=E2=80=99:
../drivers/net/dsa/microchip/ksz8795.c:415:34: error: invalid use of undefi=
ned type =E2=80=98struct ksz8=E2=80=99
  415 |  struct ksz_shifts *shifts =3D ksz8->shifts;
      |                                  ^~
../drivers/net/dsa/microchip/ksz8795.c:415:21: warning: unused variable =E2=
=80=98shifts=E2=80=99 [-Wunused-variable]
  415 |  struct ksz_shifts *shifts =3D ksz8->shifts;
      |                     ^~~~~~
../drivers/net/dsa/microchip/ksz8795.c: In function =E2=80=98ksz8_port_vlan=
_add=E2=80=99:
../drivers/net/dsa/microchip/ksz8795.c:802:31: error: passing argument 3 of=
 =E2=80=98ksz8_r_vlan_table=E2=80=99 from incompatible pointer type [-Werro=
r=3Dincompatible-pointer-types]
  802 |   ksz8_r_vlan_table(dev, vid, &data);
      |                               ^~~~~
      |                               |
      |                               u16 * {aka short unsigned int *}
../drivers/net/dsa/microchip/ksz8795.c:427:69: note: expected =E2=80=98u32 =
*=E2=80=99 {aka =E2=80=98unsigned int *=E2=80=99} but argument is of type =
=E2=80=98u16 *=E2=80=99 {aka =E2=80=98short unsigned int *=E2=80=99}
  427 | static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 =
*vlan)
      |                                                                ~~~~=
~^~~~
../drivers/net/dsa/microchip/ksz8795.c: In function =E2=80=98ksz8_port_vlan=
_del=E2=80=99:
../drivers/net/dsa/microchip/ksz8795.c:843:31: error: passing argument 3 of=
 =E2=80=98ksz8_r_vlan_table=E2=80=99 from incompatible pointer type [-Werro=
r=3Dincompatible-pointer-types]
  843 |   ksz8_r_vlan_table(dev, vid, &data);
      |                               ^~~~~
      |                               |
      |                               u16 * {aka short unsigned int *}
../drivers/net/dsa/microchip/ksz8795.c:427:69: note: expected =E2=80=98u32 =
*=E2=80=99 {aka =E2=80=98unsigned int *=E2=80=99} but argument is of type =
=E2=80=98u16 *=E2=80=99 {aka =E2=80=98short unsigned int *=E2=80=99}
  427 | static void ksz8_r_vlan_table(struct ksz_device *dev, u16 vid, u32 =
*vlan)
      |                                                                ~~~~=
~^~~~
cc1: some warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:281: drivers/net/dsa/microchip/ksz8=
795.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [../scripts/Makefile.build:497: drivers/net/dsa/microchip] Err=
or 2
make[3]: *** [../scripts/Makefile.build:497: drivers/net/dsa] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [../scripts/Makefile.build:497: drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/netdev/net-next/Makefile:1771: drivers] Error 2
