Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6426D1FB5BF
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgFPPNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgFPPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:13:00 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE345C061573;
        Tue, 16 Jun 2020 08:12:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so21905572ejq.6;
        Tue, 16 Jun 2020 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lRffz4NF07W4Q+1ZoBZkSp1mF1TGwLcEnPYhaLlgdgo=;
        b=Ej9lD3N6H82Dyu2JPhjOq5lvP5ho9UbOALRvO6XNsBX9IRil9DpiKICzNE/IeZKfw0
         36LLWyFgp2MSbwLr9U00trapFWbGGgyQwN6bb1t0+3XOSN5Ql4pZR4thh+zcimWDEfb/
         B21HhBQbqlKXYy06mH1tdck8UWwhxrgeurocdrKvHnEVoPpYbOPgkLtR5bvkFE62Z1gv
         +evnTMmYtA7u1DKenNoFL/V1ATx6GX1ba/VFEfp9TIDlIvADuq1S0R6hDd/2LnC6O/4p
         icZ1LqObpkqhdJzXOgjQHMyZdPhMF+UKabyVF1PAtzYgdTHA4DjKfmYn7ww6Nw2G4tav
         wHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lRffz4NF07W4Q+1ZoBZkSp1mF1TGwLcEnPYhaLlgdgo=;
        b=HgxIzJ3GBnwBLVvEF1EIMPXMFOUvvrSQ85B7pr/aZmdQYSsW9fNWTWkwhPHadU4yVF
         kzX6BdDeDrSSrDmBFqUGkrdpPNblu5IU/dMjTlnw8eXxkAJJlx+ALsk2QQSFssBp8LV4
         c1PgR7VkxhdW9c7zjuFTTRywrSxvAANLHl6gDwfjYLPuvYAWuykzsy6zVKBqz0iZvLPB
         a3OSh0aFiZMxysqyALd+mMwmP8R57eop9kaiTNSyRyL2XyX30IYFngW3jSvsl2wnjbg/
         TvY+muheLUovsh5N2U376KmGY0ShCTu3ViKoXLQ5g6QQWlV6klAwPqlsO99sN0eU8FM+
         63LA==
X-Gm-Message-State: AOAM531B6oAk+TDTYZyv+3BYXwCFEgcOL0nrlFaWZr2ogkUAoF9Cy1v0
        wgHrqpTTTVsIK0Ei+bvjOyOcVx/5tjEkZvVWD5U=
X-Google-Smtp-Source: ABdhPJxGqs9gyaKe0CenbU1uIZ6r09n0KF+j79z/qn69u+5AaaAYC3q5fFD6rphQL++riBYd/Z4aGfpt0C/La/jpL9s=
X-Received: by 2002:a17:906:1149:: with SMTP id i9mr3419997eja.100.1592320378543;
 Tue, 16 Jun 2020 08:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200616144118.3902244-1-olteanv@gmail.com> <20200616144118.3902244-3-olteanv@gmail.com>
 <acb765da28bde4dff4fc2cd9ea661fa1b3486947.camel@infinera.com>
 <CA+h21hoz_LJgvCiVeuPTUVHN2Nu9wWAVnzz9GS2bo=y+Y1hLJA@mail.gmail.com>
 <d02301e1e7fa9bee3486ea8b9e3d445863bf49c8.camel@infinera.com> <CA+h21hqyV5RMip8etVvSWpQU0scPpXDNbMJgP9piXrn1maSMbw@mail.gmail.com>
In-Reply-To: <CA+h21hqyV5RMip8etVvSWpQU0scPpXDNbMJgP9piXrn1maSMbw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 18:12:46 +0300
Message-ID: <CA+h21hq6iA0H25tHs=_EFNW9BVJBYMjkVGb8_hi82Gm=ei8Vdg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] dpaa_eth: fix usage as DSA master, try 4
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "madalin.bucur@oss.nxp.com" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 18:08, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, 16 Jun 2020 at 18:04, Joakim Tjernlund
> <Joakim.Tjernlund@infinera.com> wrote:
> >
> > On Tue, 2020-06-16 at 17:56 +0300, Vladimir Oltean wrote:
> > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > >
> > >
> > > Hi Joakim,
> > >
> > > On Tue, 16 Jun 2020 at 17:51, Joakim Tjernlund
> > > <Joakim.Tjernlund@infinera.com> wrote:
> > > > On Tue, 2020-06-16 at 17:41 +0300, Vladimir Oltean wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > The dpaa-eth driver probes on compatible string for the MAC node, and
> > > > > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > > > > triggers the probing of the dpaa-eth net device driver.
> > > > >
> > > > > All of this is fine, but the problem is that the struct device of the
> > > > > dpaa_eth net_device is 2 parents away from the MAC which can be
> > > > > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > > > > DSA switches won't be able to probe on top of FMan ports.
> > > > >
> > > > > It would be a bit silly to modify a core function
> > > > > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > > > > just for one driver. We're just 1 step away from implementing full
> > > > > recursion.
> > > > >
> > > > > On T1040, the /sys/class/net/eth0 symlink currently points to:
> > > > >
> > > > > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> > > >
> > > > Just want to point out that on 4.19.x, the above patch still exists:
> > > > cd /sys
> > > > find -name eth0
> > > > ./devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> > > > ./class/net/eth
> > > >
> > >
> > > By 'current' I mean 'the net tree just before this patch is applied',
> > > i.e. a v5.7 tree with "dpaa_eth: fix usage as DSA master, try 3"
> > > reverted.
> >
> > Confused, with patch reverted(and DSA working) in 4.19, I have
> >   ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> > Is that the wanted path? Because I figured you wanted to change it to the path further down in this email?
> >
> >  Jocke
> > >
>
> Yes, this is the wanted path.
> The path is fine for anything below commit 060ad66f9795 ("dpaa_eth:
> change DMA device"), including your v4.19.y, that's the point. By
> specifying that commit in the Fixes: tag, people who deal with
> backporting to stable trees know to not backport it below that commit.
> So your stable tree will only get the revert patch.
>
> -Vladimir

Oh, sorry, now I see what you were saying. The paths are reversed in
the commit description. It should be:

Good:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0

Bad:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0

So I need to spin another version.

Sorry for the confusion.

-Vladimir
