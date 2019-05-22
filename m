Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C775E25C92
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 06:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfEVEN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 00:13:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfEVEN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 00:13:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M48hlI102267;
        Wed, 22 May 2019 04:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=7HRLf3BezHIqpaBxypsQao+m1vPiNXUpQpY3syHj0HM=;
 b=F3ITnOwBRBNFjjwlXqS2iWI7UihpJa261STrq83+L0e0JA40p0Gsrv2zf1iCyk579Yg5
 MsXg6WTyVXj6w5BMB2O65fdrKRWIEUVVr5m9VnRRzgiT7EQAgd6yWsADbFWgYNk9/4hX
 4DRQAJnUHHd+i2MAoEVBHSaISYbcEQGaSxFcfoOvhhiRZgRbUOv9xrg6o+rD+k7uuCOo
 CRJwoNpq1O9DRaxOaZK/YcoitgPKtSCcRbc6mVvTGNRLlJ/kmDMpCdH3J/mEBc0kX2jo
 MobRhHy1YwFt9YOoiZL+LlVpsE/K/u83g+aOj2jDwjZ2P/oKzlWyIfsmtGFzf22ucs9E gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2smsk5918c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 04:13:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M4BeEl158656;
        Wed, 22 May 2019 04:13:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2smsgum05e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 May 2019 04:13:01 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4M4D1hx161149;
        Wed, 22 May 2019 04:13:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2smsgum050-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 04:13:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4M4CvbY010025;
        Wed, 22 May 2019 04:12:58 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 04:12:56 +0000
Date:   Wed, 22 May 2019 00:12:53 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522041253.GM2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 04:26:19PM -0700, Alexei Starovoitov wrote:
> On Tue, May 21, 2019 at 05:36:49PM -0400, Kris Van Hees wrote:
> > On Tue, May 21, 2019 at 01:55:34PM -0700, Alexei Starovoitov wrote:
> > > On Tue, May 21, 2019 at 02:41:37PM -0400, Kris Van Hees wrote:
> > > > On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > > > > On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> > > > > > 
> > > > > >     2. bpf: add BPF_PROG_TYPE_DTRACE
> > > > > > 
> > > > > > 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> > > > > > 	actually providing an implementation.  The actual implementation is
> > > > > > 	added in patch 4 (see below).  We do it this way because the
> > > > > > 	implementation is being added to the tracing subsystem as a component
> > > > > > 	that I would be happy to maintain (if merged) whereas the declaration
> > > > > > 	of the program type must be in the bpf subsystem.  Since the two
> > > > > > 	subsystems are maintained by different people, we split the
> > > > > > 	implementing patches across maintainer boundaries while ensuring that
> > > > > > 	the kernel remains buildable between patches.
> > > > > 
> > > > > None of these kernel patches are necessary for what you want to achieve.
> > > > 
> > > > I disagree.  The current support for BPF programs for probes associates a
> > > > specific BPF program type with a specific set of probes, which means that I
> > > > cannot write BPF programs based on a more general concept of a 'DTrace probe'
> > > > and provide functionality based on that.  It also means that if I have a D
> > > > clause (DTrace probe action code associated with probes) that is to be executed
> > > > for a list of probes of different types, I need to duplicate the program
> > > > because I cannot cross program type boundaries.
> > > 
> > > tracepoint vs kprobe vs raw_tracepoint vs perf event work on different input.
> > > There is no common denominator to them that can serve as single 'generic' context.
> > > We're working on the concept of bpf libraries where different bpf program
> > > with different types can call single bpf function with arbitrary arguments.
> > > This concept already works in bpf2bpf calls. We're working on extending it
> > > to different program types.
> > > You're more then welcome to help in that direction,
> > > but type casting of tracepoint into kprobe is no go.
> > 
> > I am happy to hear about the direction you are going in adding functionality.
> > Please note though that I am not type casting tracepoint into kprobe or
> > anything like that.  I am making it possible to transfer execution from
> > tracepoint, kprobe, raw-tracepoint, perf event, etc into a BPF program of
> > a different type (BPF_PROG_TYPE_DTRACE) which operates as a general probe
> > action execution program type.  It provides functionality that is used to
> > implement actions to be executed when a probe fires, independent of the
> > actual probe type that fired.
> > 
> > What you describe seems to me to be rather equivalent to what I already
> > implement in my patch.
> 
> except they're not.
> you're converting to one new prog type only that no one else can use.
> Whereas bpf infra is aiming to be as generic as possible and
> fit networking, tracing, security use case all at once.

Two points here...  the patch that implements cross-prog type tail-call support
is not specific to *any* specific prog type.  Each prog type can specify which
(if any) prog types is can receive calls from (and it can implement context
conversion code to carry any relevant info from the caller context into the
context for the callee).  There is nothing in that patch that is specific to
DTrace or any other prog type.

Then I also introduce a new prog type (not tied to any specific probe type) to
provide the ability to execute programs in a probe type independent context,
and it makes use of the cross-prog-type tail-call support in order to be able
to invoke programs in that probe-independent context from probe-specific BPF
programs.  And there is nothing that prevents anyone from using that new prog
type as well - it is available for use just like any other prog type that
already exists.

But I am confused...  the various probes you mentioned a few emails back
(kprobe, tracepoint, raw_tracepoint, perf event) each have their own BPF
program type associated with them (raw_tracepoint has two program types
serving it), which doesn't sound very generic.  But you are objecting to the
introduction of a generic prog type that can be used to execute programs
regardless of the probe type that caused the invocation because the bpf
infrastructure is aimed at being as generic as possible.

Could you elaborate on why you believe my patches are not adding generic
features?  I can certainly agree that the DTrace-specific portions are less
generic (although they are certainly available for anyone to use), but I
don't quite understand why the new features are deemed non-generic and why
you believe no one else can use this?

> > > > The reasons for these patches is because I cannot do the same with the existing
> > > > implementation.  Yes, I can do some of it or use some workarounds to accomplish
> > > > kind of the same thing, but at the expense of not being able to do what I need
> > > > to do but rather do some kind of best effort alternative.  That is not the goal
> > > > here.
> > > 
> > > what you call 'workaround' other people call 'feature'.
> > > The kernel community doesn't accept extra code into the kernel
> > > when user space can do the same.
> > 
> > Sure, but userspace cannot do the same because in the case of DTrace much
> > of this needs to execute at the kernel level within the context of the probe
> > firing, because once you get back to userspace, the system has moved on.  We
> > need to capture information and perform processing of that information at the
> > time of probe firing.  I am spending quite a lot of my time in the design of
> > DTrace based on BPF and other kernel features to avoid adding more to the
> > kernel than is really needed, to certainly also to avoid duplicating code.
> > 
> > But I am not designing and implementing a new tracer - I am making an
> > existing one available based on existing features (as much as possible).  So,
> > something that comes close but doesn't quite do what we need is not a
> > solution.
> 
> Your patches disagree with your words.
> This dtrace buffer is a redundant feature.
> per-cpu array plus perf_event_output achieve _exactly_ the same.

How can it be exactly the same when the per-cpu array plus perf_event_output
approach relies on memory to be allocated in the per-cpu array to be used as
scratch space for constructing the sample, and then that sample data gets
copied from the per-cpu array memory into the memory that was allocated for
the perf ring-buffer?  And my patch provides a way to write the data directly
into the perf ring-buffer, without the need for a scratch area to be allocated,
and without needing to copy the data from one memory chunk into another.

> > > > > Feel free to add tools/dtrace/ directory and maintain it though.
> > > > 
> > > > Thank you.
> > > > 
> > > > > The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
> > > > > and no changes are necessary in kernel/events/ring_buffer.c either.
> > > > > tools/dtrace/ user space component can use either per-cpu array map
> > > > > or hash map as a buffer to store arbitrary data into and use
> > > > > existing bpf_perf_event_output() to send it to user space via perf ring buffer.
> > > > > 
> > > > > See, for example, how bpftrace does that.
> > > > 
> > > > When using bpf_perf_event_output() you need to construct the sample first,
> > > > and then send it off to user space using the perf ring-buffer.  That is extra
> > > > work that is unnecessary.  Also, storing arbitrary data from userspace in maps
> > > > is not relevant here because this is about data that is generated at the level
> > > > of the kernel and sent to userspace as part of the probe action that is
> > > > executed when the probe fires.
> > > > 
> > > > Bpftrace indeed uses maps and ways to construct the sample and then uses the
> > > > perf ring-buffer to pass data to userspace.  And that is not the way DTrace
> > > > works and that is not the mechanism that we need here,  So, while this may be
> > > > satisfactory for bpftrace, it is not for DTrace.  We need more fine-grained
> > > > control over how we write data to the buffer (doing direct stores from BPF
> > > > code) and without the overhead of constructing a complete sample that can just
> > > > be handed over to bpf_perf_event_output().
> > > 
> > > I think we're not on the same page vs how bpftrace and bpf_perf_event_output work.
> > > What you're proposing in these patches is _slower_ than existing mechanism.
> > 
> > How can it be slower?  Is a sequence of BPF store instructions, writing
> > directly to memory in the ring-buffer slower than using BPF store instructions
> > to write data into a temporary location from which data is then copied into
> > the ring-buffer by bpf_perf_event_output()?
> > 
> > Other than this, my implementation uses exactly the same functions at the
> > perf ring-buffer level as bpf_perf_event_output() does.  In my case, the
> > buffer reserve work is done with one helper, and the final commit is done
> > with another helper.  So yes, I use two helper calls vs one helper call if
> > you use bpf_perf_event_output() but as I mention above, I avoid the creation
> > and copying of the sample data.
> 
> What stops you from using per-cpu array and perf_event_output?
> No 'reserve' call necessary. lookup from per-cpu array gives a pointer
> to large buffer that can be feed into perf_event_output.
> It's also faster for small buffers and has no issues with multi-page.
> No hacks on perf side necessary.

Please see my comments above.  And please note that aside from the overhead of
making one extra helper call (buffer_reserve), my implementation uses the very
functions that are used to implement perf_event_output.  The only difference
is that the first half of perf_event_output (reserving the needed space in the
ring-buffer - not something I came up with - it already gets done for every
write operation to the ring-buffer) gets done from buffer_reserve, and the last
part (recording the new head in the ring-buffer so userspace can see it) is
done form buffer_commit.  Yes, there is a little bit of extra code involved
because the ring-buffer is usually comprised of non-contiguous pages, but
that extra code is minimal.  The real difference with just using
perf_event_output is that perf_event_output copies a chunk of data from a
given memory location into the ring-buffer whereas my implementation places
the data into the ring-buffer directly using BPF store instructions.

The DTrace userspace implementation has an established format in which the
probe data is expected to be found in the buffer.  My proposed (minimal)
extension to the perf ring-buffer code makes it possible to write data into
the ring-buffer in the expected format.  This is not possible by simply using
perf_event_output because that adds a header to the sample data.

> > > > Also, please note that I am not duplicating any kernel functionality when it
> > > > comes to buffer handling, and in fact, I found it very easy to be able to
> > > > tap into the perf event ring-buffer implementation and add a feature that I
> > > > need for DTrace.  That was a very pleasant experience for sure!
> > > 
> > > Let's agree to disagree. All I see is a code duplication and lack of understanding
> > > of existing bpf features.
> > 
> > Could you point out to me where you believe I am duplicating code?  I'd really
> > like to address that.
> 
> see above.
