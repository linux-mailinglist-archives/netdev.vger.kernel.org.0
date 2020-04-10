Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEAB1A44C1
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgDJJyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:54:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39811 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgDJJyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:54:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id b62so1593964qkf.6
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EeJAvzVLQaULEbTZNWIM06qmXg6TMkaUiAIvIaVGINE=;
        b=K7FwIUfVLJMrIwMX2YEd8a9qFBfGbSaHETFGryQsELJp1JUy5PUbyI77oZyyoY9PUL
         OFaRQF5ekmOVg/rsNETaABulho3ryLvpQo39lzF6/inP1juDZkBoH3RML6/QbP9pDu+h
         mLXrjYDW8dl68nmjccCYZQFvicb7c0ceMjTcOr3WjCMX6qPZJGweFmes20bFK1M1E2QD
         2A9dE4b5Qs/ojjw2g4AwQXIKBKbVEu2DmB0GTXGiIdbaE/tta5O3Yx20fdB/pmVeIR2v
         I5C25BLWldDNpd1u+PDvtsEWi/TDxZpo5olvzVkYXhxjCRCim/YnmJ3RmN4FsWQHe4Gy
         9UlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EeJAvzVLQaULEbTZNWIM06qmXg6TMkaUiAIvIaVGINE=;
        b=K97E5eo4Tvo2CR0NfoWROKqqR4T7K9LciY4wdwtmRZs77EJMlogUblVmYjSrsEYNRL
         Ydie0MxiDNP81+EqEeoZGn9ypd/HZxpovR4o1rX7jZ6yQ8pPm/YDXJv6BkZbKqiBgkDV
         vg3bvNuPKkMtLYrnLSMy3gABK9E8IDZVYUX0Cxy0Rzu6pTNUn8PUggatE/NGbUussRxa
         hffIIJ8jvjPSrSWsTzdZfD1yxx4aYeTW+po1xOB5vyNxZtgjKha5p80n6C9jBJZnu/pt
         4QLX3e/GCVS52VIbgrnXQFnkI3fr2B6e8artxB4+G55gDS4597+rAlP6sl1vEnpiam80
         48AA==
X-Gm-Message-State: AGi0Pua9gZ9QpnBmRnIMxfQ2uinbCeecUTfiINjA6mi6N90zCUuJpZP/
        5t6Z9gDuPlOUmiJ+4TWOMJH8wIIkjtpv5V3/ADlJpA==
X-Google-Smtp-Source: APiQypLLneqO2gGIPiLMMPfaxvpd0a5+TVFPrx5MNM+r0uxG8GScTq1viAylay2vnlcEfmkTJ2x40He9cvouLHINQ38=
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr3265927qkk.293.1586512447883;
 Fri, 10 Apr 2020 02:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com> <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com> <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <df776fc4-871d-d82c-a202-ba4f4d7bfb42@gmail.com> <b3867109-d09c-768c-7210-74e6f76c12b8@gmail.com>
 <d9c6ba82-4f3e-0f7e-e1f8-516da25e1fe4@gmail.com> <fe30ab8d-2915-e049-ef30-760960f5efdc@gmail.com>
In-Reply-To: <fe30ab8d-2915-e049-ef30-760960f5efdc@gmail.com>
From:   Charles DAYMAND <charles.daymand@wifirst.fr>
Date:   Fri, 10 Apr 2020 11:53:56 +0200
Message-ID: <CAFJtzm1OCz-U36j5Lq4y2EiqPHZOHXVzwJMdSnJ6CnUjzXk9og@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I just tested your patch, there is no improvement on the issue.
I still have layer2 malformed packets.
I also created a TCP server on my laptop with the hardware
periodically sending udp and tcp packets and these packets are also
layer2 malformed.
Please find below an example of the malformed packet :
Frame 3533: 110 bytes on wire (880 bits), 110 bytes captured (880
bits) on interface 0
Ethernet II, Src: b2:41:6f:04:c1:86 (b2:41:6f:04:c1:86), Dst:
IPv4mcast_09 (01:00:5e:00:00:09)
802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 2833
    000. .... .... .... =3D Priority: Best Effort (default) (0)
    ...0 .... .... .... =3D DEI: Ineligible
    .... 1011 0001 0001 =3D ID: 2833
    Length: 96
        [Expert Info (Error/Malformed): Length field value goes past
the end of the payload]
            [Length field value goes past the end of the payload]
            [Severity level: Error]
            [Group: Malformed]
Logical-Link Control
Data (88 bytes)


Le mer. 8 avr. 2020 =C3=A0 00:40, Heiner Kallweit <hkallweit1@gmail.com> a =
=C3=A9crit :
>
> On 07.04.2020 08:22, Heiner Kallweit wrote:
> > On 07.04.2020 01:20, Eric Dumazet wrote:
> >>
> >>
> >> On 4/6/20 3:16 PM, Heiner Kallweit wrote:
> >>
> >>>
> >>> In a similar context Realtek made me aware of a hw issue if IP header
> >>> has the options field set. You mentioned problems with multicast pack=
ets,
> >>> and based on the following code the root cause may be related.
> >>>
> >>> br_ip4_multicast_alloc_query()
> >>> -> iph->ihl =3D 6;
> >>>
> >>> I'd appreciate if you could test (with HW tx checksumming enabled)
> >>> whether this experimental patch fixes the issue with invalid/lost
> >>> multicasts.
> >>>
> >>>
> >>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/=
ethernet/realtek/r8169_main.c
> >>> index e40e8eaeb..dd251ddb8 100644
> >>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>> @@ -4319,6 +4319,10 @@ static netdev_features_t rtl8169_features_chec=
k(struct sk_buff *skb,
> >>>                 rtl_chip_supports_csum_v2(tp))
> >>>                     features &=3D ~NETIF_F_ALL_TSO;
> >>>     } else if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
> >>> +           if (ip_hdrlen(skb) > sizeof(struct iphdr)) {
> >>
> >> Packet could be non IPv4 at this point. (IPv6 for instance)
> >>
> > Right, I should have mentioned it:
> > This experimental patch is for IPv4 only. In a final version (if it ind=
eed
> > fixes the issue) I had to extend the condition and check for IPv4.
> >
> >>> +                   pr_info("hk: iphdr has options field set\n");
> >>> +                   features &=3D ~NETIF_F_CSUM_MASK;
> >>> +           }
> >>>             if (skb->len < ETH_ZLEN) {
> >>>                     switch (tp->mac_version) {
> >>>                     case RTL_GIGA_MAC_VER_11:
> >>>
> >
>
> Here comes an updated version of the experimental patch that checks for I=
Pv4.
> It's part of a bigger experimental patch here, therefore it's not fully
> optimized.
>
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethe=
rnet/realtek/r8169_main.c
> index e40e8eaeb..69e35da6c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4307,6 +4307,23 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_bu=
ff *skb,
>         return NETDEV_TX_BUSY;
>  }
>
> +static netdev_features_t rtl8168evl_features_check(struct sk_buff *skb,
> +                                                  netdev_features_t feat=
ures)
> +{
> +       __be16 proto =3D vlan_get_protocol(skb);
> +
> +       if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
> +               if (proto =3D=3D htons(ETH_P_IP)) {
> +                       if (ip_hdrlen(skb) > sizeof(struct iphdr)) {
> +                               pr_info("hk: iphdr has options field set\=
n");
> +                               features &=3D ~NETIF_F_CSUM_MASK;
> +                       }
> +               }
> +       }
> +
> +       return features;
> +}
> +
>  static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>                                                 struct net_device *dev,
>                                                 netdev_features_t feature=
s)
> @@ -4314,6 +4331,9 @@ static netdev_features_t rtl8169_features_check(str=
uct sk_buff *skb,
>         int transport_offset =3D skb_transport_offset(skb);
>         struct rtl8169_private *tp =3D netdev_priv(dev);
>
> +       if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34)
> +               features =3D rtl8168evl_features_check(skb, features);
> +
>         if (skb_is_gso(skb)) {
>                 if (transport_offset > GTTCPHO_MAX &&
>                     rtl_chip_supports_csum_v2(tp))
> --
> 2.26.0
>
>


--=20

Charles Daymand

D=C3=A9veloppeur infrastructure

26 rue de Berri 75008 Paris

Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
Assistance utilisateur - 01 70 70 46 26
