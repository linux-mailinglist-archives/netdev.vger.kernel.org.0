Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6A382C85
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 14:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhEQMt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 08:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhEQMtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 08:49:23 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AD1C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 05:48:07 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k16so5615272ios.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 05:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HtHoZIIEe3sQeYeRVH9TD1iYg5XKzpsltRfj9VxFrHc=;
        b=adxWF7RTbDikGS27cdvekoOO5gRdd2LQXHm94drdj+8mcMr7pBZuN//8HfhT/ZF2vU
         1tkuW00yVVYj3EfH7SljKHJxyRrZWV2bePaQriG5V/21Puz+5Tos+wmLQvIqmgdAyzYV
         yWxyzIKQ8by9Jk8391sbPD41LxZ+sE/b7M87nKhgG8b7g8z2l8jNsFuaU4/DMiveQGUB
         hB4H+8q5ziKj8XMkQKFTxk3ORL1jmnJcq5l0XTGdu0/EkYTOpBVh+3nyYKKu+mj+3jCz
         tGRtHgT/JCuan91i2mmpkh0HoPOuEdbDMbofRQf70fQgdw3YZeypDdxE2mOxeEWyOMPe
         f3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HtHoZIIEe3sQeYeRVH9TD1iYg5XKzpsltRfj9VxFrHc=;
        b=lMSniQPl/H+tk28IGe+RT5SSpYXh/8BBMC+r07eeP/F3egIV+f99rExatnWmOAmmzz
         O/iu1q4yYqGeHMq2isXfeW7LINuirExPKGCXAo31uGNX0wmofgujNm+n0lkAbGjhQK9h
         9v1Fi1QJauN+LuEFbRbn9SP3GSildCFmQMliJXl6VugwB5I0iFt+vb5IywnzVb+Rcw7D
         2nHfTQnvZunSBzxM9E1XRe+4+MrNFBlV1cVCivMSVtqjEbYR3ocw/2HvbNvbUzSKseNB
         F/uUMirzqUsJVE3BN50Gz+B450hs/qsFYAfHWBa6b3pV6rrYyNNgbjSb363veFKzSkne
         yx8Q==
X-Gm-Message-State: AOAM530w7qbFSmNlfGMb7EKZIlvgwEsCmOXDZSrRebpB5JzhvPBvQ3SN
        H9Xyn8CohLWu9kZk31m0eeWeN56uKtvShnzpRmI=
X-Google-Smtp-Source: ABdhPJzdH+BOvbnacYJDOywfupjgpXfYnfgO+gWyIxxuaWHydV0jK2ejZXMYb421vqKf16OlRR+Hv3hCz+EEiXCngTs=
X-Received: by 2002:a02:91c1:: with SMTP id s1mr55943438jag.61.1621255686718;
 Mon, 17 May 2021 05:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
 <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67958B0138DDDDEAD20949FAE6519@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <494cd993-aa45-ff11-8d76-f2233fcf7295@kontron.de> <DB8PR04MB6795A2B708CED18F77EEE0A7E62D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795A2B708CED18F77EEE0A7E62D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 17 May 2021 05:47:55 -0700
Message-ID: <CAA93jw5qShao9bjEXOd8wHOakxFLzfm+Ws=_iVetzEFD9wT2aw@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 3:25 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> Hi Frieder,
>
> > -----Original Message-----
> > From: Frieder Schrempf <frieder.schrempf@kontron.de>
> > Sent: 2021=E5=B9=B45=E6=9C=8817=E6=97=A5 15:17
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; dl-linux-imx
> > <linux-imx@nxp.com>; netdev@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org
> > Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
> >
> > Hi Joakim,
> >
> > On 13.05.21 14:36, Joakim Zhang wrote:
> > >
> > > Hi Frieder,
> > >
> > > For NXP release kernel, I tested on i.MX8MQ/MM/MP, I can reproduce on
> > L5.10, and can't reproduce on L5.4.
> > > According to your description, you can reproduce this issue both L5.4=
 and
> > L5.10? So I need confirm with you.
> >
> > Thanks for looking into this. I could reproduce this on 5.4 and 5.10 bu=
t both
> > kernels were official mainline kernels and **not** from the linux-imx
> > downstream tree.
> Ok.
>
> > Maybe there is some problem in the mainline tree and it got included in=
 the
> > NXP release kernel starting from L5.10?
> No, this much looks like a known issue, it should always exist after addi=
ng AVB support in mainline.
>
> ENET IP is not a _real_ multiple queues per my understanding, queue 0 is =
for best effort. And the queue 1&2 is for AVB stream whose default bandwidt=
h fraction is 0.5 in driver. (i.e. 50Mbps for 100Mbps and 500Mbps for 1Gbps=
). When transmitting packets, net core will select queues randomly, which c=
aused the tx bandwidth fluctuations. So you can change to use single queue =
if you care more about tx bandwidth. Or you can refer to NXP internal imple=
mentation.
> e.g.
> --- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
> @@ -916,8 +916,8 @@
>                                          <&clk IMX8MQ_CLK_ENET_PHY_REF>;
>                                 clock-names =3D "ipg", "ahb", "ptp",
>                                               "enet_clk_ref", "enet_out";
> -                               fsl,num-tx-queues =3D <3>;
> -                               fsl,num-rx-queues =3D <3>;
> +                               fsl,num-tx-queues =3D <1>;
> +                               fsl,num-rx-queues =3D <1>;
>                                 status =3D "disabled";
>                         };
>                 };
>
> I hope this can help you :)

Patching out the queues is probably not the right thing.

for starters... Is there BQL support in this driver? It would be
helpful to have on all queues.

Also if there was a way to present it as two interfaces, rather than
one, that would allow for a specific avb device to be
presented.

Or:

Is there a standard means of signalling down the stack via the IP
layer (a dscp? a setsockopt?) that the AVB queue is requested?



> Best Regards,
> Joakim Zhang
> > Best regards
> > Frieder
> >
> > >
> > > Best Regards,
> > > Joakim Zhang
> > >
> > >> -----Original Message-----
> > >> From: Joakim Zhang <qiangqing.zhang@nxp.com>
> > >> Sent: 2021=E5=B9=B45=E6=9C=8812=E6=97=A5 19:59
> > >> To: Frieder Schrempf <frieder.schrempf@kontron.de>; dl-linux-imx
> > >> <linux-imx@nxp.com>; netdev@vger.kernel.org;
> > >> linux-arm-kernel@lists.infradead.org
> > >> Subject: RE: i.MX8MM Ethernet TX Bandwidth Fluctuations
> > >>
> > >>
> > >> Hi Frieder,
> > >>
> > >> Sorry, I missed this mail before, I can reproduce this issue at my
> > >> side, I will try my best to look into this issue.
> > >>
> > >> Best Regards,
> > >> Joakim Zhang
> > >>
> > >>> -----Original Message-----
> > >>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> > >>> Sent: 2021=E5=B9=B45=E6=9C=886=E6=97=A5 22:46
> > >>> To: dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
> > >>> linux-arm-kernel@lists.infradead.org
> > >>> Subject: i.MX8MM Ethernet TX Bandwidth Fluctuations
> > >>>
> > >>> Hi,
> > >>>
> > >>> we observed some weird phenomenon with the Ethernet on our
> > >>> i.MX8M-Mini boards. It happens quite often that the measured
> > >>> bandwidth in TX direction drops from its expected/nominal value to
> > >>> something like 50% (for 100M) or ~67% (for 1G) connections.
> > >>>
> > >>> So far we reproduced this with two different hardware designs using
> > >>> two different PHYs (RGMII VSC8531 and RMII KSZ8081), two different
> > >>> kernel versions (v5.4 and v5.10) and link speeds of 100M and 1G.
> > >>>
> > >>> To measure the throughput we simply run iperf3 on the target (with =
a
> > >>> short p2p connection to the host PC) like this:
> > >>>
> > >>>   iperf3 -c 192.168.1.10 --bidir
> > >>>
> > >>> But even something more simple like this can be used to get the inf=
o
> > >>> (with 'nc -l -p 1122 > /dev/null' running on the host):
> > >>>
> > >>>   dd if=3D/dev/zero bs=3D10M count=3D1 | nc 192.168.1.10 1122
> > >>>
> > >>> The results fluctuate between each test run and are sometimes 'good=
'
> > (e.g.
> > >>> ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for
> > >>> 100M
> > >> link).
> > >>> There is nothing else running on the system in parallel. Some more
> > >>> info is also available in this post: [1].
> > >>>
> > >>> If there's anyone around who has an idea on what might be the reaso=
n
> > >>> for this, please let me know!
> > >>> Or maybe someone would be willing to do a quick test on his own
> > hardware.
> > >>> That would also be highly appreciated!
> > >>>
> > >>> Thanks and best regards
> > >>> Frieder
> > >>>
> > >>> [1]:
> > >>> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fco
> > >>> mm
> > >>> u
> > >>>
> > >>
> > nity.nxp.com%2Ft5%2Fi-MX-Processors%2Fi-MX8MM-Ethernet-TX-Bandwidth-
> > >>>
> > >>
> > Fluctuations%2Fm-p%2F1242467%23M170563&amp;data=3D04%7C01%7Cqiang
> > >>>
> > >>
> > qing.zhang%40nxp.com%7C5d4866d4565e4cbc36a008d9109da0ff%7C686ea1d
> > >>>
> > >>
> > 3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637559091463792932%7CUnkno
> > >>>
> > >>
> > wn%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1ha
> > >>>
> > >>
> > WwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DygcThQOLIzp0lzhXacRLjSjnjm1FEj
> > >>> YSxakXwZtxde8%3D&amp;reserved=3D0



--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
