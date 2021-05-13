Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3631037F2F0
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhEMGYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhEMGYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 02:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6ED0613DE;
        Thu, 13 May 2021 06:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620886980;
        bh=FyrJgotOWLVRBsH3NkASUT7jP+Bize/BSx+wutxlJyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DIyQOk4dcuIAJndiSbcJfiMtBMAClX5sOIi9h6vtp7itFDMGVt7WYvntj7BWtlcIy
         BI4IcnZUUf3fKQV1pju6sQ3YvAB0hj0+Mr6+MhTyX77Eg3I03IiuWPWwBAkqib40CL
         ctjgKe+1ZmXViDUtTtiZSsEHv3IBlfy8p5chjuvtkD8HQENwT8Int+ijysbZe2YgB5
         AYg3zDmona6Zrh3kAvdwJVl/20rwc/1s5kJcZRPMhaWwANdYqQ4KSHVsIZDaf56uM/
         84B1dx8exFQ1x8jSC+489+FP3MQYn20B7UIEuoS0d6BuNlLE0Y9bl+4oVHwq5NSThn
         7WM/r/8NetrEQ==
Date:   Thu, 13 May 2021 09:22:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
Message-ID: <YJzFwKCRoFibZdWD@unreal>
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
 <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
 <YJoRd4reWa1viW76@unreal>
 <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
 <f82343ec-9d67-d033-dd07-813e7d981c4f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f82343ec-9d67-d033-dd07-813e7d981c4f@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 10:14:00AM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2021/5/13 3:02, Andrii Nakryiko wrote:
> > On Mon, May 10, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
> >>
> >> On Mon, May 10, 2021 at 11:00:29AM -0700, Andrii Nakryiko wrote:
> >>> On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> >>>>
> >>>> The result of an expression consisting of a single relational operator is
> >>>> already of the bool type and does not need to be evaluated explicitly.
> >>>>
> >>>> No functional change.
> >>>>
> >>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> >>>> ---
> >>>
> >>> See [0] and [1].
> >>>
> >>>   [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
> >>>   [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/
> >>
> >> How long do you plan to fight with such patches?
> > 
> > As long as necessary. There are better ways to contribute to libbpf
> > than doing cosmetic changes to the perfectly correct code.
> 
> No small stream, no river and sea.
> 
> There are no improvements to functionality, but may slightly speed up compilation.
> With more such accumulations, it is possible that the compilation of allmodconfig
> results in a second-level improvement.

Unlikely with modern CPUs.

> 
> I don't know if you agree, at least I think so.
> 
> > 
> >>
> >> Thanks
> >>
> >>>
> >>>>  tools/lib/bpf/libbpf.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>>> index e2a3cf4378140f2..fa02213c451f4d2 100644
> >>>> --- a/tools/lib/bpf/libbpf.c
> >>>> +++ b/tools/lib/bpf/libbpf.c
> >>>> @@ -1504,7 +1504,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> >>>>                                 ext->name, value);
> >>>>                         return -EINVAL;
> >>>>                 }
> >>>> -               *(bool *)ext_val = value == 'y' ? true : false;
> >>>> +               *(bool *)ext_val = value == 'y';
> >>>>                 break;
> >>>>         case KCFG_TRISTATE:
> >>>>                 if (value == 'y')
> >>>> --
> >>>> 2.26.0.106.g9fadedd
> >>>>
> >>>>
> > 
> > .
> > 
> 
