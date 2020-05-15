Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185DE1D5A1F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgEOTkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOTkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:40:08 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B36C061A0C;
        Fri, 15 May 2020 12:40:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id l1so3001929qtp.6;
        Fri, 15 May 2020 12:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ikkxwEu71CdGarHt15Nyy9hGFKLIof3KJehQxLwDlN4=;
        b=SOjVLl+izKiP0sVLg7P8GXLqVdqvr2sIh0zNiC4zm/TRSTUTeoLvIedrUGHHmpJbIK
         iiXZoT61t2ggO4RmXlkg7QnDVbYg8Xj6eZtWUMM/nDmHxuDass0Bb7ulopy3VX8ANnPA
         63aW4KXADE67+RBm1LgdoJhR1wKN9dXX2B/Wb3Eu7waPDK/MrMYGVC/NIV5QB9XOD8J+
         dpcV4Rvpvx4yg+3l94anP+1JptOK1LWJK/x7hFji5oj0SEJzEdlGGCXLVj4ETCd53Wrp
         ZWGNJ8BnodLJafkjoP2/T7Kagogf4OjJ76Zk9sqqipF+5B0b2bxhhiJJOc8r17l3S4ef
         T1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ikkxwEu71CdGarHt15Nyy9hGFKLIof3KJehQxLwDlN4=;
        b=Yp25y5ZVMStWAaZJS2AJT6WAht/0qgCza5aUaV/K67XWTzIU2jye6yso8hcspQpDKG
         2xTonPL79TZJxh/hMJliYq1puEJOBUQzF1/StIdY8+7azjxPCp0X+qFTG6fosFrCgxNn
         ikDA4MfG62hR9EcvS+Cl33silLvnkSmcYuGLue4gtnWbYdfE+uKi6knixPKUI3KB+UPv
         9DrkIwD/be2OG6n3DMFvBUCFOM6y2oICH+My+23wmAgnSdRSSWvX23UpZVOvP3/yeK2G
         zGpsRM0aT8CeXoCHfvwpwXSX+Z/IkYqHERlVOEEa0VuL2OHXwSo0ToELWP1Bg01kgSvC
         Ed0g==
X-Gm-Message-State: AOAM5303mkJ12mCrsIEbbFzPDld0PfEb3a+1ShSTM2/xFXS2DhB+4gYU
        ZXQVILGNPfjWtQnOxcVOl0++7DekszC+YG7w0nQ=
X-Google-Smtp-Source: ABdhPJzhUUf5V3Iz1+1Q3uB06vQXgx6/YDbfnatZLhkOKnw8GTgr+stIAdKFX+C6nJbg8Z8xrocwGtaI0BQZFNAxomQ=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr5236862qtm.171.1589571607138;
 Fri, 15 May 2020 12:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200515165007.217120-1-irogers@google.com> <20200515165007.217120-3-irogers@google.com>
In-Reply-To: <20200515165007.217120-3-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 May 2020 12:39:56 -0700
Message-ID: <CAEf4BzYMXp6KgG-ZDyqyPe9NOx3P2P7eObXNMsAnqKYsA4M_vQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] libbpf hashmap: Remove unused #include
To:     Ian Rogers <irogers@google.com>
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
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 9:51 AM Ian Rogers <irogers@google.com> wrote:
>
> Remove #include of libbpf_internal.h that is unused.
> Discussed in this thread:
> https://lore.kernel.org/lkml/CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com/
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/hashmap.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index bae8879cdf58..e823b35e7371 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -15,7 +15,6 @@
>  #else
>  #include <bits/reg.h>
>  #endif
> -#include "libbpf_internal.h"
>
>  static inline size_t hash_bits(size_t h, int bits)
>  {
> --
> 2.26.2.761.g0e0b3e54be-goog
>
