Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF09B1BD3D8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgD2E50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbgD2E50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:57:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE1C03C1AC;
        Tue, 28 Apr 2020 21:57:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s8so474578pgq.1;
        Tue, 28 Apr 2020 21:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gLboO9EBDW2YUXCY0KsznTXEWBqbi+LP4QEnByUSR1Q=;
        b=IdC8qbz4roPvFNP4IZ8cq74K5IEA7Ctp1mUcBLB1mhP4VIIYnLEPvgjQdk84dVl5In
         SOn0wcrGyrTXGR52a64GXGA/0oKfCE/W+8gLP5aso5pOU1DeFQm3qVHnG/DPLRfmuRTt
         s47WR07JBupUByimv9Z2De1aJ9z1RJKIZFn/rITKZFgkfwWapzJ94rmUJcf5h2AUKJtG
         dgjepnDCAf04L0o4pAhMo0GcFcTid4DXCBE3DTz8qBq+H+qQnz4DqlzGfuxRIeKNVJSD
         tEYLTyhZSXY12w72SlPCPadc65l2VKyFo8mgFjSSOevnhCI1jhQ1Eyo/yzO6Vvep0LTC
         Ry5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gLboO9EBDW2YUXCY0KsznTXEWBqbi+LP4QEnByUSR1Q=;
        b=uEP1kajxzL5342WoyZqiJ8ntIkmTmKTOujPHvHiZZYXP6OfYQDkSnpDkjlMOxSCzn2
         zvMUIQvCn49iNk6z4Xc+S8bvuRPrIT9JqyNRu9gRmC49mHUO1DO0vzfSv/sJH65HWQCU
         4YHc5gUGgCctauzPHaE0afMlQ50M6EMgid8dviMwHp0G98vkOukYLJO63YkZfll2wHsl
         hBFK+KaULxSDfMedQxuvgP5YNyDiz+S7nZ9DWUI/+JRmS1ifGzMtT2VWF6AzwE3KT5bl
         M/TwYzjDi4wLqI2VVvMN+VTHOC3ZhRw8SzWVl6sQKp746Wm2GiJWSl6/HXcXSgVBfYDH
         4KlQ==
X-Gm-Message-State: AGi0PuY9qp0koZijo5QZpVV+aDU/kCvK/kiaAxa2EQxf21C7fzJlVGmt
        DsClbi1wPMObdGKC7Ls4y40=
X-Google-Smtp-Source: APiQypLK8i2VkPtvlSoHVuaUGNrmL1q3KH9URGpOiFMsFWZMf+4WObfs7pa9txYmqGfnJn5E/FG/Iw==
X-Received: by 2002:a65:4c41:: with SMTP id l1mr31343733pgr.43.1588136243924;
        Tue, 28 Apr 2020 21:57:23 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:562d])
        by smtp.gmail.com with ESMTPSA id a16sm3955969pgg.23.2020.04.28.21.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 21:57:22 -0700 (PDT)
Date:   Tue, 28 Apr 2020 21:57:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v7 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Message-ID: <20200429045720.kl737inpxduutemn@ast-mbp.dhcp.thefacebook.com>
References: <20200429035841.3959159-1-songliubraving@fb.com>
 <20200429035841.3959159-4-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429035841.3959159-4-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 08:58:41PM -0700, Song Liu wrote:
> +
> +	skel = test_enable_stats__open_and_load();
> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
> +		return;
> +
> +	stats_fd = bpf_enable_stats(BPF_STATS_RUNTIME_CNT);

Just realized that the name is wrong.
The stats are enabling run_cnt and run_time_ns.
runtime_cnt sounds like 'snark' from 'The Hunting of the Snark' :)
May be BPF_STATS_RUN_TIME ?

> +	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno)) {
> +		test_enable_stats__destroy(skel);
> +		return;
> +	}
> +
> +	err = test_enable_stats__attach(skel);
> +	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
> +		goto cleanup;
> +
> +	/* generate 100 sys_enter */
> +	for (i = 0; i < 100; i++)
> +		usleep(1);
> +
> +	test_enable_stats__detach(skel);
> +
> +	prog_fd = bpf_program__fd(skel->progs.test_enable_stats);
> +	memset(&info, 0, info_len);
> +	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> +	if (CHECK(err, "get_prog_info",
> +		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
> +		goto cleanup;
> +	if (CHECK(info.run_time_ns == 0, "check_stats_enabled",
> +		  "failed to enable run_time_ns stats\n"))
> +		goto cleanup;
> +
> +	bss_fd = bpf_map__fd(skel->maps.bss);
> +	err = bpf_map_lookup_elem(bss_fd, &zero, &count);

'count' is a global var. It's accessible directly via skeleton.
No need for map_lookup.
Even after __detach(skel) the global data is still valid.

> +	if (CHECK(err, "map_lookup_elem",
> +		  "failed map_lookup_elem for fd %d\n", bss_fd))
> +		goto cleanup;
> +
> +	CHECK(info.run_cnt != count, "check_run_cnt_valid",
> +	      "invalid run_cnt stats\n");

what happens if there are other syscalls during for(i<100) loop?
The count will still match, right?
Then why 100 ? and why usleep() at all?
test_enable_stats__attach() will generate at least one syscall.

> +
> +cleanup:
> +	test_enable_stats__destroy(skel);
> +	close(stats_fd);

May be close(stats_fd) first.
Then test_enable_stats__attach(skel); again.
Generate few more syscalls and check that 'count' incrementing,
but info.run_cnt doesnt ?
That check assumes that sysctl is off. Overkill?
