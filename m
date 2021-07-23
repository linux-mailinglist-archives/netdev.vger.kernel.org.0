Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35483D4361
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 01:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhGWWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 18:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhGWWnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 18:43:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BEC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:23:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso4072589ybq.10
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ACK2zFOGRnTq5KCIypURS3GDVHBxYVLVyqsJJVg0FMk=;
        b=lLNcg4psUOsaKRc+CNNdYSAdADUFX3ztqdNssUg2Jxn1i3imcx9/YMFcpmS03Ns+Zw
         lrEbcrtdW7Yq5cletMp6tXk//4eq9KIgDi1l1Uog/peo6CQjLEDbC9wIjz4VSkfHKPi6
         BONAzgEG46QB1ON4Y85n574u7w2ocy4/wJdZOIEND1szbNaMnCFPzKQLmuyWcSWu0DxY
         fTqKE1FDLXYMbGgIkmpAy0toNlWpLLcEBBoT7Qwm05bSdNt0GvgcHEhc8PKfrySpcmMq
         SKzFPwHuaL/M/ZOVlcSTV7DbS6VwjwRyJk0sN9/E2yFnpHwJBJGsD4HAlsWqnNVGIl6z
         GkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ACK2zFOGRnTq5KCIypURS3GDVHBxYVLVyqsJJVg0FMk=;
        b=Ou4X1ORmVpowqvAFFw7EdAsU94a8LjUBlbEflK/oJu36/5uC2L2ibPS7WI8YAIxeR/
         8S/a/EylrZ09hcQfxPouT9FjofkrwKn5+y7/2RA3UokgKwNJY7YFIfndF7KJGaM9AE9B
         xnzLZNLh57SzYS7ljMlQHB0ek52DBpfnWrkR/am6CfAUaCK8dZxgQMxA1j95lkMsbKNb
         SnE6D0U8xcokRT+kugz3SabHPK7cEGtAhy6ccnCV9tZEh8UFDrGM6SFwOh/deW2vN/4M
         C5qxAoW0TZPAbHvFeIiPs7gP0brrLa3TFFaIBmGGI12kIkjJrRNdlN6cj+yDeoGaMcXw
         7qQA==
X-Gm-Message-State: AOAM530nUymYrmuQFe5DaPd5J8BSE+oJT9NvmDJ6Ldp8NY+b3ZGdYOyn
        Kmd/ViWzBMeA2G6rgWBW6lYa7GA=
X-Google-Smtp-Source: ABdhPJzf9DgQIK26kVbu7pPykg/NVubmu8bIChdrZgeFH9zr6i4c53MppWWXMpjUrWkzUiJDJTQS0aI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:627f:b1f:13ac:723b])
 (user=sdf job=sendgmr) by 2002:a25:30c2:: with SMTP id w185mr9411883ybw.321.1627082618018;
 Fri, 23 Jul 2021 16:23:38 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:23:35 -0700
In-Reply-To: <20210723223939.fr45rzktocvg5usw@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <YPtPd8x+XlLSSpXp@google.com>
Mime-Version: 1.0
References: <20210723002747.3668098-1-sdf@google.com> <20210723223939.fr45rzktocvg5usw@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next] bpf: increase supported cgroup storage value size
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/23, Martin KaFai Lau wrote:
> On Thu, Jul 22, 2021 at 05:27:47PM -0700, Stanislav Fomichev wrote:
> > Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> > storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's  
> align
> > max cgroup value size with the other storages.
> >
> > For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> > allocator is not happy about larger values.
> >
> > netcnt test is extended to exercise those maximum values
> > (non-percpu max size is close to, but not real max).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/local_storage.c                    | 12 +++++-
> >  tools/testing/selftests/bpf/netcnt_common.h   | 38 +++++++++++++++----
> >  .../testing/selftests/bpf/progs/netcnt_prog.c | 29 +++++++-------
> >  tools/testing/selftests/bpf/test_netcnt.c     | 25 +++++++-----
> >  4 files changed, 73 insertions(+), 31 deletions(-)
> >
> > diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> > index 7ed2a14dc0de..a276da74c20a 100644
> > --- a/kernel/bpf/local_storage.c
> > +++ b/kernel/bpf/local_storage.c
> > @@ -1,6 +1,7 @@
> >  //SPDX-License-Identifier: GPL-2.0
> >  #include <linux/bpf-cgroup.h>
> >  #include <linux/bpf.h>
> > +#include <linux/bpf_local_storage.h>
> >  #include <linux/btf.h>
> >  #include <linux/bug.h>
> >  #include <linux/filter.h>
> > @@ -284,8 +285,17 @@ static int cgroup_storage_get_next_key(struct  
> bpf_map *_map, void *key,
> >  static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
> >  {
> >  	int numa_node = bpf_map_attr_numa_node(attr);
> > +	__u32 max_value_size = PCPU_MIN_UNIT_SIZE;
> >  	struct bpf_cgroup_storage_map *map;
> >
> > +	/* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
> > +	 * is the same as other local storages.
> > +	 */
> > +	if (attr->map_type == BPF_MAP_TYPE_CGROUP_STORAGE)
> > +		max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
> > +
> > +	BUILD_BUG_ON(PCPU_MIN_UNIT_SIZE > BPF_LOCAL_STORAGE_MAX_VALUE_SIZE);
> If PCPU_MIN_UNIT_SIZE did become larger, I assume it would be bounded by
> BPF_LOCAL_STORAGE_MAX_VALUE_SIZE again?

> Instead of BUILD_BUG_ON, how about a min_t here:

> 	if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> 		max_value_size = min_t(__u32,
> 					BPF_LOCAL_STORAGE_MAX_VALUE_SIZE,
> 					PCPU_MIN_UNIT_SIZE);

Sounds like a much better idea, thanks, will incorporate into v2.
