Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA5B4351DE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJTRtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhJTRtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:49:03 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA5AC061753;
        Wed, 20 Oct 2021 10:46:38 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id v195so12636405ybb.0;
        Wed, 20 Oct 2021 10:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOKBPHMdWljkZNSIDrjUwmzeBvLMb2d21VbPwWacTgM=;
        b=fuvYz9EiYxo+eAIB8lLKMZjoVGkpQhjptDXD7t+bH2LGHwLxNuORBHqD1+aGki/29m
         i3EKQZOhqRpXiuRC2Zm4sQYgBCuMPwBm1dGN9n3MkQ0A6YJEq8sWqdKlhju3FghSEFGL
         vTuPceVxHo5Lm2sX5h9jQYrUb9Kop382Wa5/dGGHRc5Hbc9Qvs7IiN8Hg3IAXjkuRijt
         eWd5+ACFNktNe7+DxVYf7BPTXZLRLOfuWIzS3JTFiG8+PieISTfdQwSzv6n+nG57DE8x
         uGo/A1znriTj0fcp2Mj2omTwSp+zw+BxxnpGAwxgkLwlfpvTYoRM0G/H3ZUNFpczG821
         k45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOKBPHMdWljkZNSIDrjUwmzeBvLMb2d21VbPwWacTgM=;
        b=LCXhYdW/BbswA7D2CBUMj0q71PSPQ4q5tl+fhj+STUnb5nBiB25crKtM9R68uE8t+6
         chqHxav8kK7lqyGfFhDWW2t0Ueqd3XcQFve4ZYpMYIGXZE7g3SCQ8KLhWcmtyI8N8H+b
         8FrsY7lCyNHTflthQeXdJn3/1NsQACX4OKIhCzggpG6VluhABjK52pzySomhc4ST8I4Q
         aNNVv3xEXg/kb3M1kzPWO1thWnAxnBpL6rbwaQstnCNHQ77LqU3XuwlEWWcjmVag3ZtO
         QAoGchDjNDrEcmmO0pAc0oUs/7uk6sA+5TELhyVxKqstkVc2ftgePdd3fTwaY2+p6hC+
         KnRA==
X-Gm-Message-State: AOAM530tVnpEtXYMSnovegjjgF+uzJaPmHwBA0SDi+SmV6wP9SfF83cJ
        aZ395Lj5526hUs8500TtLvBOG1LPNXjTlRtKFZk=
X-Google-Smtp-Source: ABdhPJy1/YWZivJtSDC696TGHVh7c8JDcR90h3/DoB2Lt5zT45YYfw4swcV8w8OngSAn2svPXmcGkpXF4IMshFTPFB0=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr444609ybf.455.1634751998190;
 Wed, 20 Oct 2021 10:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211012023231.19911-1-wanjiabing@vivo.com> <616d9ba173075_1eb12088b@john-XPS-13-9370.notmuch>
In-Reply-To: <616d9ba173075_1eb12088b@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 10:46:27 -0700
Message-ID: <CAEf4BzaAmvoT-n8pusycm_q1-Tp4B+KMxu3yw1BXkM3xHY2-HQ@mail.gmail.com>
Subject: Re: [PATCH] [v2] selftests: bpf: Remove duplicated include in cgroup_helpers
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Wan Jiabing <wanjiabing@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kael_w@yeah.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 9:07 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Wan Jiabing wrote:
> > Fix following checkincludes.pl warning:
> > ./scripts/checkincludes.pl tools/testing/selftests/bpf/cgroup_helpers.c
> > tools/testing/selftests/bpf/cgroup_helpers.c: unistd.h is included more
> > than once.
> >
> > Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> > ---
> > Changelog:
> > v2:
> > - Fix the commit description.
> > ---
>
> The Subject is a bit unusual. Typically it would be something like,
>
>  "[PATCH bpf-next] selftests, remove duplicated include in cgroup_helpers"

Also for selftests we use "selftests/bpf: " prefix (at least we
generally try, for consistency). Fixed up, applied to bpf-next.
Thanks.

>
> For the actual patch though LGTM.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
