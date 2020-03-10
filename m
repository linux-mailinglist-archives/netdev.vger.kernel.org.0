Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B99180A8B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgCJVeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:34:06 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36675 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJVeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:34:06 -0400
Received: by mail-pj1-f66.google.com with SMTP id l41so1001123pjb.1;
        Tue, 10 Mar 2020 14:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LCYPTkQeKs5bkCfHOomw0TrHzkMe0qPSXP3P+PmgQZA=;
        b=Fu8kz70JHhPVj7Izd1K/hx/8IzzxpQP6ecte+uFAUOTowWZuCA8hOlJNfXAC1a/h6K
         w9OE/Z9Hckx4avIhtYFtdKIOEnlPbqKxWqn58phK5yQWip5rcLo4oL8o4CCMPIoOk8tW
         9e+KV6iTQgpASPPEi3egKeJeIK7vmVCLnQKAE/7pn1JOPBzP9vhw1Oig3EIhHjUADkWh
         3oGS0PZLvvbcJ6+TtJXtDoOLoXO0cCiqCvfziNwYhmLhXD3vcEHFARRZ4+R228R3L8CH
         LJwN9bVDl1xx5mxPkofS9QdFAjn9jxxUoojP8YrsF41ljB1VLIYuMw6uMSpXCgITWMM9
         iajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LCYPTkQeKs5bkCfHOomw0TrHzkMe0qPSXP3P+PmgQZA=;
        b=GD+uq1NjaApHWg8MS+EqZVfXzYMrcRpuXnK6zyV44usQf9teAPtETZLFlv3O4qwMt8
         uOQ2KRY7rANYRK8D7he3SVteLpKlEozQEtU8mIyva3gTF42uZDmKgVo/xO4U7MMHmh6J
         j5cxIkTzP4TXBPW05XR9S/vbRpVExboqerakEGQhqEzcTpBrU3/39gqSEDDCUbhvnyxW
         qaU7YSQrrroxiNchKVQkqIS8YtpKSRROhRheiSljMT/hIXOs13qnKAcARVRQNpQ8Nc+O
         lfuhG6/JYrjnSozhAJ7jCGEAWlu27tTdaV2Oxka2x6i4KGF97dVRDsyc8u8v8i/2E2gh
         WZog==
X-Gm-Message-State: ANhLgQ1zaHv3JEA4z7kTfBe9BCnog+T95WJWCQ2MBKYewPU+yYDcTaj0
        Daza5TgErmJ7krQmw+57n6E7JziV
X-Google-Smtp-Source: ADFU+vtKzTFph3EFMuiDFMNGj+lzsVC/1Ve/V7t2tQBxjs0mEpcLLkgWtpKVZzvQuk+pRzAB4TLlig==
X-Received: by 2002:a17:902:bf0b:: with SMTP id bi11mr10942422plb.245.1583876044306;
        Tue, 10 Mar 2020 14:34:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j12sm32757413pga.78.2020.03.10.14.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:34:03 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:33:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e6807c39b0b1_586d2b10f16785b8eb@john-XPS-13-9370.notmuch>
In-Reply-To: <20200310055147.26678-3-danieltimlee@gmail.com>
References: <20200310055147.26678-1-danieltimlee@gmail.com>
 <20200310055147.26678-3-danieltimlee@gmail.com>
Subject: RE: [PATCH bpf-next 2/2] samples: bpf: refactor perf_event user
 program with libbpf bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel T. Lee wrote:
> The bpf_program__attach of libbpf(using bpf_link) is much more intuitive
> than the previous method using ioctl.
> 
> bpf_program__attach_perf_event manages the enable of perf_event and
> attach of BPF programs to it, so there's no neeed to do this
> directly with ioctl.
> 
> In addition, bpf_link provides consistency in the use of API because it
> allows disable (detach, destroy) for multiple events to be treated as
> one bpf_link__destroy.
> 
> This commit refactors samples that attach the bpf program to perf_event
> by using libbbpf instead of ioctl. Also the bpf_load in the samples were
> removed and migrated to use libbbpf API.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

[...]

>  
>  int main(int argc, char **argv)
>  {
> +	int prog_fd, *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
> +	struct bpf_program *prog;
> +	struct bpf_object *obj;
> +	struct bpf_link **link;
>  	char filename[256];
> -	int *pmu_fd, opt, freq = DEFAULT_FREQ, secs = DEFAULT_SECS;
>  
>  	/* process arguments */
>  	while ((opt = getopt(argc, argv, "F:h")) != -1) {
> @@ -165,36 +170,47 @@ int main(int argc, char **argv)
>  	/* create perf FDs for each CPU */
>  	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
>  	pmu_fd = malloc(nr_cpus * sizeof(int));
> -	if (pmu_fd == NULL) {
> -		fprintf(stderr, "ERROR: malloc of pmu_fd\n");
> +	link = malloc(nr_cpus * sizeof(struct bpf_link *));
> +	if (pmu_fd == NULL || link == NULL) {
> +		fprintf(stderr, "ERROR: malloc of pmu_fd/link\n");
>  		return 1;
>  	}
>  
>  	/* load BPF program */
>  	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> -	if (load_bpf_file(filename)) {
> +	if (bpf_prog_load(filename, BPF_PROG_TYPE_PERF_EVENT, &obj, &prog_fd)) {
>  		fprintf(stderr, "ERROR: loading BPF program (errno %d):\n",
>  			errno);
> -		if (strcmp(bpf_log_buf, "") == 0)
> -			fprintf(stderr, "Try: ulimit -l unlimited\n");
> -		else
> -			fprintf(stderr, "%s", bpf_log_buf);
>  		return 1;
>  	}
> +
> +	prog = bpf_program__next(NULL, obj);
> +	if (!prog) {
> +		printf("finding a prog in obj file failed\n");
> +		return 1;
> +	}
> +
> +	map_fd = bpf_object__find_map_fd_by_name(obj, "ip_map");
> +	if (map_fd < 0) {
> +		printf("finding a ip_map map in obj file failed\n");
> +		return 1;
> +	}
> +
>  	signal(SIGINT, int_exit);
>  	signal(SIGTERM, int_exit);
>  
>  	/* do sampling */
>  	printf("Sampling at %d Hertz for %d seconds. Ctrl-C also ends.\n",
>  	       freq, secs);
> -	if (sampling_start(pmu_fd, freq) != 0)
> +	if (sampling_start(pmu_fd, freq, prog, link) != 0)
>  		return 1;
>  	sleep(secs);
> -	sampling_end(pmu_fd);
> +	sampling_end(link);
>  	free(pmu_fd);
> +	free(link);

Not really a problem with this patch but on error we don't free() memory but
then on normal exit there is a free() its a bit inconsistent. How about adding
free on errors as well?

>  
>  	/* output sample counts */
> -	print_ip_map(map_fd[0]);
> +	print_ip_map(map_fd);
>  
>  	return 0;
>  }

[...]
  
>  static void print_ksym(__u64 addr)
> @@ -137,6 +136,7 @@ static inline int generate_load(void)
>  static void test_perf_event_all_cpu(struct perf_event_attr *attr)
>  {
>  	int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	struct bpf_link **link = malloc(nr_cpus * sizeof(struct bpf_link *));

need to check if its null? Its not going to be very friendly to segfault
later. Or maybe I'm missing the check.

>  	int *pmu_fd = malloc(nr_cpus * sizeof(int));
>  	int i, error = 0;
>  
> @@ -151,8 +151,12 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
>  			error = 1;
>  			goto all_cpu_err;
>  		}
> -		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[0]) == 0);
> -		assert(ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE) == 0);
> +		link[i] = bpf_program__attach_perf_event(prog, pmu_fd[i]);
> +		if (link[i] < 0) {
> +			printf("bpf_program__attach_perf_event failed\n");
> +			error = 1;
> +			goto all_cpu_err;
> +		}
>  	}
>  
>  	if (generate_load() < 0) {
> @@ -161,11 +165,11 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
>  	}
>  	print_stacks();
>  all_cpu_err:
> -	for (i--; i >= 0; i--) {
> -		ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
> -		close(pmu_fd[i]);
> -	}
> +	for (i--; i >= 0; i--)
> +		bpf_link__destroy(link[i]);
> +
>  	free(pmu_fd);
> +	free(link);
>  	if (error)
>  		int_exit(0);
>  }

Thanks,
John
