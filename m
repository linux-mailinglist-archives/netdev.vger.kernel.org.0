Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537AE1DE901
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgEVObp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgEVObo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:31:44 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE5A223D6;
        Fri, 22 May 2020 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590157904;
        bh=BZ7dmXmIcurudc/NsJj+prqSnYqq0bXTVQfK8aIbtsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASrSiWIWq8UNgqamwQ+ZfAhy5jiTVzZbswAJcNi3c53bNS91mmyamykCPcbIUThym
         bBdfw6N0rsYE2NCvIjjbqz4kRaqZ4/6Fr5gy5FsYT+EktXPK0Mu3tXYatXA47C3mij
         CJSEHox1R/QJneKG13Vzg6H/Yy1CK8Az3gT/DnJs=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D1D1340AFD; Fri, 22 May 2020 11:31:41 -0300 (-03)
Date:   Fri, 22 May 2020 11:31:41 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     kajoljain <kjain@linux.ibm.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
Message-ID: <20200522143141.GG14034@kernel.org>
References: <20200520182011.32236-1-irogers@google.com>
 <3e8f12d8-0c56-11e9-e557-e384210f15c1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8f12d8-0c56-11e9-e557-e384210f15c1@linux.ibm.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 22, 2020 at 02:55:46PM +0530, kajoljain escreveu:
> On 5/20/20 11:50 PM, Ian Rogers wrote:
> > Metric groups contain metrics. Metrics create groups of events to
> > ideally be scheduled together. Often metrics refer to the same events,
> > for example, a cache hit and cache miss rate. Using separate event
> > groups means these metrics are multiplexed at different times and the
> > counts don't sum to 100%. More multiplexing also decreases the
> > accuracy of the measurement.

<SNIP>
 
> > Ian Rogers (7):
> >   perf metricgroup: Always place duration_time last
> >   perf metricgroup: Use early return in add_metric
> >   perf metricgroup: Delay events string creation
> >   perf metricgroup: Order event groups by size
> >   perf metricgroup: Remove duped metric group events
> >   perf metricgroup: Add options to not group or merge
> >   perf metricgroup: Remove unnecessary ',' from events
 
> Reviewd-By: Kajol Jain <kjain@linux.ibm.com>
> Tested-By: Kajol Jain <kjain@linux.ibm.com> ( Tested it to see behavior with some metric groups in both x86 and Power machine)

Thanks, added to the patches,

- Arnaldo
