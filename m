Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3912ABE681
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393280AbfIYUdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:33:42 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33437 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392728AbfIYUdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:33:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id r5so94099qtd.0;
        Wed, 25 Sep 2019 13:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GADczkAuSXOvItcr9lxHUP0yxANceiDW2PS/w3w0uD0=;
        b=Ln96P+J3JAwWQEMw3a3rfG0ZDUBoi9t1kYvQ73/1I4Hegp9Hw8wLctl7qGYxvV/Dos
         5tCcqXt7iC2w4RJPqtFifKUAPP/V1U9xLcnhVuu1o14eQlhBnaXzipgduWH4f4rP9Hd/
         f9/0frTBleFIT7z1NKRwK2MoaBoss8m65OL/f8bzoap7hlIE78vPbCXRGRFaBWqRVZ7l
         Uu80Lv/q3iUPSsM/HgVylX5qHDscbJqwhrKJQx5numI44/3KJ5e+kEUE2RFXqjS72udm
         4G/Rpf/1rKK2VohVG4GC+nWcJ7hGbfZryr1WeNLgPxGRsVqUmQ78KfJkge+YVm4mV0jv
         tyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GADczkAuSXOvItcr9lxHUP0yxANceiDW2PS/w3w0uD0=;
        b=XlpQc4nlV1FHvt0UaAkyVyNdknClz4PBWjulxoFvVWewNMrNqL7L1Wsm2ds6Ctc/X2
         3kqryQ/eXshaxuxG3oTn3UMlgRlujKqDxcJzeFzU0kpmNqs449nlFlm/rFoyeLZ5+CxP
         J8sdTy3b6bMAq2LMF9MCac/l8OV+T37VfpfH45Vx+JgO/DJxDhjhsF+93NwW12afZG79
         lVI3opRE0AigmtQNeMWWA+wCBfH6KcdZxhJNNa6J4xuKhqwOJOKr07G0JO14UJv7z/6f
         uOGda0u2SMTwijQrdHEFpjl1Azes/UN5dKvyVdlKgj6WBiYpe35EiKyHsxL/SJBpRG0/
         amFQ==
X-Gm-Message-State: APjAAAU75Rcyb7FQvqY0RDkhvYSelkZ4lNMmG3XOY82XHjlGK/CZOVbR
        KI38AVT+U619IfDr//ZSl2qVRgtsj5M=
X-Google-Smtp-Source: APXvYqyAfV3yBaeNLHQ3QotxfPtpe2YTLwsCcHQ6O4Dh8RYyW0InuF/NLU8zIrsIl0F4Rri+nnWrwA==
X-Received: by 2002:ad4:40c8:: with SMTP id x8mr1317345qvp.227.1569443619663;
        Wed, 25 Sep 2019 13:33:39 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id c201sm3631459qke.128.2019.09.25.13.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 13:33:38 -0700 (PDT)
Date:   Wed, 25 Sep 2019 17:33:34 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v11 4/4] tools/testing/selftests/bpf: Add
 self-tests for new helper.
Message-ID: <20190925203334.GA26832@frodo.byteswizards.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <20190924152005.4659-5-cneirabustos@gmail.com>
 <7562dae7-fd18-e334-8167-8c67234b3c3f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7562dae7-fd18-e334-8167-8c67234b3c3f@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 04:07:09PM +0000, Yonghong Song wrote:
> 
> 
> On 9/24/19 8:20 AM, Carlos Neira wrote:
> > Self tests added for new helper
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   2 +-
> >   tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
> >   .../selftests/bpf/progs/test_pidns_kern.c     |  71 ++++++++
> >   tools/testing/selftests/bpf/test_pidns.c      | 152 ++++++++++++++++++
> >   4 files changed, 227 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
> >   create mode 100644 tools/testing/selftests/bpf/test_pidns.c
> > 
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 7f3196af1ae4..d86b28aa8f44 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -28,7 +28,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> >   	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
> >   	test_cgroup_storage test_select_reuseport test_section_names \
> >   	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
> > -	test_btf_dump test_cgroup_attach xdping
> > +	test_btf_dump test_cgroup_attach xdping test_pidns
> 
> Could you fold test_pidns into test_progs?
> 
> >   
> >   BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> >   TEST_GEN_FILES = $(BPF_OBJ_FILES)
> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index 6c4930bc6e2e..03d0e15ae29f 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -231,6 +231,9 @@ static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
> >   static long long (*bpf_tcp_gen_syncookie)(struct bpf_sock *sk, void *ip,
> >   					  int ip_len, void *tcp, int tcp_len) =
> >   	(void *) BPF_FUNC_tcp_gen_syncookie;
> > +static int (*bpf_get_ns_current_pid_tgid)(__u32 dev, __u64 inum) =
> > +	(void *) BPF_FUNC_get_ns_current_pid_tgid;
> > +
> >   
> >   /* llvm builtin functions that eBPF C program may use to
> >    * emit BPF_LD_ABS and BPF_LD_IND instructions
> > diff --git a/tools/testing/selftests/bpf/progs/test_pidns_kern.c b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
> > new file mode 100644
> > index 000000000000..96cb707db3ee
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_pidns_kern.c
> > @@ -0,0 +1,71 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
> 
> 2019
> 
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of version 2 of the GNU General Public
> > + * License as published by the Free Software Foundation.
> 
> You do not need the above statement, which is covered by
> "SPDX-License-Identifier: GPL-2.0".
> 
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +struct {
> > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > +	__uint(max_entries, 1);
> > +	__type(key, __u32);
> > +	__type(value, __u64);
> > +} ns_inum_map SEC(".maps");
> > +
> > +struct  {
> > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > +	__uint(max_entries, 1);
> > +	__type(key, __u32);
> > +	__type(value, __u32);
> > +} ns_dev_map SEC(".maps");
> > +
> > +struct   {
> > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > +	__uint(max_entries, 1);
> > +	__type(key, __u32);
> > +	__type(value, __u32);
> > +} pidmap SEC(".maps");
> 
> Can we make the value __u64 to include
> both pid and tid to compare both?
> 
> > +
> > +struct {
> > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > +	__uint(max_entries, 1);
> > +	__type(key, __u32);
> > +	__type(value, __u64);
> > +} ns_pid_map SEC(".maps");
> > +
> > 
> 
> The above four one-element maps are perfectly examples
> to use static global variables which are supported
> by the kernel.
> 
> You can take a look at the patch
>    https://patchwork.ozlabs.org/patch/1081014/
> which shows how user space can modify the map
> values. In the future, we could have a better
> interface to read/update those static variable
> values.
> 
> > +
> > +SEC("tracepoint/syscalls/sys_enter_nanosleep")
> > +int trace(void *ctx)
> > +{
> > +	__u32 key = 0, *expected_pid, *dev;
> 
> expected_pid => __u64 *?
> 
> > +	__u64 *val, *inum, nspid;
> > +	__u32 pid;
> > +
> > +	dev = bpf_map_lookup_elem(&ns_dev_map, &key);
> > +	if (!dev)
> > +		return 0;
> > +
> > +	inum = bpf_map_lookup_elem(&ns_inum_map, &key);
> > +	if (!inum)
> > +		return 0;
> > +
> > +	nspid = bpf_get_ns_current_pid_tgid(*dev, *inum);
> > +	expected_pid = bpf_map_lookup_elem(&pidmap, &key);
> > +
> > +	if (!expected_pid || *expected_pid != nspid)
> > +		return 0;
> > +
> > +	val = bpf_map_lookup_elem(&ns_pid_map, &key);
> > +	if (val)
> > +		*val = nspid;
> > +
> > +	return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> > diff --git a/tools/testing/selftests/bpf/test_pidns.c b/tools/testing/selftests/bpf/test_pidns.c
> > new file mode 100644
> > index 000000000000..088f8025f2bf
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_pidns.c
> > @@ -0,0 +1,152 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2018 Carlos Neira cneirabustos@gmail.com
> 
> 2019
> 
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of version 2 of the GNU General Public
> > + * License as published by the Free Software Foundation.
> 
> ditto. you do not need the above statement.
> 
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <syscall.h>
> > +#include <unistd.h>
> > +#include <linux/perf_event.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/time.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +
> > +#include "cgroup_helpers.h"
> > +#include "bpf_rlimit.h"
> > +
> > +#define CHECK(condition, tag, format...) ({		\
> > +	int __ret = !!(condition);			\
> > +	if (__ret) {					\
> > +		printf("%s:FAIL:%s ", __func__, tag);	\
> > +		printf(format);				\
> > +	} else {					\
> > +		printf("%s:PASS:%s\n", __func__, tag);	\
> > +	}						\
> > +	__ret;						\
> > +})
> > +
> > +static int bpf_find_map(const char *test, struct bpf_object *obj,
> > +			const char *name)
> > +{
> > +	struct bpf_map *map;
> > +
> > +	map = bpf_object__find_map_by_name(obj, name);
> > +	if (!map)
> > +		return -1;
> > +	return bpf_map__fd(map);
> 
> The 'test' argument is not used here.
> Also, we have bpf_object__find_map_fd_by_name() API, you can
> use it and you do not need this function.
> 
> > +}
> > +
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	int pidmap_fd, ns_inum_map_fd, ns_dev_map_fd, ns_pid_map_fd;
> > +	const char *probe_name = "syscalls/sys_enter_nanosleep";
> > +	const char *file = "test_pidns_kern.o";
> > +	int err, bytes, efd, prog_fd, pmu_fd;
> > +	struct perf_event_attr attr = {};
> > +	struct bpf_object *obj;
> > +	__u32 nspid = 0;
> > +	__u32 key = 0, pid;
> > +	int exit_code = 1;
> 
> to make it reverse Christmas tree style?
> 
> > +	struct stat st;
> > +	char buf[256];
> > +
> > +	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
> > +	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
> > +		goto cleanup_cgroup_env;
> > +
> > +	ns_dev_map_fd = bpf_find_map(__func__, obj, "ns_dev_map");
> > +	if (CHECK(ns_dev_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
> > +		  ns_dev_map_fd, errno))
> > +		goto close_prog;
> > +
> > +	ns_inum_map_fd = bpf_find_map(__func__, obj, "ns_inum_map");
> > +	if (CHECK(ns_inum_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
> > +		  ns_inum_map_fd, errno))
> > +		goto close_prog;
> > +
> > +	ns_pid_map_fd = bpf_find_map(__func__, obj, "ns_pid_map");
> > +	if (CHECK(ns_pid_map_fd < 0, "bpf_find_map", "err %d errno %d\n",
> > +		  ns_pid_map_fd, errno))
> > +		goto close_prog;
> > +
> > +	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
> > +	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
> > +		  pidmap_fd, errno))
> > +		goto close_prog;
> > +
> > +	pid = getpid();
> > +	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
> 
> maybe
> 	id = (__u64) getpid() << 32 | gettid();
> 	bpf_map_update_elem(pidmap_fd, &key, &id, 0);
> 
> In your original above kernel code, you actually compare user space pid
> to kernel tid, which is okay for this program as it is the main thread 
> and tid == pid, but the mechanism is wrong.
> 
> > +
> > +	if (stat("/proc/self/ns/pid", &st))
> > +		goto close_prog;
> > +
> > +	bpf_map_update_elem(ns_inum_map_fd, &key, &st.st_ino, 0);
> > +	bpf_map_update_elem(ns_dev_map_fd, &key, &st.st_dev, 0);
> > +
> > +
> > +	snprintf(buf, sizeof(buf),
> > +		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
> > +	efd = open(buf, O_RDONLY, 0);
> > +	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
> > +		goto close_prog;
> > +	bytes = read(efd, buf, sizeof(buf));
> > +	close(efd);
> > +	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
> > +		  "bytes %d errno %d\n", bytes, errno))
> > +		goto close_prog;
> > +
> > +	attr.config = strtol(buf, NULL, 0);
> > +	attr.type = PERF_TYPE_TRACEPOINT;
> > +	attr.sample_type = PERF_SAMPLE_RAW;
> > +	attr.sample_period = 1;
> > +	attr.wakeup_events = 1;
> > +
> > +	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
> > +	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
> > +		  errno))
> > +		goto close_prog;
> > +
> > +	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> > +	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
> > +		  errno))
> > +		goto close_pmu;
> > +
> > +	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> > +	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
> > +		  errno))
> > +		goto close_pmu;
> 
> The whole thing above related to tracepoint can be simplified. Please 
> see prog_tests/stacktrace_map.c.
> 
> > +
> > +	/* trigger some syscalls */
> > +	sleep(1);
> > +
> > +	err = bpf_map_lookup_elem(ns_pid_map_fd, &key, &nspid);
> > +	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
> > +		goto close_pmu;
> > +
> > +	if (CHECK(nspid != pid, "compare nspid vs pid",
> > +		  "kern nspid %u user pid %u", nspid, pid))
> > +		goto close_pmu;
> > +
> > +	exit_code = 0;
> > +	printf("%s:PASS\n", argv[0]);
> > +
> > +close_pmu:
> > +	close(pmu_fd);
> > +close_prog:
> > +	bpf_object__close(obj);
> > +cleanup_cgroup_env:
> > +	return exit_code;
> > +}
> > 
Thanks Yonghong,

I'll correct these issues on v12.

Bests 
