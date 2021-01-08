Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FF52EFB40
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbhAHWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAHWdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:33:51 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897DDC061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 14:33:10 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id o17so26655653lfg.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VcLpmzX4hECgkQlnNfDceyQmby+RbEXut2HAWkKmWRQ=;
        b=G3VRktJVg0NyPhCew5tpF8Qu8QNLNlhh+fhZmnsYyIlKtXdeNYQ73ImcHfUq7yKRTr
         Rj/IBYvrjm79FKT9ya1eXbOjLcPOA9PGdEGSG5Ju37l6n635MaRnwGnFi5/ItfBPWI2K
         b63u9eiCGj9NTMwnIGPpXWG2KuxccZUfgmiCnMZZR82RiSkUqIWNRueG2BxbeSBA0/vf
         2z/a/Yu9Kwc+OC9ji2/OweWaQVytyPCXhb2VdCqXZyl/5sXcECEIBFoy0D99iwnc2/Rc
         WtOA2iwAa4DkPZM4p0VmlhhmCjBPcMPT7Bup8nhLMoRoz4egOv9LK9jDQ0vIJHQMACim
         wksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VcLpmzX4hECgkQlnNfDceyQmby+RbEXut2HAWkKmWRQ=;
        b=RS3qNS7LHlR6CatT0g7nhI4q1wbJlTdZrARKRv4ncu1DsveFmVdNyhM7P4FUO77SP6
         /DUMmFrbhqL9BhAe7O9gv6EdYe2tUH5pQafYeITISlpiYUhzlOTdpqbYohDH6f4TJ6rm
         TKFmr9ISuHNoK7EYRk1AL259mAnD6JXH3OZjqjP64+kDFlJ5hcv0TYEDbT98Md9YLNrR
         a+6FFMhgUPPdwPgXWb0PLAo0TA2HFO6nHM4BS3Kt8H4M+/dvU5nwsS2x9zhFao4OAo+y
         UZFCA8K/PKhhRs75hx9MyoGxBrxvKsVIW3SRO5cjo2j5Eo4E7br7myPHmZ7y6RAOJIOq
         Wdkg==
X-Gm-Message-State: AOAM532mVjgnaiNAzk1s8NM/CsMzICTZLVDzcNFOqzodDMW+tD23neut
        xTTm+N64vd9fgclmaib3IODLG4I39/UTXhGd2XA=
X-Google-Smtp-Source: ABdhPJx+RH0UFWjGXq/Vmm5nw6yWrcBYzq1IhmwFNhBbWiievNl6dB9TIwtDUO/kj0IR2YKwN8HiSpuK2XnF/GJ8s7Y=
X-Received: by 2002:a19:8357:: with SMTP id f84mr2538490lfd.567.1610145189020;
 Fri, 08 Jan 2021 14:33:09 -0800 (PST)
MIME-Version: 1.0
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
 <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com> <X/hhT4Sz9FU4kiDe@lunn.ch>
 <CAJKO-jYwineOM5wc+FX=Nj3AOfKK06qK-iqQSP3uQufNRnuGWQ@mail.gmail.com>
 <X/jIx/brD6Aw+4sk@lunn.ch> <68bfbe38-5a3a-598c-25d7-dad33253ee9f@gmail.com>
In-Reply-To: <68bfbe38-5a3a-598c-25d7-dad33253ee9f@gmail.com>
From:   Brian Silverman <silvermanbri@gmail.com>
Date:   Fri, 8 Jan 2021 17:32:57 -0500
Message-ID: <CAJKO-jb7sbzCxPCj75zcZHhdn3xSnuzKu7pSq5dMDxj1tj7LqA@mail.gmail.com>
Subject: Re: MDIO over I2C driver driver probe dependency issue
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks - I will have to keep a local patch to fix this for my needs
for the time being.

If in the future if I'm able to do something better (e.g. with a
better fw_devlink, which looks interesting), I'll post a patch.  But I
generally lag the latest kernels by a couple years, so...  not any
time soon.

<and hopefully this time my post doesn't bounce as I've turned off HTML>



On Fri, Jan 8, 2021 at 5:11 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 1/8/2021 1:04 PM, Andrew Lunn wrote:
> > On Fri, Jan 08, 2021 at 03:02:52PM -0500, Brian Silverman wrote:
> >> Thanks for the responses - I now have a more clear picture of what's going on.
> >>  (Note: I'm using Xilinx's 2019.2 kernel (based off 4.19).  I believe it would
> >> be similar to latest kernels, but I could be wrong.)
> >
> > Hi Brian
> >
> > macb_main has had a lot of changes with respect to PHYs. Please try
> > something modern, like 5.10.
>
> It does not seem to me like 5.10 will be much better, because we have
> the following in PHYLINK:
>
> int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>                              u32 flags)
> ...
>           phy_dev = of_phy_find_device(phy_node);
>           /* We're done with the phy_node handle */
>           of_node_put(phy_node);
>           if (!phy_dev)
>                   return -ENODEV;
>
> Given Brian's configuration we should be returning -EPROBE_DEFER here,
> but doing that would likely break a number of systems that do expect
> -ENODEV to be returned. However there may be hope with fw_devlink to
> create an appropriate graph of probing orders and solve the
> consumer/provider order generically.
>
> Up until now we did not really have a situation like this one where the
> MDIO/PHY subsystem depended upon an another one to be available. The
> problem does exist, however it is not clear to me yet how to best solve it.
> --
> Florian
