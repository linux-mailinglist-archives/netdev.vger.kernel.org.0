Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02281224798
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 02:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGRAts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 20:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRAts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 20:49:48 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FA5C0619D2;
        Fri, 17 Jul 2020 17:49:48 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g13so9036814qtv.8;
        Fri, 17 Jul 2020 17:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xvlkr5da2a1bZrjar9qG2hQO5DIfq2z+FvuH/Ed+mLM=;
        b=tINAQ8g1JKEV7eVNLw6FBfFEluOP26aOBiXd98LRPDnXTjAQAPrccj5/rXsk7iGDda
         s9ZsJQH+ZdMgj5XvWaoZ6a8b+KNiPKMVggCneu08gs2JqUabivM9poTjstDtmPfnqrzl
         RuOJqH2uQphLsNnL/hs/EhxUuxVJCIZEJaYGkNuZO43z2YCJW1RqVQlfYRiji2Q9gR7/
         hqaplc4PJBmaiyif3PgMZpQFCUDRBP3Srb6aK5+T+ss4tjDVaglvtXe/5OrTxfIuQ4QI
         Qe2r6s3ss/urLtzA7fr09ZsBVVU+WazUfr8fE1efh9zJBqJ5R1FCUK3EKDJF+BukQcxI
         o8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xvlkr5da2a1bZrjar9qG2hQO5DIfq2z+FvuH/Ed+mLM=;
        b=RyNSVZhG4/6W7CW5efeKD36WJ5IKwmzm+//5Pj8X5vJ+zwwqcEvk1gJkljMtKF7IOn
         2Pl5G/qQkHA3xn6+O0hg5DEP9kPxB1kIqShjP0qFlK8qhmBnWlGqompYDWEi2PU3gi+l
         iml4SJxEYDJG+RMHUecsEGSByKTnbICJ8h5EAr6ymADw0BI4IIhs/r2zpsrYa+iJlXlH
         9SEPL7JwJfF2+bZloPqwfn81RcC1Na17uRMAwNSFGgShFdQUclrjAGbf9pefNLcV3B/K
         5jxIWt4yLn2P1jF6xGtY2EgKO6zNduQF8IQ2VOKUTfXzzVaYE64Ht4HawkdnjreAihQ+
         oAtQ==
X-Gm-Message-State: AOAM530MF1p1tuUAjqiqRm4vX/Kmc4sPxGTyM+GOfdZY0O4LHtP73aix
        nHZ6xwcZu2465e6yIRMS2IFDLVKf
X-Google-Smtp-Source: ABdhPJzPc4D7roMF2iTO6aFepZoQhiknM6GsGs/uVOoxJuMyWaDeKKdOYsNTRgzNDGT1bWzSQZ2ebw==
X-Received: by 2002:aed:2e41:: with SMTP id j59mr13105319qtd.108.1595033386883;
        Fri, 17 Jul 2020 17:49:46 -0700 (PDT)
Received: from bpf-dev (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.gmail.com with ESMTPSA id x29sm13304247qtx.74.2020.07.17.17.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 17:49:46 -0700 (PDT)
Date:   Fri, 17 Jul 2020 20:49:42 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3] folds tests from test_current_pid_tgid_new_ns into
 test_progs.
Message-ID: <20200718004940.GA38154@bpf-dev>
References: <20200718004122.37775-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718004122.37775-1-cneirabustos@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My last email was missing what changed from V2.
Changes from V2:
 - Test that does not create a new namespace has been included in test_progs
 - Test creating a new pid namespace is a standalone test.
 - Skeleton is used in both tests.

On Fri, Jul 17, 2020 at 08:41:22PM -0400, Carlos Neira wrote:
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |  2 +-
>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 85 -----------------
>  .../bpf/prog_tests/ns_current_pidtgid.c       | 59 ++++++++++++
>  .../bpf/progs/test_ns_current_pid_tgid.c      | 37 --------
>  .../bpf/progs/test_ns_current_pidtgid.c       | 25 +++++
>  ...new_ns.c => test_current_pidtgid_new_ns.c} |  0
>  .../bpf/test_ns_current_pidtgid_newns.c       | 91 +++++++++++++++++++
>  8 files changed, 178 insertions(+), 124 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
>  rename tools/testing/selftests/bpf/{test_current_pid_tgid_new_ns.c => test_current_pidtgid_new_ns.c} (100%)
>  create mode 100644 tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
> 
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 1bb204cee853..022055f23592 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -30,8 +30,8 @@ test_tcpnotify_user
>  test_libbpf
>  test_tcp_check_syncookie_user
>  test_sysctl
> -test_current_pid_tgid_new_ns
>  xdping
> +test_ns_current_pidtgid_newns
>  test_cpp
>  *.skel.h
>  /no_alu32
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e7a8cf83ba48..c1ba9c947196 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -37,7 +37,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>  	test_cgroup_storage \
>  	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
>  	test_progs-no_alu32 \
> -	test_current_pid_tgid_new_ns
> +	test_ns_current_pidtgid_newns
>  
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)
> @@ -163,6 +163,7 @@ $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
>  $(OUTPUT)/test_netcnt: cgroup_helpers.c
>  $(OUTPUT)/test_sock_fields: cgroup_helpers.c
>  $(OUTPUT)/test_sysctl: cgroup_helpers.c
> +$(OUTPUT)/test_ns_current_pidtgid_newns: test_ns_current_pidtgid_newns.c
>  
>  DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
> diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> deleted file mode 100644
> index e74dc501b27f..000000000000
> --- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> -#include <test_progs.h>
> -#include <sys/stat.h>
> -#include <sys/types.h>
> -#include <unistd.h>
> -#include <sys/syscall.h>
> -
> -struct bss {
> -	__u64 dev;
> -	__u64 ino;
> -	__u64 pid_tgid;
> -	__u64 user_pid_tgid;
> -};
> -
> -void test_ns_current_pid_tgid(void)
> -{
> -	const char *probe_name = "raw_tracepoint/sys_enter";
> -	const char *file = "test_ns_current_pid_tgid.o";
> -	int err, key = 0, duration = 0;
> -	struct bpf_link *link = NULL;
> -	struct bpf_program *prog;
> -	struct bpf_map *bss_map;
> -	struct bpf_object *obj;
> -	struct bss bss;
> -	struct stat st;
> -	__u64 id;
> -
> -	obj = bpf_object__open_file(file, NULL);
> -	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> -		return;
> -
> -	err = bpf_object__load(obj);
> -	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> -		goto cleanup;
> -
> -	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> -	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> -		goto cleanup;
> -
> -	prog = bpf_object__find_program_by_title(obj, probe_name);
> -	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
> -		  probe_name))
> -		goto cleanup;
> -
> -	memset(&bss, 0, sizeof(bss));
> -	pid_t tid = syscall(SYS_gettid);
> -	pid_t pid = getpid();
> -
> -	id = (__u64) tid << 32 | pid;
> -	bss.user_pid_tgid = id;
> -
> -	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> -		perror("Failed to stat /proc/self/ns/pid");
> -		goto cleanup;
> -	}
> -
> -	bss.dev = st.st_dev;
> -	bss.ino = st.st_ino;
> -
> -	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
> -	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
> -		goto cleanup;
> -
> -	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> -	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> -		  PTR_ERR(link))) {
> -		link = NULL;
> -		goto cleanup;
> -	}
> -
> -	/* trigger some syscalls */
> -	usleep(1);
> -
> -	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> -	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> -		goto cleanup;
> -
> -	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
> -		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> -		goto cleanup;
> -cleanup:
> -	bpf_link__destroy(link);
> -	bpf_object__close(obj);
> -}
> diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> new file mode 100644
> index 000000000000..49578c0afbe0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_ns_current_pidtgid.skel.h"
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +#include <sched.h>
> +#include <sys/wait.h>
> +#include <sys/mount.h>
> +#include <sys/fcntl.h>
> +
> +void test_ns_current_pidtgid(void)
> +{
> +	int err, duration = 0;
> +	struct test_ns_current_pidtgid *skel;
> +	struct test_ns_current_pidtgid__bss  *bss;
> +	struct stat st;
> +	__u64 id;
> +
> +	skel = test_ns_current_pidtgid__open();
> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> +		return;
> +
> +	err = test_ns_current_pidtgid__load(skel);
> +	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
> +		goto cleanup;
> +
> +	pid_t tid = syscall(SYS_gettid);
> +	pid_t pid = getpid();
> +
> +	id = (__u64) tid << 32 | pid;
> +
> +	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> +		perror("Failed to stat /proc/self/ns/pid");
> +		goto cleanup;
> +	}
> +
> +	bss = skel->bss;
> +	bss->dev = st.st_dev;
> +	bss->ino = st.st_ino;
> +	bss->user_pid_tgid = 0;
> +
> +	err = test_ns_current_pidtgid__attach(skel);
> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	/* trigger tracepoint */
> +	usleep(1);
> +
> +	CHECK(bss->user_pid_tgid != id, "pid/tgid", "got %llu != exp %llu\n",
> +		bss->user_pid_tgid, id);
> +cleanup:
> +	test_ns_current_pidtgid__destroy(skel);
> +
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> deleted file mode 100644
> index 1dca70a6de2f..000000000000
> --- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> +++ /dev/null
> @@ -1,37 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> -
> -#include <linux/bpf.h>
> -#include <stdint.h>
> -#include <bpf/bpf_helpers.h>
> -
> -static volatile struct {
> -	__u64 dev;
> -	__u64 ino;
> -	__u64 pid_tgid;
> -	__u64 user_pid_tgid;
> -} res;
> -
> -SEC("raw_tracepoint/sys_enter")
> -int trace(void *ctx)
> -{
> -	__u64  ns_pid_tgid, expected_pid;
> -	struct bpf_pidns_info nsdata;
> -	__u32 key = 0;
> -
> -	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
> -		   sizeof(struct bpf_pidns_info)))
> -		return 0;
> -
> -	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> -	expected_pid = res.user_pid_tgid;
> -
> -	if (expected_pid != ns_pid_tgid)
> -		return 0;
> -
> -	res.pid_tgid = ns_pid_tgid;
> -
> -	return 0;
> -}
> -
> -char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> new file mode 100644
> index 000000000000..9818a56510d9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> +
> +#include <linux/bpf.h>
> +#include <stdint.h>
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 user_pid_tgid = 0;
> +__u64 dev = 0;
> +__u64 ino = 0;
> +
> +SEC("raw_tracepoint/sys_enter")
> +int handler(const void *ctx)
> +{
> +	struct bpf_pidns_info nsdata;
> +
> +	if (bpf_get_ns_current_pid_tgid(dev, ino, &nsdata,
> +		   sizeof(struct bpf_pidns_info)))
> +		return 0;
> +	user_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> +
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c b/tools/testing/selftests/bpf/test_current_pidtgid_new_ns.c
> similarity index 100%
> rename from tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> rename to tools/testing/selftests/bpf/test_current_pidtgid_new_ns.c
> diff --git a/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
> new file mode 100644
> index 000000000000..3bca38941c99
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_ns_current_pidtgid_newns.c
> @@ -0,0 +1,91 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_ns_current_pidtgid.skel.h"
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +#include <sched.h>
> +#include <sys/wait.h>
> +#include <sys/mount.h>
> +#include <sys/fcntl.h>
> +
> +#define STACK_SIZE (1024 * 1024)
> +static char child_stack[STACK_SIZE];
> +
> +static int newns_pidtgid(void *arg)
> +{
> +	struct test_ns_current_pidtgid__bss  *bss;
> +	struct test_ns_current_pidtgid *skel;
> +	int pidns_fd = 0, err = 0;
> +	pid_t pid, tid;
> +	struct stat st;
> +	__u64 id;
> +
> +	skel = test_ns_current_pidtgid__open();
> +	err = test_ns_current_pidtgid__load(skel);
> +	if (err) {
> +		perror("Failed to load skeleton");
> +		goto cleanup;
> +	}
> +
> +	tid = syscall(SYS_gettid);
> +	pid = getpid();
> +	id = (__u64) tid << 32 | pid;
> +
> +	if (stat("/proc/self/ns/pid", &st)) {
> +		printf("Failed to stat /proc/self/ns/pid: %s\n",
> +			strerror(errno));
> +		goto cleanup;
> +	}
> +
> +	bss = skel->bss;
> +	bss->dev = st.st_dev;
> +	bss->ino = st.st_ino;
> +	bss->user_pid_tgid = 0;
> +
> +	err = test_ns_current_pidtgid__attach(skel);
> +	if (err) {
> +		printf("Failed to attach: %s err: %d\n", strerror(errno), err);
> +		goto cleanup;
> +	}
> +	/* trigger tracepoint */
> +	usleep(1);
> +
> +	if (bss->user_pid_tgid != id) {
> +		printf("test_ns_current_pidtgid_newns:FAIL\n");
> +		err = EXIT_FAILURE;
> +	} else {
> +		printf("test_ns_current_pidtgid_newns:PASS\n");
> +		err = EXIT_SUCCESS;
> +	}
> +
> +cleanup:
> +		setns(pidns_fd, CLONE_NEWPID);
> +		test_ns_current_pidtgid__destroy(skel);
> +
> +	return 0;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	pid_t cpid;
> +	int wstatus;
> +
> +	cpid = clone(newns_pidtgid,
> +			child_stack + STACK_SIZE,
> +			CLONE_NEWPID | SIGCHLD, NULL);
> +	if (cpid == -1) {
> +		printf("test_ns_current_pidtgid_newns:Failed on CLONE: %s\n",
> +			 strerror(errno));
> +		exit(EXIT_FAILURE);
> +	}
> +	if (waitpid(cpid, &wstatus, 0) == -1) {
> +		printf("test_ns_current_pidtgid_newns:Failed on waitpid: %s\n",
> +			strerror(errno));
> +	}
> +	return (WEXITSTATUS(wstatus));
> +}
> -- 
> 2.20.1
> 
