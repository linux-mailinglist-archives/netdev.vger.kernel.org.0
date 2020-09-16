Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34C26BFAF
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIPIsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPIs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:48:27 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705DC06174A;
        Wed, 16 Sep 2020 01:48:27 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n61so5926749ota.10;
        Wed, 16 Sep 2020 01:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9WmfdGG11fZlXHtIWtmEZpI64NmbJvrHDfdVUWJJ26I=;
        b=WTBZsz3I1yt7dHuR/zcAGYSfhZgF/fh/i7uG0aE1q0wmhrwqhH5mV72hu1CWBEfP0x
         NhoVDmEdXyNoGeiuHRFcfj8uRKdJerbF8uPZVcuZdgonfm1ix+F63SZTVXv/Sj58OElV
         m04+wAMYuOKYa9THDLTCPWbO5KowcMYGFoXRhyGy0Bh5wKzeXLYpSxpd0R+GQnY3X+Lw
         lZECnH8kD1fyLyXpHk4bTRtyBOxG5sR0IqtdXkB9EwBouBo1pwRENRcESlkdQWtLqk25
         JUeBKq5UQcKfv/65Cft1+edkDTBMNLL6dpKpEP+p1V5jOaVsSJ5ySBHE0RZfukFa6ndF
         dzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9WmfdGG11fZlXHtIWtmEZpI64NmbJvrHDfdVUWJJ26I=;
        b=Qc8FeC65hR6CyJUyWhmWwTE8VsG0ohf5/k+mgNY9nvwsgy52DBo9wnLE0ombHNglUf
         DYMD7SHn8P0BMBPsI9sy/lHe3ZfdSM0iG0riXNmhr8DZS/pDVV//wDYuPJTPnIqxJVwe
         csdPlT91FNppt2TJiefO6EUoa3xriWmIKO7t+5xgtxThwhxJ7n4SuYWcY+O+q8rpEach
         xn8I6aqDmyojept3D4k+lIlG5KT2dj3M/3L2sR6oaou1aVfn3p4IOXCMRsB0xA9IVhQA
         472vCyz36tOFPwB5kvZexC164/KS34mTaoifnjjA13oc1jXMfdr/CknfkyK7dV/F2fM1
         j/sg==
X-Gm-Message-State: AOAM530XJVXsZF8Y9XZ4YsdyVMdxcXvtQCXKVQRha1penSfTYlq1X76L
        uMVVMAxGkfGPSBTZ/Yyo93M530YJDicv15mLbqk=
X-Google-Smtp-Source: ABdhPJwISwR0m1rtGDZALu5HLELsrHJCDuhuDRh2Wv0WsYeZ5yobjBKDu6QZDuf+CQPmlYwZlkuTGmR3YslmwW7D8Ow=
X-Received: by 2002:a9d:6d95:: with SMTP id x21mr16350478otp.339.1600246106782;
 Wed, 16 Sep 2020 01:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
 <20200916062614.GF142621@kroah.com> <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
 <20200916074217.GB189144@kroah.com> <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
 <20200916082226.GA509119@kroah.com>
In-Reply-To: <20200916082226.GA509119@kroah.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 11:47:58 +0300
Message-ID: <CAFCwf1366_GoTj1gpneJBSqVxJ1mOnsdZiC+DJLG85GHGfZrzw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:21 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 16, 2020 at 11:02:39AM +0300, Oded Gabbay wrote:
> > On Wed, Sep 16, 2020 at 10:41 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Sep 16, 2020 at 09:36:23AM +0300, Oded Gabbay wrote:
> > > > On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > > > > > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > > > > > >
> > > > > > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > > > > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > > > > > >
> > > > > > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > > > > > into the habanalabs driver.
> > > > > > > >
> > > > > > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > > > > > are in that patch's commit message.
> > > > > > > >
> > > > > > > > Link to v2 cover letter:
> > > > > > > > https://lkml.org/lkml/2020/9/12/201
> > > > > > >
> > > > > > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > > > > > structured and designed.
> > > > > > Why is that ?
> > > > > > Can you please point to the things that bother you or not working correctly?
> > > > > > I can't really fix the driver if I don't know what's wrong.
> > > > > >
> > > > > > In addition, please read my reply to Jakub with the explanation of why
> > > > > > we designed this driver as is.
> > > > > >
> > > > > > And because of the RDMA'ness of it, the RDMA
> > > > > > > folks have to be CC:'d and have a chance to review this.
> > > > > > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > > > > > the kernel and we can't connect to it due to the lack of H/W support
> > > > > > we have
> > > > > > Therefore, I don't see why we need to CC linux-rdma.
> > > > > > I understood why Greg asked me to CC you because we do connect to the
> > > > > > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > > > > > not really the same.
> > > > >
> > > > > Ok, to do this "right" it needs to be split up into separate drivers,
> > > > > hopefully using the "virtual bus" code that some day Intel will resubmit
> > > > > again that will solve this issue.
> > > > Hi Greg,
> > > > Can I suggest an alternative for the short/medium term ?
> > > >
> > > > In an earlier email, Jakub said:
> > > > "Is it not possible to move the files and still build them into a single
> > > > module?"
> > > >
> > > > I thought maybe that's a good way to progress here ?
> > >
> > > Cross-directory builds of a single module are crazy.  Yes, they work,
> > > but really, that's a mess, and would never suggest doing that.
> > >
> > > > First, split the content to Ethernet and RDMA.
> > > > Then move the Ethernet part to drivers/net but build it as part of
> > > > habanalabs.ko.
> > > > Regarding the RDMA code, upstream/review it in a different patch-set
> > > > (maybe they will want me to put the files elsewhere).
> > > >
> > > > What do you think ?
> > >
> > > I think you are asking for more work there than just splitting out into
> > > separate modules :)
> > >
> > > thanks,
> > >
> > > greg k-h
> > Hi Greg,
> >
> > If cross-directory building is out of the question, what about
> > splitting into separate modules ? And use cross-module notifiers/calls
> > ? I did that with amdkfd and amdgpu/radeon a couple of years back. It
> > worked (that's the best thing I can say about it).
>
> That's fine with me.
>
> > The main problem with this "virtual bus" thing is that I'm not
> > familiar with it at all and from my experience I imagine it would take
> > a considerable time and effort to upstream this infrastructure work.
>
> It shouldn't be taking that long, but for some unknown reason, the
> original author of that code is sitting on it and not resending it.  Go
> poke them through internal Intel channels to find out what the problem
> is, as I have no clue why a 200-300 line bus module is taking so long to
> get "right" :(
>
> I'm _ALMOST_ at the point where I would just do that work myself, but
> due to my current status with Intel, I'll let them do it as I have
> enough other things on my plate...
>
> > This could delay the NIC code for a couple of years, which by then
> > this won't be relevant at all.
>
> Why wouldn't this code be relevant in a year?  It's going to be 2+ years
> before any of this shows up in an "enterprise distro" based on their
> release cycles anyway :)
>
> thanks,
>
> greg k-h

Hi Greg,
ok, I'll take a look. Do you happen to have the name of the patch-set / author ?

Regarding the RDMA stuff, I'll do some work internally to separate it
from the Ethernet code and then will send that code only to RDMA
people with more detailed explanations.

Thanks,
Oded
