Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53801985D4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgC3Uuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:50:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43951 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbgC3Uuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:50:39 -0400
Received: by mail-lf1-f68.google.com with SMTP id n20so15399747lfl.10;
        Mon, 30 Mar 2020 13:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYSrazrfVi1jY1Prlj3p6KJda4nbRacEZEWDIYMV4oA=;
        b=lW9klCebCDpn1bUAO20Ql5Gk5m/Wz4OO+sSFnhk5aJYuvKAuay/lSd2vpxRhyZgRSt
         Jm+hL2IOUHmyvOjJCgyiHv9FWyHfC1NHWMrrKarBZl3kfuzqzLgTfcr5n69m2zAVv8n6
         qAFUxiOpzEFSy33wx7g6n6sWuA6JGtsXOJ+jtkZGHC3cYyjbxJdFIC9uttIM6jnWqF+J
         +cuAVbQquAw+mUE8FYPTv3f9hqncOEepGQfdSAHIinVaw0cFFu81eBi3FxERXm6TVb1X
         HkUQQJvTakYLqf/DfKbwNUMpPKBqIe/A58r77zdC/2wjm2tHp+AW5lCqFoA3rqHjl4BQ
         aG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYSrazrfVi1jY1Prlj3p6KJda4nbRacEZEWDIYMV4oA=;
        b=FpjYxia4jAtbnJa19pHpL9rBbLwAx/4K/Si8xhx8IiAIjPqfDyUREy2QZjxADJhj7Q
         xItRX+VmC2XpyxJ66dCD6ds35lReCpd9FTW+maK+fq4G4UbGpFFijKqrwV1ty9JGQehj
         ZCuOsUZaCTX4yAkg4WfyAFcK4fjzTHJd4AL8RHfCdynupdS3ScC6whIKPYiSASfMffSP
         L9x3VPT2K3pCIFEVyxT0+TCunGaHwV+qhghi8muGU8uatv9L7SsRAGfbytOq0y6u7dY7
         FHk4fpGDSC8mNbEURNutOOHTG1sJ0yMK52hjcE79I7jVjmKIPT2KvHoMdhy4SnR4KBo1
         hpFg==
X-Gm-Message-State: AGi0PuZFQPcKZO82JZVUIz0gelRA3zHt73wqZKbhS5kwXuyWvgtwwMXU
        8CllWUD3okqaQWniUAcheaU9jOLuKOyy5F3glOs=
X-Google-Smtp-Source: APiQypKNNr0rzth6W/dHNg93lr6pPrWVPHa3W5s6961t6EjWJySqIb6CGgfm2WNfTKAXaYsuPzJ6ict+vIi/mB9g1BI=
X-Received: by 2002:ac2:4191:: with SMTP id z17mr8999905lfh.73.1585601437132;
 Mon, 30 Mar 2020 13:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com> <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
In-Reply-To: <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Mar 2020 13:50:25 -0700
Message-ID: <CAADnVQ+rg=hcxg0ZwV62bKk5ji8jYHEPZ1B2Y-Ouk_ANx=K11A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 1:46 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/30/20 2:20 PM, Andrii Nakryiko wrote:
> >> The observability piece should go in the same release as the feature.
> > You mean LINK_QUERY command I mentioned before? Yes, I'm working on
> > adding it next, regardless if this patch set goes in right now or
> > later.
>
> There was also mention of a "human override" details of which have not
> been discussed. Since the query is not ready either, then the
> create/update should wait so that all of it can be in the same kernel
> release. As it stands it is a half-baked feature.

"human override" was discussed only in the context of xdp.
There won't be override for cgroup-bpf.
Just like one doesn't exist today and there is no need for it.
There will be no override for clsbpf either.
None of the multi prog hooks need it.
