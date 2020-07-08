Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093E6218FE6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGHSrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:47:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726425AbgGHSrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 14:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594234064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fcsHqKvyEn+7TUlrftNO7s3T6e7eg/prGJp2vr2tLls=;
        b=g3sMSZfu2QI791LF/HUR8RVvOUob4km53kYKE0ZV+ZloRtXvXWEjv7P0W8r+O2IId35zgl
        A8RgsNZPcE6akXAnG7YLT+q/BaYQctDr5ZEs5JFp5pEQJ5OTRps+x15HJfhsHu33hHEgWX
        /FLPfI5p7BpSu90DcK8Y33ZqgIU1xkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-l8cy0SDLO6CVRyfWjFLFnw-1; Wed, 08 Jul 2020 14:47:40 -0400
X-MC-Unique: l8cy0SDLO6CVRyfWjFLFnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9521719057A0;
        Wed,  8 Jul 2020 18:47:37 +0000 (UTC)
Received: from krava (unknown [10.40.195.124])
        by smtp.corp.redhat.com (Postfix) with SMTP id 358367F8A7;
        Wed,  8 Jul 2020 18:47:33 +0000 (UTC)
Date:   Wed, 8 Jul 2020 20:47:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf parse-events: report bpf errors
Message-ID: <20200708184732.GC3581918@krava>
References: <20200707211449.3868944-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707211449.3868944-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 02:14:49PM -0700, Ian Rogers wrote:
> Setting the parse_events_error directly doesn't increment num_errors
> causing the error message not to be displayed. Use the
> parse_events__handle_error function that sets num_errors and handle
> multiple errors.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

looks good

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

