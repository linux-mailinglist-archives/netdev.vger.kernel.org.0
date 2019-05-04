Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB4B1370D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfEDChG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:37:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38061 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfEDChG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:37:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id k16so10043618wrn.5;
        Fri, 03 May 2019 19:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Ntx05QG4ilOvib9WtlBUryyH4t9YJiOtbQVxpeRJFs=;
        b=Slx5wgrbNxF3svrHhvpnyiLtH1KaGl67V26B/Nk/rM/aB9VEL9V6IjZfbZfyMGgH30
         Ul6AJgAfXekcWpobFf92VDfXK/shYpuMiQBX/fY+q5dYu9PjEI3aYRV8u5Fne/GD+lza
         h4faDZqb0Oxb7eUAlf4Vci5cvEWJ1jMINL5o3VaupC7H6xFGHX7x/wyEbF/1iAwgEB3o
         L37u83UDCW3o/8qfg/ogJLdJhpHY1tv57Ap4KIpxJ4kxemz2ASL8OfTY8bwpFdlTNcI7
         hfHz3rUUoOUDsNEoX25xIbn9O6hj050xg8dOhlUftuZa4Sz195WGI2ZM5j0hiGvP0LXC
         0m/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Ntx05QG4ilOvib9WtlBUryyH4t9YJiOtbQVxpeRJFs=;
        b=Z3AkSf+rmNDKm9qxvioIIeCdLPbCp48pk7BTUKI6ya7PRHSslZSXB7Ts9pGSVokhtF
         /XLy0dtVD5zTNX/t9B6+tc/FXQ4/mcnTckJvqNUdWjR9rx/uuBYMCnuorRyqnTGOAjfG
         rpy6ZN0iOxqmdlGSZn9NQ2vc/+xOpbHPJAVHyerw6lNmNuZp3ifpa5gycjpiRxlauTcT
         q3FQKkDcGN3EOEw28ZtdhAg7hpldnACp3j7fb1jass+4HaTbljwWT2ji9EAc6Mr5JBBF
         1sH6z6zvRYdWMPxMPx0eYlYD9YIaPPHhrH3+MHSeq8D+ywws7Il/CvPqFHl+tQ55afxQ
         4Nyw==
X-Gm-Message-State: APjAAAWMU8tmDf04X6qx5GVz/E2uG0DiTpgFXh0Eo3uYtVCCh/8JRt3k
        eUoMd9tjyJQU1AkXIIV1nwe7+zQxJpJn1GajJ+TQD45g
X-Google-Smtp-Source: APXvYqzNS7/KAzFHNHYB+DNtu+lzHFn3oMUNt4ik3tylQdZULoa9EFuk9QS0iADHAwJXloGDpPdTpBN7t7nNrRHMz2c=
X-Received: by 2002:a5d:4dc1:: with SMTP id f1mr9521663wru.300.1556937423661;
 Fri, 03 May 2019 19:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190504011826.30477-1-olteanv@gmail.com> <20190504011826.30477-10-olteanv@gmail.com>
 <a0b29ac4-7159-6ccf-9ad1-8193951be7ea@gmail.com>
In-Reply-To: <a0b29ac4-7159-6ccf-9ad1-8193951be7ea@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 4 May 2019 05:36:52 +0300
Message-ID: <CA+h21hq25OSou=SJHgJmGyhmSFrPA3nsDV446Trg+awZwKTmtw@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9] Documentation: net: dsa: sja1105: Add info
 about supported traffic modes
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     vivien.didelot@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 at 05:17, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/3/2019 6:18 PM, Vladimir Oltean wrote:
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  Documentation/networking/dsa/sja1105.rst | 49 ++++++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> >
> > diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
> > index 7c13b40915c0..a70a04164d07 100644
> > --- a/Documentation/networking/dsa/sja1105.rst
> > +++ b/Documentation/networking/dsa/sja1105.rst
> > @@ -63,6 +63,38 @@ If that changed setting can be transmitted to the switch through the dynamic
> >  reconfiguration interface, it is; otherwise the switch is reset and
> >  reprogrammed with the updated static configuration.
> >
> > +Traffic support
> > +===============
> > +
> > +The switches do not support switch tagging in hardware. But they do support
> > +customizing the TPID by which VLAN traffic is identified as such. The switch
> > +driver is leveraging ``CONFIG_NET_DSA_TAG_8021Q`` by requesting that special
> > +VLANs (with a custom TPID of ``ETH_P_EDSA`` instead of ``ETH_P_8021Q``) are
> > +installed on its ports when not in ``vlan_filtering`` mode. This does not
> > +interfere with the reception and transmission of real 802.1Q-tagged traffic,
> > +because the switch does no longer parse those packets as VLAN after the TPID
> > +change.
> > +The TPID is restored when ``vlan_filtering`` is requested by the user through
> > +the bridge layer, and general IP termination becomes no longer possible through
> > +the switch netdevices in this mode.
> > +
> > +The switches have two programmable filters for link-local destination MACs.
> > +These are used to trap BPDUs and PTP traffic to the master netdevice, and are
> > +further used to support STP and 1588 ordinary clock/boundary clock
> > +functionality.
> > +
> > +The following traffic modes are supported over the switch netdevices:
> > +
> > ++--------------------+------------+------------------+------------------+
> > +|                    | Standalone |   Bridged with   |   Bridged with   |
> > +|                    |    ports   | vlan_filtering 0 | vlan_filtering 1 |
> > ++====================+============+==================+==================+
> > +| Regular traffic    |     Yes    |       Yes        |  No (use master) |
> > ++--------------------+------------+------------------+------------------+
>
> Just to make sure I fully understand the limitation here and sorry for
> making you repeat it since I am sure you have explained it already.
>
> Let's say that I have a bridge with vlan_filtering=1 configured, and I
> assign an IP address to the bridge master device (as is a common thing
> with e.g.: SOHO routers), does that mean I cannot ping any stations
> behind that bridge at all?
>

Let's make it even more concrete to make sure I understand.
Let's say I have eth0, eth1, swp0@eth1, swp1@eth1, swp2@eth1,
swp3@eth1. The DSA master is eth1, and swp0-3 are under br0.
You are asking: "can I put more netdevices under br0 other than the
switch ports, such as eth0?"
No, if you want to do that you'd have to create br1 and bridge the DSA
master (eth1) with the other netdevice you want to speak with. In the
situation we're talking about, br0 is simply a conduit for switchdev
operations and not so much of a netdevice.

> We used to have this problem with DSA master devices being a bridge
> member which was fixed a while ago by simply denying them a bridge join
> [1], would that be something to rework somehow here such that we can let
> your DSA master device join the bridge to continue delivering frames to
> the bridge master?
>
> [1]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8db0a2ee2c6302a1dcbcdb93cb731dfc6c0cdb5e
>
>

I know this patch, but in what ways are you proposing a rework
exactly? Would you want the "dumb switch" mode to bridge the master
with the switch ports, so that you don't need another br1?

> > +| Management traffic |     Yes    |       Yes        |       Yes        |
> > +|    (BPDU, PTP)     |            |                  |                  |
> > ++--------------------+------------+------------------+------------------+
> > +
> >  Switching features
> >  ==================
> >
> > @@ -92,6 +124,23 @@ that VLAN awareness is global at the switch level is that once a bridge with
> >  ``vlan_filtering`` enslaves at least one switch port, the other un-bridged
> >  ports are no longer available for standalone traffic termination.
> >
> > +Topology and loop detection through STP is supported.
> > +
> > +L2 FDB manipulation (add/delete/dump) is currently possible for the first
> > +generation devices. Aging time of FDB entries, as well as enabling fully static
> > +management (no address learning and no flooding of unknown traffic) is not yet
> > +configurable in the driver.
> > +
> > +Other notable features
> > +======================
> > +
> > +The switches have a PTP Hardware Clock that can be steered through SPI and used
> > +for timestamping management traffic on ingress and egress.
> > +Also, the T, Q and S devices support TTEthernet (an implementation of SAE
> > +AS6802 from TTTech), which is a set of Ethernet QoS enhancements somewhat
> > +similar in behavior to IEEE TSN (time-aware shaping, time-based policing).
> > +Configuring these features is currently not supported in the driver.
> > +
> >  Device Tree bindings and board design
> >  =====================================
> >
> >
>
> --
> Florian

Thanks,
-Vladimir
