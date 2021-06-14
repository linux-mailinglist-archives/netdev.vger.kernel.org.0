Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E353A5FE5
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 12:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhFNKWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 06:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhFNKWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 06:22:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A95C061574;
        Mon, 14 Jun 2021 03:20:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i34so8228412pgl.9;
        Mon, 14 Jun 2021 03:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0wdxFoyZhLUQIgeRMpuNtUz23AzX1EH+9KJWYMAQ0uI=;
        b=XoIYGwnhli0plkGuRxzN71a/gQhaLEVXp5a+dNmDUf5sUUKqXht1uqDMrLO5Ur+b4r
         y6/52Bvg49tmuoFcn8qSc07o0IDFxCR8CC96W5lOx2f4FJMeODik2XpVAznEKY6NB7+g
         Fnf1r9K1rQPCvnIxFgjHSm8VFd6fiGJ+tlN1QI5AEkPwWw3uQLyR3HHGH4n3PlhVEFJR
         +i/YafzcL1lar9SRQPIwH/UmxrQ4MMqyP9b3oUj7A2Sdc+U/c0VKMVZBXOif8PesHJtn
         BYbjuyat79i6YITMgORavh1UCEXlbHXut5oCWwXIL24sWhjRmI4UF93+YE3CjDGm37KZ
         c7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0wdxFoyZhLUQIgeRMpuNtUz23AzX1EH+9KJWYMAQ0uI=;
        b=l+dQM7WVM3ALgp5drZDV9SXI/Rp4y9xmmlCB9W/mrPctuF4qs650I3dRjxr3P0t8z3
         IdZ4VDxqYzuSEPEFjVvDzeEk6IRkzxIBwumFpF8KrrxMD6k53lwe2F4rf0gcguTpEurH
         pWbcaGZ+pSqtdScsI6G+TojURI1/RpaPHQB4C0yEuGbPtfhuZILlIkeSwAdqXkhe7WYE
         +hp2GSZ0AQgYJmh8lDJO4lSB/mX0Li9kpDGH/sbIJt8NOn6b375fvqPlx458cu3CO0V/
         2EDiWKwjyl1g6LhaQToA5Cj7ATucLXTnv7uG3DosV3L9i9/Cxq1DA8EsHZQshuoeIQyk
         MyzQ==
X-Gm-Message-State: AOAM530LhxxId1dm43F3P7oTxXKm62+xbag5LK5d0LnJ2T88Sr+CWDf6
        NKPwcf9AAC8CqNjTkpYVa5Q=
X-Google-Smtp-Source: ABdhPJyalE1XBeOi9j6VjUVRoQbj1R8H0xsP7LTF345m03pMm4KI2gZt1F6NPuqyQILK7jhXxM8iAA==
X-Received: by 2002:aa7:9af6:0:b029:2e9:dfed:6a59 with SMTP id y22-20020aa79af60000b02902e9dfed6a59mr20900390pfp.37.1623666004507;
        Mon, 14 Jun 2021 03:20:04 -0700 (PDT)
Received: from localhost ([2402:3a80:11da:e842:a475:28cf:d9ad:7d88])
        by smtp.gmail.com with ESMTPSA id k136sm12494207pfd.87.2021.06.14.03.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 03:20:04 -0700 (PDT)
Date:   Mon, 14 Jun 2021 15:48:44 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yaniv Agman <yanivagman@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, toke@redhat.com
Subject: Re: [PATCH bpf-next 0/3] Fixes for TC-BPF series
Message-ID: <20210614101844.4jgq6sh7vodgxojj@apollo>
References: <CAMy7=ZUXRJni3uUVWkWFu8Dkc5XCVsM54i_iLDwHQ5Y0Z3inJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy7=ZUXRJni3uUVWkWFu8Dkc5XCVsM54i_iLDwHQ5Y0Z3inJw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:02:07PM IST, Yaniv Agman wrote:
> Hi Kartikeya,
>
> I recently started experimenting with the new tc-bpf API (which is
> great, many thanks!) and I wanted to share a potential problem I
> found.
> I'm using this "Fixes for TC-BPF series" thread to write about it, but
> it is not directly related to this patch set.
>
> According to the API summary given in
> https://lore.kernel.org/bpf/20210512103451.989420-3-memxor@gmail.com/,
> "It is advised that if the qdisc is operated on by many programs,
> then the program at least check that there are no other existing
> filters before deleting the clsact qdisc."
> In the example given, one should:
>
> /* set opts as NULL, as we're not really interested in
> * getting any info for a particular filter, but just
> * detecting its presence.
> */
> r = bpf_tc_query(&hook, NULL);
>

Yes, at some revision this worked, but then we changed it to not allow passing
opts as NULL and I forgot to remove the snippet from the commit message. Sorry
for that, but now it's buried in the git history forever :/. Mea Culpa.

> However, following in this summary, where bpf_tc_query is described,
> it is written that the opts argument cannot be NULL.
> And indeed, when I tried to use the example above, an error (EINVAL)
> was returned (as expected?)
>
> Am I missing something?
>

You are correct. We could do a few thing things:

1. Add a separate documentation file that correctly describes things (everything
minus that para).
2. Support passing NULL to just detect presence of filters at a hook.
3. Add a multi query API that dumps all filters.

Regardless of what we choose here, it will still be racy to clean up the qdisc a
program installs itself, as there is a small race (but a race nonetheless)
between checking of installed filters and removing the qdisc.

I will discuss this today in the TC meeting to find some proper solution instead
of the current hack. For now it would probably be best to leave it around I
guess, though that does entail a small performance impact (due to enabling the
sch_handle_{ingress,egress} static key).

--
Kartikeya
