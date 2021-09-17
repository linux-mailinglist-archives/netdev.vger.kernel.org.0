Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0840F1DE
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244956AbhIQGIY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Sep 2021 02:08:24 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:35161 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232726AbhIQGIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:08:23 -0400
Received: from [100.113.2.146] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id 1C/CB-29868-58034416; Fri, 17 Sep 2021 06:07:01 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRWlGSWpSXmKPExsWi1/P8kG6LgUu
  iwYm5hhbn7x5itvj17gi7xaL3M1gtji0Qc2Dx2DnrLrvHzh2fmTw+b5ILYI5izcxLyq9IYM34
  s2sBU8Eq0Yol97exNTDuFuxi5OIQEljJKHF6zQlmCGczo8TJM4vYuhg5OdgEdCSOdU5iBLFFB
  BQkppz8wwpSxCwwhVFi5tulzCAJYQFviZ1fdzJDFPlIrGzuZoKwrSSenDnJDmKzCKhKPHqyGm
  goBwevgKPE/seCIGEhgViJz5OPgu3iFFCX2D5zCguIzSggK9F34ghYnFlAXGLTs++sILaEgID
  Ekj3nmSFsUYmXj/+xgoyUENCQWHrZCyIsIbFvdy8bhG0gsXXpPhYIW15i9owbUHFOie5/j6HG
  60gs2P0JytaWWLbwNdh4XgFBiZMzn7BMYJSYheSKWUhaZiFpmYWkZQEjyypGy6SizPSMktzEz
  BxdQwMDXUNDY10DXSNTI73EKt1EvdRS3eTUvJKiRKCsXmJ5sV5xZW5yTopeXmrJJkZgHKcUMv
  zZwbj6zQe9Q4ySHExKorz1yi6JQnxJ+SmVGYnFGfFFpTmpxYcYZTg4lCR4N+sA5QSLUtNTK9I
  yc4ApBSYtwcGjJMLLB5LmLS5IzC3OTIdInWK05Jjwcu4iZo6DR+cBybknFi9iFmLJy89LlRLn
  na4H1CAA0pBRmgc3Dpb2LjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5tUHmcKTmVcCt/UV0
  EFMQAcd2e8AclBJIkJKqoEpMuyjrmeLn1po4U5lmWYZbS/1XaEnP83mF05J1WL4cDT13Isvau
  2/P7xuO9tceOL2XdPuBZq3opoOXkpbuPfJ2+Dsd9Pvb/t1QOvlkgd509x+//H1SZSQ/Zc9+YF
  geeyH5hnbus8x3Xxx7If4sZVb5s1JvbQy4urC3+/fLpp/1onh28nPwnefHs47I77v44TWrpLG
  wC2lKlsnht2LE/QI5VwsxFrFZPCDz3DXja/mmkU3N21ZyBp2I2WrdGj+5D/qZnuPLtoaurqey
  ezKtDSnL2d4BdVnGvw01HukGfLC7nrv7H/PghhXyq73r556vMyqja8668x+mXVBDG6e265qfD
  tQ8UJ6T9n+notPT/jl6iqxFGckGmoxFxUnAgDZKosz9gMAAA==
X-Env-Sender: Walter.Stoll@duagon.com
X-Msg-Ref: server-2.tower-233.messagelabs.com!1631858820!265226!1
X-Originating-IP: [46.140.231.194]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 12465 invoked from network); 17 Sep 2021 06:07:00 -0000
Received: from 46-140-231-194.static.upc.ch (HELO chdua14.duagon.ads) (46.140.231.194)
  by server-2.tower-233.messagelabs.com with ECDHE-RSA-AES256-SHA384 encrypted SMTP; 17 Sep 2021 06:07:00 -0000
Received: from chdua14.duagon.ads (172.16.90.14) by chdua14.duagon.ads
 (172.16.90.14) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Fri, 17 Sep
 2021 08:07:00 +0200
Received: from chdua14.duagon.ads ([fe80::4058:63e9:621d:cb5]) by
 chdua14.duagon.ads ([fe80::4058:63e9:621d:cb5%12]) with mapi id
 15.00.1497.023; Fri, 17 Sep 2021 08:07:00 +0200
From:   Walter Stoll <Walter.Stoll@duagon.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: [BUG] net/phy: ethtool versus phy_state_machine race condition
Thread-Topic: [BUG] net/phy: ethtool versus phy_state_machine race condition
Thread-Index: Adeq+zlOM+IIDk7fQpuG9NCcUwJ8ZgAQnvGAABLV5zA=
Date:   Fri, 17 Sep 2021 06:07:00 +0000
Message-ID: <addb830174704f3c9dcfea1323ed8ec8@chdua14.duagon.ads>
References: <0a11298161d641eb8bd203daeac38db1@chdua14.duagon.ads>
 <YUPMQ1HZDBEELnz0@lunn.ch>
In-Reply-To: <YUPMQ1HZDBEELnz0@lunn.ch>
Accept-Language: en-US, de-CH
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-codetwo-clientsignature-inserted: true
x-codetwoprocessed: true
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.17.0.41]
x-loop: 1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Von: Andrew Lunn <andrew@lunn.ch>
> Gesendet: Freitag, 17. September 2021 00:59
> An: Walter Stoll <Walter.Stoll@duagon.com>
> Cc: f.fainelli@gmail.com; hkallweit1@gmail.com; netdev@vger.kernel.org
> Betreff: Re: [BUG] net/phy: ethtool versus phy_state_machine race condition
> 
> On Thu, Sep 16, 2021 at 01:08:21PM +0000, Walter Stoll wrote:
> > Effect observed
> > ---------------
> >
> > During final test of one of our products, we use ethtool to set the mode of
> > the ethernet port eth0 as follows:
> >
> > ethtool -s eth0 speed 100 duplex full autoneg off
> >
> > However, very rarely the command does not work as expected. Even though the
> > command executes without error, the port is not set accordingly. As a result,
> > the test fails.
> >
> > We observed the effect with kernel version v5.4.138-rt62. However, we think
> > that the most recent kernel exhibits the same behavior because the structure of
> > the sources in question (see below) did not change. This also holds for the non
> > realtime kernel.
> >
> >
> > Root cause
> > ----------
> >
> > We found that there exists a race condition between ethtool and the PHY state-
> > machine.
> >
> > Execution of the ethtool command involves the phy_ethtool_ksettings_set()
> > function being executed, see
> > https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L315
> >
> > Here the mode is stored in the phydev structure. The phy_start_aneg() function
> > then takes the mode from the phydev structure and finally stores the mode into
> > the PHY.
> >
> > However, the phy_ethtool_ksettings_set() function can be interrupted by the
> > phy_state_machine() worker thread. If this happens just before the
> > phy_start_aneg() function is called, then the new settings are overwritten by
> > the current settings of the PHY. This is because the phy_state_machine()
> > function reads back the PHY settings, see
> > https://elixir.bootlin.com/linux/v5.4.138/source/drivers/net/phy/phy.c#L918
> >
> > This is exactly what happens in our case. We were able to proof this by
> > inserting various dev_info() calls in the code.
> 
> Hi Walter
> 
> This makes sense.  We have a similar problem with MAC code calling
> phy_read_status() without holding the PHY lock as well. I have some
> patches for that, which i need to rebase. I will see if your proposed
> fixed can be added to that, or if it should be a separate series.
> 
>       Andrew

Hi Andrew

Thanks a lot for your immediate response. Please note that I am not a kernel
developer. Therefore I think, the patch eventually applied will look differently
from what I proposed. Please let me know whenever you have something to test.

Walter
