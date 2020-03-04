Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36A178F11
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbgCDK7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:59:41 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44372 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387792AbgCDK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:59:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id n7so1799274wrt.11
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5+lxMHSrWpaZWIvGG7ROz8dnvJme1icgxoGYCvDIO5o=;
        b=tFj+U53tyfluwcxiziZWLUcNqlVMhQ2WzhZZs4lRVdFUAiCzSnTZiXaRFs2y/1nY+k
         zWLgQ2iWenV9WSRUhT5oRpmSH2d7QVPeG/hMZGCuEWsT48VY5tD0mpvYb2ZNH9kzPhLa
         lfs+YeiQthX8hg9UnSgCD84yoh22LZ9WPSNHcfl27pTKQTVI5K0C+rrrgi8NmEcmvg2r
         JqRZHlbo8UfGIBdeRdngcmrlxJC97UwphxdMWq4c2+ih8KjRk7hNJx103UpFE3gPhWtf
         O6MUZduDct1sikoTC5sQm7D8AEftNdxD+AC0xLg0e06Nurq3C48AHowlnkw70CNyjaVZ
         zpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5+lxMHSrWpaZWIvGG7ROz8dnvJme1icgxoGYCvDIO5o=;
        b=tErE1yzlqqcaW2hc+c00gbQxYjs/eEwmGlINKMPsmRJKWii2nhDE4wBLk63WeTEn21
         zrCyMu3R4qVRDhXZiSXaIE7ypXe55Ne58eWqR2iF3Pnm57/bitOjcUl9O7FUg+vLadgY
         usbXlp85udvwImD6AXo1VJkZef4lejyG4vBtxoWo9p+zrkqLEaFRyT+E/yaDlmiDCj5v
         rUyAACYWwZcW3tZhR6crVNVl3cNWzObdPjlAHkaJVqDGxS/RTRLy4H815+dmXHW9Txuc
         X9jt1d+71ZM4p1pQ05gmTywfY3Of1hAnyhAKv+Bn5tuTKIETiSG55jDnB8W5I1UYasM+
         79Uw==
X-Gm-Message-State: ANhLgQ3rOYGnuwmxN7ftuRc06tPAwqb5CUss55KwUVnGS85lE+XOgCgQ
        GC3cmKU/k4QO7+6MXgdq8Ca4GA==
X-Google-Smtp-Source: ADFU+vvGUvigrXWW0Y6f/jajpdZLo8/9UR4q3nv8vYKYYhgqGiiWKEx1uaPMjgrqoS3UhJ1roztFOw==
X-Received: by 2002:a5d:5188:: with SMTP id k8mr3532426wrv.265.1583319576860;
        Wed, 04 Mar 2020 02:59:36 -0800 (PST)
Received: from [192.168.1.10] ([194.35.118.106])
        by smtp.gmail.com with ESMTPSA id i1sm17823667wrs.18.2020.03.04.02.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 02:59:36 -0800 (PST)
Subject: Re: [PATCH v3 bpf-next 1/3] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200303195555.1309028-1-songliubraving@fb.com>
 <20200303195555.1309028-2-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <0140e565-55c0-7025-dfbb-88f644532c6a@isovalent.com>
Date:   Wed, 4 Mar 2020 10:59:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303195555.1309028-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-03 11:55 UTC-0800 ~ Song Liu <songliubraving@fb.com>
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>   ./bpftool prog profile id 337 duration 3 cycles instructions llc_misses
> 
>         4228 run_cnt
>      3403698 cycles                                              (84.08%)
>      3525294 instructions   #  1.04 insn per cycle               (84.05%)
>           13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
> 
> This command measures cycles and instructions for BPF program with id
> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
> output is similar to perf-stat. In this example, the counters were only
> counting ~84% of the time because of time multiplexing of perf counters.
> 
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticeable errors to
> the measurement results.
> 
> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
> build bpftool twice. The first time _bpftool is built without skeletons.
> Then, _bpftool is used to generate the skeletons. The second time, bpftool
> is built with skeletons.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Hi Song, thank you for all the changes! Just found a couple more things
below, sorry I missed them on the v2.

[...]

> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c

[...]

> +static int profile_open_perf_events(struct profiler_bpf *obj)
> +{
> +	unsigned int cpu, m;
> +	int map_fd, pmu_fd;
> +
> +	profile_perf_events = calloc(
> +		sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
> +	if (!profile_perf_events) {
> +		p_err("failed to allocate memory for perf_event array: %s",
> +		      strerror(errno));
> +		return -1;
> +	}
> +	map_fd = bpf_map__fd(obj->maps.events);
> +	if (map_fd < 0) {
> +		p_err("failed to get fd for events map");
> +		return -1;
> +	}
> +
> +	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
> +		if (!metrics[m].selected)
> +			continue;
> +		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
> +			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
> +					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
> +			if (pmu_fd < 0 ||
> +			    bpf_map_update_elem(map_fd, &profile_perf_event_cnt,
> +						&pmu_fd, BPF_ANY) ||
> +			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
> +				p_err("failed to create event %s on cpu %d",
> +				      metrics[m].name, cpu);
> +				goto err;

You can probably simply return here...

> +			}
> +			profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
> +		}
> +	}
> +	return 0;
> +err:
> +	profile_close_perf_events(profile_obj);
> +	return -1;

... and remove the "err:" label here, because if I understand correctly
the only call to profile_open_perf_events() is in do_profile() (below),
and if it fails, "profile_close_perf_events(profile_obj);" is called there.

> +}

[...]

> +static int do_profile(int argc, char **argv)
> +{

[...]

> +	err = profile_open_perf_events(profile_obj);
> +	if (err) {
> +		p_err("failed to open perf events");

Also do you think we can remove this p_err() (or move the text in
profile_open_perf_events() error messages)? This is because
profile_open_perf_events() already prints something if it fails, and
error messages work best with JSON if there is just one at a time.

Would also apply to profile_target_name() a few lines above.

> +		goto out;
> +	}
> +
> +	err = profiler_bpf__attach(profile_obj);
> +	if (err) {
> +		p_err("failed to attach profile_obj");
> +		goto out;
> +	}
> +	signal(SIGINT, int_exit);
> +
> +	sleep(duration);
> +	profile_print_and_cleanup();
> +	return 0;
> +
> +out:
> +	profile_close_perf_events(profile_obj);
> +	if (profile_obj)
> +		profiler_bpf__destroy(profile_obj);
> +	close(profile_tgt_fd);
> +	free(profile_tgt_name);
> +	return err;
> +}
