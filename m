Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CEF1618BD
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgBQRYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:24:39 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40222 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgBQRYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:24:38 -0500
Received: by mail-ed1-f65.google.com with SMTP id p3so21507717edx.7;
        Mon, 17 Feb 2020 09:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u1nQEtqW2aNqmLIp3clQ4fXsItGN/dXkZ4CfdqKQPVA=;
        b=Y8TV+aE9BIOYZJc8/gD4X9Uh/XtTtK/3QNse2ZB0uFlmVzZ3v3YCfB7M8wQz7MLRJG
         TV0zqFXBDvQ/fiVL9gTjwXrKP7fGa2jyvK7tcXHy5pF0nSudVj6HTnhpuHKwPB0Wav3A
         KgdV2AP86tz864P/dxkgY9JcC5qJXWJSwRcf+BZ0eE9p5TCEKI9p9sg4YilYqmFnj3lv
         e5fJHHbyENi9lJPF/tFPNI27cK2AvvBLcZtq99Jr/f8JhhRK5aWirVaJf1BMX0KFcK5e
         ss2SSWXf0C0s/cpzGWnhEQG8mVwnUHI0Wyq2+wBoJapWsTnioyKf+8uwIHjevU/vQAL3
         tOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u1nQEtqW2aNqmLIp3clQ4fXsItGN/dXkZ4CfdqKQPVA=;
        b=JVD7pOUJFQdUkuihyjh2VWmJNZDNyYKKGpX2VfoId/vMgc7sTOj3uQP8QiecoGpDxB
         Bn0kkbh6zOqDpCI0bfTxXs+ETdfv7dCYS6uyDcWrpIYSYmie4YnghDy1JBcKFe2InLP8
         JgKxg/ioPZc8cv7yv/66GcFlTbM7P40K2OPaDVqWipdaS3TrjtxZ/0RHflvNQ6aq6wCG
         iI8S2GPP6E93FOyXsjG4wi74nlnWmFOeciqW88Yt/mlUQUmINjOeqtBgRk1/OXcxN1UC
         MemN4vM8Oi7OAfxm9cMM/JRmCTSWfd+x4AUDqnW+Nnmfe6Vsgq7wYy2aam3giR87vlhR
         DJiQ==
X-Gm-Message-State: APjAAAV/y7E9/gg8kPqSZg3U+GlDesoC+cPlzAxgCIP4IKa3o3RtkUOL
        fdBAteTz/YwjSrIUQG98lbXFVh1XretoNmnZ45Q=
X-Google-Smtp-Source: APXvYqw75BYhDxlqR4xeUOWFafyGl0xfBrqpMyJLiRI7SJj+IBardCJE6VE/53BU10mpxUUOVFb8hf74aNXWiFC2X54=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr15377184edr.145.1581960276700;
 Mon, 17 Feb 2020 09:24:36 -0800 (PST)
MIME-Version: 1.0
References: <20200217144414.409-1-olteanv@gmail.com> <20200217144414.409-4-olteanv@gmail.com>
 <20200217152912.GE31084@lunn.ch> <CA+h21ho29TRG8JYfSaaSsoxM-mg0-yOKBNCq9wbHDHCf2pkdUg@mail.gmail.com>
In-Reply-To: <CA+h21ho29TRG8JYfSaaSsoxM-mg0-yOKBNCq9wbHDHCf2pkdUg@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 17 Feb 2020 19:24:25 +0200
Message-ID: <CA+h21hp-4WWtY=-WeMgC0M6Ls7Aq6AdVv3y=8WE9z=2Ybikt7Q@mail.gmail.com>
Subject: Re: [PATCH devicetree 3/4] arm64: dts: fsl: ls1028a: add node for
 Felix switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 at 17:33, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Andrew,
>
> On Mon, 17 Feb 2020 at 17:29, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Hi Vladimir
> >
> > > +                                     /* Internal port with DSA tagging */
> > > +                                     mscc_felix_port4: port@4 {
> > > +                                             reg = <4>;
> > > +                                             phy-mode = "gmii";
> >
> > Is it really using gmii? Often in SoC connections use something else,
> > and phy-mode = "internal" is more appropriate.
> >
>
> What would be that "something else"? Given that the host port and the
> switch are completely different hardware IP blocks, I would assume
> that a parallel GMII is what's connecting them, no optimizations done.
> Certainly no serializer. But I don't know for sure.
> Does it matter, in the end?
>

To clarify, the reason I'm asking whether it matters is because I'd
have to modify PHY_INTERFACE_MODE_GMII in
drivers/net/dsa/ocelot/felix_vsc9959.c too, for the internal ports.
Then I'm not sure anymore what tree this device tree patch should go
in through.

> > > +                                             ethernet = <&enetc_port2>;
> > > +
> > > +                                             fixed-link {
> > > +                                                     speed = <2500>;
> > > +                                                     full-duplex;
> > > +                                             };
> >
> > gmii and 2500 also don't really go together.
>
> Not even if you raise the clock frequency?
>
> >
> >      Andrew
>
> Thanks,
> -Vladimir
