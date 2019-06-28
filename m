Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3705A75F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF1XFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:05:18 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40771 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF1XFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:05:18 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so7500601ljh.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GqfzcGTh4R+wjudzcyBPWjah+lJ5/F0fn2v7GiYZZ1A=;
        b=pzwBCZ+hEhuF0BWeVUfu6SkZIpY1bN87/e7nB8Y+GdcMuWSa97E/Uf5YhCv+jn4ha6
         e//1PWFAausGWjhzQ1oVU6YvJ8VkrbqAPRNMtkMBAwP6lhw2P2T/SwZt1mZJD/X7n/vQ
         OuwSNuRcqVhUeBZaud3kV5x1gnG7g2bVZTPUDuXw7B40081EL20cZfe2AChoXMxFRmVM
         h7xKhLdNj9kWC3CRZLCr0zjiKMBJ0CyBjC5U3cJdTZqvpA0DHcKT22Aen4UtdO8N6cv2
         EBRfiV6b69wnobETdZwwad4vP31sRQM/TyOHaHWKPAMRYT6rcQM/SZbqHMVknzgebqa8
         QypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GqfzcGTh4R+wjudzcyBPWjah+lJ5/F0fn2v7GiYZZ1A=;
        b=QyZcQROBD/ExcX3vVttXpO0ffUKNjQI2rytWI4Srli4t4yn7Nu0v8s64+uetzj0i4o
         0YXlg053XnQ9ntVWT9+cdd+p3yCRogRrpXLRIf9dJF2MFFw1hqwW53cbPWHZmjR2xET4
         QmFB94/7KSQjEi2Q26bJzhe/it5oLD3OwdmaDzYtq7oyNY2tsX5p0nbib7Bz15lR3XKN
         h8P3dHI1ooPz58RYHnPgFvSO6HtqutrlhjqyZ4xyWJz4yLNhzcTticjCLm2VfA2B/oJY
         4lWw2erQi0lYkoCZdIcpCY0cxjaqhZsd9BGtLPqpdXld7ne4ScMSJ4amf2VUPCmwmCIF
         dd2Q==
X-Gm-Message-State: APjAAAWLoJZ5ewPqDdzEnSTySLlv+ERNl2+Sb0sl4vVOT58kvXZcgc30
        6ktwLdHtdIdkwHFK3OoVcFjlxM4YKtQGOhBx4UCVfRtP0DnZAw==
X-Google-Smtp-Source: APXvYqyb+IODZkDaSzeYM2z+Z6NUQ7nHDLo8t8QrnPDdXxpufnA1F1qjEioD/oQWkrnwtYqxsbD2prYuA8maHYT2544=
X-Received: by 2002:a2e:5b1b:: with SMTP id p27mr7304303ljb.97.1561763116214;
 Fri, 28 Jun 2019 16:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-2-csully@google.com>
 <20190626160832.3f191a53@cakuba.netronome.com> <CAH_-1qzzWVKxDX3LaorsgYPjT5uhDgqdN3oMZtJ2p6AzDqRyXA@mail.gmail.com>
 <20190628114615.4fc81791@cakuba.netronome.com> <20190628200628.GS27733@lunn.ch>
In-Reply-To: <20190628200628.GS27733@lunn.ch>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 16:05:05 -0700
Message-ID: <CAH_-1qxdG2nFXTQs30nVanmNuEmENV-bf=60NpAZPy9j3EjyWg@mail.gmail.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute Engine
 Virtual NIC
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 1:06 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Jun 28, 2019 at 11:46:15AM -0700, Jakub Kicinski wrote:
> > On Fri, 28 Jun 2019 10:52:27 -0700, Catherine Sullivan wrote:
> > > > > +if NET_VENDOR_GOOGLE
> > > > > +
> > > > > +config GVE
> > > > > +     tristate "Google Virtual NIC (gVNIC) support"
> > > > > +     depends on (PCI_MSI && X86)
> > > >
> > > > We usually prefer for drivers not to depend on the platform unless
> > > > really necessary, but IDK how that applies to the curious new world
> > > > of NICs nobody can buy :)
> > >
> > > This is the only platform it will ever need to run on so we would really
> > > prefer to not have to support others :)
> >
> > I think the motivation is partially to force the uniform use of generic
> > APIs across the drivers, so that re-factoring of core code is easier.
> > Do you have any specific pain-points in mind where x86 dependency
> > simplifies things? If not I think it's a better default to not have it.
> > Not a big deal, though.
>
> And maybe sometime in the future you might want to put this interface
> in an ARM64 server?
>
> One 'pain-paint' is that the driver might assume cache-coherency,
> which is an x86 thing. If the generic APIs have been used, it should
> not be an issue, but i've not spent the time to see if the DMA API has
> been used correctly.
>
>      Andrew

Mostly it is just hesitation around lack of testing. But I've done a few quick
compile tests and ARM and ARM64 don't seem to have any problems so
I've removed the dependency in v3.
