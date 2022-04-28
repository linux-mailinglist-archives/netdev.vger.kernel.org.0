Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AA751356F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347503AbiD1NpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241572AbiD1NpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:45:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313F45BE7C;
        Thu, 28 Apr 2022 06:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C037861743;
        Thu, 28 Apr 2022 13:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1704C385A0;
        Thu, 28 Apr 2022 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651153305;
        bh=P6NwmKSl37HKqsBkfsnaVlnnymPDnCBmzwPmXUQ33Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CRQtEPEgZg+qRGcXuTGCR3GNA6UcwMOAVM5UjNZO6BYVYP4pCCWk8i7fjs3sy2MEm
         9TUgHoQvu1wpc0V/GlaXgT+e7VAOUAvVKrSPSh2DnJZ+vM9lqDNj0NqR+2zX0aomZC
         LrxHktS11GBOa7o2PELLVIv2SCmVDmqiH53FrCdfw7haN6ceTrVIbPm6pszAq2B+8W
         zUSS4VeV8oc6ZCZfl6jKqnDlHAcU7UAyuSyJQ+8Otb3scEn1AAkn2S3IjJzaSWcLNm
         hGkcf2+6/BqhC5ST7vWg2bS2C1/Q0rphijrZ4y0hPfmi50jMKQhYVPtODDKEbYcRJC
         G1cD58+d4XOKg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1AC44400B1; Thu, 28 Apr 2022 10:41:42 -0300 (-03)
Date:   Thu, 28 Apr 2022 10:41:42 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Timothy Hayes <timothy.hayes@arm.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 3/3] perf test: Add perf_event_attr test for Arm SPE
Message-ID: <YmqZluTEKAgg4AU0@kernel.org>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-4-timothy.hayes@arm.com>
 <20220424145307.GE978927@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424145307.GE978927@leoy-ThinkPad-X240s>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Apr 24, 2022 at 10:53:07PM +0800, Leo Yan escreveu:
> On Thu, Apr 21, 2022 at 05:52:05PM +0100, Timothy Hayes wrote:
> > Adds a perf_event_attr test for Arm SPE in which the presence of
> > physical addresses are checked when SPE unit is run with pa_enable=1.
> > 
> > Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> 
> Reviewed-by: Leo Yan <leo.yan@linaro.org>
> Tested-by: Leo Yan <leo.yan@linaro.org>

Thanks, applied the set to perf/urgent.

- Arnaldo
 
> > ---
> >  tools/perf/tests/attr/README                         |  1 +
> >  .../perf/tests/attr/test-record-spe-physical-address | 12 ++++++++++++
> >  2 files changed, 13 insertions(+)
> >  create mode 100644 tools/perf/tests/attr/test-record-spe-physical-address
> > 
> > diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> > index 454505d343fa..eb3f7d4bb324 100644
> > --- a/tools/perf/tests/attr/README
> > +++ b/tools/perf/tests/attr/README
> > @@ -60,6 +60,7 @@ Following tests are defined (with perf commands):
> >    perf record -R kill                           (test-record-raw)
> >    perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
> >    perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
> > +  perf record -e arm_spe_0/pa_enable=1/ -- kill (test-record-spe-physical-address)
> >    perf stat -e cycles kill                      (test-stat-basic)
> >    perf stat kill                                (test-stat-default)
> >    perf stat -d kill                             (test-stat-detailed-1)
> > diff --git a/tools/perf/tests/attr/test-record-spe-physical-address b/tools/perf/tests/attr/test-record-spe-physical-address
> > new file mode 100644
> > index 000000000000..7ebcf5012ce3
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/test-record-spe-physical-address
> > @@ -0,0 +1,12 @@
> > +[config]
> > +command = record
> > +args    = --no-bpf-event -e arm_spe_0/pa_enable=1/ -- kill >/dev/null 2>&1
> > +ret     = 1
> > +arch    = aarch64
> > +
> > +[event-10:base-record-spe]
> > +# 622727 is the decimal of IP|TID|TIME|CPU|IDENTIFIER|DATA_SRC|PHYS_ADDR
> > +sample_type=622727
> > +
> > +# dummy event
> > +[event-1:base-record-spe]
> > \ No newline at end of file
> > -- 
> > 2.25.1
> > 

-- 

- Arnaldo
