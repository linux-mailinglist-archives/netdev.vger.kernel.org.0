Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE7247C6D3
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhLUSoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbhLUSoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:44:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280FC06173F
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 10:44:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p18so11408904pld.13
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 10:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dd1YoI2o4q02bX0x09QUIoR25zx0n5gG0OTjgIjYa4A=;
        b=s/sPr7U9xGYzyJMQE0qYIe1yOPMvbI5S7pxeTRXZRN+8ulo7zhhEBr+EinZhbd2wsB
         +2S+icfeTqoBxEAd2QjWENTBAlkEhZZXz5dQED0WWFJgD8C/fVjRMzqwGd8XhjWdSngN
         SUtvqF+yNAlEHqMVQzucfApXae9hXkwRXdA+cjvKRheevl4mRwz5YtANamYhdyp2h1JX
         AgBVzsRXkNhKlm33Z6JODZUzCzFkyDFlwuM5FWH600u1ODPjN7lqD4vevijk4TTEgnD/
         Tw76j4EyeB68FuUN6V0q/6NApMoUNBt6U18mm4J1RW2/22BmU0QQd620jk6FWDQE9fhA
         FUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dd1YoI2o4q02bX0x09QUIoR25zx0n5gG0OTjgIjYa4A=;
        b=VPOGUGbgvtwRmgtwKi1sQ8ckmqSWE+XgOfYa2bUsGBg4UxSX2HzMCmrgPAlocQ7Qmk
         vPphw5IwabgwJfs1zOQjsUd68t91wDewpTWL7dFKoryAa9ZNuXOe+utU/AlSqN+2+GVt
         /EQX8d9mIjzxRYesWFPOxwxrJ/d4KbfzI0GF2Y2Xk3UcnU0WWgKxHASmd2ljBZnxs5LT
         oeC6udM0i9sERwK/84HHD8SFGRhBfiFPhOObvbPpL5KgUdmQrreDp6UvUwIOc0AF4AHV
         sSz2X2ojO66iVnJOBKAwltDDnTDVJSQyFECgMHeTMPGsTHb1ute46X2WjrpkyF6le3Ck
         fY2A==
X-Gm-Message-State: AOAM531apwRcOTn3L0Wx7mp42NaGHDLXYV6m8qY/0RYqv/AMuh7RE2VH
        w+E1Jehyi6mucZlfjPIs3P6jRR3OZ87tlaarA4H27g==
X-Google-Smtp-Source: ABdhPJzjPRcPF/ik1Xjt8WwlNpN9FxwJvvBTDlWX6Cjo6Bdo/nRhs+9FBh3YD9yKMrMDfctAhfF39xtetj2jg5KzQyU=
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr5292434pjk.93.1640112261177;
 Tue, 21 Dec 2021 10:44:21 -0800 (PST)
MIME-Version: 1.0
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <YcF9rRTVzrbCyOtq@kroah.com> <CO1PR11MB51700037C8A23B19C0DCF5CAD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcHlQH0gXTHh4cjV@kroah.com>
In-Reply-To: <YcHlQH0gXTHh4cjV@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 21 Dec 2021 10:44:11 -0800
Message-ID: <CAPcyv4hoo=qBLC9d_VYHwCErE5ngsONgQPa45-K4c-GVfFJhsw@mail.gmail.com>
Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ add Christoph for configfs feedback ]

On Tue, Dec 21, 2021 at 7:03 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 21, 2021 at 02:03:38PM +0000, Chen, Mike Ximing wrote:
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Tuesday, December 21, 2021 2:10 AM
> > > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.williams@intel.com>; pierre-
> > > louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > > Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
> > >
> > > On Tue, Dec 21, 2021 at 12:50:30AM -0600, Mike Ximing Chen wrote:
> > > > v12:
> > >
> > > <snip>
> > >
> > > How is a "RFC" series on version 12?  "RFC" means "I do not think this should be merged, please give me
> > > some comments on how this is all structured" which I think is not the case here.
> >
> > Hi Greg,
> >
> > "RFC" here means exactly what you referred to. As you know we have made many changes since your
> > last review of the patch set (which was v10).  At this point we are not sure if we are on the right track in
> > terms of some configfs implementation, and would like some comments from the community. I stated
> > this in the cover letter before the change log: " This submission is still a work in progress.... , a couple of
> > issues that we would like to get help and suggestions from reviewers and community". I presented two
> > issues/questions we are facing, and would like to get comments.
> >
> > The code on the other hand are tested and validated on our hardware platforms. I kept the version number
> > in series (using v12, instead v1) so that reviewers can track the old submissions and have a better
> > understanding of the patch set's history.
>
> "RFC" means "I have no idea if this is correct, I am throwing it out
> there and anyone who also cares about this type of thing, please
> comment".
>
> A patch that is on "RFC 12" means, "We all have no clue how to do this,
> we give up and hope you all will do it for us."
>
> I almost never comment on RFC patch series, except for portions of the
> kernel that I really care about.  For a brand-new subsystem like this,
> that I still do not understand who needs it, that is not the case.
>
> I'm going to stop reviewing this patch series until you at least follow
> the Intel required rules for sending kernel patches like this out.  To
> not do so would be unfair to your coworkers who _DO_ follow the rules.
>
> > > > - The following coding style changes suggested by Dan will be implemented
> > > >   in the next revision
> > > > -- Replace DLB_CSR_RD() and DLB_CSR_WR() with direct ioread32() and
> > > >    iowrite32() call.
> > > > -- Remove bitmap wrappers and use linux bitmap functions directly.
> > > > -- Use trace_event in configfs attribute file update.
> > >
> > > Why submit a patch series that you know will be changed?  Just do the work, don't ask anyone to review
> > > stuff you know is incorrect, that just wastes our time and ensures that we never want to review it again.
> > >
> > Since this is a RFC, and is not for merging or a full review, we though it was OK to log the pending coding
> > style changes. The patch set was submitted and reviewed by the community before, and there was no
> > complains on using macros like DLB_CSR_RD(), etc, but we think we can replace them for better
> > readability of the code.
>
> Coding style changes should NEVER be ignored and put off for later.
> To do so means you do not care about the brains of anyone who you are
> wanting to read this code.  We have a coding style because of brains and
> pattern matching, not because we are being mean.

Hey Greg,

This is my fault.

To date Mike has been patiently and diligently following my review
feedback to continue to make the driver smaller and more Linux
idiomatic. Primarily this has been ripping and replacing a pile of
object configuration ioctls with configfs. While my confidence in that
review feedback was high, my confidence in the current round of deeper
architecture reworks is lower and they seemed to raise questions that
are likely FAQs with using configfs. Specifically the observation that
configfs, like sysfs, lacks an "atomically update multiple attributes"
capability. To my knowledge that's just the expected tradeoff with
pseudo-fs based configuration and it is up to userspace to coordinate
multiple configuration writers.

The other question is the use of anon_inode_getfd(). To me that
mechanism is reserved for syscall and ioctl based architectures, and
in this case it was only being used as a mechanism to get an automatic
teardown action at process exit. Again, my inclination is that configs
requires userspace to clean up anything it created. If "tear down on
last close" behavior is needed that would either need to come from a
userspace daemon to watch clients, or another character device that
clients could open to represent the active users of the configuration.
My preference is for the former.

I green-lighted the work-in-progress / RFC posting  (with the known
style warts) to get momentum on just those questions. I thought it
better to not polish this driver to a shine and get some mid-rework
feedback. Mike continues to be a pleasure to work with, please take
any frustrations on how this was presented out on me, I'll do better
next time for these types of questions. DLB is unlike anything I have
reviewed previously.
