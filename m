Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC476267F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfGHQjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:39:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49986 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfGHQja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:39:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68GXjUi132033;
        Mon, 8 Jul 2019 16:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=IxnXRwFEVsBRcHWVY1AUPNtwkkxS39pGXrbWoyZ4Lsw=;
 b=Fp/JXrr1F/US89eAFmDqwrjS5ytA2Bk6p9MCtg0f8xvvLnuii2vH0qVLYDh2iG1Pgsvp
 Fhxa+zbXiqx4pVSX/XEfKdW/QnzSIGKWigQCN9GJzeZNb6UN47/xRrPf0Pv3E5uQH5QN
 DGAd/lg2Fi1JkHfP6mH737oN8ApJAkF97iZae7Or4Ofc//AViLIGwoY6mm5g67XIqxk3
 dupyan40rxoQuHvCz6S9fL1fTbIqEmA2uxnFGktXJbZIC9Z+Wof/QKAQyVcQdKcHxSL2
 9jT+IUMbvpNJ8yotyKnJN3Nty5H8nInzmilFW1bylL95WAwJjttP2LbHIk94sc9KUECN BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9qffyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:38:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68Gbb8P034884;
        Mon, 8 Jul 2019 16:38:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tjhpck953-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jul 2019 16:38:22 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x68GcMFp036252;
        Mon, 8 Jul 2019 16:38:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tjhpck94t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:38:22 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x68GcFBL000636;
        Mon, 8 Jul 2019 16:38:15 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 09:38:14 -0700
Date:   Mon, 8 Jul 2019 12:38:11 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190708163811.GB20847@oracle.com>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
 <20190704130509.GO3402@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704130509.GO3402@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907080206
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 03:05:09PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees wrote:
> > +int dt_bpf_attach(int event_id, int bpf_fd)
> > +{
> > +	int			event_fd;
> > +	int			rc;
> > +	struct perf_event_attr	attr = {};
> > +
> > +	attr.type = PERF_TYPE_TRACEPOINT;
> > +	attr.sample_type = PERF_SAMPLE_RAW;
> > +	attr.sample_period = 1;
> > +	attr.wakeup_events = 1;
> > +	attr.config = event_id;
> > +
> > +	/* Register the event (based on its id), and obtain a fd. */
> > +	event_fd = perf_event_open(&attr, -1, 0, -1, 0);
> > +	if (event_fd < 0) {
> > +		perror("sys_perf_event_open");
> > +		return -1;
> > +	}
> > +
> > +	/* Enable the probe. */
> > +	rc = ioctl(event_fd, PERF_EVENT_IOC_ENABLE, 0);
> 
> AFAICT you didn't use attr.disabled = 1, so this IOC_ENABLE is
> completely superfluous.

Oh yes, good point (and the same applies to the dt_buffer.c code where I set
up the events that own each buffer - no point in doing an explicit enable there
eiteher).

Thanks for catching this!

> > +	if (rc < 0) {
> > +		perror("PERF_EVENT_IOC_ENABLE");
> > +		return -1;
> > +	}
> > +
> > +	/* Associate the BPF program with the event. */
> > +	rc = ioctl(event_fd, PERF_EVENT_IOC_SET_BPF, bpf_fd);
> > +	if (rc < 0) {
> > +		perror("PERF_EVENT_IOC_SET_BPF");
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
