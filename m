Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3289226FBDB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIRL4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRL4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 07:56:39 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40BC06174A;
        Fri, 18 Sep 2020 04:56:39 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h17so5141955otr.1;
        Fri, 18 Sep 2020 04:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bKOrvyGUMEvEmOgg/jMWt/EUqVke0/N7VcikSM/zy5E=;
        b=nT1xkTnBT44HIB5gZBYN1J8G2VdO+OJkIKIhOXeBgLEsONUbEOECgEIBmC+CzOB4fi
         s2+RJpe+KtnS4Ny1JZ8AkkwfkKPKpZD2lHHco54ucxQO123wIch6Trxm3LEleX5owCNQ
         N7WNQ64lLwj8qzil+7QMxCj1TZXzeGdescOOEeqDER7fuNIH8FlK+yS3TqtEXUGWW/dY
         S4+QI2I0wajHSS4iY9bMvXerjQFmdEegIdMNFO9BC727wJ2HJJ0VtbaCkGtQq/3hbx0k
         53PyzP3ACS78t8wqQQ7NcV9xl/r/EIK0UDehYXZS6w0jb6jVyud4sqR3PWIHAzQVVaKi
         YIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bKOrvyGUMEvEmOgg/jMWt/EUqVke0/N7VcikSM/zy5E=;
        b=fNdbuLPGLdb57fgS43GAqjKpo/u0vTmxP3hMi7y406qT11wV+ViGkdFk7EOvZlahIZ
         3stxAY+kAKujqNIZ2wPiYarZD9TUTgu9YRvMoFH3kODJm1f8tNEUkJ77VXaWqlehzoje
         TN1lsI3N2PU2O4yGAdND5iBbnVVoKaYJ8G/IAw3jg9g/KuGWdNXylIuMtG5Tv9jlX3XO
         iq3rKxm2GAAX+QuY3aG8HU9vyB5CpTygIlikTJPJbsvDCy+9X+fhbD7tXZtwyTHUzvEf
         ffkhwpmiSN+62rlWuWjFBqCbK6hnMuxYeACC7ywicArwxIfzQCz3wtkAp7UaHsCmGGrp
         f05g==
X-Gm-Message-State: AOAM532jwYaIiorKincyPmLQ9beRQIbqvrarxZlQhvv6RvWMR53AxAOR
        eTvy6r1CqQXGAceeUptrVlTZv+0iFBNb1esy43E=
X-Google-Smtp-Source: ABdhPJzk5hzh3206q304HnVA4MDalu//mmX4OhC3q96ogtc63dcCtzPNKyFt3Rusp6BT9OtcYeEocHth+XDGyX/528o=
X-Received: by 2002:a9d:b95:: with SMTP id 21mr6191903oth.143.1600430198690;
 Fri, 18 Sep 2020 04:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
In-Reply-To: <20200918115227.GR869610@unreal>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 14:56:09 +0300
Message-ID: <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 2:52 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > >> infrastructure for communication between multiple accelerators. Same
> > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > >> The RDMA implementation we did does NOT support some basic RDMA
> > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > >> library or to connect to the rdma infrastructure in the kernel.
> > >
> > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > you can't add random device offloads as IOCTL to nedevs.
> > >
> > > RDMA is the proper home for all the networking offloads that don't fit
> > > into netdev.
> > >
> > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > all. I'm sure this can too.
> >
> > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > was suggested to go through the vfio subsystem instead.
> >
> > I think this comes back to the discussion we had when EFA was upstreamed, which
> > is what's the bar to get accepted to the RDMA subsystem.
> > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
> >
> > Does GAUDI fit these requirements? If not, should it be in a different subsystem
> > or should we open the "what qualifies as an RDMA device" question again?
>
> I want to remind you that rdma-core requirement came to make sure that
> anything exposed from the RDMA to the userspace is strict with proper
> UAPI header hygiene.
>
> I doubt that Havana's ioctls are backed by anything like this.
>
> Thanks

Why do you doubt that ? Have you looked at our code ?
Our uapi and IOCTLs interface is based on drm subsystem uapi interface
and it is very safe and protected.
Otherwise Greg would have never allowed me to go upstream in the first place.

We have a single function which is the entry point for all the IOCTLs
of our drivers (only one IOCTL is RDMA related, all the others are
compute related).
That function is almost 1:1 copy of the function in drm.

Thanks,
Oded
