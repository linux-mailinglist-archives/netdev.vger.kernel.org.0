Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45BA28FCD
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 06:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfEXEGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 00:06:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfEXEGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 00:06:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O43pD0068348;
        Fri, 24 May 2019 04:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=GCTsI00gkNvHBP4Xpk/j0wuaNXUl5LjVwQVHtGmjRyU=;
 b=ocHCDk5DdkOxbzHxWTr4+wIHXxwBq2vHM7kuECEQlftnbtOWhqdtE7Syft5Jsd5/MndE
 64IG8H40SCsXKansF2xDHMW31I7x/Obutno8Zz+dSN/IjFp6NL3t3OnbTQWvt4S5YyFb
 SU5TbxBsCLvhMoIaGVkEXpQDxYZL+rKWJbW0clZj1D4vzt5O3l+Nbb2B5VRPSamV6QQ5
 bHTMzYF5uyIYLCJiGcoMnd5lieCnQexED7oaXJZlNtVQND2+v3crsn4oFb+O5sZVANYf
 iltccHN5E8Z40977hvVEg/5kzrBzMAg2tShTPRRnHcYmFwP4FJSryfH7EBTsMwC7tt0Q ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2smsk5pc4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 04:05:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4O43krk107841;
        Fri, 24 May 2019 04:05:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2smsgvvhcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 May 2019 04:05:37 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4O45alM113125;
        Fri, 24 May 2019 04:05:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2smsgvvhcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 May 2019 04:05:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4O45YEk025803;
        Fri, 24 May 2019 04:05:34 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 May 2019 04:05:33 +0000
Date:   Fri, 24 May 2019 00:05:27 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524040527.GU2422@oracle.com>
References: <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
 <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905240026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 02:13:31PM -0700, Alexei Starovoitov wrote:
> On Thu, May 23, 2019 at 01:46:10AM -0400, Kris Van Hees wrote:
> > 
> > I think there is a difference between a solution and a good solution.  Adding
> > a lot of knowledge in the userspace component about how things are imeplemented
> > at the kernel level makes for a more fragile infrastructure and involves
> > breaking down well established boundaries in DTrace that are part of the design
> > specifically to ensure that userspace doesn't need to depend on such intimate
> > knowledge.
> 
> argh. see more below. This is fundamental disagreement.
> 
> > > > Another advantage of being able to operate on a more abstract probe concept
> > > > that is not tied to a specific probe type is that the userspace component does
> > > > not need to know about the implementation details of the specific probes.
> > > 
> > > If that is indeed the case that dtrace is broken _by design_
> > > and nothing on the kernel side can fix it.
> > > 
> > > bpf prog attached to NMI is running in NMI.
> > > That is very different execution context vs kprobe.
> > > kprobe execution context is also different from syscall.
> > > 
> > > The user writing the script has to be aware in what context
> > > that script will be executing.
> > 
> > The design behind DTrace definitely recognizes that different types of probes
> > operate in different ways and have different data associated with them.  That
> > is why probes (in legacy DTrace) are managed by providers, one for each type
> > of probe.  The providers handle the specifics of a probe type, and provide a
> > generic probe API to the processing component of DTrace:
> > 
> >     SDT probes -----> SDT provider -------+
> >                                           |
> >     FBT probes -----> FBT provider -------+--> DTrace engine
> >                                           |
> >     syscall probes -> systrace provider --+
> > 
> > This means that the DTrace processing component can be implemented based on a
> > generic probe concept, and the providers will take care of the specifics.  In
> > that sense, it is similar to so many other parts of the kernel where a generic
> > API is exposed so that higher level components don't need to know implementation
> > details.
> > 
> > In DTrace, people write scripts based on UAPI-style interfaces and they don't
> > have to concern themselves with e.g. knowing how to get the value of the 3rd
> > argument that was passed by the firing probe.  All they need to know is that
> > the probe will have a 3rd argument, and that the 3rd argument to *any* probe
> > can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
> > capable of providing that).  Different probes have different ways of passing
> > arguments, and only the provider code for each probe type needs to know how
> > to retrieve the argument values.
> > 
> > Does this help bring clarity to the reasons why an abstract (generic) probe
> > concept is part of DTrace's design?
> 
> It actually sounds worse than I thought.
> If dtrace script reads some kernel field it's considered to be uapi?! ouch.
> It means dtrace development philosophy is incompatible with the linux kernel.
> There is no way kernel is going to bend itself to make dtrace scripts
> runnable if that means that all dtrace accessible fields become uapi.

No, no, that is not at all what I am saying.  In DTrace, the particulars of
how you get to e.g. probe arguments or current task information are not
something that script writers need to concern themselves about.  Similar to
how BPF contexts have a public (uapi) declaration and a kernel-level context
declaration taht is used to actually implement accessing the data (using the
is_valid_access and convert_ctx_access functions that prog types implement).
DTrace exposes an abstract probe entity to script writers where they can
access probe arguments as arg0 through arg9.  Nothing in the userspace needs
to know how you obtain the value of those arguments.  So, scripts can be
written for any kind of probe, and the only information that is used to
verify programs is obtained from the abstract probe description (things like
its unique id, number of arguments, and possible type information for each
argument).  The knowledge of how to get to the value of the probe arguments
is only known at the level of the kernel, so that when the implementation of
the probe in the kernel is modified, the mapping from actual probe to abstract
representation of the probe (in the kernel) can be modified along with it,
and userspace won't even notice that anything changed.

Many parts of the kernel work the same way.  E.g. file system implementations
change, yet the API to use the file systems remains the same.

> In stark contrast to dtrace all of bpf tracing scripts (bcc scripts
> and bpftrace scripts) are written for specific kernel with intimate
> knowledge of kernel details. They do break all the time when kernel changes.
> kprobe and tracepoints are NOT uapi. All of them can change.
> tracepoints are a bit more stable than kprobes, but they are not uapi.

Sure, and I understand why.  And in DTrace, there is an extra layer in the
design of the tracing framework that isolates implementation changes at the
level of the probes from what is exposed to userspace.  That way changes can
be made at the kernel level without worrying about the implications for
userspace.  Of course one can simply not care about userspace altogether,
whether there is an abstraction in place or not, but the added bonus of the
abstraction is that not caring about userspace won't affect userspace much :)

By the way, the point behind this design is also that it doesn't enforce the
use of that abstraction.  Nothing prevents people from using probes directly.
But it provides a generic probe concept that isolates the probe implementation
details from the tracing tool.
