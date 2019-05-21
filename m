Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51C325A51
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfEUWaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:30:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfEUWaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:30:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LMTF8A075731;
        Tue, 21 May 2019 22:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=hfrehOtNeE26qUnFbETQxxYWak6GYzmEx+f/MxV9DFk=;
 b=QP1cuAFersfNktI/8hWpeTLIDdvI+baKZ5u/baPoQe47GpejWP7qiR1fn1hUU/L87yIe
 cUVpA+XHuIuj0I4mHfzgHFWh0xEdlzt32gGjsN3VgOHO9IpJYt5jrF1S7ZgBZjq55RYY
 T7EtNGHtZ0cdZ/QG0csIRBoHJFV0PXw9MJeYIYXZcJs3tg8JF5XI/BREX83LNkzdO4hZ
 QZYEKytGM4gw2wyZAlyiMgBtRBD1WfVqwIq6vStZirqkr2cAMJ40gFXTcHTa88aor3Uw
 fohwwOdvTGURUSVySlAPigCx6MtKux88qxoPeewvbviGABd9TSe1wjYO3DfF6BEZU7hI Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2smsk584t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 22:29:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LMThmT103151;
        Tue, 21 May 2019 22:29:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2smsgugj6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 22:29:55 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LMTtJ5103540;
        Tue, 21 May 2019 22:29:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2smsguggnd-442
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 22:29:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LLaqt9001622;
        Tue, 21 May 2019 21:36:52 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 21:36:51 +0000
Date:   Tue, 21 May 2019 17:36:49 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521213648.GK2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 01:55:34PM -0700, Alexei Starovoitov wrote:
> On Tue, May 21, 2019 at 02:41:37PM -0400, Kris Van Hees wrote:
> > On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > > On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> > > > 
> > > >     2. bpf: add BPF_PROG_TYPE_DTRACE
> > > > 
> > > > 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> > > > 	actually providing an implementation.  The actual implementation is
> > > > 	added in patch 4 (see below).  We do it this way because the
> > > > 	implementation is being added to the tracing subsystem as a component
> > > > 	that I would be happy to maintain (if merged) whereas the declaration
> > > > 	of the program type must be in the bpf subsystem.  Since the two
> > > > 	subsystems are maintained by different people, we split the
> > > > 	implementing patches across maintainer boundaries while ensuring that
> > > > 	the kernel remains buildable between patches.
> > > 
> > > None of these kernel patches are necessary for what you want to achieve.
> > 
> > I disagree.  The current support for BPF programs for probes associates a
> > specific BPF program type with a specific set of probes, which means that I
> > cannot write BPF programs based on a more general concept of a 'DTrace probe'
> > and provide functionality based on that.  It also means that if I have a D
> > clause (DTrace probe action code associated with probes) that is to be executed
> > for a list of probes of different types, I need to duplicate the program
> > because I cannot cross program type boundaries.
> 
> tracepoint vs kprobe vs raw_tracepoint vs perf event work on different input.
> There is no common denominator to them that can serve as single 'generic' context.
> We're working on the concept of bpf libraries where different bpf program
> with different types can call single bpf function with arbitrary arguments.
> This concept already works in bpf2bpf calls. We're working on extending it
> to different program types.
> You're more then welcome to help in that direction,
> but type casting of tracepoint into kprobe is no go.

I am happy to hear about the direction you are going in adding functionality.
Please note though that I am not type casting tracepoint into kprobe or
anything like that.  I am making it possible to transfer execution from
tracepoint, kprobe, raw-tracepoint, perf event, etc into a BPF program of
a different type (BPF_PROG_TYPE_DTRACE) which operates as a general probe
action execution program type.  It provides functionality that is used to
implement actions to be executed when a probe fires, independent of the
actual probe type that fired.

What you describe seems to me to be rather equivalent to what I already
implement in my patch.

> > The reasons for these patches is because I cannot do the same with the existing
> > implementation.  Yes, I can do some of it or use some workarounds to accomplish
> > kind of the same thing, but at the expense of not being able to do what I need
> > to do but rather do some kind of best effort alternative.  That is not the goal
> > here.
> 
> what you call 'workaround' other people call 'feature'.
> The kernel community doesn't accept extra code into the kernel
> when user space can do the same.

Sure, but userspace cannot do the same because in the case of DTrace much
of this needs to execute at the kernel level within the context of the probe
firing, because once you get back to userspace, the system has moved on.  We
need to capture information and perform processing of that information at the
time of probe firing.  I am spending quite a lot of my time in the design of
DTrace based on BPF and other kernel features to avoid adding more to the
kernel than is really needed, to certainly also to avoid duplicating code.

But I am not designing and implementing a new tracer - I am making an
existing one available based on existing features (as much as possible).  So,
something that comes close but doesn't quite do what we need is not a
solution.

> > > Feel free to add tools/dtrace/ directory and maintain it though.
> > 
> > Thank you.
> > 
> > > The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
> > > and no changes are necessary in kernel/events/ring_buffer.c either.
> > > tools/dtrace/ user space component can use either per-cpu array map
> > > or hash map as a buffer to store arbitrary data into and use
> > > existing bpf_perf_event_output() to send it to user space via perf ring buffer.
> > > 
> > > See, for example, how bpftrace does that.
> > 
> > When using bpf_perf_event_output() you need to construct the sample first,
> > and then send it off to user space using the perf ring-buffer.  That is extra
> > work that is unnecessary.  Also, storing arbitrary data from userspace in maps
> > is not relevant here because this is about data that is generated at the level
> > of the kernel and sent to userspace as part of the probe action that is
> > executed when the probe fires.
> > 
> > Bpftrace indeed uses maps and ways to construct the sample and then uses the
> > perf ring-buffer to pass data to userspace.  And that is not the way DTrace
> > works and that is not the mechanism that we need here,  So, while this may be
> > satisfactory for bpftrace, it is not for DTrace.  We need more fine-grained
> > control over how we write data to the buffer (doing direct stores from BPF
> > code) and without the overhead of constructing a complete sample that can just
> > be handed over to bpf_perf_event_output().
> 
> I think we're not on the same page vs how bpftrace and bpf_perf_event_output work.
> What you're proposing in these patches is _slower_ than existing mechanism.

How can it be slower?  Is a sequence of BPF store instructions, writing
directly to memory in the ring-buffer slower than using BPF store instructions
to write data into a temporary location from which data is then copied into
the ring-buffer by bpf_perf_event_output()?

Other than this, my implementation uses exactly the same functions at the
perf ring-buffer level as bpf_perf_event_output() does.  In my case, the
buffer reserve work is done with one helper, and the final commit is done
with another helper.  So yes, I use two helper calls vs one helper call if
you use bpf_perf_event_output() but as I mention above, I avoid the creation
and copying of the sample data.

> > Also, please note that I am not duplicating any kernel functionality when it
> > comes to buffer handling, and in fact, I found it very easy to be able to
> > tap into the perf event ring-buffer implementation and add a feature that I
> > need for DTrace.  That was a very pleasant experience for sure!
> 
> Let's agree to disagree. All I see is a code duplication and lack of understanding
> of existing bpf features.

Could you point out to me where you believe I am duplicating code?  I'd really
like to address that.

	Kris
