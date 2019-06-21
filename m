Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C87F4DF7E
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfFUEFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:05:49 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42255 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfFUEFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:05:48 -0400
Received: by mail-qk1-f193.google.com with SMTP id b18so3477666qkc.9;
        Thu, 20 Jun 2019 21:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6YmRrujmQ4lsaMmeiMiJdmMPnCKf9eM+r6csPeOuwgI=;
        b=GV1BeA9CqHRlwnHcaNufk7UyhjRwrqLv9yckpZCmBQVyvcCc/WAYvbi4ju0L94QNfu
         fH4/uiY+253kME+bQRCLKrQh4yUWD5fblBWJkezZXcaaxPIukVRInFPJyb5SQ701NnK2
         KLEJyjvUAZln42bFRae9L3iFiCR2s3ovv8aYPhnVVYYxD3z75b1b0ydnRfcXWyHpLRm1
         JY+E+9xf94ZdhoHjCJd/wq/jmSrI0myC26K7GjDPuTI2Kqn1ixHMgKtowZBFHHWyEGYD
         /ANTmAHq6KEH6Agl8Yj0f6aQ6DzhDcT8IDgUjaCPvTtLLPHUEieRObqaDUvXsRyB/Hox
         OsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6YmRrujmQ4lsaMmeiMiJdmMPnCKf9eM+r6csPeOuwgI=;
        b=NFyygKTvf0kjPtQFvXmCqrJH9C9OjLf5Xr5TZ5lXYNtKX3PPGa5rWrETjvGLMN3Y4V
         ly4aVpixayBECFB+RjJUT+in0F80LBV0QYbPZghYXebmxs7JmS6e3zyqx+J5xfo2jlxr
         prjR/0JklXyVPWwPBXXz72/zjr+9SAUcpfCnHgjh998ZQsu6ReVqG8FKFwWZPNRRh1cD
         t4ahQGfJkt9fU/We3FqwdO6Gk87NRpTujTa2ntBJrkHDf552+pw5gc7f2bO5gPWDordI
         QNylrE3QeUgNh7qTlJVxRDAVIFldZuetNv6hnCn76AMtgSRH3qKDglvfzH2dQ6DewHfy
         Zjig==
X-Gm-Message-State: APjAAAXy3qtocCowE3fXwWvhaRfZjvwuY+Dj1mcaJJzdft3z8glz1djd
        UHTcH6ceATvXe+kjdFtc1EsWazg1DNRGPaC5AzA=
X-Google-Smtp-Source: APXvYqwWP0hNCZUg9/nJ262moGsFzJfG+Ay6PyIgdB1jt8vK0CVxOg7pv2Q0VRkiPnUr8XM/HPg/OtWfRDzsG7552rI=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr2421821qkj.39.1561089947171;
 Thu, 20 Jun 2019 21:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
 <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com>
 <CACAyw9_Yr=pmvCRYsVHoQBrH7qBwmcaXZezmqafwJTxaCmDf6A@mail.gmail.com>
 <CAEf4Bzbpm0pSvXU8gfSTL2xECTDb+Z9HKKO2Y-Ap=L6VTWL9MQ@mail.gmail.com> <CACAyw98hwj5hpT00P5JiW3V+QPdyddKfN_yQj=okXvg89eTgsA@mail.gmail.com>
In-Reply-To: <CACAyw98hwj5hpT00P5JiW3V+QPdyddKfN_yQj=okXvg89eTgsA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:05:35 -0700
Message-ID: <CAEf4BzYMAkXVobfWppMtF1d9c_vSFFHEoXC8MdZPq-OXFrMzLA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 2:28 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Mon, 17 Jun 2019 at 22:00, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > In my mind, BPF loaders should be able to pass through BTF to the kernel
> > > as a binary blob as much as possible. That's why I want the format to
> > > be "self describing". Compatibility then becomes a question of: what
> > > feature are you using on which kernel. The kernel itself can then still be
> > > strict-by-default or what have you.
> >
> > That would work in ideal world, where kernel is updated frequently
> > (and BTF is self-describing, which it is not). In practice, though,
> > libbpf is far more up-to-date and lends its hand on "sanitizing" .BTF
> > from kernel-unsupported features (so far we manage to pull this off
> > very reasonably). If you have a good proposal how to make .BTF
> > self-describing, that would be great!
>
> I think sanitizing is going to become a problem, but we've been around
> that argument a few times :)

Yep :)

>
> Making .BTF self describing need at least adding length to certain fields,
> as I mentioned in another thread. Plus an interface to interrogate the
> kernel about a loaded BTF blob.
>
> > > I agree with you, the syntax probably has to be different. I'd just like it to
> > > differ by more than a "*" in the struct definition, because that is too small
> > > to notice.
> >
> > So let's lay out how it will be done in practice:
> >
> > 1. Simple map w/ custom key/value
> >
> > struct my_key { ... };
> > struct my_value { ... };
> >
> > struct {
> >     __u32 type;
> >     __u32 max_entries;
> >     struct my_key *key;
> >     struct my_value *value;
> > } my_simple_map BPF_MAP = {
> >     .type = BPF_MAP_TYPE_ARRAY,
> >     .max_entries = 16,
> > };
> >
> > 2. Now map-in-map:
> >
> > struct {
> >     __u32 type;
> >     __u32 max_entries;
> >     struct my_key *key;
> >     struct {
> >         __u32 type;
> >         __u32 max_entries;
> >         __u64 *key;
> >         struct my_value *value;
> >     } value;
> > } my_map_in_map BPF_MAP = {
> >     .type = BPF_MAP_TYPE_HASH_OF_MAPS,
> >     .max_entries = 16,
> >     .value = {
> >         .type = BPF_MAP_TYPE_ARRAY,
> >         .max_entries = 100,
> >     },
> > };
> >
> > It's clearly hard to misinterpret inner map definition for a custom
> > anonymous struct type, right?
>
> That's not what I'm concerned about. My point is: sometimes you
> have to use a pointer, sometimes you don't. Every user has to learn this.
> Chance is, they'll probably get it wrong first. Is there a way to give a
> reasonable error message for this?

Right now pointer is always required. My initial intent for map-in-map
was to not use pointer, but since then I've proposed a slightly
different approach, which eliminates all these concerns you mentioned.
As for messaging, yeah, that the simplest part, which can always be
improved.

>
> > > I kind of assumed that BTF support for those maps would at some point
> > > appear, maybe I should have checked that.
> >
> > It will. Current situation with maps not supporting specifying BTF for
> > key and/or value looks more like a bug, than feature and we should fix
> > that. But even if we fix it today, kernels are updated much slower
> > than libbpf, so by not supporting key_size/value_size, we force people
> > to get stuck with legacy bpf_map_def for a really long time.
>
> OK.
>
> I'll go and look at the newest revision of the patch set now :o)
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
