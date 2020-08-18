Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CC62481A6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgHRJPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:15:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRJPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:15:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I9DP2v034473;
        Tue, 18 Aug 2020 09:14:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bODkJj/SYYVTqZjf0h99hHqVYgZyhbZHfVzYRtKndNU=;
 b=cDzWxBOzDAfGmrlVpBY8U6MQrsSXYJfpVti+6XDdX+NuNmdKl9krxmYmOOy2BK6BSjuf
 Mik21QRTyeKmrMvFf+2JIzIta1HnByz5R3UEnDk5PkomJlUrARRB1r+VUcKpn9XsqMvg
 IROz1n6dPLMP8JSFUuRzqGPVCq8NDBkygRzH/7ais2DCMhZ+WrR+JnLIuOFXlOgfVG9z
 26IwEw9JE56qQcp50xZ5Iyh1D4A0y7MBOICPkXj9IEd3Ag3Tc4foTuvyYEwQbrA4Uy8S
 2Sl2ENDNYQ31o4I6+3QD37w+n1Vt8fNkPU4G2byj0td/YfZUn+xC2QlKjinp2inv5utO fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmbjkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 09:14:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I98Cv1084323;
        Tue, 18 Aug 2020 09:12:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32xsfrmy3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 09:12:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I9CK7A026936;
        Tue, 18 Aug 2020 09:12:20 GMT
Received: from dhcp-10-175-204-131.vpn.oracle.com (/10.175.204.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 02:12:19 -0700
Date:   Tue, 18 Aug 2020 10:12:05 +0100 (IST)
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
In-Reply-To: <20200814170120.q5gcmlapm7aldmzg@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2008180945380.3461@localhost>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com> <1596724945-22859-3-git-send-email-alan.maguire@oracle.com> <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com> <alpine.LRH.2.21.2008141344560.6816@localhost>
 <20200814170120.q5gcmlapm7aldmzg@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=3 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 14 Aug 2020, Alexei Starovoitov wrote:

> On Fri, Aug 14, 2020 at 02:06:37PM +0100, Alan Maguire wrote:
> > On Wed, 12 Aug 2020, Alexei Starovoitov wrote:
> > 
> > > On Thu, Aug 06, 2020 at 03:42:23PM +0100, Alan Maguire wrote:
> > > > 
> > > > The bpf_trace_printk tracepoint is augmented with a "trace_id"
> > > > field; it is used to allow tracepoint filtering as typed display
> > > > information can easily be interspersed with other tracing data,
> > > > making it hard to read.  Specifying a trace_id will allow users
> > > > to selectively trace data, eliminating noise.
> > > 
> > > Since trace_id is not seen in trace_pipe, how do you expect users
> > > to filter by it?
> > 
> > Sorry should have specified this.  The approach is to use trace
> > instances and filtering such that we only see events associated
> > with a specific trace_id.  There's no need for the trace event to
> > actually display the trace_id - it's still usable as a filter.
> > The steps involved are:
> > 
> > 1. create a trace instance within which we can specify a fresh
> >    set of trace event enablings, filters etc.
> > 
> > mkdir /sys/kernel/debug/tracing/instances/traceid100
> > 
> > 2. enable the filter for the specific trace id
> > 
> > echo "trace_id == 100" > 
> > /sys/kernel/debug/tracing/instances/traceid100/events/bpf_trace/bpf_trace_printk/filter
> > 
> > 3. enable the trace event
> > 
> > echo 1 > 
> > /sys/kernel/debug/tracing/instances/events/bpf_trace/bpf_trace_printk/enable
> > 
> > 4. ensure the BPF program uses a trace_id 100 when calling bpf_trace_btf()
> 
> ouch.
> I think you interpreted the acceptance of the
> commit 7fb20f9e901e ("bpf, doc: Remove references to warning message when using bpf_trace_printk()")
> in the wrong way.
> 
> Everything that doc had said is still valid. In particular:
> -A: This is done to nudge program authors into better interfaces when
> -programs need to pass data to user space. Like bpf_perf_event_output()
> -can be used to efficiently stream data via perf ring buffer.
> -BPF maps can be used for asynchronous data sharing between kernel
> -and user space. bpf_trace_printk() should only be used for debugging.
> 
> bpf_trace_printk is for debugging only. _debugging of bpf programs themselves_.
> What you're describing above is logging and tracing. It's not debugging of programs.
> perf buffer, ring buffer, and seq_file interfaces are the right
> interfaces for tracing, logging, and kernel debugging.
> 
> > > It also feels like workaround. May be let bpf prog print the whole
> > > struct in one go with multiple new lines and call
> > > trace_bpf_trace_printk(buf) once?
> > 
> > We can do that absolutely, but I'd be interested to get your take
> > on the filtering mechanism before taking that approach.  I'll add
> > a description of the above mechanism to the cover letter and
> > patch to be clearer next time too.
> 
> I think patch 3 is no go, because it takes bpf_trace_printk in
> the wrong direction.
> Instead please refactor it to use string buffer or seq_file as an output.

Fair enough. I'm thinking a helper like

long bpf_btf_snprintf(char *str, u32 str_size, struct btf_ptr *ptr,
		      u32 ptr_size, u64 flags);

Then the user can choose perf event or ringbuf interfaces
to share the results with userspace.

> If the user happen to use bpf_trace_printk("%s", buf);
> after that to print that string buffer to trace_pipe that's user's choice.
> I can see such use case when program author wants to debug
> their bpf program. That's fine. But for kernel debugging, on demand and
> "always on" logging and tracing the documentation should point
> to sustainable interfaces that don't interfere with each other,
> can be run in parallel by multiple users, etc.
> 

The problem with bpf_trace_printk() under this approach is
that the string size for %s arguments is very limited;
bpf_trace_printk() restricts these to 64 bytes in size.
Looks like bpf_seq_printf() restricts a %s string to 128
bytes also.  We could add an additional helper for the 
bpf_seq case which calls bpf_seq_printf() for each component
in the object, i.e.

long bpf_seq_btf_printf(struct seq_file *m, struct btf_ptr *ptr,
			u32 ptr_size, u64 flags);

This would steer users away from bpf_trace_printk()
for this use case - since it can print only a small
amount of the string - while supporting all 
the other user-space communication mechanisms.

Alan
