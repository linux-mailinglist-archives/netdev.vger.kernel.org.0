Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A415926A94
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfEVTKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:10:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39728 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbfEVTKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:10:09 -0400
Received: by mail-pl1-f193.google.com with SMTP id g9so1518900plm.6
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b+Db0Ho967KIuB480AsX6/OKFU0wLR6Q1jk2wQ0DXCQ=;
        b=WX1aKVNW/YnkYXQJzyC6vSeafONarW/j2n+CRF5tH2BTfoilsWZjgSOCVWOciORDjl
         HPQuZuykB77k7JD5vQW4h/PEjS1ZK1fM+l/UyvHWAV/kWbZHmxBP0ALLiMJqEGtUPAkA
         Xw4uOtngkdyt1c7P4pVI/duXphdOodJcSVlQHgVUDIl4Nr1+GTwSVtVwvlIEvADKqmvB
         tP0/yzkXm+uy9LgKMKOHwDV/Ksfer9/26DxeVbVOeZw+XDY/M9pFbArKDQlC7laNeeqQ
         SB3NbhS6sVycv+HD8qDiBDV1L0YASIUSBkr87NwtSPTpVPH8GHeX1SK/zChsHDg6zi4D
         j9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b+Db0Ho967KIuB480AsX6/OKFU0wLR6Q1jk2wQ0DXCQ=;
        b=mw8ahMObvqM6c4s8muQovgyubG6E6SA/3dt6rcmpsuIYxQgtKeR9GUHfycd58xFtKO
         /En7UoLh96W1k8wCcR72bp2eluI0Z+4oMGhKBME5BruG0t+k+Rp246iR8nyQwb6mUTyW
         fZMQdj7a7jBk0TW5729vVEZrq3U0AQ2aYPM30lRUG3+4g4YhH4/7PnO1CelchdgOzYJ3
         aJ5xYCkk3teFF2D+8h2NZ5V1n911FuPfY5nKViAtthM111cXV8n7vdLJEw/FbHwXXlEo
         TA+J8HP8J+sML9VLw5yXRaNoFsj5lv1EkOG1ICBQYE/bLDKlw+CSTpRj8WXXQQq5kAjK
         PR3Q==
X-Gm-Message-State: APjAAAW5PPtu2heFcPUQeRVP+tNbtATKopN8VOtWqnIHQFauIDvDkioC
        tK92Ag3GY1LHDOFktrZLGbU3gA==
X-Google-Smtp-Source: APXvYqwQH0q3LLA0opfCF1qW2MqmJcSagCew0hGSv2HZ4Jp770S60C6UTtZ9L6EXPEEAvPYjM+7XNQ==
X-Received: by 2002:a17:902:b58a:: with SMTP id a10mr62595282pls.83.1558552208085;
        Wed, 22 May 2019 12:10:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j10sm26042127pgk.37.2019.05.22.12.10.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 12:10:07 -0700 (PDT)
Date:   Wed, 22 May 2019 12:10:06 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next v2 3/3] tools/bpf: add a selftest for
 bpf_send_signal() helper
Message-ID: <20190522191006.GN10244@mini-arch>
References: <20190522053900.1663459-1-yhs@fb.com>
 <20190522053903.1663924-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522053903.1663924-1-yhs@fb.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21, Yonghong Song wrote:
> The test covered both nmi and tracepoint perf events.
>   $ ./test_send_signal_user
>   test_send_signal (tracepoint): OK
>   test_send_signal (perf_event): OK
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
>  .../bpf/progs/test_send_signal_kern.c         |  51 +++++
>  .../selftests/bpf/test_send_signal_user.c     | 212 ++++++++++++++++++
>  4 files changed, 266 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c
>  create mode 100644 tools/testing/selftests/bpf/test_send_signal_user.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 66f2dca1dee1..5eb6368a96a2 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -23,7 +23,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>  	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
>  	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
>  	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
> -	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
> +	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> +	test_send_signal_user
>  
>  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
>  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 5f6f9e7aba2a..cb02521b8e58 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -216,6 +216,7 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
>  	(void *) BPF_FUNC_sk_storage_get;
>  static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
>  	(void *)BPF_FUNC_sk_storage_delete;
> +static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
>  
>  /* llvm builtin functions that eBPF C program may use to
>   * emit BPF_LD_ABS and BPF_LD_IND instructions
> diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> new file mode 100644
> index 000000000000..45a1a1a2c345
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
> @@ -0,0 +1,51 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/bpf.h>
> +#include <linux/version.h>
> +#include "bpf_helpers.h"
> +
> +struct bpf_map_def SEC("maps") info_map = {
> +	.type = BPF_MAP_TYPE_ARRAY,
> +	.key_size = sizeof(__u32),
> +	.value_size = sizeof(__u64),
> +	.max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
> +
> +struct bpf_map_def SEC("maps") status_map = {
> +	.type = BPF_MAP_TYPE_ARRAY,
> +	.key_size = sizeof(__u32),
> +	.value_size = sizeof(__u64),
> +	.max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
> +
> +SEC("send_signal_demo")
> +int bpf_send_signal_test(void *ctx)
> +{
> +	__u64 *info_val, *status_val;
> +	__u32 key = 0, pid, sig;
> +	int ret;
> +
> +	status_val = bpf_map_lookup_elem(&status_map, &key);
> +	if (!status_val || *status_val != 0)
> +		return 0;
> +
> +	info_val = bpf_map_lookup_elem(&info_map, &key);
> +	if (!info_val || *info_val == 0)
> +		return 0;
> +
> +	sig = *info_val >> 32;
> +	pid = *info_val & 0xffffFFFF;
> +
> +	if ((bpf_get_current_pid_tgid() >> 32) == pid) {
> +		ret = bpf_send_signal(sig);
> +		if (ret == 0)
> +			*status_val = 1;
> +	}
> +
> +	return 0;
> +}
> +char __license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_send_signal_user.c b/tools/testing/selftests/bpf/test_send_signal_user.c
> new file mode 100644
> index 000000000000..0bd0f7674860
> --- /dev/null
[..]
> +++ b/tools/testing/selftests/bpf/test_send_signal_user.c
Any reason you didn't put it under bpf/prog_tests?
That way you don't need to define your own CHECK macro and
care about the includes.

> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <syscall.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +
> +#include <linux/perf_event.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#include "bpf_rlimit.h"
> +
> +#define CHECK(condition, tag, format...) ({				\
> +	int __ret = !!(condition);					\
> +	if (__ret) {							\
> +		printf("%s(%d):FAIL:%s ", __func__, __LINE__, tag);	\
> +		printf(format);						\
> +		printf("\n");						\
> +	}								\
> +	__ret;								\
> +})
> +
> +static volatile int signal_received = 0;
> +
> +static void sigusr1_handler(int signum)
> +{
> +	signal_received++;
> +}
> +
> +static void test_common(struct perf_event_attr *attr, int prog_type,
> +			const char *test_name)
> +{
> +	int pmu_fd, prog_fd, info_map_fd, status_map_fd;
> +	const char *file = "./test_send_signal_kern.o";
> +	struct bpf_object *obj = NULL;
> +	int pipe_c2p[2], pipe_p2c[2];
> +	char buf[256];
> +	int err = 0;
> +	u32 key = 0;
> +	pid_t pid;
> +	u64 val;
> +
> +	if (CHECK(pipe(pipe_c2p), test_name,
> +		  "pipe pipe_c2p error: %s", strerror(errno)))
> +		return;
> +
> +	if (CHECK(pipe(pipe_p2c), test_name,
> +		  "pipe pipe_p2c error: %s", strerror(errno))) {
> +		close(pipe_c2p[0]);
> +		close(pipe_c2p[1]);
> +		return;
> +	}
> +
> +	pid = fork();
> +	if (CHECK(pid < 0, test_name, "fork error: %s", strerror(errno))) {
> +		close(pipe_c2p[0]);
> +		close(pipe_c2p[1]);
> +		close(pipe_p2c[0]);
> +		close(pipe_p2c[1]);
> +		return;
> +	}
> +
> +	if (pid == 0) {
> +		/* install signal handler and notify parent */
> +		signal(SIGUSR1, sigusr1_handler);
> +
> +		close(pipe_c2p[0]); /* close read */
> +		close(pipe_p2c[1]); /* close write */
> +
> +		/* notify parent signal handler is installed */
> +		write(pipe_c2p[1], buf, 1);
> +
> +		/* make sense parent enabled bpf program to send_signal */
> +		read(pipe_p2c[0], buf, 1);
> +
> +		/* wait a little for signal handler */
> +		sleep(1);
> +
> +		if (signal_received)
> +			write(pipe_c2p[1], "2", 1);
> +		else
> +			write(pipe_c2p[1], "0", 1);
> +
> +		/* wait for parent notification and exit */
> +		read(pipe_p2c[0], buf, 1);
> +
> +		close(pipe_c2p[1]);
> +		close(pipe_p2c[0]);
> +		exit(0);
> +	}
> +
> +	close(pipe_c2p[1]); /* close write */
> +	close(pipe_p2c[0]); /* close read */
> +
> +	err = bpf_prog_load(file, prog_type, &obj, &prog_fd);
> +	if (CHECK(err < 0, test_name, "bpf_prog_load error: %s",
> +		  strerror(errno)))
> +		goto prog_load_failure;
> +
> +	pmu_fd = syscall(__NR_perf_event_open, attr, pid, -1,
> +			 -1 /* group id */, 0 /* flags */);
> +	if (CHECK(pmu_fd < 0, test_name, "perf_event_open error: %s",
> +		  strerror(errno)))
> +		goto close_prog;
> +
> +	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> +	if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_enable error: %s",
> +		  strerror(errno)))
> +		goto disable_pmu;
> +
> +	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> +	if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_set_bpf error: %s",
> +		  strerror(errno)))
> +		goto disable_pmu;
> +
> +	info_map_fd = bpf_object__find_map_fd_by_name(obj, "info_map");
> +	if (CHECK(info_map_fd < 0, test_name, "find map %s error", "info_map"))
> +		goto disable_pmu;
> +
> +	status_map_fd = bpf_object__find_map_fd_by_name(obj, "status_map");
> +	if (CHECK(status_map_fd < 0, test_name, "find map %s error", "status_map"))
> +		goto disable_pmu;
> +
> +	/* wait until child signal handler installed */
> +	read(pipe_c2p[0], buf, 1);
> +
> +	/* trigger the bpf send_signal */
> +	key = 0;
> +	val = (((u64)(SIGUSR1)) << 32) | pid;
> +	bpf_map_update_elem(info_map_fd, &key, &val, 0);
> +
> +	/* notify child that bpf program can send_signal now */
> +	write(pipe_p2c[1], buf, 1);
> +
> +	/* wait for result */
> +	read(pipe_c2p[0], buf, 1);
> +
> +	if (buf[0] == '2')
> +		printf("test_send_signal (%s): OK\n", test_name);
> +	else
> +		printf("test_send_signal (%s): FAIL\n", test_name);
> +
> +	/* notify child safe to exit */
> +	write(pipe_p2c[1], buf, 1);
> +
> +disable_pmu:
> +	close(pmu_fd);
> +close_prog:
> +	bpf_object__close(obj);
> +prog_load_failure:
> +	close(pipe_c2p[0]);
> +	close(pipe_p2c[1]);
> +	wait(NULL);
> +}
> +
> +static void test_tracepoint(void)
> +{
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_TRACEPOINT,
> +		.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN,
> +		.sample_period = 1,
> +		.wakeup_events = 1,
> +	};
> +	int bytes, efd;
> +	char buf[256];
> +
> +	snprintf(buf, sizeof(buf),
> +		 "/sys/kernel/debug/tracing/events/syscalls/sys_enter_nanosleep/id");
> +	efd = open(buf, O_RDONLY, 0);
> +	if (CHECK(efd < 0, "tracepoint",
> +		  "open syscalls/sys_enter_nanosleep/id failure: %s",
> +		  strerror(errno)))
> +		return;
> +
> +	bytes = read(efd, buf, sizeof(buf));
> +	close(efd);
> +	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "tracepoint",
> +		  "read syscalls/sys_enter_nanosleep/id failure: %s",
> +		  strerror(errno)))
> +		return;
> +
> +	attr.config = strtol(buf, NULL, 0);
> +
> +	test_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
> +}
> +
> +static void test_nmi_perf_event(void)
> +{
> +	struct perf_event_attr attr = {
> +		.sample_freq = 50,
> +		.freq = 1,
> +		.type = PERF_TYPE_HARDWARE,
> +		.config = PERF_COUNT_HW_CPU_CYCLES,
> +	};
> +
> +	test_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
> +}
> +
> +int main(void)
> +{
> +	test_tracepoint();
> +	test_nmi_perf_event();
> +	return 0;
> +}
> -- 
> 2.17.1
> 
