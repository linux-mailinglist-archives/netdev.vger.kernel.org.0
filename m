Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E8244A28
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgHNNHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:07:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgHNNHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 09:07:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ED3eOs142665;
        Fri, 14 Aug 2020 13:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=nlhg+MLUtNGE2qTI7BFjaYQJzmON0Z3UTG+f5DartME=;
 b=Nh3/fbhgX1yasIS+F1RZBXFeLh/pB+4UxSAftNlfBUk8I2rv8z3aKTqpY/iJRveIreY3
 xQyLmmsPbwslvLmdcoYpHO1IJCXaNQv+PQPhPkJvzuTbKpGeRXMWVvCIqF+eREnckdv1
 piatm3J6KSxfx+5eyf4mziEB15NuSUHM90rDXB9R2VDQar4LiwSJDqK5OqKBcHWfJCDF
 +XxfHoPhR8dpLW/yVjI+yzeAMKQJvLf4hP9dhyrIGDdqtfu1Z9meFSQT6QMUrAkKS8HF
 LUYVIsaaRr7X1o04Gb/DaGOskSgvfl4cQ4PBiwhbTpxSBf3sWMuUu/bRLiLlzJ2PHaST Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32sm0n6720-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Aug 2020 13:06:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ED3jfY096235;
        Fri, 14 Aug 2020 13:06:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32t5mt5xs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 13:06:52 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07ED6mQf000468;
        Fri, 14 Aug 2020 13:06:48 GMT
Received: from dhcp-10-175-169-217.vpn.oracle.com (/10.175.169.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 14 Aug 2020 13:06:48 +0000
Date:   Fri, 14 Aug 2020 14:06:37 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: make BTF show support generic,
 apply to seq files/bpf_trace_printk
In-Reply-To: <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2008141344560.6816@localhost>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com> <1596724945-22859-3-git-send-email-alan.maguire@oracle.com> <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=11
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008140099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9712 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=11 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020, Alexei Starovoitov wrote:

> On Thu, Aug 06, 2020 at 03:42:23PM +0100, Alan Maguire wrote:
> > 
> > The bpf_trace_printk tracepoint is augmented with a "trace_id"
> > field; it is used to allow tracepoint filtering as typed display
> > information can easily be interspersed with other tracing data,
> > making it hard to read.  Specifying a trace_id will allow users
> > to selectively trace data, eliminating noise.
> 
> Since trace_id is not seen in trace_pipe, how do you expect users
> to filter by it?

Sorry should have specified this.  The approach is to use trace
instances and filtering such that we only see events associated
with a specific trace_id.  There's no need for the trace event to
actually display the trace_id - it's still usable as a filter.
The steps involved are:

1. create a trace instance within which we can specify a fresh
   set of trace event enablings, filters etc.

mkdir /sys/kernel/debug/tracing/instances/traceid100

2. enable the filter for the specific trace id

echo "trace_id == 100" > 
/sys/kernel/debug/tracing/instances/traceid100/events/bpf_trace/bpf_trace_printk/filter

3. enable the trace event

echo 1 > 
/sys/kernel/debug/tracing/instances/events/bpf_trace/bpf_trace_printk/enable

4. ensure the BPF program uses a trace_id 100 when calling bpf_trace_btf()

So the above can be done for multiple programs; output can then
be separated for different programs if trace_ids and filtering are
used together. The above trace instance only sees bpf_trace_btf()
events which specify trace_id 100.

I've attached a tweaked version of the patch 4 in the patchset that 
ensures that a trace instance with filtering enabled as above sees
the bpf_trace_btf events, but _not_ bpf_trace_printk events (since
they have trace_id 0 by default).

To me the above provides a simple way to separate BPF program output
for simple BPF programs; ringbuf and perf events require a bit more
work in both BPF and userspace to support such coordination.  What do
you think - does this approach seem worth using? If so we could also
consider extending it to bpf_trace_printk(), if we can find a way
to provide a trace_id there too.
 
> It also feels like workaround. May be let bpf prog print the whole
> struct in one go with multiple new lines and call
> trace_bpf_trace_printk(buf) once?

We can do that absolutely, but I'd be interested to get your take
on the filtering mechanism before taking that approach.  I'll add
a description of the above mechanism to the cover letter and
patch to be clearer next time too.

> 
> Also please add interface into bpf_seq_printf.
> BTF enabled struct prints is useful for iterators too
> and generalization you've done in this patch pretty much takes it there.
> 

Sure, I'll try and tackle that next time.

> > +#define BTF_SHOW_COMPACT	(1ULL << 0)
> > +#define BTF_SHOW_NONAME		(1ULL << 1)
> > +#define BTF_SHOW_PTR_RAW	(1ULL << 2)
> > +#define BTF_SHOW_ZERO		(1ULL << 3)
> > +#define BTF_SHOW_NONEWLINE	(1ULL << 32)
> > +#define BTF_SHOW_UNSAFE		(1ULL << 33)
> 
> I could have missed it earlier, but what is the motivation to leave the gap
> in bits? Just do bit 4 and 5 ?
> 

Patch 3 uses the first 4 as flags to bpf_trace_btf();
the final two are not supported for the helper as flag values
so I wanted to leave some space for additional bpf_trace_btf() flags.
BTF_SHOW_NONEWLINE is always used for bpf_trace_btf(), since the
tracing adds a newline for us and we don't want to double up on newlines, 
so it's ORed in as an implicit argument for the bpf_trace_btf() case. 
BTF_SHOW_UNSAFE isn't allowed within BPF so it's not available as
a flag for the helper.

Thanks!

Alan

From 10bd268b2585084c8f35d1b6ab0c3df76203f5cc Mon Sep 17 00:00:00 2001
From: Alan Maguire <alan.maguire@oracle.com>
Date: Thu, 6 Aug 2020 14:21:10 +0200
Subject: [PATCH] selftests/bpf: add bpf_trace_btf helper tests

Basic tests verifying various flag combinations for bpf_trace_btf()
using a tp_btf program to trace skb data.  Also verify that we
can create a trace instance to filter trace data, using the
trace_id value passed to bpf_trace/bpf_trace_printk events.

trace_id is specifiable for bpf_trace_btf() so the test ensures
the trace instance sees the filtered events only.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/prog_tests/trace_btf.c | 150 +++++++++++++++++++++
 .../selftests/bpf/progs/netif_receive_skb.c        |  48 +++++++
 2 files changed, 198 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_btf.c b/tools/testing/selftests/bpf/prog_tests/trace_btf.c
new file mode 100644
index 0000000..64a920f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_btf.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+#include "netif_receive_skb.skel.h"
+
+#define TRACEFS		"/sys/kernel/debug/tracing/"
+#define TRACEBUF	TRACEFS "trace_pipe"
+#define TRACEID		"100"
+#define TRACEINST	TRACEFS "instances/traceid" TRACEID "/"
+#define TRACEINSTBUF	TRACEINST "trace_pipe"
+#define TRACEINSTEVENT	TRACEINST "events/bpf_trace/bpf_trace_printk/"
+#define BTFMSG		"(struct sk_buff)"
+#define PRINTKMSG	"testing,testing"
+#define MAXITER		1000
+
+static bool findmsg(FILE *fp, const char *msg)
+{
+	bool found = false;
+	char *buf = NULL;
+	size_t buflen;
+	int iter = 0;
+
+	/* verify our search string is in the trace buffer */
+	while (++iter < MAXITER &&
+	       (getline(&buf, &buflen, fp) >= 0 || errno == EAGAIN)) {
+		found = strstr(buf, msg) != NULL;
+		if (found)
+			break;
+	}
+	free(buf);
+
+	return found;
+}
+
+/* Demonstrate that bpf_trace_btf succeeds with non-zero return values,
+ * and that filtering by trace instance works.  bpf_trace_btf() is called
+ * with trace_id of 100, so we create a trace instance that enables 
+ * bpf_trace_printk() events and filters on trace_id.  The trace instance
+ * pipe should therefore only see the trace_id == 100 events, i.e. the
+ * bpf_trace_btf() events.  The bpf program also uses bpf_trace_printk() -
+ * we ensure the global trace_pipe sees those but the instance does not.
+ */
+void test_trace_btf(void)
+{
+	struct netif_receive_skb *skel;
+	struct netif_receive_skb__bss *bss;
+	FILE *fp = NULL, *fpinst = NULL;
+	int err, duration = 0;
+
+	skel = netif_receive_skb__open();
+	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+		return;
+
+	err = netif_receive_skb__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
+		goto cleanup;
+
+	bss = skel->bss;
+
+	err = netif_receive_skb__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* Enable trace instance which filters on trace id associated with
+	 * bpf_trace_btf().
+	 */
+	if (CHECK(system("mkdir " TRACEINST), "could not create trace instance",
+		  "error creating %s", TRACEINST))
+		goto cleanup;
+
+	if (CHECK(system("echo \"trace_id == " TRACEID "\" > " TRACEINSTEVENT "filter"),
+		  "could not specify trace id filter for %s", TRACEID))
+		goto cleanup;
+	if (CHECK(system("echo 1 > " TRACEINSTEVENT "enable"), "could not enable trace event",
+		  "error enabling %s", TRACEINSTEVENT))
+		goto cleanup;
+
+	fp = fopen(TRACEBUF, "r");
+	if (CHECK(fp == NULL, "could not open trace buffer",
+		  "error %d opening %s", errno, TRACEBUF))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fileno(fp), F_SETFL, O_NONBLOCK);
+
+	fpinst = fopen(TRACEINSTBUF, "r");
+	if (CHECK(fpinst == NULL, "could not open instance trace buffer",
+		  "error %d opening %s", errno, TRACEINSTBUF))
+		goto cleanup;
+
+	/* We do not want to wait forever if this test fails... */
+	fcntl(fileno(fpinst), F_SETFL, O_NONBLOCK);
+
+	/* generate receive event */
+	system("ping -c 1 127.0.0.1 > /dev/null");
+
+	/*
+	 * Make sure netif_receive_skb program was triggered
+	 * and it set expected return values from bpf_trace_printk()s
+	 * and all tests ran.
+	 */
+	if (CHECK(bss->ret <= 0,
+		  "bpf_trace_btf: got return value",
+		  "ret <= 0 %ld test %d\n", bss->ret, bss->num_subtests))
+		goto cleanup;
+
+	if (CHECK(bss->num_subtests != bss->ran_subtests, "check all subtests ran",
+	      "only ran %d of %d tests\n", bss->num_subtests,
+	      bss->ran_subtests))
+		goto cleanup;
+
+	/* All messages should be in global trace_pipe */
+	if (CHECK(!findmsg(fp, BTFMSG), "global trace pipe should have BTF",
+		  "btf data not in trace pipe"))
+		goto cleanup;
+
+
+	if (CHECK(!findmsg(fp, PRINTKMSG),
+		  "global trace pipe should have printk",
+		  "trace_printk data not in global trace pipe"))
+		goto cleanup;
+
+
+	if (CHECK(!findmsg(fpinst, BTFMSG),
+		  "instance trace pipe should have BTF",
+		  "btf data not in instance trace pipe"))
+		goto cleanup;
+
+
+	/* we filtered on trace id, so bpf_trace_printk() message should not
+	 * be in our trace instance log.
+	 */
+	CHECK(findmsg(fpinst, PRINTKMSG),
+	      "instance trace pipe should not have printk",
+	      "trace_printk data should not be in instance trace pipe");
+	
+cleanup:
+	if (fpinst)
+		 fclose(fpinst);
+	if (fp)
+		fclose(fp);
+
+	system("echo 0 > " TRACEINSTEVENT "enable");
+	system("rmdir " TRACEINST);
+	netif_receive_skb__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
new file mode 100644
index 0000000..a14f79b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Oracle and/or its affiliates. */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+long ret = 0;
+int num_subtests = 0;
+int ran_subtests = 0;
+
+/* Note a trace id of 100 is used, allowing filtering. */
+#define CHECK_TRACE(_p, flags)						 	\
+	do {								 	\
+		++num_subtests;						 	\
+		if (ret >= 0) {						 	\
+			++ran_subtests;					 	\
+			ret = bpf_trace_btf(_p, sizeof(*(_p)), 100, flags);	\
+		}							 	\
+	} while (0)
+
+/* TRACE_EVENT(netif_receive_skb,
+ *	TP_PROTO(struct sk_buff *skb),
+ */
+SEC("tp_btf/netif_receive_skb")
+int BPF_PROG(trace_netif_receive_skb, struct sk_buff *skb)
+{
+	static const char printkmsg[] = "testing,testing, ran %d so far...";
+	static const char skb_type[] = "struct sk_buff";
+	static struct btf_ptr p = { };
+
+	p.ptr = skb;
+	p.type = skb_type;
+
+	/* This message will go to the global tracing log */
+	bpf_trace_printk(printkmsg, sizeof(printkmsg), ran_subtests);
+
+	CHECK_TRACE(&p, 0);
+	CHECK_TRACE(&p, BTF_TRACE_F_COMPACT);
+	CHECK_TRACE(&p, BTF_TRACE_F_NONAME);
+	CHECK_TRACE(&p, BTF_TRACE_F_PTR_RAW);
+	CHECK_TRACE(&p, BTF_TRACE_F_ZERO);
+	CHECK_TRACE(&p, BTF_TRACE_F_COMPACT | BTF_TRACE_F_NONAME |
+		    BTF_TRACE_F_PTR_RAW | BTF_TRACE_F_ZERO);
+
+	return 0;
+}
-- 
1.8.3.1

