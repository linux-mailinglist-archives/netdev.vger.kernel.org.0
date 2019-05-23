Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1616B27558
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfEWFRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:17:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35506 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEWFRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:17:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N58bOa136530;
        Thu, 23 May 2019 05:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=YHmUkeaqmv1OOxNWaSvy+U5cIOirtzQ4CVGUc/PM624=;
 b=vJ+6qXiUAYAOUc2vALVQ800raEdyVY1BhDr0pKEtusn00E4Q9X1QrNcUQS4FiihW8Wq/
 MZ7GbtHcx8BXUtZKeP9KC1hQIgbHhTlNlRp9ba/B9W3xoy6EpCglz20WDBk3FVQnJc23
 2D6Xq4bpdm9h8ZTPq/TKV1Cng9Z5MCTC3zAZXuV0+Q6joCeHEnHr9IioEg0co8dv+FLt
 GtnqLFn4dho6yDFDs35R5YSHoyF7UJC3FTBlOIvb1Q7Xlf/L9t6xKfZiXf/aQGNO4T2J
 lBJ0MHqeBVTqqy5vvHnL+ZEZLSrmjFVoz3zZSykC2h9u0CFKpuQkJEfBT0CmSJ3D/i/7 +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2smsk57vvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:16:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N5FYGM027444;
        Thu, 23 May 2019 05:16:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2smsgt16dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 May 2019 05:16:15 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4N5GFn4028865;
        Thu, 23 May 2019 05:16:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2smsgt16ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:16:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4N5GBwq005662;
        Thu, 23 May 2019 05:16:11 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 05:16:11 +0000
Date:   Thu, 23 May 2019 01:16:08 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523051608.GP2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 01:16:25PM -0700, Alexei Starovoitov wrote:
> On Wed, May 22, 2019 at 12:12:53AM -0400, Kris Van Hees wrote:
> > 
> > Could you elaborate on why you believe my patches are not adding generic
> > features?  I can certainly agree that the DTrace-specific portions are less
> > generic (although they are certainly available for anyone to use), but I
> > don't quite understand why the new features are deemed non-generic and why
> > you believe no one else can use this?
> 
> And once again your statement above contradicts your own patches.
> The patch 2 adds new prog type BPF_PROG_TYPE_DTRACE and the rest of the patches
> are tying everything to it.
> This approach contradicts bpf philosophy of being generic execution engine
> and not favoriting one program type vs another.

I am not sure I understand where you see a contradiction.  What I posted is
a generic feature, and sample code that demonstrates how it can be used based
on the use-case that I am currently working on.  So yes, the sample code is
very specific but it does not restrict the use of the cross-prog-type tail-call
feature.  That feature is designed to be generic.

Probes come in different types (kprobe, tracepoint, perf event, ...) and they
each have their own very specific data associated with them.  I agree 100%
with you on that.  And sometimes tracing makes use of those specifics.  But
even from looking at the implementation of the various probe related prog
types (and e.g. the list of helpers they each support) it shows that there is
a lot of commonality as well.  That common functionality is common to all the
probe program types, and that is where I suggest introducing a program type
that captures the common concept of a probe, so perhaps a better name would
be BPF_PROG_TYPE_PROBE.

The principle remains the same though...  I am proposing adding support for
program types that provide common functionality so that programs for various
program types can make use of the more generic programs stored in prog arrays.

> I have nothing against dtrace language and dtrace scripts.
> Go ahead and compile them into bpf.
> All patches to improve bpf infrastructure are very welcomed.
> 
> In particular you brought up a good point that there is a use case
> for sharing a piece of bpf program between kprobe and tracepoint events.
> The better way to do that is via bpf2bpf call.
> Example:
> void bpf_subprog(arbitrary args)
> {
> }
> 
> SEC("kprobe/__set_task_comm")
> int bpf_prog_kprobe(struct pt_regs *ctx)
> {
>   bpf_subprog(...);
> }
> 
> SEC("tracepoint/sched/sched_switch")
> int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> {
>   bpf_subprog(...);
> }
> 
> Such configuration is not supported by the verifier yet.
> We've been discussing it for some time, but no work has started,
> since there was no concrete use case.
> If you can work on adding support for it everyone will benefit.
> 
> Could you please consider doing that as a step forward?

This definitely looks to be an interesting addition and I am happy to look into
that further.  I have a few questions that I hope you can shed light on...

1. What context would bpf_subprog execute with?  If it can be called from
   multiple different prog types, would it see whichever context the caller
   is executing with?  Or would you envision bpf_subprog to not be allowed to
   access the execution context because it cannot know which one is in use?

2. Given that BPF programs are loaded with a specification of the prog type, 
   how would one load a code construct as the one you outline above?  How can
   you load a BPF function and have it be used as subprog from programs that
   are loaded separately?  I.e. in the sample above, if bpf_subprog is loaded
   as part of loading bpf_prog_kprobe (prog type KPROBE), how can it be
   referenced from bpf_prog_tracepoint (prog type TRACEPOINT) which would be
   loaded separately?

	Cheers,
	Kris
