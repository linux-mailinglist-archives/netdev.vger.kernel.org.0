Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18D4257B7
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 20:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbfEUSoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 14:44:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbfEUSoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 14:44:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LIcXvZ101084;
        Tue, 21 May 2019 18:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=TNyL8LpIbOB4LoFMqrfRxE8ZeFvo438h9vL46i7IfL8=;
 b=ElKbZ4czVRuis3YinIVdhot4CeceOrkC7Uc5X51zATLnYt6VqBqdIy1f3Xrg9dsnKMtk
 s47WaZXBw0tMWP9P8zzJ5ohYPqM+kb/dD36WWvclhVDioQOx8ge/zBqQVgAMSTeY3bwC
 7uu0l6h8q8EqMKT27pVkm5X40BLCymj68q2HgqoOnph+kBC5E7uIAaa9TV7uDgmYIbuz
 Yn5BwFU8D2zy52lyWqjEWOE3pMSe7hiEQTDncUwbJ7Iml/EQl7+MAfYeik0+wbAzpZZm
 ywFLL0x4ElJS+B+pNk3BnDeMBnlL2X4QGtXsMEc8Fa29aXeHGMc+5JgmC5Et5OlUKFYQ BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapqf9pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 18:43:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LIfUgm051904;
        Tue, 21 May 2019 18:41:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1yc2cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 18:41:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LIfi04052401;
        Tue, 21 May 2019 18:41:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sks1yc2cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 18:41:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LIfept013238;
        Tue, 21 May 2019 18:41:41 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 18:41:40 +0000
Date:   Tue, 21 May 2019 14:41:37 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521184137.GH2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> > 
> >     2. bpf: add BPF_PROG_TYPE_DTRACE
> > 
> > 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> > 	actually providing an implementation.  The actual implementation is
> > 	added in patch 4 (see below).  We do it this way because the
> > 	implementation is being added to the tracing subsystem as a component
> > 	that I would be happy to maintain (if merged) whereas the declaration
> > 	of the program type must be in the bpf subsystem.  Since the two
> > 	subsystems are maintained by different people, we split the
> > 	implementing patches across maintainer boundaries while ensuring that
> > 	the kernel remains buildable between patches.
> 
> None of these kernel patches are necessary for what you want to achieve.

I disagree.  The current support for BPF programs for probes associates a
specific BPF program type with a specific set of probes, which means that I
cannot write BPF programs based on a more general concept of a 'DTrace probe'
and provide functionality based on that.  It also means that if I have a D
clause (DTrace probe action code associated with probes) that is to be executed
for a list of probes of different types, I need to duplicate the program
because I cannot cross program type boundaries.

By implementing a program type for DTrace, and making it possible for
tail-calls to be made from various probe-specific program types to the DTrace
program type, I can accomplish what I described above.  More details are in
the cover letter and the commit messages of the individual patches.

The reasons for these patches is because I cannot do the same with the existing
implementation.  Yes, I can do some of it or use some workarounds to accomplish
kind of the same thing, but at the expense of not being able to do what I need
to do but rather do some kind of best effort alternative.  That is not the goal
here.

> Feel free to add tools/dtrace/ directory and maintain it though.

Thank you.

> The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
> and no changes are necessary in kernel/events/ring_buffer.c either.
> tools/dtrace/ user space component can use either per-cpu array map
> or hash map as a buffer to store arbitrary data into and use
> existing bpf_perf_event_output() to send it to user space via perf ring buffer.
> 
> See, for example, how bpftrace does that.

When using bpf_perf_event_output() you need to construct the sample first,
and then send it off to user space using the perf ring-buffer.  That is extra
work that is unnecessary.  Also, storing arbitrary data from userspace in maps
is not relevant here because this is about data that is generated at the level
of the kernel and sent to userspace as part of the probe action that is
executed when the probe fires.

Bpftrace indeed uses maps and ways to construct the sample and then uses the
perf ring-buffer to pass data to userspace.  And that is not the way DTrace
works and that is not the mechanism that we need here,  So, while this may be
satisfactory for bpftrace, it is not for DTrace.  We need more fine-grained
control over how we write data to the buffer (doing direct stores from BPF
code) and without the overhead of constructing a complete sample that can just
be handed over to bpf_perf_event_output().

Also, please note that I am not duplicating any kernel functionality when it
comes to buffer handling, and in fact, I found it very easy to be able to
tap into the perf event ring-buffer implementation and add a feature that I
need for DTrace.  That was a very pleasant experience for sure!

Kris
