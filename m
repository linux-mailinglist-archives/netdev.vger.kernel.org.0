Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A891DC03B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgETUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgETUeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:34:12 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 766D3207E8;
        Wed, 20 May 2020 20:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590006851;
        bh=nrhqiPlqg0n1hAE/O/a+UV4rvWhhKR/jrI3wT+HPdB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fnETanLGKttjkEDsIOkbvEpJYimeA18NjKziM8drdxMbWqnxJRwv2z9bJPmHYy4OX
         Qymq55cxN+8xS9TpqOtAcsZqHbC9oKnawEEkLKBjb/yGVzqJj8DHvUu7N1CNgXjWcC
         FPJnGkx5GKum6HTnpGaHQ3qI28qCOx5Zb6erqtF4=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 7029A40AFD; Wed, 20 May 2020 17:34:09 -0300 (-03)
Date:   Wed, 20 May 2020 17:34:09 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/7] perf metricgroup: Delay events string creation
Message-ID: <20200520203409.GA26877@kernel.org>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-4-irogers@google.com>
 <20200520131412.GK157452@krava>
 <CAP-5=fXHRiahLZjQHcFiWW=zdXc7r+=WdMpzeCj-+xPcqB2khQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXHRiahLZjQHcFiWW=zdXc7r+=WdMpzeCj-+xPcqB2khQ@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, May 20, 2020 at 11:22:22AM -0700, Ian Rogers escreveu:
> On Wed, May 20, 2020 at 6:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >                               break;
> > >               }
> > >       }
> > > +     if (!ret) {
> >
> > could you please do instead:
> >
> >         if (ret)
> >                 return ret;
> >
> > so the code below cuts down one indent level and you
> > don't need to split up the lines
> 
> Done, broken out as a separate patch in v2:
> https://lore.kernel.org/lkml/20200520182011.32236-3-irogers@google.com/

Jiri, was this the only issue with this patchkit? I've merged already
the first one, that you acked.

- Arnaldo
