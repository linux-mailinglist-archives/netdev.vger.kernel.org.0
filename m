Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BD019F7B1
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgDFOMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:12:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34225 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbgDFOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:12:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id i186so7303081qke.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 07:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N+gYFJn1pdJz1uMpo8TigW4XHx8T5DcheQBKnbwva7I=;
        b=ZelWCVBhLkE/qb0uh3z+pwmp23UM+4L8P4CvaaBIQqmkBMJZ/5fef/3b2FNfztQcJ5
         d2ORfqQQb286PNtu17FygdilARXOenZQBdnDGLeSpeOd1lPb8Mi3lXFsxUhbv2PkTkt7
         MFoMsKm5t4flbbBPF6DMOGMulMrIWb1EVVGvM1neN34nZbH+dhlXZTA3aBMqjmd5zeCp
         RgTmpGWLQBAhh1BSnCZnVx8RoK9iPe7TgZ2OqrdVt5S7pN74Xcl+Rk370xEeGqzGqpZ1
         o/bvQUo7zxciCGxJZ5B1yQShPvszKsTcEvCR5GYhVF/ad+FGiFsy3Zkw9L4CXDcbRTA1
         uCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N+gYFJn1pdJz1uMpo8TigW4XHx8T5DcheQBKnbwva7I=;
        b=UYKb/5mnUkbst71x9yllWR8OPmWA/h8e+wLosIGVbH4om3JcG+3L5trsJzb2NrhrVm
         B+wt3yLLR6v+yuS6xu28Z+Ace9jSd9n9OHdrteWmzKxwwRmv5mCcO7anwdLBJEP0uftO
         DCRWeoX5CWos0J9HyNB4KSlaGjrjRL95fmSys/orUQo+02h7Kl72j1Cn4Y2EqMbXvCCU
         CHGDg9njRL5aKjb1MhqPfHits1TDl9cPcRmxTaMuso/vJqGAT1B6yRJryb40buAmdMs2
         1F9JqJ/9k5AKy7YcEV08sAfkKhKeVyoCoLA75wQxvOeXpBwYvnerysCqv54+48uiFzKJ
         uoXw==
X-Gm-Message-State: AGi0PuZTsd19YMVlDfNuREuGYrNO0PPzJH8W0aYx4tXIGLJ0ZUSmh/gO
        JohpIG+l2TFFSl/1bB9TLyzXqRPsW7CkpLedx0oOgA==
X-Google-Smtp-Source: APiQypLemhMUZ//jsvEeoCE8OwKSZ8l9wu/hS+5W3VU46fe5IG+LuVglJwOWMaU6/NpODtHf+2+4p/+9BMIBfPfBcBE=
X-Received: by 2002:a05:620a:81c:: with SMTP id s28mr16440957qks.147.1586182348606;
 Mon, 06 Apr 2020 07:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com> <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com> <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
In-Reply-To: <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
From:   Charles DAYMAND <charles.daymand@wifirst.fr>
Date:   Mon, 6 Apr 2020 16:12:17 +0200
Message-ID: <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
Sorry for the long delay, I didn't have physical access to the
hardware last week. I did more testing today by connecting directly my
laptop to the hardware and the issue not only affects multicast but
also unicast with macvlan.
Only ping packets are correctly sent.
Using wireshark I can only see malformed ethernet packets (example
with multicast packet below)
Frame 1: 106 bytes on wire (848 bits), 106 bytes captured (848 bits)
IEEE 802.3 Ethernet
    Destination: IPv4mcast_09 (01:00:5e:00:00:09)
    Source: b2:41:6f:04:c1:86 (b2:41:6f:04:c1:86)
    Length: 96
        [Expert Info (Error/Malformed): Length field value goes past
the end of the payload]
Logical-Link Control
    DSAP: Unknown (0x45)
    SSAP: Unknown (0xc0)
    Control field: I, N(R)=3D46, N(S)=3D0 (0x5C00)
Data (88 bytes)
    Data: 50320c780111087fac159401e0000009020802080048207a...
    [Length: 88]
Please find the full pcap file at this url with also a tentative to
establish a ssh connection :
https://fourcot.fr/temp/malformed_ethernet2.pcap

Best regards

Charles


Le mar. 31 mars 2020 =C3=A0 16:07, Heiner Kallweit <hkallweit1@gmail.com> a=
 =C3=A9crit :
>
> Thanks for further testing! The good news from my perspective is that the=
 issue doesn't occur
> w/o macvlen, therefore it doesn't seem to be a r8169 network driver issue=
.
>
> W/o knowing tcpdump in detail I think it switches the NIC to promiscuous =
mode, means
> it should see all packets, incl. the ones with checksum errors.
> Maybe you can mirror the port to which the problematic system is connecte=
d and
> analyze the traffic. Or for whatever reason the switch doesn't forward th=
e multicast
> packets to your notebook.
>
> Heiner
>
>
> On 31.03.2020 15:44, Charles DAYMAND wrote:
> > Hello,
> > We tested to enable tx checksumming manually (via ethtool) on a kernel =
4.19.0-5-amd64 which is the oldest kernel compatible with our software and =
we observed exactly the same issue.
> > For information when connecting a laptop directly to the interface we c=
an't see any multicast packet when tx checksumming is enabled on tcpdump.
> > Our network is composed of a cisco switch and we can still see the mult=
icast counters correctly increasing even when we have the issue.
> >
> > I also confirm that when not using macvlan but the real interface there=
 is no issue on the multicast packets, they are correctly sent and received=
.
> > I have a stupid question, if the IP checksum was bad on the multicast p=
acket, would the receiver NIC drop the packet or would it be seen by tcpdum=
p by the receiver ?
> >
> > Le ven. 27 mars 2020 =C3=A0 20:43, Eric Dumazet <edumazet@google.com <m=
ailto:edumazet@google.com>> a =C3=A9crit :
> >
> >     On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.=
com <mailto:hkallweit1@gmail.com>> wrote:
> >     >
> >     > On 27.03.2020 19:52, Eric Dumazet wrote:
> >     > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gm=
ail.com <mailto:hkallweit1@gmail.com>> wrote:
> >     > >>
> >     > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
> >     > >>> On 27.03.2020 10:08, Charles Daymand wrote:
> >     > >>>> During kernel upgrade testing on our hardware, we found that=
 macvlan
> >     > >>>> interface were no longer able to send valid multicast packet=
.
> >     > >>>>
> >     > >>>> tcpdump run on our hardware was correctly showing our multic=
ast
> >     > >>>> packet but when connecting a laptop to our hardware we didn'=
t see any
> >     > >>>> packets.
> >     > >>>>
> >     > >>>> Bisecting turned up commit 93681cd7d94f
> >     > >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_=
F_IP_CSUM
> >     > >>>> which is responsible for the drop of packet in case of macvl=
an
> >     > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was alread=
y a specific
> >     > >>>> case since TSO was keep disabled.
> >     > >>>>
> >     > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our=
 multicast
> >     > >>>> issue, but we believe that this hardware issue is important =
enough to
> >     > >>>> keep tx checksum off by default on this revision.
> >     > >>>>
> >     > >>>> The change is deactivating the default value of NETIF_F_IP_C=
SUM for this
> >     > >>>> specific revision.
> >     > >>>>
> >     > >>>
> >     > >>> The referenced commit may not be the root cause but just reve=
al another
> >     > >>> issue that has been existing before. Root cause may be in the=
 net core
> >     > >>> or somewhere else. Did you check with other RTL8168 versions =
to verify
> >     > >>> that it's indeed a HW issue with this specific chip version?
> >     > >>>
> >     > >>> What you could do: Enable tx checksumming manually (via ethto=
ol) on
> >     > >>> older kernel versions and check whether they are fine or not.
> >     > >>> If an older version is fine, then you can start a new bisect =
with tx
> >     > >>> checksumming enabled.
> >     > >>>
> >     > >>> And did you capture and analyze traffic to verify that actual=
ly the
> >     > >>> checksum is incorrect (and packets discarded therefore on rec=
eiving end)?
> >     > >>>
> >     > >>>
> >     > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> >     > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr <=
mailto:charles.daymand@wifirst.fr>>
> >     > >>>> ---
> >     > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
> >     > >>>>  1 file changed, 3 insertions(+)
> >     > >>>>
> >     > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b=
/net/drivers/net/ethernet/realtek/r8169_main.c
> >     > >>>> index a9bdafd15a35..3b69135fc500 100644
> >     > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> >     > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> >     > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev=
 *pdev, const struct pci_device_id *ent)
> >     > >>>>              dev->vlan_features &=3D ~(NETIF_F_ALL_TSO | NET=
IF_F_SG);
> >     > >>>>              dev->hw_features &=3D ~(NETIF_F_ALL_TSO | NETIF=
_F_SG);
> >     > >>>>              dev->features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_=
SG);
> >     > >>>> +            if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34)=
 {
> >     > >>>> +                    dev->features &=3D ~NETIF_F_IP_CSUM;
> >     > >>>> +            }
> >     > >>>>      }
> >     > >>>>
> >     > >>>>      dev->hw_features |=3D NETIF_F_RXALL;
> >     > >>>>
> >     > >>>
> >     > >>
> >     > >> After looking a little bit at the macvlen code I think there m=
ight be an
> >     > >> issue in it, but I'm not sure, therefore let me add Eric (as m=
acvlen doesn't
> >     > >> seem to have a dedicated maintainer).
> >     > >>
> >     > >> r8169 implements a ndo_features_check callback that disables t=
x checksumming
> >     > >> for the chip version in question and small packets (due to a H=
W issue).
> >     > >> macvlen uses passthru_features_check() as ndo_features_check c=
allback, this
> >     > >> seems to indicate to me that the ndo_features_check callback o=
f lowerdev is
> >     > >> ignored. This could explain the issue you see.
> >     > >>
> >     > >
> >     > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switchi=
ng skb->dev,
> >     > > so the second __dev_queue_xmit() should eventually call the rea=
l_dev
> >     > > ndo_features_check()
> >     > >
> >     > Thanks, Eric. There's a second path in macvlan_queue_xmit() calli=
ng
> >     > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply al=
so there?
> >
> >     This path wont send packets to the physical NIC, packets are inject=
ed
> >     back via dev_forward_skb()
> >
> >     >
> >     > Still I find it strange that a tx hw checksumming issue should af=
fect multicasts
> >     > only. Also the chip version in question is quite common and I wou=
ld expect
> >     > others to have hit the same issue.
> >     > Maybe best would be to re-test on the affected system w/o involvi=
ng macvlen.
> >     >
> >     > >
> >     > >
> >     > >> Would be interesting to see whether it fixes your issue if you=
 let the
> >     > >> macvlen ndo_features_check call lowerdev's ndo_features_check.=
 Can you try this?
> >     > >>
> >     > >> By the way:
> >     > >> Also the ndo_fix_features callback of lowerdev seems to be ign=
ored.
> >     >
> >
> >
> >
> > --
> >
> > logo wifirst <http://www.wifirst.fr/en>
> >
> > Charles Daymand
> >
> > D=C3=A9veloppeur infrastructure
> >
> > 26 rue de Berri 75008 Paris
> >
> > Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
> > Assistance utilisateur - 01 70 70 46 26
> >
>


--=20

Charles Daymand

D=C3=A9veloppeur infrastructure

26 rue de Berri 75008 Paris

Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
Assistance utilisateur - 01 70 70 46 26
