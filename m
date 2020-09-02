Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89225A52A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgIBFpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBFpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:45:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9BC061244;
        Tue,  1 Sep 2020 22:45:33 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u20so2237398pfn.0;
        Tue, 01 Sep 2020 22:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BmiJlaHiyPSVNfl9EVoNCOg+J8E6kGVUb5DLOxw34yA=;
        b=ARp1EAO33YdUDEoQc1p3tQv+jMRzsRB6x+nkCG6a+YdW0dWkApBC2zoBkTEicUmVx9
         UOLSntzK3+BbeYPG7nkiK0m/z5DJ9Ewll9MaDOMlXBoZLrUA//IwxHkxtsweoAIQ6dV5
         rVfGzVYh2T/ml/zub1m3tc6veKDuYWcHR2RCVCl1o33Gt7IHZTzOfPSqryOs7OHS2WkS
         d2yGyJyW/lgxrKxfFX1gBGz54cRfqSoE651iAaq4DK3K+8d8NHobYGdRNYBQqNvY94F+
         MjkVy4b63n7O0FHt2w66qPCcQ/bgmeUEQoksLMIHIbwkZcVO9EJ5Dul8imO3MXWrjtcO
         QPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BmiJlaHiyPSVNfl9EVoNCOg+J8E6kGVUb5DLOxw34yA=;
        b=qH/hUjUTC8celGI+6wvSLJiOqr219MgLG2m1lhl96m9Zq6lHLqda7h3RdnB/yqByQt
         UjEOaeeiOrvIstulRO57QHGm/qpYEGmmgSzyzUa7rDzc0HrYn7eoiOE0YkXR449O29jm
         /hF8ukhnRnSu5LJfHEwwKtw+CXJBrObji6+YVug0MwHkjtwelhSP2YwV7HCoknV7frvR
         2SFBimrocJ2VKSO8AGWbkkeOoOw2CHEUeCJb1CKr/2TfEhRQb+/imIXOybA55Ffk7IfK
         GR8k5I4DSsAc1QZGaCLltFmEniLYimkDGXOaWp3LkYzomxmmDIbzbLBQztIqtjND0sh9
         rnGQ==
X-Gm-Message-State: AOAM532bBMIpf9b3mNZKsuBmY1KCgcsSQNv6FKTIDcXY7ERbLywgdJz+
        aFGqqfKESmiZWTZqUK66ups=
X-Google-Smtp-Source: ABdhPJzJ0v6kLtrH/J/FsSOp4dv3FOBxR9f3gnm0YpGUlHoBNIkg5oFxGe1QUFOZH01j2zVxxzJEyQ==
X-Received: by 2002:a62:648c:: with SMTP id y134mr1724610pfb.114.1599025532557;
        Tue, 01 Sep 2020 22:45:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c38b])
        by smtp.gmail.com with ESMTPSA id j13sm3969723pfn.166.2020.09.01.22.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 22:45:31 -0700 (PDT)
Date:   Tue, 1 Sep 2020 22:45:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 12/14] selftests/bpf: convert pyperf,
 strobemeta, and l4lb_noinline to __noinline
Message-ID: <20200902054529.5sjbmt2t6pgzi4sk@ast-mbp.dhcp.thefacebook.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-13-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901015003.2871861-13-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 06:50:01PM -0700, Andrii Nakryiko wrote:
> diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
> index cc615b82b56e..13998aee887f 100644
> --- a/tools/testing/selftests/bpf/progs/pyperf.h
> +++ b/tools/testing/selftests/bpf/progs/pyperf.h
> @@ -67,7 +67,7 @@ typedef struct {
>  	void* co_name; // PyCodeObject.co_name
>  } FrameData;
>  
> -static __always_inline void *get_thread_state(void *tls_base, PidData *pidData)
> +static __noinline void *get_thread_state(void *tls_base, PidData *pidData)
>  {
>  	void* thread_state;
>  	int key;
> @@ -154,12 +154,10 @@ struct {
>  	__uint(value_size, sizeof(long long) * 127);
>  } stackmap SEC(".maps");
>  
> -#ifdef GLOBAL_FUNC
> -__attribute__((noinline))
> -#else
> -static __always_inline
> +#ifndef GLOBAL_FUNC
> +static
>  #endif
> -int __on_event(struct bpf_raw_tracepoint_args *ctx)
> +__noinline int __on_event(struct bpf_raw_tracepoint_args *ctx)
>  {
>  	uint64_t pid_tgid = bpf_get_current_pid_tgid();
>  	pid_t pid = (pid_t)(pid_tgid >> 32);
> diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
> index ad61b722a9de..d307c67ce52e 100644
> --- a/tools/testing/selftests/bpf/progs/strobemeta.h
> +++ b/tools/testing/selftests/bpf/progs/strobemeta.h
> @@ -266,8 +266,7 @@ struct tls_index {
>  	uint64_t offset;
>  };
>  
> -static __always_inline void *calc_location(struct strobe_value_loc *loc,
> -					   void *tls_base)
> +static __noinline void *calc_location(struct strobe_value_loc *loc, void *tls_base)

hmm. this reduces the existing test coverage. Unless I'm misreading it.
Could you keep existing strobemta tests and add new one?
With new ifdefs. Like this GLOBAL_FUNC.
