Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9648D27563
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfEWFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:20:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfEWFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:20:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N5Ixe3130166;
        Thu, 23 May 2019 05:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=pH8VdY/mb5VHXZ7P2iO2Ynlr34Utx1j6uwMP/dmBjUU=;
 b=TvxsMjqK7E7fjg6ZwqgS4u94YWPvZ6hTHs//r0Na+mv2weRJIid5ojZRTkFsptJobR58
 UUdBnsqyDKn/CXt0Olx4IMd2LBIESu7B12DvLoq7B4EjMEeUYsYvB3BTWraLurN+xoSD
 IqNuTOIKL8PDPYjwwrZ39qhTUUfkYDhB/Nl7W2BLgDNhDSqSJmLcSKwQLbpjXHlneobq
 2O+7cr0ZIYPaovpHiGyPaOIMvI/Say7RBF/0lI3LdjtzK12uwteYzuF+SIwyXE9H+d7i
 8qpRljtzVJxdHmImycVjQQlOAuDltR/F18rJiMgrhgrQUj5Do+nHLgV9oxnhIRppPkYf OQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2smsk5fvau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:19:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N5J64o159989;
        Thu, 23 May 2019 05:19:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2smshf121f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 May 2019 05:19:22 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4N5JM3q160229;
        Thu, 23 May 2019 05:19:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2smshf1219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 05:19:22 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4N5JJhB010871;
        Thu, 23 May 2019 05:19:21 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 05:19:18 +0000
Date:   Thu, 23 May 2019 01:19:16 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523051916.GQ2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190522142531.GE16275@worktop.programming.kicks-ass.net>
 <20190522182215.GO2422@oracle.com>
 <20190522195526.mayamzc7gstqzcpr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522195526.mayamzc7gstqzcpr@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 12:55:27PM -0700, Alexei Starovoitov wrote:
> On Wed, May 22, 2019 at 02:22:15PM -0400, Kris Van Hees wrote:
> > On Wed, May 22, 2019 at 04:25:32PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > > 
> > > > and no changes are necessary in kernel/events/ring_buffer.c either.
> > > 
> > > Let me just NAK them on the principle that I don't see them in my inbox.
> > 
> > My apologies for failing to include you on the Cc for the patches.  That was
> > an oversight on my end and certainly not intentional.
> > 
> > > Let me further NAK it for adding all sorts of garbage to the code --
> > > we're not going to do gaps and stay_in_page nonsense.
> > 
> > Could you give some guidance in terms of an alternative?  The ring buffer code
> > provides both non-contiguous page allocation support and a vmalloc-based
> > allocation, and the vmalloc version certainly would avoid the entire gap and
> > page boundary stuff.  But since the allocator is chosen at build time based on
> > the arch capabilities, there is no way to select a specific memory allocator.
> > I'd be happy to use an alternative approach that allows direct writing into
> > the ring buffer.
> 
> You do not _need_ direct write from bpf prog.
> dtrace language doesn't mandate direct write.
> 'direct write into ring buffer form bpf prog' is an interesting idea and
> may be nice performance optimization, but in no way it's a blocker for dtrace scripts.
> Also it's far from clear that it actually brings performance benefits.
> Letting bpf progs write directly into ring buffer comes with
> a lot of corner cases. It's something to carefully analyze.

I agree that doing direct writes is something that can be deferred right now,
especially because there are more fundamental things to focus on.  Thank you
for your acknowledgement of the idea, and I certainly look forward to exploring
this further at a later time,

> I suggest to proceed with user space dtrace conversion to bpf
> without introducing kernel changes.
