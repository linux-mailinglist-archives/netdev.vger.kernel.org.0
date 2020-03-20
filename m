Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D218C7F0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 08:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCTHF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 03:05:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37465 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgCTHF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 03:05:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id d1so5134029wmb.2
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 00:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2VAdTGu4zrsvfmnjnqq93sqZyQU8KLDQ4SHifAku4/w=;
        b=QfND24zRWoV+mgGJXmnkRydzxqLUio8c+HcpLZPpeg0o/gDUi/dX+Phw4HFnb7rFEE
         kOTpvu+mBFyEgbNkXBLhAMrXxbA1n7lBKKjRRTiufVtzP3Mge4G+kv6KJv+yLCkmURp9
         wsUvKUiC63aCwHujMlQ68d7WxDMAomCLnq1EIUm4Y77Rnh08hUA0T2m/Vr+JGMFQtPfx
         /dzAJSOOs7mYDOo20n0Knol7NPSSf+hQhgqzscppZnt1PpuAE8pYg36EvLXombY+e+FB
         cu2IS518+nPWTmoDC7FOvzuRBKx2ucSFynFCbN0GIvMu99pv9TqG63w2hyoinZzlOSxs
         YqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2VAdTGu4zrsvfmnjnqq93sqZyQU8KLDQ4SHifAku4/w=;
        b=XvcoBWBfYUGvy14hZgd3T0f6C3bzmtSDf6coKSpIiLSx49HqwzenjJVePK/fVQKMmn
         3VXMoTX5A4UH/endV79HZoNlPdR4jqYbWL6+UXAS3uNNqIZEOC1EygfJLoLQsB8+1RC9
         1vwYgtoez6h12e3TqmZjG577ZuZgsDo0ZdyArAmB9t80pOJcm6cdQMOCQoSFCeONkUI/
         DEMzpqG3kRUn2XpfPlRkAQZ587k2CrU+fth/YKVHlF7CymzT9Xn57gjPxzcfYXF3slWI
         4W2EOFdhBeNfhKOyWe3CyH95rWwMSQe/6ll+AVqONgR8qQqqC+u/06Xzm4Kxly91tka5
         Fv7Q==
X-Gm-Message-State: ANhLgQ0Gq0/bMU1OhiTP3mA5p0X32Im8+nLj9fIjpva7eZyLuH+zjDYl
        vQoM33qtVf0JCJCHINHeWA+lsCeR+8wAbKIxhwk=
X-Google-Smtp-Source: ADFU+vtRhO9RmZic1J1n5HD1yStHTdmIB7lpeIoh4VjnPaVdq7gHCHMK3Tg0uGSTZNaog9NvL9+whW/NqEuSSQ0OysY=
X-Received: by 2002:a7b:c8ce:: with SMTP id f14mr8393713wml.138.1584687926967;
 Fri, 20 Mar 2020 00:05:26 -0700 (PDT)
MIME-Version: 1.0
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584623248-27508-5-git-send-email-sunil.kovvuri@gmail.com>
 <20200319155631.GC27807@lunn.ch> <20200319154211.4bf7cf01@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200319154211.4bf7cf01@kicinski-fedora-PC1C0HJN>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 20 Mar 2020 12:35:15 +0530
Message-ID: <CA+sq2Cf_enB_wKmoFtiHVFuT+eLeP07GRnzbioxfa=ND9n+_ig@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 4/8] octeontx2-vf: Ethtool support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 4:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Mar 2020 16:56:31 +0100 Andrew Lunn wrote:
> > On Thu, Mar 19, 2020 at 06:37:24PM +0530, sunil.kovvuri@gmail.com wrote:
> > > From: Tomasz Duszynski <tduszynski@marvell.com>
> > >
> > > Added ethtool support for VF devices for
> > >  - Driver stats, Tx/Rx perqueue stats
> > >  - Set/show Rx/Tx queue count
> > >  - Set/show Rx/Tx ring sizes
> > >  - Set/show IRQ coalescing parameters
> > >  - RSS configuration etc
> > >
> > > It's the PF which owns the interface, hence VF
> > > cannot display underlying CGX interface stats.
> > > Except for this rest ethtool support reuses PF's
> > > APIs.
> > >
> > > Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> > > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> >
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> But they didn't add static inlines, no? Don't the dependencies
> look strange?
>
> VF depends on PF code, but ethtool code (part of PF) also needs
> symbols from the VF..
>

ethtool code has no dependency on symbols from the VF driver.
PF driver compiles and module loads fine without enabling VF driver.
While getting rid of __weak fn()s i forgot to remove EXPORT symbols
from VF driver.
I will remove and resubmit.

Thanks,
Sunil.
