Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE65FEAB
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGDXcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:32:24 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39874 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDXcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:32:23 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so6657091edv.6;
        Thu, 04 Jul 2019 16:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cX6nHtTKELS0nlqmaRfVAhra97bpjvwlsmKbwJvPrso=;
        b=rxl1wTXi046K+QqtyHJvHyAJgrlScrICo4IcfjX78f7TBSCH6gB+2yKRSQChPuc0x2
         6so96zGpdM1L5QmCnq3tQqZZJHTtqc6z5VtiaKA/xM14WOkTv7KfSp+9GE6j+n4k/gLb
         FH/XIN6SSU/8GfvtL57cO4NYTDiZHE+roDOuZng/6OcVdu7/UVItQzAIYDL100fB3TGl
         MHBbmZRYz+I7LW0kIVIK77oU7leOx9DDqh8VXyJEWysbfH3g0V9BirA/CZAqdCAp/JD6
         exjODXOaliCajA2UgpL95TJlvOy2kfpVZaIDFnfTHWio87wMdnxWdnanWXzv2TQ1toXk
         3gPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cX6nHtTKELS0nlqmaRfVAhra97bpjvwlsmKbwJvPrso=;
        b=PgY9Bf8Kk87KuGC6Igy1OugcD/xKh5uSX9jlF6lahaZmtgPPUahi+WbpJkOC6nMmJR
         ZwqrSuTxjvNcpJ0vmLA/vZpI7C0Vf2fxVH2gonsSHsAZt5st2cI0pZ5wgSUMcwSLXEGZ
         E/Zgb/IKt8Ge3kvXxbX0jKBDsnL1z66Xh214lvELN+OP3GCKnW+ybn7raHXTpcZ58Nkq
         EQUE663K4V+VpbZHriXcnMQprWJGOHq4hpjft9T0lJ0hh+rx7I4he5cETnLETXwJPawR
         4oRcyh80HroNdPXRdikPREDiPLy1dxHn2MIMOBMnTdby4DPoGLOlxS2OEcMv2mMHfLVE
         9qOQ==
X-Gm-Message-State: APjAAAWjgqH/gEGX+x4Fk/iTeZ2bNI15+2RTwQ5rBjLwo9+fNCOenkST
        ExvUwGO6ZUN3rscbpVaOUBybvogBXkq3KibcUzw=
X-Google-Smtp-Source: APXvYqwubu8GnrljQuP6hpQyT0Bj/7SRpfGpd1V8szw8gCaTzMPhkSeoUuAvBgEbpax9UIQXw7I/eJvRRVTgRPDSEf8=
X-Received: by 2002:a50:aa14:: with SMTP id o20mr1159284edc.165.1562283141133;
 Thu, 04 Jul 2019 16:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch> <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net> <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch> <20190624182614.GC5690@piout.net>
In-Reply-To: <20190624182614.GC5690@piout.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 5 Jul 2019 02:32:09 +0300
Message-ID: <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 at 00:23, Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> On 24/06/2019 18:24:31+0200, Andrew Lunn wrote:
> > On Mon, Jun 24, 2019 at 05:23:45PM +0200, Allan W. Nielsen wrote:
> > > Hi Andrew,
> > >
> > > The 06/24/2019 16:26, Andrew Lunn wrote:
> > > > > > Yeah, there are 2 ethernet controller ports (managed by the enetc driver)
> > > > > > connected inside the SoC via SGMII links to 2 of the switch ports, one of
> > > > > > these switch ports can be configured as CPU port (with follow-up patches).
> > > > > >
> > > > > > This configuration may look prettier on DSA, but the main restriction here
> > > > > > is that the entire functionality is provided by the ocelot driver which is a
> > > > > > switchdev driver.  I don't think it would be a good idea to copy-paste code
> > > > > > from ocelot to a separate dsa driver.
> > > > > >
> > > > >
> > > > > We should probably make the ocelot driver a DSA driver then...
> > > > An important part of DSA is being able to direct frames out specific
> > > > ports when they ingress via the CPU port. Does the silicon support
> > > > this? At the moment, i think it is using polled IO.
> > >
> > > That is supported, it requires a bit of initial configuration of the Chip, but
> > > nothing big (I believe this configuration is part of Claudiu's change-set).
> > >
> > > But how do you envision this done?
> > >
> > > - Let the existing SwitchDev driver and the DSA driver use a set of common
> > >   functions.
> > > - Convert the existing Ocelot driver from SwitchDev to DSA
> > > - Fork (copy) the existing driver of Ocelot, and modify it as needed for the
> > >   Felix driver
> > >
> > > My guess is the first one, but I would like to understand what you have in mind.
> >
> > I don't know the various architectures the switch is used in. But it
> > does seem like a core library, and then a switchdev wrapper for Ocelot
> > and a DSA wrapper for Felix would make sense.
>
> Ocelot could also be used in a DSA setting where one port can be
> connected to an external MAC and be used to inject/extract frames
> to/from any other ports. In that case, the IFH would serve as the DSA
> tag.
>
>
> --
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Hi everyone,

Thank you for the nice discussion.
I've been talking off-list to Claudiu and Alexandru about switchdev vs
DSA for the Felix/Ocelot switches.
My initial reaction was the same as Andrew's - there's a CPU-facing
Ethernet MAC with some vendor-defined injection and extraction
headers? Sounds like DSA.
But then we discussed about what DSA for Felix/Ocelot would look like.
Here are some points to consider:
- DSA is typically used for discrete switches, switchdev is typically
used for embedded ones. As far as I understand from Allan's message,
Ocelot is really an entire switching SoC that's running Linux inside
(on the MIPS CPU) with a switchdev driver. There is no (mainline?)
driver that would control the Ocelot SoC from a higher-level Linux
system. The latter would (maybe) fit DSA more.
- The D in DSA is for cascaded switches. Apart from the absence of
such a "Ocelot SoC" driver (which maybe can be written, I don't know),
I think the switching core itself has some fundamental limitations
that make a DSA implementation questionable:
    1. The switch has a single port which can apply these vendor tags.
Also the injection header is different than the extraction header. See
more at #4.
    2. The switch will tag all frames that go upstream on this port
towards the CPU, no matter what source port they came from. It can't
be told "hey, don't add a tag for frames coming from this
downstream-facing port, because it's a DSA port and not front-panel,
so there's another switch underneath you who already added a tag to
the frame". So frames that arrive at the CPU through an array of N
cascaded Felix/Ocelot switches will need to be peeled off, one by one,
by N vendor tags.
    3. The extraction header does not contain a field for the "switch
id", only for the "source port". This means that if you want to figure
out the switch id, you really *need* to make a topology out of those
stacked vendor tags and figure out which switch it was by counting the
tags. It also means that you can only have Felix/Ocelot in a linear
topology.
    4. The switch cannot parse its own vendor tags. This is a big one,
because it means that for an autonomously forwarded frame which
transits two cascaded switches but doesn't reach the CPU, there is no
one in the path who's going to consume the vendor tag. So the frame
will exit the other front-panel port with extra bytes in it.

Ok, let's say that all of the above limitations have one thing in
common - the vendor tags aren't really thought out with DSA-like
setups in mind. In theory it's possible to not use the native tags and
instead implement a dsa_8021q tagger for it. But then, RX timestamps
for PTP are also transmitted to the CPU through this vendor header,
and losing PTP is a big no-no.

So my conclusion is that DSA for Felix/Ocelot doesn't make a lot of
sense if the whole purpose is to hide the CPU-facing netdev.
In a cascaded setup, these switches could only sit at the top of tree,
and ironically, they'd be better modeled as a switchdev DSA master
port than part of the DSA tree itself. Put these switches anywhere
else in the tree and they're just troublemakers.
As for the LS1028A, I think that connecting this embedded switch via
two Ethernet MACs is just poorly thought out design, but that doesn't
mean DSA is going to help it in any way other than perhaps cosmetic.

Regards,
-Vladimir
