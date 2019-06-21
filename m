Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A7E4DE02
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfFUAIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:08:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40575 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfFUAIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:08:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so2575216pfp.7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CtcKIxOBJDXb1YMFFIKUvp1vj9xeUODj/cxc0fShO6E=;
        b=JR+vY5ckPMpLQTFRWE+dKEzucxSXr3U8cKh2SX70QW3oRIM5NQiQofHAHaqUcUin/w
         JWhBfabLkE8q1TKlsVYB7wWIsp+xECyB/2hX0EEyvOZZNs9PDszBZSDS+ReRDNALQBmX
         q+KICZEeoSs1v/HyBbxrlsS2b/tCrRCrmXcxFalgJs3mYr59KHQ+jEoQaaN6KgvVO2nJ
         3PwCrM2LCwjPw2DLEO8rW+XihvpTWn9t2mdW1x4dpMJlDQF4Eo9vTKFYVLp/AaJw7WP5
         M2RJ+xEui2m2Dc+LFRosM0LAyBGzfatBskHXexbDLX/k+LXmyRcAHgCyn4UkSXoGhs9i
         VY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CtcKIxOBJDXb1YMFFIKUvp1vj9xeUODj/cxc0fShO6E=;
        b=ubv6gNfUOhx6VFAsy/xT1f2Ht8vDq9yLS1WOwErcoy8k/y5e7ZjlEjjfQvzVkN5rYt
         x2Z6SLjqfNqyULmhMfZEgH/w56dDyGe1amwb6E85V9cnCFOc0z1EyRtonGEK/R4Pte9v
         Wn8RieF/ThaSQGmecdwDrZ3UZkqKTUaE3ZWWh/vfQ14smgnMR0fEHhAg/hSsgio3DdyQ
         FsFTFNt4hJrAzUBvLmsoCNtZe5t+u3JlGvCfsyiw40dqE2U8mNNJt4Bu7PrYTNU+0lyE
         hF/WqsSwKDTTJok2Gbap0ZEDbaaIPa/EyGQpjnliTgCmEwDVxa+tuCIa3FWcpvI0npmX
         FMcA==
X-Gm-Message-State: APjAAAWko0ADqQZTbN78NXWy1UR0OPQkvmfG5gXXki+VkjtOyE94Ctjg
        NgpdwI9E7/n5/4uXWSlCSttRBA==
X-Google-Smtp-Source: APXvYqxgYBWiFOrj5HNpz+/FCpzyLc7TZlx+EJAQx5cJoqMOCKZUY1H+JFA3fOapkxLNA+Ssa5evfg==
X-Received: by 2002:a17:90a:216f:: with SMTP id a102mr2521250pje.29.1561075700506;
        Thu, 20 Jun 2019 17:08:20 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id k13sm659448pgq.45.2019.06.20.17.08.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:08:20 -0700 (PDT)
Date:   Thu, 20 Jun 2019 17:08:19 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 5/7] selftests/bpf: switch test to new
 attach_perf_event API
Message-ID: <20190621000819.GD1383@mini-arch>
References: <20190620230951.3155955-1-andriin@fb.com>
 <20190620230951.3155955-6-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620230951.3155955-6-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/20, Andrii Nakryiko wrote:
> Use new bpf_program__attach_perf_event() in test previously relying on
> direct ioctl manipulations.
Maybe use new detach/disable routine at the end of the
test_stacktrace_build_id_nmi as well?

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c     | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> index 1c1a2f75f3d8..1bbdb0b82ac5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> @@ -17,6 +17,7 @@ static __u64 read_perf_max_sample_freq(void)
>  void test_stacktrace_build_id_nmi(void)
>  {
>  	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> +	const char *prog_name = "tracepoint/random/urandom_read";
>  	const char *file = "./test_stacktrace_build_id.o";
>  	int err, pmu_fd, prog_fd;
>  	struct perf_event_attr attr = {
> @@ -25,6 +26,7 @@ void test_stacktrace_build_id_nmi(void)
>  		.config = PERF_COUNT_HW_CPU_CYCLES,
>  	};
>  	__u32 key, previous_key, val, duration = 0;
> +	struct bpf_program *prog;
>  	struct bpf_object *obj;
>  	char buf[256];
>  	int i, j;
> @@ -39,6 +41,10 @@ void test_stacktrace_build_id_nmi(void)
>  	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
>  		return;
>  
> +	prog = bpf_object__find_program_by_title(obj, prog_name);
> +	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
> +		goto close_prog;
> +
>  	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
>  			 0 /* cpu 0 */, -1 /* group id */,
>  			 0 /* flags */);
> @@ -47,16 +53,10 @@ void test_stacktrace_build_id_nmi(void)
>  		  pmu_fd, errno))
>  		goto close_prog;
>  
> -	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> -	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
> -		  err, errno))
> +	err = bpf_program__attach_perf_event(prog, pmu_fd);
> +	if (CHECK(err, "attach_perf_event", "err %d\n", err))
>  		goto close_pmu;
>  
> -	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> -	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
> -		  err, errno))
> -		goto disable_pmu;
> -
>  	/* find map fds */
>  	control_map_fd = bpf_find_map(__func__, obj, "control_map");
>  	if (CHECK(control_map_fd < 0, "bpf_find_map control_map",
> -- 
> 2.17.1
> 
