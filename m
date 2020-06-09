Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B0C1F48C7
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgFIVWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFIVWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:22:17 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37A7C05BD1E;
        Tue,  9 Jun 2020 14:22:16 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id b10so132720uaf.0;
        Tue, 09 Jun 2020 14:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lvo6gmfaSUatvcdPmlKUWjisLMZTWlY31eXgIl8wXfM=;
        b=eDrRBDWRazsKcuFMK88bS+L3xhQwKZ6Jde99eN2tR+dWuTnLjy34W+3n3Ww8l5kIlv
         6u3uiJ0ogyzwor7kMHvuynNDvFYZv0RsaceiiQTePvf9a85dzWQlaD6tKOZfXFJ99yiW
         WG/plUXLrS4SWDVfNvEp5HhjedWcizQsPrWs1BKJR/QKPV/uDb9fLb0gvJAzUQFNoxTZ
         GEp7IoGPR9s4/SZhmqNzfvCoXIEzm94tdqhK898jXDa/wqtlyjdGYy9IdqNEpZaYWImJ
         WHPtC/me7dvfRGSNwEZT5I1W+8Grot4LGawAxvsrNnr0JgAZsEG2UC/MqCaqS0H0ujyo
         e4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lvo6gmfaSUatvcdPmlKUWjisLMZTWlY31eXgIl8wXfM=;
        b=nvcsdlA6Jv4YgVi58OzH4TS3KHPxjDyfYeDKnYxQBHiHupgf/r6wBaW6UNpz9TEPci
         V2bj+WYXiwdv43Jz29ppk91ycz5QS3rLvcu18mVMdT0KhKsV2WYArG9w6VlvLnTk/ggh
         MnzMhKbKekFs0Gxao0J0UaYB5S+THRZIXs98Anegl9863CQfxx98M2qRCbakMQPXJ2y4
         9j3MMxNnR85vdAfCgiG3UsTxd2TjS58qTOMHluKBMfKtXQD5jpai8zYo96UuTHSuwMnV
         GHNd+FNtqjO8e6uGJGjoxcxWsEmgB/sBl4+B3EbUM4L7DaWSx27jGxsxWwsJkSkV0tfE
         v/cw==
X-Gm-Message-State: AOAM5308SBgNUK9DksbVTeqUo4JtPec5j1++hPlP5vn6eUkPPnQPZPdh
        +MVlyApVzswF6qoCNZNWhY3Lr92CVLiE/APR7AQ=
X-Google-Smtp-Source: ABdhPJzv9zcfmFRD/xb+N4TrM5e7mssTEt6wunGbMj0+XsQ2MiBmqviK4jz/SHdgoIOI6C7fqOlNqElwR4p7fO1/rwc=
X-Received: by 2002:ab0:4754:: with SMTP id i20mr324220uac.142.1591737735766;
 Tue, 09 Jun 2020 14:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609111323.GA19604@bombadil.infradead.org> <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
 <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
In-Reply-To: <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
From:   jim.cromie@gmail.com
Date:   Tue, 9 Jun 2020 15:21:49 -0600
Message-ID: <CAJfuBxwyDysP30cMWDusw4CsSQitchA5hOKkpk1PktbsbCKTSw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
To:     Joe Perches <joe@perches.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 10:49 AM Joe Perches <joe@perches.com> wrote:
>
> (adding Jim Cromie and comments)
>

thanks for bringing me in...


> On Tue, 2020-06-09 at 09:03 -0700, Randy Dunlap wrote:
> > On 6/9/20 4:13 AM, Matthew Wilcox wrote:
> > > On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
> > > > Here is the third version of dynamic debug improvements in Venus
> > > > driver.  As has been suggested on previous version by Joe [1] I've
> > > > made the relevant changes in dynamic debug core to handle leveling
> > > > as more generic way and not open-code/workaround it in the driver.
> > > >
> > > > About changes:
> > > >  - added change in the dynamic_debug and in documentation
> > > >  - added respective pr_debug_level and dev_dbg_level
> > >
> > > Honestly, this seems like you want to use tracepoints, not dynamic debug.
>
> Tracepoints are a bit heavy and do not have any class
> or grouping mechanism.
>
> debug_class is likely a better name than debug_level
>
> > Also see this patch series:
> > https://lore.kernel.org/lkml/20200605162645.289174-1-jim.cromie@gmail.com/
> > [PATCH 00/16] dynamic_debug: cleanups, 2 features
> >
> > It adds/expands dynamic debug flags quite a bit.
>
> Yes, and thanks Randy and Jim and Stanimir
>
> I haven't gone through Jim's proposal enough yet.
> It's unfortunate these patches series conflict.
>
> And for Jim, a link to Stanimir's patch series:
> https://lore.kernel.org/lkml/20200609104604.1594-1-stanimir.varbanov@linaro.org/
>
>


As Joe noted, there is a lot of ad-hockery to possibly clean up,
but I dont grok how these levels should be distinguished from
KERN_(WARN|INFO|DEBUG) constants.
Those constants are used by coders, partly to convey how bad things are
As a user, Id be reluctant to disable an EMERG callsite.

are you trying to add a User Bit ? or maybe 7-9 of them ?

I have a patchset which adds a 'u' flag, for user.
An earlier version had x,y,z flags for 3 different user purposes.
I simplified, since only 1 was needed to mark up arbitrary sets of callsites.
Another patchset feature lets u select on that flag.

 #> echo u+p > control

Joe suggested class, I certainly find level confusing.

Is what you want user-flags u[1-7], or driver-flags d]1-7]   ?
and let me distinguish,
your flags are set in code, not modifiable by user, only for filtering
on flag/bit state ?
so theyd be different than [pfmltu_] flags, which are user changed.

my patchset also adds filtering on flag-state,
so that "echo u+p > control " could work.

if you had
     echo 'module venus 1+p; 2+p; 9+p' > control
how far would you get ?

if it covers your needs, then we could add
numerical flags (aka U1, U9) can be distinguished from  [pfmltu_PFMLTU]
and excluded from the mod-flags changes

from there, it shouldnt be hard to add some macro help

DECLARE_DYNDBG_FLAG ( 1, 'x' )
DECLARE_DYNDBG_FLAG ( 2, 'y' )
DECLARE_DYNDBG_FLAG ( 3, 'z' )

DECLARE_DYNDBG_FLAG_INFO ( 4, 'q', "unquiet a programmer defined debug
callsite set" )

also, since Im here, and this is pretty much on-topic,
I perused https://lkml.org/lkml/2020/5/21/399

I see 3 things;
- s / dev_dbg / VDBGL /
- add a bunch of VDBGM calls
- sys_get_prop_image_version  signature change.   (this doesnt really
belong here)

ISTM most of the selection of dyndbg callsites in that part of venus
could be selected by format.

   echo "module venus format error +p" > control

if so, refining your messages will define the logical sets for you ?


thanks
JimC (one of them anyway)
