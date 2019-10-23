Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3476E1E71
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391146AbfJWOmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 10:42:53 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44617 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389423AbfJWOmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 10:42:53 -0400
Received: by mail-qk1-f195.google.com with SMTP id u22so19945648qkk.11;
        Wed, 23 Oct 2019 07:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mu433qAoZLzCvpsIBkfu1/ordKCWjNtfzGpnRMeKU5o=;
        b=fdV6qjLpY9ipNmJBe2P+kdeZttcMJIJjrNBIRqefviX5t9OQcKfQJUnW7qjHaM9nzt
         a48FswxJJXH4ZIWJOG6GSnyuyWUEn+jskK9ubn1YaNCEmEKNa1/7S/zaQ891PF5bdHOp
         DcTJkQiJhBY23ADIC0W/lG7wflDXdX3xlvEIBF0NzizAY0UPeWFj4i6TCwTyNaabnoGV
         mymPxyWC8EW0G9z3Nqx5cBlyq1unGcYgheT39S74GvOrOTSFsXpVaj3Se2/18sxamQin
         QGN0zkkY+LHmV3CfrB9/Pi8wM2VRknSDsvNK1BLwZ5KG86MhYAALlrhGhhHEhjYL85ZB
         Nk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mu433qAoZLzCvpsIBkfu1/ordKCWjNtfzGpnRMeKU5o=;
        b=rd9QJMVmp0G0EpwUFCG5lEfnYHsKt+/NzTKOLxUAqpqJf7vqf9unl/xT7CvsJ7cbMG
         JKZfuWAIPSevWsWo8fGZo6Sp24VISF+VzrcLRebq+RLbaVfEBgNh9MFC4Lp4ssZyeS9q
         wfwqV+kWPW+9DySznxCBoe4fQnJzfWoWwsd//AP/7u//zMJ5A95gnGs4/kPx+hQQjztn
         yDewFboYvKoiJAaxczaCvIT0+zDm9HLTk+PFMq9j9hNQYmof4Wexf4xmuqnMqAB6JFMu
         Oxfu3y+TaNVK5ZtL9W8OiFYeKrjbOZOUn8BqilMqrvnjfpTitSPxAiLOhHLig6KlOm2J
         raXw==
X-Gm-Message-State: APjAAAXbA2FXpQ+HBTf0HXHQKPNKd6zND/y0s72X/SMrh70xaBWdEniF
        Se3VFP+Tj6mV7gFQd/PKPXl7LvLdgHshcg==
X-Google-Smtp-Source: APXvYqz6TzI7ZPgR09ZUVRZuDICGec4Er9bubjKtzgJpFcPmyJQ0RWP7wTqR8/1BCsZ63m78eUWJTA==
X-Received: by 2002:a05:620a:12d1:: with SMTP id e17mr9098042qkl.329.1571841771561;
        Wed, 23 Oct 2019 07:42:51 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id r36sm10522596qta.27.2019.10.23.07.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 07:42:50 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:42:46 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v15 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Message-ID: <20191023144245.GA4112@ebpf00.byteswizards.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-5-cneirabustos@gmail.com>
 <e3138bca-14b1-6fcf-12be-992462abe0ce@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3138bca-14b1-6fcf-12be-992462abe0ce@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 03:02:51AM +0000, Yonghong Song wrote:
> 
> 
> On 10/22/19 12:17 PM, Carlos Neira wrote:
> > Self tests added for new helper
> 
> Please mention the name of the new helper in the commit message.
> 
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> 
> LGTM Ack with a few nits below.
> Acked-by: Yonghong Song <yhs@fb.com>
> 
> > ---
> >   .../bpf/prog_tests/ns_current_pid_tgid.c      | 87 +++++++++++++++++++
> >   .../bpf/progs/test_ns_current_pid_tgid.c      | 37 ++++++++
> >   2 files changed, 124 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> > new file mode 100644
> > index 000000000000..257f18999bb6
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
> > @@ -0,0 +1,87 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> > +#include <test_progs.h>
> > +#include <sys/stat.h>
> > +#include <sys/types.h>
> > +#include <unistd.h>
> > +#include <sys/syscall.h>
> > +
> > +struct bss {
> > +	__u64 dev;
> > +	__u64 ino;
> > +	__u64 pid_tgid;
> > +	__u64 user_pid_tgid;
> > +};
> > +
> > +void test_ns_current_pid_tgid(void)
> > +{
> > +	const char *probe_name = "raw_tracepoint/sys_enter";
> > +	const char *file = "test_ns_current_pid_tgid.o";
> > +	int err, key = 0, duration = 0;
> > +	struct bpf_link *link = NULL;
> > +	struct bpf_program *prog;
> > +	struct bpf_map *bss_map;
> > +	struct bpf_object *obj;
> > +	struct bss bss;
> > +	struct stat st;
> > +	__u64 id;
> > +
> > +	obj = bpf_object__open_file(file, NULL);
> > +	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> > +		return;
> > +
> > +	err = bpf_object__load(obj);
> > +	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> > +		goto cleanup;
> > +
> > +	bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> > +	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> > +		goto cleanup;
> > +
> > +	prog = bpf_object__find_program_by_title(obj, probe_name);
> > +	if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
> > +		  probe_name))
> > +		goto cleanup;
> > +
> > +	memset(&bss, 0, sizeof(bss));
> > +	pid_t tid = syscall(SYS_gettid);
> > +	pid_t pid = getpid();
> > +
> > +	id = (__u64) tid << 32 | pid;
> > +	bss.user_pid_tgid = id;
> > +
> > +	if (CHECK_FAIL(stat("/proc/self/ns/pid", &st))) {
> > +		perror("Failed to stat /proc/self/ns/pid");
> > +		goto cleanup;
> > +	}
> > +
> > +	bss.dev = st.st_dev;
> > +	bss.ino = st.st_ino;
> > +
> > +	err = bpf_map_update_elem(bpf_map__fd(bss_map), &key, &bss, 0);
> > +	if (CHECK(err, "setting_bss", "failed to set bss : %d\n", err))
> > +		goto cleanup;
> > +
> > +	link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> > +	if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
> > +		  PTR_ERR(link)))
> > +		goto cleanup;
> 
> You already have default link = NULL.
> Here, I think you can do
> 		link = NULL;
> 		goto cleanup;
> 
> > +
> > +	/* trigger some syscalls */
> > +	usleep(1);
> > +
> > +	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> > +	if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> > +		goto cleanup;
> > +
> > +	if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs. bpf pid/tgid",
> > +		  "User pid/tgid %llu EBPF pid/tgid %llu\n", id, bss.pid_tgid))
> 
> EBPF -> BPF?
> 
> > +		goto cleanup;
> > +cleanup:
> > +
> 
> The above empty line can be removed.
> 
> > +	if (!IS_ERR_OR_NULL(link)) {
> 
> With the above suggested change, you only need to check
> 	if (!link)
> 
> > +		bpf_link__destroy(link);
> > +		link = NULL;
> > +	}
> > +	bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > new file mode 100644
> > index 000000000000..cdb77eb1a4fb
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
> > @@ -0,0 +1,37 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2019 Carlos Neira cneirabustos@gmail.com */
> > +
> > +#include <linux/bpf.h>
> > +#include <stdint.h>
> > +#include "bpf_helpers.h"
> > +
> > +static volatile struct {
> > +	__u64 dev;
> > +	__u64 ino;
> > +	__u64 pid_tgid;
> > +	__u64 user_pid_tgid;
> > +} res;
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int trace(void *ctx)
> > +{
> > +	__u64  ns_pid_tgid, expected_pid;
> > +	struct bpf_pidns_info nsdata;
> > +	__u32 key = 0;
> > +
> > +	if (bpf_get_ns_current_pid_tgid(res.dev, res.ino, &nsdata,
> > +		   sizeof(struct bpf_pidns_info)))
> > +		return 0;
> > +
> > +	ns_pid_tgid = (__u64)nsdata.tgid << 32 | nsdata.pid;
> > +	expected_pid = res.user_pid_tgid;
> > +
> > +	if (expected_pid != ns_pid_tgid)
> > +		return 0;
> > +
> > +	res.pid_tgid = ns_pid_tgid;
> > +
> > +	return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> 
> The new helper does not require GPL, could you double check this?
> The above _license should not be necessary.

Thanks, Yonghong.

Do I need to re-send the series of patches as v16 ? or I could reply to this thread addressing your comments for patch 4/5.
Thanks again for your support.

Bests 
