Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2253A25F96A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgIGL16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgIGL1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:27:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10000C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:59:57 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so13518023iol.10
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RiiUeathDqvxgkY1TmFZqGdZcHfZQQ8f+G3aje1G33g=;
        b=twfe4aVdeRQZyVKmZt8fYrxf5XIeYLtfy7tAty12lYesYl8XQ6clUyeQISJxwrYQIX
         uOpO3eJ0P7CPOl/++uzTae1SoMwdf4lAH94Ps8wJMxq+WyRLZdjlZe/7/jICofW7rNtb
         vr0bKPa2oUMKLuS2IMWTe02KELUHFt1D9mGzZsE6TjhxfSdtMGhqiuvZjzyGliMM3Br3
         hIXLsgPBGfkrUNfApnr6PHPbvelUkdoiRv7soBxFM0oJd4dJav3GiCrn5gGl7dQQW2wh
         8AX4QLEhT6cEFrQ/awCTKkzp/MYsug5Yk17Cgm9mjqJrKm70LppEvCQawsSHf5vwt8Pa
         +p0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RiiUeathDqvxgkY1TmFZqGdZcHfZQQ8f+G3aje1G33g=;
        b=WUqXGjDUPpIOcifyV2PupbMzDpVL8hEs9lvYfrzN1fSAtBNNMy9aUWancp74lynHWn
         2+v/uVxkZZr4SQOaSJFXlw0p25DJJ4s0t0NEw4g6REcP4vfLLKf6HCvxPrDMU0femP4E
         Tn104g95jGWBh6Kq+qsmNnZFF2hnm/krQJ7j4Z06+qfP2+fplijXxAz0Kpz4qBSm20BN
         iiqJnjkfZLLwNRF8ztnXutG55SGsWNjGyi6hUfIgmYbm1DjGCAdaChyE9V1ZzyeU3iEi
         P/2q6UemnYZ6Cfk5qO6WogxJ6UUxK14uml0Q8c0POR798P776jejOhimY/zdMBxdaTsq
         vUSw==
X-Gm-Message-State: AOAM532SAS1+B71i/9ydlqYY+J9N7RLvHGsMckIt/Spa8BT0RkuVlDk9
        IfJw4t//TCD+4Vf/5fq1nPFlSnNH6kCxKEfyYio=
X-Google-Smtp-Source: ABdhPJxKgPxHAwCEVyfAtaC74eCIlBVhgLNaNZTexttGOecc9qojDbEwJsMPuxOZ6NpVscWew53j7ZUE8/yKoatirnY=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr16773963iol.12.1599476396354;
 Mon, 07 Sep 2020 03:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion> <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion> <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 7 Sep 2020 16:29:45 +0530
Message-ID: <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sat, Sep 5, 2020 at 2:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Sep 2020 12:29:04 +0000 Sunil Kovvuri Goutham wrote:
> > > >No, there are 3 drivers registering to 3 PCI device IDs and there can
> > > >be many instances of the same devices. So there can be 10's of instances of
> > > AF, PF and VFs.
> > >
> > > So you can still have per-pci device devlink instance and use the tracepoint
> > > Jakub suggested.
> > >
> >
> > Two things
> > - As I mentioned above, there is a Crypto driver which uses the same mbox APIs
> >   which is in the process of upstreaming. There also we would need trace points.
> >   Not sure registering to devlink just for the sake of tracepoint is proper.
> >
> > - The devlink trace message is like this
> >
> >    TRACE_EVENT(devlink_hwmsg,
> >      . . .
> >         TP_printk("bus_name=%s dev_name=%s driver_name=%s incoming=%d type=%lu buf=0x[%*phD] len=%zu",
> >                   __get_str(bus_name), __get_str(dev_name),
> >                   __get_str(driver_name), __entry->incoming, __entry->type,
> >                   (int) __entry->len, __get_dynamic_array(buf), __entry->len)
> >    );
> >
> >    Whatever debug message we want as output doesn't fit into this.
>
> Make use of the standard devlink tracepoint wherever applicable, and you
> can keep your extra ones if you want (as long as Jiri don't object).

Sure and noted. I have tried to use devlink tracepoints and since it
could not fit our purpose I used these.

Thanks,
Sundeep
