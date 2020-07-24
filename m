Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898AD22BD84
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGXFc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGXFcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:32:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8836AC0619D3;
        Thu, 23 Jul 2020 22:32:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z3so4456566pfn.12;
        Thu, 23 Jul 2020 22:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gw6qwe9hZyk10sI0UvBBcocF5vy86tjSPTY0BqZ8UQM=;
        b=rqxeQur2k0IeMSKNTQeqgntS1E57Ho2o2CSzw5WpKaGO/T2adV5GKLcB9I9JvtpItZ
         EFX+qA+gpwYXw92ikKCi9AhBJM6VhzC8WxHpz+6WbSIwXJKH2OKF8HVHlsad+17f0ZNr
         SmnxqJXXZiUnU15UFzWXvWDuJD5tFEu4iejire+UAFmrJID9IlbYdP9ilE1ewJqstC41
         0tzNhlpP4qddxvlqKreJ7HyQ4Uu5VwgmLaYCaL5w9gA1XGM63Wt4Lm4cgyc/Dt+NVZAg
         0qGcfMHMM7vuzQjqIBWJ5ghz195TTWBVteHBJMCEyv/57+muZ5A0sMdimO+Z/tMs+9fB
         L1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gw6qwe9hZyk10sI0UvBBcocF5vy86tjSPTY0BqZ8UQM=;
        b=ftmKv4iUSfTinUicge/LzJuxwdNxLu+lSh5SZmOeQiYdnfzz+YKG7AYJzqPwMnpia5
         bIugoQ4HQcJXnS6REW1JnftN1ioc9ttwBP8d8x4cwRGScNc7QoYww2lnVrMkpFvSFrHC
         CQw0BD1RomYefj4R+GYyZbXkv0LQRYSPCTkVPnWGp2Xho+8IIBJqY/0ihmbC6C4ZKKG0
         ZvBkvokKjvqm88iiZnVwZ19Q7v+6vs/wD5hU/vmHCh0NBGHk4/z2pG9TeK1bmlH3zFbG
         yRMy3fjK4Bc4RObp2JY3BpTKNsOHbueam9F+45nNNeotMIKbwJtvklthxyv+zu2/WDgg
         Ze6Q==
X-Gm-Message-State: AOAM531r7cS2osUx1Fy76zaCg+cPPSFQ49Ak1Sxp6KZoM0LLXa48o94w
        6YgWKhtWR0Kipl2W8HOQCkQ=
X-Google-Smtp-Source: ABdhPJweosQbkxclrfGxb4N8JekqfS6yj6Tlb2CmEm598P9mmNEPJw/0bIQEuC6fXLYR3rOeStNnjA==
X-Received: by 2002:a63:4d3:: with SMTP id 202mr7279457pge.14.1595568743717;
        Thu, 23 Jul 2020 22:32:23 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:dfa8])
        by smtp.gmail.com with ESMTPSA id m20sm4832686pgn.62.2020.07.23.22.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 22:32:22 -0700 (PDT)
Date:   Thu, 23 Jul 2020 22:32:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        brouer@redhat.com, peterz@infradead.org
Subject: Re: [PATCH v5 bpf-next 5/5] selftests/bpf: add
 get_stackid_cannot_attach
Message-ID: <20200724053220.dtega3r7i3jewgxx@ast-mbp.dhcp.thefacebook.com>
References: <20200723180648.1429892-1-songliubraving@fb.com>
 <20200723180648.1429892-6-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723180648.1429892-6-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:06:48AM -0700, Song Liu wrote:
> +	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
> +			 0 /* cpu 0 */, -1 /* group id */,
> +			 0 /* flags */);
> +	if (pmu_fd < 0 && errno == ENOENT) {
> +		printf("%s:SKIP:cannot open PERF_COUNT_HW_CPU_CYCLES with precise_ip > 0\n",
> +		       __func__);
> +		test__skip();
> +		goto cleanup;
> +	}

That wasn't enough in my test VM.
I've changed it to be: (errno == ENOENT || errno == EOPNOTSUPP)
and applied the set.
Thanks
