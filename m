Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567BD27F291
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgI3T0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3T0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:26:51 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E59C061755;
        Wed, 30 Sep 2020 12:26:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id p21so45822pju.0;
        Wed, 30 Sep 2020 12:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FvgCO40CVKe5gFglLc4kgPCPyIA7toxlMSbqo9V3nFw=;
        b=YgCHtskmuGEloUlw0SHLFmhoOs5pP0pMK3Xrq1RZE+Tm0reuWwkSxIBDqhxQ+xHVV/
         rt2SNedlNgzgsFkLTa9cqikbePpJlVywVTPpHlM0IjlCWqWwSESyY5vY3WN7PPs+yQKF
         VkSOClw28bq0YQvigDNt7J4khX/VqM4kqBCKzxFtzZWYkb1AHJFY0WA7m/vJc+2Uko6h
         dmaomuUcXw+DBTzfpyOy7DuEVxH2914zkMBG1x+FZesA7dzEJ2ABIoOnK/3ePM/9ucpQ
         RFFEdXxHViegl2UD2hLWYqmjym4q3N94wukhfH14GaE3TXhvf0sACDuu4pAVmeZR6PVR
         zKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FvgCO40CVKe5gFglLc4kgPCPyIA7toxlMSbqo9V3nFw=;
        b=qslWAbJvYoUI0mfDPE5mHExLvwhu4g7pJxWEHovn9Q6fMNsqQDqMZzRn8BLx1bSOZt
         DUSra5HmOjdEhs1xKjdCiITixxXh33N3g3I0an+vE+2tQkWsYtPupuXtykNLiYxWWwwq
         wrnuNsYAISq0P52GDiBVwIcRaL4V35E1teiIqfnScS/7rrHsQsg5Jl0OhIxauzo+EY/v
         6vRe5MxukULihXNS+83GM696WEFY4f5SaJ2veDJu7yKqZcXF61+2B3Cxk0m4X9t008pc
         BU9orXTkktaqETWHXEsEr0mjhvGCaGql3kj0ttNtIhOcEP/G54luegWz58YKJqNqjGg8
         uhzg==
X-Gm-Message-State: AOAM531I8UP1PH1Yqjyl/Tfi3XcbJ7AIlJd4axVpSfhRMFso8DMl053/
        du3Hq1QfqmqvMQyXObUD8FU=
X-Google-Smtp-Source: ABdhPJzcHNYWcrD0DF3lRquNxeb9fl+ZeYD9CacSH7El998/y6zmRzxV9g3QuIkw8+aSbKpvaLcy/Q==
X-Received: by 2002:a17:90b:515:: with SMTP id r21mr3814953pjz.115.1601494010493;
        Wed, 30 Sep 2020 12:26:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2a2])
        by smtp.gmail.com with ESMTPSA id q18sm3457908pfg.158.2020.09.30.12.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 12:26:49 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:26:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org
Subject: Re: [PATCH v3 bpf-next 2/2] selftests/bpf: add tests for
 BPF_F_PRESERVE_ELEMS
Message-ID: <20200930192647.mgunvnxzb5mmxae7@ast-mbp.dhcp.thefacebook.com>
References: <20200930152058.167985-1-songliubraving@fb.com>
 <20200930152058.167985-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930152058.167985-3-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:20:58AM -0700, Song Liu wrote:
> diff --git a/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
> new file mode 100644
> index 0000000000000..dc77e406de41f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_pe_preserve_elems.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
> +#include "vmlinux.h"

Does it actually need vmlinux.h ?
Just checking to make sure it compiles on older kernels.

> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +} array_1 SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +	__uint(map_flags, BPF_F_PRESERVE_ELEMS);
> +} array_2 SEC(".maps");
> +
> +SEC("raw_tp/sched_switch")
> +int BPF_PROG(read_array_1)
> +{
> +	struct bpf_perf_event_value val;
> +	long ret;
> +
> +	ret = bpf_perf_event_read_value(&array_1, 0, &val, sizeof(val));
> +	bpf_printk("read_array_1 returns %ld", ret);
> +	return ret;
> +}
> +
> +SEC("raw_tp/task_rename")
> +int BPF_PROG(read_array_2)
> +{
> +	struct bpf_perf_event_value val;
> +	long ret;
> +
> +	ret = bpf_perf_event_read_value(&array_2, 0, &val, sizeof(val));
> +	bpf_printk("read_array_2 returns %ld", ret);

Please remove printk from the tests. It only spams the trace_pipe.

> +	return ret;

The return code is already checked as far as I can see.
That's enough to pass/fail the test, right?
