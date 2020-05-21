Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F1F1DD455
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbgEUR2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727955AbgEUR2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:28:19 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F742072C;
        Thu, 21 May 2020 17:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590082099;
        bh=pRt37ocE9vbggyrqslixMeQ2DbUZaL7la/D9a2Hyc0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ckSLP4YKyS88FddhbJdgMzUz8vGOQPYYrpD0JarsGmKMcHdz/RvArC57UE0IcAS8K
         j8sNGhCwSlhy/FJEUDjB/PMevl5125W9NQB2Ff9idCtW8N1xT8wxFW4FYm/z/ueLFL
         gfjwiD3laRWqiM6D+HT/FaKaf/zqbHKnwPG1Q6DQ=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id EB8D840AFD; Thu, 21 May 2020 14:28:16 -0300 (-03)
Date:   Thu, 21 May 2020 14:28:16 -0300
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
Subject: Re: [PATCH 5/7] perf metricgroup: Remove duped metric group events
Message-ID: <20200521172816.GE14034@kernel.org>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava>
 <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
 <20200520220912.GP157452@krava>
 <CAP-5=fU12vP45Sg3uRSuz-xoceTPTKw9-XZieKv1PaTnREMdrw@mail.gmail.com>
 <20200521105412.GS157452@krava>
 <CAP-5=fWfV=+TY80kvTz9ZmzzzR5inYbZXRuQfsLfe9tPG7eJrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWfV=+TY80kvTz9ZmzzzR5inYbZXRuQfsLfe9tPG7eJrQ@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, May 21, 2020 at 10:26:02AM -0700, Ian Rogers escreveu:
> On Thu, May 21, 2020 at 3:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > ok, I misunderstood and thought you would colaps also M3 to
> > have A,B computed via M1 group and with separate D ...
> >
> > thanks a lot for the explanation, it might be great to have it
> > in the comments/changelog or even man page
> 
> Thanks Jiri! Arnaldo do you want me to copy the description above into
> the commit message of this change and resend?

Send as a follow on patch, please.

- Arnaldo

> This patch adds some description to find_evsel_group, this is expanded
> by the next patch that adds the two command line flags:
> https://lore.kernel.org/lkml/20200520072814.128267-7-irogers@google.com/
> When writing the patches it wasn't clear to me how much detail to
> include in say the man pages.
> 
> Thanks,
> Ian
