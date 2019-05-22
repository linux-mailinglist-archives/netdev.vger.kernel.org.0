Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF925D8C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 07:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfEVFYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 01:24:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58180 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEVFYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 01:24:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M5EDBu160383;
        Wed, 22 May 2019 05:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=7yB1jRRKfJaTqC5CwIRJSAlMgBo0pt+Z3oKjydQnMbA=;
 b=Pdf6HkCpfujIhOnSEKRQckBYu+cLerSuyaUTvpy5Ji9HaoLNXsfTUr+fQErYVTc0qiiJ
 ZvzrCdv/4uxLdg369gHvAaTKruY3BmENC6m5HGe1U08UU85i3St1WVNSWWRAypdhucS+
 8O41vongb2zciolGPc6rpqYNgA65IO3TWS+uyKY0olBdUO2rpdDOaK2yEvY2lj6plLV3
 C5t3Bcwi1Tca6Xk097sYBlil6dfgeNXAGwqnbxK52bmY94xK8Pq44DEj+PjH+FbJZaTC
 d1CV8v1t868VUFq9SKSXNCd20+C3mhyXkfw1zMU9jm/KEqQqN8hBj9XdwLgcCrkFniJJ Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2smsk597sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 05:23:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4M5N9IU133624;
        Wed, 22 May 2019 05:23:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2smshecvjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 May 2019 05:23:33 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4M5NXYZ134191;
        Wed, 22 May 2019 05:23:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2smshecvjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 05:23:33 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4M5NUSL027017;
        Wed, 22 May 2019 05:23:30 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 05:23:30 +0000
Date:   Wed, 22 May 2019 01:23:27 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522052327.GN2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521174757.74ec8937@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 05:48:11PM -0400, Steven Rostedt wrote:
> On Tue, 21 May 2019 14:43:26 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > Steve,
> > sounds like you've missed all prior threads.
> 
> I probably have missed them ;-)
> 
> > The feedback was given to Kris it was very clear:
> > implement dtrace the same way as bpftrace is working with bpf.
> > No changes are necessary to dtrace scripts
> > and no kernel changes are necessary.
> 
> Kris, I haven't been keeping up on all the discussions. But what
> exactly is the issue where Dtrace can't be done the same way as the
> bpftrace is done?

There are several issues (and I keep finding new ones as I move forward) but
the biggest one is that I am not trying to re-design and re-implement) DTrace
from the ground up.  We have an existing userspace component that is getting
modified to work with a new kernel implementation (based on BPF and various
other kernel features that are thankfully available these days).  But we need
to ensure that the userspace component continues to function exactly as one
would expect.  There should be no need to modify DTrace scripts.  Perhaps
bpftrace could be taught to parse DTrace scripts (i.e. implement the D script
language with all its bells and whistles) but it currently cannot and DTrace
obviously can.  It seems to be a better use of resources to focus on the
kernel component, where we can really provide a much cleaner implementation
for DTrace probe execution because BPF is available and very powerful.

Userspace aside, there are various features that are not currently available
such as retrieving the ppid of the current task, and various other data items
that relate to the current task that triggered a probe.  There are ways to
work around it (using the bpf_probe_read() helper, which actually performs a
probe_kernel_read()) but that is rather clunky and definitely shouldn't be
something that can be done from a BPF program if we're doing unprivileged
tracing (which is a goal that is important for us).  New helpers can be added
for things like this, but the list grows large very quickly once you look at
what information DTrace scripts tend to use.

One of the benefits of DTrace is that probes are largely abstracted entities
when you get to the script level.  While different probes provide different
data, they are all represented as probe arguments and they are accessed in a
very consistent manner that is independent from the actual kind of probe that
triggered the execution.  Often, a single DTrace clause is associated with
multiple probes, of different types.  Probes in the kernel (kprobe, perf event,
tracepoint, ...) are associated with their own BPF program type, so it is not
possible to load the DTrace clause (translated into BPF code) once and
associate it with probes of different types.  Instead, I'd have to load it
as a BPF_PROG_TYPE_KPROBE program to associate it with a kprobe, and I'd have
to load it as a BPF_PROG_TYPE_TRACEPOINT program to associate it with a
tracepoint, and so on.  This also means that I suddenly have to add code to
the userspace component to know about the different program types with more
detail, like what helpers are available to specific program types.

Another advantage of being able to operate on a more abstract probe concept
that is not tied to a specific probe type is that the userspace component does
not need to know about the implementation details of the specific probes.
This avoids a tight coupling between the userspace component and the kernel
implementation.

Another feature that is currently not supported is speculative tracing.  This
is a feature that is not as commonly used (although I personally have found it
to be very useful in the past couple of years) but it quite powerful because
it allows for probe data to be recorded, and have the decision on whether it
is to be made available to userspace postponed to a later event.  At that time,
the data can be discarded or committed.

These are just some examples of issues I have been working on.  I spent quite
a bit of time to look for ways to implement what we need for DTrace with a
minimal amount of patches to the kernel because there really isn't any point
in doing unnecessary work.  I do not doubt that there are possible clever
ways to somehow get around some of these issues with clever hacks and
workarounds, but I am not trying to hack something together that hopefully
will be close enough to the expected functionality.

DTrace has proven itself to be quite useful and dependable as a tracing
solution, and I am working on continuing to deliver on that while recognizing
the significant work that others have put into advancing the tracing
infrastructure in Linux in recent years.  So many people have contributed
excellent features - and I am making use of those features as much as I can.
But as is often the case, not everything that I need is currently implemented.
As I expressed during last year's Plumbers in Vancouver, I am putting a very
strong emphasis on ensuring that what I propose as contributions is not
limited to just DTrace.  My goal is to work in an open, collaborative manner,
providing features that anyone can use if they want to.

I wish that the assertion that "no changes are necessary to dtrace scripts and
no kernel changes are necessary" were true, but my own findings contradict
that.  To my knowledge no tool exists right now that can execute any and all
valid DTrace scripts without any changes to the scripts and without any changes
to the kernel.  The only tool I know that can execute DTrace scripts right now
does require rather extensive kernel changes, and the work I am doing right now
is aimed at doing much better than that.

	Kris
