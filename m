Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F417B76C2
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbfISJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:53:27 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45743 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388954AbfISJx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 05:53:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so3386279qtj.12
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 02:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=irgTfvft8fZHZVDdYovXyZT3bMtMcfkp7KarqlH7Nzw=;
        b=XyVILQzV7IIMuQTXMRysBss5y8qxFJOyMfVNTgIOTn8pGD0V1r0pg+eIWHRlPqXoQB
         q4B06C6e8PRxXlbMm799MfwqO+rr1yxYCoQlAo6HvMRbBJ8XNx3Wm55MNaGxHQyx8Vxh
         0PRbZRirq/dEDtUYyy9b4csWTpOQbwpW81Dmu0G+zkB1VyXWWzebxx5UsCmb+8FK5hkg
         XDCLTw9I5GMBska/COUwdztiUMKNi+1t7c/THhlOnfOuO7GleohKRQqwkce81qZRszo1
         ly8IbFXAqwMLaVj0/sbyv5776kZimbpSlYliWGuaHkNkWKmUkXoKU9xEtc4jCheJ+gih
         pPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=irgTfvft8fZHZVDdYovXyZT3bMtMcfkp7KarqlH7Nzw=;
        b=A63Ayo0QLpz1+d97iGHrlyc6dpRMu6YxSnDKktbeikV7ESaL3v88Sfp+6ctM+Y3iEb
         nWph47ZLNZpu+JFWrFJbxUJY37OpegNGEmjafIVxmNKOsiHzer1Zhkkvm4XZoxhEEQiW
         m0aFCaNkqPaJD4gcAQ0Z7ZxpWCLD0SOpoBKo3facu/CUmMdwxQ0bDajkkkaSn7KIwT6z
         Jx/nXAl1XKv6b2UIwHa09xMNroP5laejRIT9kW67IzlR7Ocs/TPDZevZ6cYqix83acjz
         se2kPAtGl4YdB6VaJZS8dU7MP1jfOMRBs2tTi/3mqfOuqUBjQZ47NouhmxDoYkBCLdMY
         YVnw==
X-Gm-Message-State: APjAAAWVCiBgN3h6qoi+anXKc/aODd7Tr6YpTBuRxc5Ie5UvPLcGLNl5
        +7HrHM2YsQrUvQGqSbXQ9f31MdC67JLXyDGyaPbOzg==
X-Google-Smtp-Source: APXvYqwGxF5+gbe//CSxlcRosUjiP99Gh80dd5As38n1jDNp000qh7ZpLMgKtFTlllVpTf5nAIeHIY8EyajIzQ2e5fI=
X-Received: by 2002:ac8:e09:: with SMTP id a9mr2264679qti.88.1568886805752;
 Thu, 19 Sep 2019 02:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com> <9357.1568880036@nyx>
In-Reply-To: <9357.1568880036@nyx>
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI=?= 
        <zaharov@selectel.ru>
Date:   Thu, 19 Sep 2019 12:53:14 +0300
Message-ID: <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=87=D1=82, 19 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 11:00, Jay V=
osburgh <jay.vosburgh@canonical.com>:
>
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=97=D0=B0=D1=85=D0=B0=D1=80=
=D0=BE=D0=B2 wrote:
>
> >> >Once a while, one of 802.3ad slaves fails to initialize and hangs in
> >> >BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slav=
e
> >> >link initialization transition states") checks slave->last_link_up. B=
ut
> >> >link can still hang in weird state.
> >> >After physical link comes up it sends first two LACPDU messages and
> >> >doesn't work properly after that. It doesn't send or receive LACPDU.
> >> >Once it happens, the only message in dmesg is:
> >> >bond1: link status up again after 0 ms for interface eth2
> >>
> >>         I believe this message indicates that the slave entered
> >> BOND_LINK_FAIL state, but downdelay was not set.  The _FAIL state is
> >> really for managing the downdelay expiration, and a slave should not b=
e
> >> in that state (outside of a brief transition entirely within
> >> bond_miimon_inspect) if downdelay is 0.
> >That's true, downdelay was set to 0, we only use updelay 500.
> >Does it mean, that the bonding driver shouldn't set slave to FAIL
> >state in this case?
>
>         It really shouldn't change the slave->link outside of the
> monitoring functions at all, because there are side effects that are not
> happening (user space notifications, updelay / downdelay, etc).
>
> >> >This behavior can be reproduced (not every time):
> >> >1. Set slave link down
> >> >2. Wait for 1-3 seconds
> >> >3. Set slave link up
> >> >
> >> >The fix is to check slave->link before setting it to BOND_LINK_FAIL o=
r
> >> >BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is i=
n
> >> >BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
> >> >BOND_LINK_DOWN.
> >> >
> >> >Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
> >> >transition states")
> >> >Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
> >> >---
> >> > drivers/net/bonding/bond_main.c | 2 +-
> >> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bo=
nd_main.c
> >> >index 931d9d935686..a28776d8f33f 100644
> >> >--- a/drivers/net/bonding/bond_main.c
> >> >+++ b/drivers/net/bonding/bond_main.c
> >> >@@ -3135,7 +3135,7 @@ static int bond_slave_netdev_event(unsigned lon=
g event,
> >> >                */
> >> >               if (bond_update_speed_duplex(slave) &&
> >> >                   BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
> >> >-                      if (slave->last_link_up)
> >> >+                      if (slave->link =3D=3D BOND_LINK_UP)
> >> >                               slave->link =3D BOND_LINK_FAIL;
> >> >                       else
> >> >                               slave->link =3D BOND_LINK_DOWN;
> >>
> >>         Is the core problem here that slaves are reporting link up, bu=
t
> >> returning invalid values for speed and/or duplex?  If so, what network
> >> device are you testing with that is exhibiting this behavior?
> >That's true, because link becomes FAIL right in this block of code.
> >We use Mellanox ConnectX-3 Pro nic.
> >
> >>
> >>         If I'm not mistaken, there have been several iterations of
> >> hackery on this block of code to work around this same problem, and ea=
ch
> >> time there's some corner case that still doesn't work.
> >As i can see, commit 4d2c0cda0744 ("bonding: speed/duplex update at
> >NETDEV_UP event")
> >introduced BOND_LINK_DOWN state if update speed/duplex failed.
> >
> >Commit ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
> >changed DOWN state to FAIL.
> >
> >Commit 334031219a84 ("bonding/802.3ad: fix slave link initialization
> >transition states")
> >implemented different new state for different current states, but it
> >was based on slave->last_link_up.
> >In our case slave->last_link_up !=3D0 when this code runs. But, slave is
> >not in UP state at the moment. It becomes
> >FAIL and hangs in this state.
> >So, it looks like checking if slave is in UP mode is more appropriate
> >here. At least it works in our case.
> >
> >There was one more commit 12185dfe4436 ("bonding: Force slave speed
> >check after link state recovery for 802.3ad")
> >but it doesn't help in our case.
> >
> >>
> >>         As Davem asked last time around, is the real problem that devi=
ce
> >> drivers report carrier up but supply invalid speed and duplex state?
> >Probably, but I'm not quite sure right now. We didn't face this issue
> >before 4d2c0cda0744 and ea53abfab960
> >commits.
>
>         My concern here is that we keep adding special cases to this
> code apparently without really understanding the root cause of the
> failures.  4d2c0cda0744 asserts that there is a problem that drivers are
> not supplying speed and duplex information at NETDEV_UP time, but is not
> specific as to the details (hardware information).  Before we add
> another change, I would like to understand what the actual underlying
> cause of the failure is, and if yours is somehow different from what
> 4d2c0cda0744 or ea53abfab960 were fixing (or trying to fix).
>
>         Would it be possible for you to instrument the code here to dump
> out the duplex/speed failure information and carrier state of the slave
> device at this point when it fails in your testing?  Something like the
> following (which I have not compile tested):
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
> index 931d9d935686..758af8c2b9e1 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -378,15 +378,22 @@ static int bond_update_speed_duplex(struct slave *s=
lave)
>         slave->duplex =3D DUPLEX_UNKNOWN;
>
>         res =3D __ethtool_get_link_ksettings(slave_dev, &ecmd);
> -       if (res < 0)
> +       if (res < 0) {
> +               pr_err("DBG ksettings res %d slave %s\n", res, slave_dev-=
>name);
>                 return 1;
> -       if (ecmd.base.speed =3D=3D 0 || ecmd.base.speed =3D=3D ((__u32)-1=
))
> +       }
> +       if (ecmd.base.speed =3D=3D 0 || ecmd.base.speed =3D=3D ((__u32)-1=
)) {
> +               pr_err("DBG speed %u slave %s\n", ecmd.base.speed,
> +                      slave_dev->name);
>                 return 1;
> +       }
>         switch (ecmd.base.duplex) {
>         case DUPLEX_FULL:
>         case DUPLEX_HALF:
>                 break;
>         default:
> +               pr_err("DBG duplex %u slave %s\n", ecmd.base.duplex,
> +                      slave_dev->name);
>                 return 1;
>         }
>
> @@ -3135,6 +3142,9 @@ static int bond_slave_netdev_event(unsigned long ev=
ent,
>                  */
>                 if (bond_update_speed_duplex(slave) &&
>                     BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
> +                       pr_err("DBG slave %s event %d carrier %d\n",
> +                              slave->dev->name, event,
> +                              netif_carrier_ok(slave->dev));
>                         if (slave->last_link_up)
>                                 slave->link =3D BOND_LINK_FAIL;
>                         else

Thanks, did that, without my patch. Here is the output when link doesn't wo=
rk.
Host has actor port state 71 and partner port state 1:
[Thu Sep 19 12:14:04 2019] mlx4_en: eth2: Steering Mode 1
[Thu Sep 19 12:14:04 2019] DBG speed 4294967295 slave eth2
[Thu Sep 19 12:14:04 2019] DBG slave eth2 event 1 carrier 0
[Thu Sep 19 12:14:04 2019] 8021q: adding VLAN 0 to HW filter on device eth2
[Thu Sep 19 12:14:04 2019] mlx4_en: eth2: Link Up
[Thu Sep 19 12:14:04 2019] bond-san: link status up again after 0 ms
for interface eth2

Here is the output when everything works fine:
[Thu Sep 19 12:15:40 2019] mlx4_en: eth2: Steering Mode 1
[Thu Sep 19 12:15:40 2019] DBG speed 4294967295 slave eth2
[Thu Sep 19 12:15:40 2019] DBG slave eth2 event 1 carrier 0
[Thu Sep 19 12:15:40 2019] 8021q: adding VLAN 0 to HW filter on device eth2
[Thu Sep 19 12:15:40 2019] bond-san: link status definitely down for
interface eth2, disabling it
[Thu Sep 19 12:15:40 2019] mlx4_en: eth2: Link Up
[Thu Sep 19 12:15:40 2019] bond-san: link status up for interface
eth2, enabling it in 500 ms
[Thu Sep 19 12:15:41 2019] bond-san: link status definitely up for
interface eth2, 10000 Mbps full duplex

If I'm not mistaken, there's up event before carrier is up.


--=20
Best Regards,
Aleksei Zakharov
System administrator
