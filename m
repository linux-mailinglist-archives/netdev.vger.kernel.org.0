Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A751997CF
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgCaNsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:48:47 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37847 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730442AbgCaNsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 09:48:46 -0400
Received: by mail-qv1-f68.google.com with SMTP id n1so10855405qvz.4
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Tknx72E0/1bZfRE6ZqA5Gs1n1+8464Xg9NTXUSlpPcs=;
        b=xnpVOfvgn6JtmIgDJV14LaF0wEKcAIxM0p2C06XngRlABdmZKFtbgu/9ztX67OwYcg
         Q8Q2lDHnXBt7mxMBitmwIpXYkWb4TNU4razeTyr6ME1Y0jeEx5Y9cx+uiTnTr9Roy8iY
         R8OGlQgYH+DAGp9LiPRJRHSvnBe1jaLJu1kgE0Lr8SmCfsWPm54JBytkiyNHXDxjKVxE
         3xDKBHto3douGwT/1bQhxKHVBabxJTik9HtgJK9ZqLauTJGVeFL8p9ANzpgi5O8nPhCV
         868aYglVJyE5ZZYn8U/mpHU5Y1tJOCOFZJSr8opmjx1ne4jWsIcwGmLZa6gQwCh11vxF
         XbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Tknx72E0/1bZfRE6ZqA5Gs1n1+8464Xg9NTXUSlpPcs=;
        b=Z278u9cpUWzwTuDNQEP8LpL1KP56qLSLjE5xY+tpxNKmrEHYu2n0P1GZhAXTQ3YgwX
         g12hr2EDnMGiuGI8j9No6AwGPGQ1HjWYOOETBonRZQ8qrxdsYu8dMJKiS4+3KLhyE3d8
         yy36PXIJfEnBn6Xrn1et6WZIT3qXenhrSoxX2A7c0yj74SiXfwov8X+YLRH5md0sqkvd
         97vUldzUxBP5SMody8+9eco66ewWXzw6u8Z2Oc++/7PcyQEUKdvrB6AMR9aCWCRd4SF3
         9QTEG/5h1k3VvWd0wd6AvUjCySiP4kWsbtpnQhKXAggcgpRngzc4AfmJVKTuqRzEi3x+
         /XGw==
X-Gm-Message-State: ANhLgQ1S4jGXN/GSWS4SwoaM2XBfF4zYTN+XFN1YnFA66fPTuqxntHJ+
        q89fGJRB+tUpeqKcWPNHrTyEuqcigfhya07wG9N4HRT0
X-Google-Smtp-Source: ADFU+vs3qDJxALIoQqZQhV1fBNpT9j/jniKW2ruk7jppKy/dsWuyS9LVOJWerx6GTUPhxHKeHosIHpvuYaLp8NrA76s=
X-Received: by 2002:a05:6214:2c4:: with SMTP id g4mr16875950qvu.65.1585662524350;
 Tue, 31 Mar 2020 06:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com> <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
In-Reply-To: <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
From:   Charles DAYMAND <charles.daymand@wifirst.fr>
Date:   Tue, 31 Mar 2020 15:48:33 +0200
Message-ID: <CAFJtzm3pwAXKOxYLi+-EgCXYxA90UCGvRvn=qW=HD9AKzoheSQ@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
We tested to enable tx checksumming manually (via ethtool) on a kernel
4.19.0-5-amd64 which is the oldest kernel compatible with our software
and we observed exactly the same issue.
For information when connecting a laptop directly to the interface we
can't see any multicast packet when tx checksumming is enabled on
tcpdump.
Our network is composed of a cisco switch and we can still see the
multicast counters correctly increasing even when we have the issue.

I also confirm that when not using macvlan but the real interface
there is no issue on the multicast packets, they are correctly sent
and received.
I have a stupid question, if the IP checksum was bad on the multicast
packet, would the receiver NIC drop the packet or would it be seen by
tcpdump by the receiver ?

Le ven. 27 mars 2020 =C3=A0 20:43, Eric Dumazet <edumazet@google.com> a =C3=
=A9crit :
>
> On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com> w=
rote:
> >
> > On 27.03.2020 19:52, Eric Dumazet wrote:
> > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.co=
m> wrote:
> > >>
> > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
> > >>> On 27.03.2020 10:08, Charles Daymand wrote:
> > >>>> During kernel upgrade testing on our hardware, we found that macvl=
an
> > >>>> interface were no longer able to send valid multicast packet.
> > >>>>
> > >>>> tcpdump run on our hardware was correctly showing our multicast
> > >>>> packet but when connecting a laptop to our hardware we didn't see =
any
> > >>>> packets.
> > >>>>
> > >>>> Bisecting turned up commit 93681cd7d94f
> > >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_C=
SUM
> > >>>> which is responsible for the drop of packet in case of macvlan
> > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a sp=
ecific
> > >>>> case since TSO was keep disabled.
> > >>>>
> > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multi=
cast
> > >>>> issue, but we believe that this hardware issue is important enough=
 to
> > >>>> keep tx checksum off by default on this revision.
> > >>>>
> > >>>> The change is deactivating the default value of NETIF_F_IP_CSUM fo=
r this
> > >>>> specific revision.
> > >>>>
> > >>>
> > >>> The referenced commit may not be the root cause but just reveal ano=
ther
> > >>> issue that has been existing before. Root cause may be in the net c=
ore
> > >>> or somewhere else. Did you check with other RTL8168 versions to ver=
ify
> > >>> that it's indeed a HW issue with this specific chip version?
> > >>>
> > >>> What you could do: Enable tx checksumming manually (via ethtool) on
> > >>> older kernel versions and check whether they are fine or not.
> > >>> If an older version is fine, then you can start a new bisect with t=
x
> > >>> checksumming enabled.
> > >>>
> > >>> And did you capture and analyze traffic to verify that actually the
> > >>> checksum is incorrect (and packets discarded therefore on receiving=
 end)?
> > >>>
> > >>>
> > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
> > >>>> ---
> > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
> > >>>>  1 file changed, 3 insertions(+)
> > >>>>
> > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/d=
rivers/net/ethernet/realtek/r8169_main.c
> > >>>> index a9bdafd15a35..3b69135fc500 100644
> > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev=
, const struct pci_device_id *ent)
> > >>>>              dev->vlan_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_S=
G);
> > >>>>              dev->hw_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG)=
;
> > >>>>              dev->features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> > >>>> +            if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34) {
> > >>>> +                    dev->features &=3D ~NETIF_F_IP_CSUM;
> > >>>> +            }
> > >>>>      }
> > >>>>
> > >>>>      dev->hw_features |=3D NETIF_F_RXALL;
> > >>>>
> > >>>
> > >>
> > >> After looking a little bit at the macvlen code I think there might b=
e an
> > >> issue in it, but I'm not sure, therefore let me add Eric (as macvlen=
 doesn't
> > >> seem to have a dedicated maintainer).
> > >>
> > >> r8169 implements a ndo_features_check callback that disables tx chec=
ksumming
> > >> for the chip version in question and small packets (due to a HW issu=
e).
> > >> macvlen uses passthru_features_check() as ndo_features_check callbac=
k, this
> > >> seems to indicate to me that the ndo_features_check callback of lowe=
rdev is
> > >> ignored. This could explain the issue you see.
> > >>
> > >
> > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb=
->dev,
> > > so the second __dev_queue_xmit() should eventually call the real_dev
> > > ndo_features_check()
> > >
> > Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
> > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also the=
re?
>
> This path wont send packets to the physical NIC, packets are injected
> back via dev_forward_skb()
>
> >
> > Still I find it strange that a tx hw checksumming issue should affect m=
ulticasts
> > only. Also the chip version in question is quite common and I would exp=
ect
> > others to have hit the same issue.
> > Maybe best would be to re-test on the affected system w/o involving mac=
vlen.
> >
> > >
> > >
> > >> Would be interesting to see whether it fixes your issue if you let t=
he
> > >> macvlen ndo_features_check call lowerdev's ndo_features_check. Can y=
ou try this?
> > >>
> > >> By the way:
> > >> Also the ndo_fix_features callback of lowerdev seems to be ignored.
> >



--=20

Charles Daymand

D=C3=A9veloppeur infrastructure

26 rue de Berri 75008 Paris

Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
Assistance utilisateur - 01 70 70 46 26



--=20

Charles Daymand

D=C3=A9veloppeur infrastructure

26 rue de Berri 75008 Paris

Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
Assistance utilisateur - 01 70 70 46 26
