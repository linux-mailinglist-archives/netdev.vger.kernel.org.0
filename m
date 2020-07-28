Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6422FFEB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 05:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgG1DIA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 23:08:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbgG1DIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 23:08:00 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S32QDY141305;
        Mon, 27 Jul 2020 23:07:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32j2pawpaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 23:07:25 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06S32nJZ142839;
        Mon, 27 Jul 2020 23:07:24 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32j2pawp9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 23:07:24 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06S355bO026407;
        Tue, 28 Jul 2020 03:07:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 32gcy4jx40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 03:07:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06S37J8N31130100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 03:07:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9FE9A405E;
        Tue, 28 Jul 2020 03:07:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A314FA404D;
        Tue, 28 Jul 2020 03:07:13 +0000 (GMT)
Received: from [9.79.218.184] (unknown [9.79.218.184])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Jul 2020 03:07:13 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] perf record: Set PERF_RECORD_SAMPLE if attr->freq is set.
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
In-Reply-To: <20200727065948.12201-1-irogers@google.com>
Date:   Tue, 28 Jul 2020 08:37:11 +0530
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <FC944B00-A77C-48CE-8DD4-188E32DD6DBE@linux.vnet.ibm.com>
References: <20200727065948.12201-1-irogers@google.com>
To:     Ian Rogers <irogers@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_16:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 clxscore=1011
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 27-Jul-2020, at 12:29 PM, Ian Rogers <irogers@google.com> wrote:
> 
> From: David Sharp <dhsharp@google.com>
> 
> evsel__config() would only set PERF_RECORD_SAMPLE if it set attr->freq

Hi Ian,

Commit message says PERF_RECORD_SAMPLE. But since we are setting period here, it has to say “PERF_SAMPLE_PERIOD” ?


Thanks
Athira 

> from perf record options. When it is set by libpfm events, it would not
> get set. This changes evsel__config to see if attr->freq is set outside of
> whether or not it changes attr->freq itself.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
> tools/perf/util/evsel.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index ef802f6d40c1..811f538f7d77 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> 	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> 				     opts->user_interval != ULLONG_MAX)) {
> 		if (opts->freq) {
> -			evsel__set_sample_bit(evsel, PERIOD);
> 			attr->freq		= 1;
> 			attr->sample_freq	= opts->freq;
> 		} else {
> 			attr->sample_period = opts->default_interval;
> 		}
> 	}
> +	/*
> +	 * If attr->freq was set (here or earlier), ask for period
> +	 * to be sampled.
> +	 */
> +	if (attr->freq)
> +		evsel__set_sample_bit(evsel, PERIOD);
> 
> 	if (opts->no_samples)
> 		attr->sample_freq = 0;
> -- 
> 2.28.0.rc0.142.g3c755180ce-goog
> 
> 
> 

