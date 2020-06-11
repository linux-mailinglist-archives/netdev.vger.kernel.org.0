Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E331F6F52
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgFKVTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgFKVTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 17:19:49 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D3C08C5C1;
        Thu, 11 Jun 2020 14:19:49 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id l10so4172286vsr.10;
        Thu, 11 Jun 2020 14:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1anzsAXDWtZ5K2mcw80BCvcE8icDfice76lV0jTfYAA=;
        b=MDmWelydbeCksVJLKPT78OCVuxJO7+H8IZANEJiiHrDodWUvLU72wq7aPJTlhDS9ET
         lzRiOTs5ZBFUxua0uaYzb49RHWtkB0aJ8WsOukLaGXz7MevMpN0OJVkJPYYoEQhyz4De
         DvwjfglVq3hOlo0hCgYIaum4siPju5qAl1/7sl/Gk2syvCDHKhxdSOzBP4YCC9nLwzLz
         FHWaihN0x/MYoVNyiUNP2aSRq3Xwxn2qMwZHBPeRMgTHs76BxCGi4Qqgsq90h87xiSlx
         LI3HPDW8AcHw0dONu7B1FbrI7I8bNoE+gVlspuUFVWXzi3kgOo7bKwuBZUd+k60wN8wL
         vOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1anzsAXDWtZ5K2mcw80BCvcE8icDfice76lV0jTfYAA=;
        b=hiiU4k8qzznbIqoGiGzoS8AWYvOX/Ij5RDCafAUkg1WQH2KLojYvRfRAxGbtBbrt0o
         xdoz5fger1tKZ0s5fH7arLNZ1iwxR3vmsBaT4WN/yxpFYOvUqZJeZWPtN1vSCpfT7wMs
         0AD5/RpaDlG54iMhPrItxQ+gb2j0KRR/DfnZY8y2TysJX4/GGjij59GeJ/blW//YvGt+
         Scw9G5gIgCKdiORlbOk0Bi4wDwxqHekZsxToOAYKAONdwij0eD52pQm/BeaTiBiuRaPn
         mMo2znV57zo98S0j3lwQobw4U+Sgb4oqa+CWTqEay5rgUn7ZiKLLs1zQp4+CuFuKL9TA
         yizA==
X-Gm-Message-State: AOAM532EFmIWdKVS12iyyqs1B1HMkd0iHlDmfA4N3GlJ1be5st+maU/g
        9fUmRPD4NzvK8tuYyY2l/NFOymLSl9c4Ni+mJqnpW6H9t6I=
X-Google-Smtp-Source: ABdhPJy+E0/cF9nMa5aGYNVdqiPt5XHzlP8rg8uxvtC9H/Knxv9lR9jMJT25654cQYCFU37wUugHZOkb+Vlxac3CO5s=
X-Received: by 2002:a67:8bc5:: with SMTP id n188mr8094751vsd.78.1591910387709;
 Thu, 11 Jun 2020 14:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com> <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com> <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
 <20200611062648.GA2529349@kroah.com> <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
 <20200611105217.73xwkd2yczqotkyo@holly.lan> <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
 <20200611121817.narzkqf5x7cvl6hp@holly.lan>
In-Reply-To: <20200611121817.narzkqf5x7cvl6hp@holly.lan>
From:   jim.cromie@gmail.com
Date:   Thu, 11 Jun 2020 15:19:21 -0600
Message-ID: <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trimmed..

> > > Currently I think there not enough "levels" to map something like
> > > drm.debug to the new dyn dbg feature. I don't think it is intrinsic
> > > but I couldn't find the bit of the code where the 5-bit level in struct
> > > _ddebug is converted from a mask to a bit number and vice-versa.
> >
> > Here [1] is Joe's initial suggestion. But I decided that bitmask is a
> > good start for the discussion.
> >
> > I guess we can add new member uint "level" in struct _ddebug so that we
> > can cover more "levels" (types, groups).
>
> I don't think it is allocating only 5 bits that is the problem!
>
> The problem is that those 5 bits need not be encoded as a bitmask by
> dyndbg, that can simply be the category code for the message. They only
> need be converted into a mask when we compare them to the mask provided
> by the user.
>
>
> Daniel.


heres what I have in mind.  whats described here is working.
I'll send it out soon

commit 20298ec88cc2ed64269c8be7b287a24e60a5347e
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Wed Jun 10 12:55:08 2020 -0600

    dyndbg: WIP towards module->debugflags based callsite controls

    There are *lots* of ad-hoc debug printing solutions in kernel,
    this is a 1st attempt at providing a common mechanism for many of them.

    Basically, there are 2 styles of debug printing:
    - levels, with increasing verbosity, 1-10 forex
    - bits/flags, independently controlling separate groups of dprints

    This patch does bits/flags (with no distinction made yet between 2)

    API:

    - change pr_debug(...)  -->  pr_debug_typed(type_id=0, ...)
    - all existing uses have type_id=0
    - developer creates exclusive types of log messages with type_id>0
      1, 2, 3 are disjoint groups, for example: hi, mid, low

    - !!type_id is just an additional callsite selection criterion

      Qfoo() { echo module foo $* >/proc/dynamic_debug/control }
      Qfoo +p               # all groups, including default 0
      Qfoo mflags 1 +p      # only group 1
      Qfoo mflags 12 +p     # TBD[1]: groups 1 or 2
      Qfoo mflags 0 +p      # ignored atm TBD[2]
      Qfoo mflags af +p     # TBD[3]: groups a or f (10 or 15)

    so patch does:

    - add u32 debugflags to struct module. Each bit is a separate print-class.

    - add unsigned int mflags into struct ddebug_query
      mflags matched in ddebug_change

    - add unsigned int type_id:5 to struct _ddebug
      picks a single debugflag bit.  No subclass or multitype nonsense.
      nice and dense, packs with other members.
      we will have a lot of struct _ddebugs.

    - in ddebug_change()
      filter on !! module->debugflags,
      IFF query->module is given, and matches dt->mod_name
      and query->mflags is given, and bitmatches module->debugflags

    - in parse_query()
      accept new query term: mflags $arg
      populate query->mflags
      arg-type needs some attention, but basic plumbing is there

    WIP: not included:

    - pr_debug_typed( bitpos=0, ....)
      aka: pr_debug_class() or pr_debug_id()
      the bitpos is 1<<shift, allowing a single type. no ISA relations.
      this covers OP's high,mid,low case, many others

    - no way to exersize new code in ddebug_change
      need pr_debug_typed() to make a (not-null) typed callsite.
      also no way to set module->debugflags

    Im relying on:
    cdf6d00696 dynamic_debug: don't duplicate modname in ddebug_add_module

    which copies the ptr-val from module->name to dt->mod_name, which
    allowed == tests instead of strcmp.

    That equivalence and a (void*) cast in use of container_of() seem to
    do the trick to get the module, then module->debugflags.

    Notes:

    1- A query ANDs all its query terms together, so Qfoo() above
    requires both "module foo" AND all additional query terms given in $*

    But since callsite type_id creates disjoint groups, "mflags 12" is
    nonsense if it means groups 1 AND 2.  Here, 1 OR 2 is meaningful, if
    its not judged to be too confusing.

    2- im not sure what this does atm, or should do
       Qfoo mflags 0 +p      # select only untyped ? or no flags check at all ?

    3- since modflags has 32 bits, [1-9a-v] could select any single type_id
       it is succinct, but arcane.
       its a crude alphanumeric map for developers to make flags mnemonic
       maybe query keyword should be mbits
