Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7151C1A7167
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 05:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbgDNDDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 23:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728755AbgDNDDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 23:03:14 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB8C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 20:03:14 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so7222820ilh.8
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 20:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MvvX428jhA03WN2yaKHPbkqaFaksfSra1Adu8XMIvnk=;
        b=lsxWeaXi7KzM9AHRz9I3JGG6nz3zZugSUkekvKuK+DbygExzEtKRUvMtby+huNU2aA
         5TmBsboQd/Nosp2M44QZfFkSrPTiuXYBE32zZdQUyoxi0WIkSbIU6LwlqypQSPCRboZW
         l5rhNUrPpFwa1dW9233XjtmeODqwSj6Y4ZoxPZ5tM+3TBqg+kdGYqAVVm3pjlNIwiKsW
         vY6dYz3ae12FKAuPJM6v8ZDGaB648qnI03GpkXHf8C7KGRutPeZ5fW49tFykS9j80Qmg
         w/D7AEXamHkAotXZIzomuXjDJ/HiGpuksmffIfy5OpR3yrl2Yru3EagATt219x95K1iM
         Oejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MvvX428jhA03WN2yaKHPbkqaFaksfSra1Adu8XMIvnk=;
        b=VmYPS8F9B6BhovtzUO3GK9npxra80M8x94ZG9ZZIkMyE0P/TY4Mh01tJUu8cWPBTxk
         a9cCFFZb8Q/KIID/NQK6WNkM8/ij6umWO4MVM6BZ3tH/Mv7QdC/l1FWZHhzaXz3LKgRV
         GXzoNN6tSlgjCR+/y39E34CIGmFZpPSvv2Du+hFDwZok5zRnLlkjHOHjOqQ8hBrtjYrR
         D+GepvoIzUDjEJOdzVjc6hdhBdx9VMHgmiaP/RLqC1CWaVDZhMF1FiyH5WBqLcBb2YrR
         pgDaRif1hlmpAJ3Tm/1bDcaCFgU1GYMxx2ZDgJch0jPMh/Cl9c3XAGHpiop2vkIbE18c
         Ba+w==
X-Gm-Message-State: AGi0Puapn7GTIOQxGJOGQzC3U/+iQXZ3ACF4cmLu5yFzsgFKgq5waBuz
        qdd/a6m8yTHAjE3i3AOkI8kb80hSjt4LjmlGjvuFJYF1iQE=
X-Google-Smtp-Source: APiQypJdxOiHOVepSY+VJkvtNtZWPvs+Ogm/uxPCVhz3OiBFQ0RTo9yglWG4d2rrW8/Lzr5mGBOtamSbDoyYatU0RkI=
X-Received: by 2002:a92:c991:: with SMTP id y17mr20440596iln.239.1586833393592;
 Mon, 13 Apr 2020 20:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200409155409.12043-1-dqfext@gmail.com> <20200409.102035.13094168508101122.davem@davemloft.net>
 <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com>
 <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com> <CALW65jZAdFFNfGioAFWPwYN+F4baL0Z-+FX_pAte97uxNK3T6g@mail.gmail.com>
 <CA+h21hp8LueSfh+Z8f0-Y7dTPB50d+3E3K9n6R5MwNzA3Dh1Lw@mail.gmail.com>
In-Reply-To: <CA+h21hp8LueSfh+Z8f0-Y7dTPB50d+3E3K9n6R5MwNzA3Dh1Lw@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 14 Apr 2020 11:03:02 +0800
Message-ID: <CALW65jYodd=GoWrGTcAWEO6wNQdvSQjgO=4tmNYNnmbCh7n8sg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 6:46 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Qingfang,
>
> On Fri, 10 Apr 2020 at 05:51, DENG Qingfang <dqfext@gmail.com> wrote:
> >
> > On Fri, Apr 10, 2020 at 10:27 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > >
> > >
> > > On 4/9/2020 7:19 PM, DENG Qingfang wrote:
> > > > So, since nothing else uses the mt7530_set_jumbo function, should I
> > > > remove the function and just add a single rmw to mt7530_setup?
> > >
> > > (please do not top-post on netdev)
> > >
> > > There is a proper way to support the MTU configuration for DSA switch
> > > drivers which is:
> > >
> > >         /*
> > >          * MTU change functionality. Switches can also adjust their MRU
> > > through
> > >          * this method. By MTU, one understands the SDU (L2 payload) length.
> > >          * If the switch needs to account for the DSA tag on the CPU
> > > port, this
> > >          * method needs to to do so privately.
> > >          */
> > >         int     (*port_change_mtu)(struct dsa_switch *ds, int port,
> > >                                    int new_mtu);
> > >         int     (*port_max_mtu)(struct dsa_switch *ds, int port);
> >
> > MT7530 does not support configuring jumbo frame per-port
> > The register affects globally
> >
> > >
> > > --
> > > Florian
>
> This is a bit more tricky, but I think you can still deal with it
> using the port_change_mtu functionality. Basically it is only a
> problem when the other ports are standalone - otherwise the
> dsa_bridge_mtu_normalization function should kick in.
> So if you implement port_change_mtu, you should do something along the lines of:
>
> for (i = 0; i < MT7530_NUM_PORTS; i++) {
>     struct net_device *slave;
>
>     if (!dsa_is_user_port(ds, i))
>         continue;
>
>     slave = ds->ports[i].slave;
>
>     slave->mtu = new_mtu;
> }
>
> to update the MTU known by the stack for all net devices.
Should we warn users that all ports will be affected?
>
> Hope this helps,
> -Vladimir
