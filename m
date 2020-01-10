Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42A2137213
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgAJQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:03:00 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43787 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbgAJQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:03:00 -0500
Received: by mail-ed1-f68.google.com with SMTP id dc19so1990010edb.10;
        Fri, 10 Jan 2020 08:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVojUMyqjFTe7QocLHmtkpZSaA4+eW8y+0hQ0G/L7KE=;
        b=GQbi6VxagFtBoDNGn47AsDsIX7GbFuxxbo9ADZdJA5DppPq9Q3udOig8l6KZyLA7G+
         KlWDzn9rzyrtQeHdfu4Ew5DzMpt0L0pPwc77PzlLpS708rPgowGROLpvzg91bRV8wGHU
         lE6X1lcvG869TmejUBf07Y09nBiGf/x6if5oi+tw25CLzoLeCd+rjwNHpauEUVQCEAPn
         Z2zp9++SinfhmmAxWbormx490hqJ6WM0YnE263wPoVngh6BVZvtdIH9ufSJsHZNHwyvJ
         fEl/2P5vVJL65zWjPOVWmjKqqqdyzdqlLzj8qdsDl7KYDlpMziNFWEWOhmZDF0SBMWEl
         Ufeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AVojUMyqjFTe7QocLHmtkpZSaA4+eW8y+0hQ0G/L7KE=;
        b=cHTsRxXZOwntIwivWXDwfwm3hZ+UcqV/ZE93R5UwScnNp7Z3or2GZEapfILbFq1tPy
         UulL9purZeuP/QRj0dC4nwwlxueec9l/Q4uQGgaJ36n9ZZRQ8Rk9A5zGH4rziBdrFLjS
         kl9SfX0V7+xZ8JDEbc7qBcrwyCNgng9HrfZgvaAiDMV9+xt3F56n2xQ//R7kge51aZOG
         bO9BoIV9FJ2iYyNhz5eHChP5LJ/PGlIgXugrumaoBQndLTl0RYkvPimBPTnXZebdlAx0
         LPN7oaVfVt7GQQlk6c49czHqWjvyJHNQxh259s2Nn75UeeCeRKvmQr7ipHuu4qVqrfa0
         +nnQ==
X-Gm-Message-State: APjAAAU5V1R1XA8SNAznGNjw5xPIqHTOzftISlOXJhpiEJxasKgdPzar
        evt8ND015mKD6IfqfVYmO8GFsuVzxqqLl4TEU9Q=
X-Google-Smtp-Source: APXvYqw8whNJFgpyJe0GoUhyEmo/i6GQC9qL7MAUL0SkyawCqcunPrYTIX2HZzO+jnYUaHEg3bY5de3fvfIro8tKY44=
X-Received: by 2002:aa7:db04:: with SMTP id t4mr4354934eds.122.1578672177451;
 Fri, 10 Jan 2020 08:02:57 -0800 (PST)
MIME-Version: 1.0
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline>
 <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan>
 <87lfr9axm8.fsf@linux.intel.com> <b7e1cb8b-b6b1-c0fa-3864-4036750f3164@ti.com>
 <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
In-Reply-To: <157853205713.36295.17877768211004089754@aguedesl-mac01.jf.intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 10 Jan 2020 18:02:45 +0200
Message-ID: <CA+h21hr9ApvPSYigcS0WkFVg0+Od=G+ZVxkV7GvdaNbDmCmiCA@mail.gmail.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
To:     Andre Guedes <andre.guedes@linux.intel.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andre,

On Thu, 9 Jan 2020 at 03:08, Andre Guedes <andre.guedes@linux.intel.com> wrote:
>
> Hi,
>
> > >>> 1. add support in taprio to be configured without any schedule in the
> > >>> "full offload" mode. In practice, allowing taprio to work somewhat
> > >>> similar to (mqprio + frame-preemption), changes in the code should de
> > >>> fairly small;
> > >>
> > >> +
> > >>
> > >> And if follow mqprio settings logic then preemption also can be enabled
> > >> immediately while configuring taprio first time, and similarly new ADMIN
> > >> can't change it and can be set w/o preemption option afterwards.
> > >>
> > >> So that following is correct:
> > >>
> > >> OPER
> > >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> > >>        base-time 10000000 \
> > >>        num_tc 3 \
> > >>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> > >>        queues 1@0 1@1 2@2 \
> > >>        preemption 0 1 1 1
> > >>        flags 1
> > >>
> > >> then
> > >> ADMIN
> > >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> > >>        base-time 12000000 \
> > >>        num_tc 3 \
> > >>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> > >>        queues 1@0 1@1 2@2 \
> > >>        preemption 0 1 1 1
> > >>        sched-entry S 01 300000 \
> > >>        sched-entry S 02 300000 \
> > >>        flags 1
> > >>
> > >> then
> > >> ADMIN
> > >> $ tc qdisc add dev IFACE parent root handle 100 taprio \
> > >>        base-time 13000000 \
> > >>        sched-entry S 01 300000 \
> > >>        sched-entry S 02 300000 \
> > >>        flags 1
> > >>
> > >> BUT:
> > >>
> > >> 1) The question is only should it be in this way? I mean preemption to be
> > >> enabled immediately? Also should include other parameters like
> > >> fragment size.
> > >
> > > We can decide what things are allowed/useful here. For example, it might
> > > make sense to allow "preemption" to be changed. We can extend taprio to
> > > support changing the fragment size, if that makes sense.
> > >
> > >>
> > >> 2) What if I want to use frame preemption with another "transmission selection
> > >> algorithm"? Say another one "time sensitive" - CBS? How is it going to be
> > >> stacked?
> > >
> > > I am not seeing any (conceptual*) problems when plugging a cbs (for
> > > example) qdisc into one of taprio children. Or, are you talking about a
> > > more general problem?
> > >
> > > * here I am considering that support for taprio without an schedule is
> > >   added.
> > >
> > >>
> > >> In this case ethtool looks better, allowing this "MAC level" feature, to be
> > >> configured separately.
> > >
> > > My only issue with using ethtool is that then we would have two
> > > different interfaces for "complementary" features. And it would make
> > > things even harder to configure and debug. The fact that one talks about
> > > traffic classes and the other transmission queues doesn't make me more
> > > comfortable as well.
> > >
> > > On the other hand, as there isn't a way to implement frame preemption in
> > > software, I agree that it makes it kind of awkward to have it in the tc
> > > subsystem.
> > Absolutely. I think frame pre-emption feature flag, per queue express/
> > pre-empt state, frag size, timers (hold/release) to be configured
> > independently (perhaps through ethtool) and then taprio should check
> > this with the lower device and then allow supporting additional Gate
> > operations such as Hold/release if supported by underlying device.
> >
> > What do you think? Why to abuse tc for this?
> >
>
> After reading all this great discussion and revisiting the 802.1Q and 802.3br
> specs, I'm now leaning towards to not coupling Frame Preemption support under
> taprio qdisc. Besides what have been discussed, Annex S.2 from 802.1Q-2018
> foresees FP without EST so it makes me feel like we should keep them separate.
>
> Regarding the FP configuration knobs, the following seems reasonable to me:
>     * Enable/disable FP feature
>     * Preemptable queue mapping
>     * Fragment size multiplier
>
> I'm not sure about the knob 'timers (hold/release)' described in the quotes
> above. I couldn't find a match in the specs. If it refers to 'holdAdvance' and
> 'releaseAdvance' parameters described in 802.1Q-2018, I believe they are not
> configurable. Do we know any hardware where they are configurable?
>

On NXP LS1028A, HOLD_ADVANCE is configurable on both ENETC and the
Felix switch (its default value is 127 bytes). Same as Synopsys, it is
a global setting and not per queue or per GCL entry.
RELEASE_ADVANCE is not configurable.
Regardless, I am not sure if there is any value in configuring this
knob. Remember that the minimum guard band size still needs to be
twice as large as the minimum Ethernet frame size.

As for the main topic of tc-taprio vs ethtool for configuring frame
preemption, I think ethtool is the more natural place for configuring
the traffic class to pMAC/eMAC mapping, global enable bit, and
fragment size, while tc-taprio is the more natural place for
configuring hold/release on individual GCL entries. The tc-taprio
offload can check the netdev support of the ethtool feature, just as
it checks right now the support for PTP clock for the full offload
feature.

Introducing tc-taprio with a null schedule is not really natural, and
frame preemption is a hardware-only feature that cannot be emulated,
so it is odd to enable it through tc.

> Regards,
>
> Andre

Regards,
-Vladimir
