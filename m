Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8812021BB70
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgGJQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgGJQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:52:48 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2760DC08E6DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:52:47 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t9so3587844lfl.5
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 09:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RlISFKaDjH1zyGnB/suGTc9TB09Qw6+4Fx2g8+KHkUU=;
        b=izG97bMkZJyNC+IiukufSHXq+4DnOVA9GWOfuBNjyri3NRCeFiGnKTwfDZsUCCwpSU
         vYNaf4v0+qXvc92/HNLPFBnv/bKe32x0fGilfH1gH6iDS/qCc7ievqk+uBX1LW49yMUp
         cJGoEkkeFBICh9JAOeBn9LtWuhRw8OSPxShms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlISFKaDjH1zyGnB/suGTc9TB09Qw6+4Fx2g8+KHkUU=;
        b=hXAVjxoSsLVYaT9lcDZsGjfc6UIZeyNEPtNQpxPv0RZBDnFtr3WjzL0hb7ajPFnDVU
         Vx00YBd4YJW+O9uvTnybQ1/KP0IogYED9pa6OrPT3w/N0fddnk62lD9759in0db5tzlH
         /9T7AyvF3qM1d8HFi+papxKrTno9H3AIpIFxcTYPNoPOKcKTHFXLNGcMwHrygk0wd0eZ
         yLdFi8cbE6qgP3z/PjJS1EgjhQGlCEGp0rFCSbjSxTPGd0u0GPCMQI3jA/noxtGORlOK
         tky8/G93tCqV1DP64Ove8xjRUXMiSX0YT9uev1fYcw85u88SeaIoCOJcKYVyGCqMTJbQ
         gyAA==
X-Gm-Message-State: AOAM5320zlXr7yx7SvtxZzeANacSglw0BuoceMURpQAqpm/uKTca5MKM
        4QBYI6IcjhhOGuA6W+CCXYtBYQ==
X-Google-Smtp-Source: ABdhPJzTTgesc2bWjzIePhKgkseUApJSkL5rVcAIuWLzP98oRHNpV1xwx9xU8OcdVAvSZHGB0V7cDA==
X-Received: by 2002:a19:8a07:: with SMTP id m7mr43895647lfd.31.1594399965482;
        Fri, 10 Jul 2020 09:52:45 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id f19sm2069527lja.84.2020.07.10.09.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 09:52:45 -0700 (PDT)
Date:   Fri, 10 Jul 2020 18:52:41 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf] selftests/bpf: Set attach type for CGROUP_SOCKOPT
 verifier test
Message-ID: <20200710185241.07d53eb2@toad>
In-Reply-To: <20200710164917.423125-1-jakub@cloudflare.com>
References: <20200710164917.423125-1-jakub@cloudflare.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 16:49:17 +0000
Jakub Sitnicki <jakub@cloudflare.com> wrote:

> BPF_PROG_TYPE_CGROUP_SOCKOPT requires expected_attach_type to be set on
> prog load. Set it in the verifier test that checks if calling
> bpf_perf_event_output() from CGROUP_SOCKOPT is allowed so that the runner
> does skip it.
> 
> Cc: Stanislav Fomichev <sdf@google.com>
> Fixes: 0456ea170cd6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/verifier/event_output.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
> index 99f8f582c02b..c5e805980409 100644
> --- a/tools/testing/selftests/bpf/verifier/event_output.c
> +++ b/tools/testing/selftests/bpf/verifier/event_output.c
> @@ -112,6 +112,7 @@
>  	"perfevent for cgroup sockopt",
>  	.insns =  { __PERF_EVENT_INSNS__ },
>  	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
> +	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
>  	.fixup_map_event_output = { 4 },
>  	.result = ACCEPT,
>  	.retval = 1,

Just noticed same fix has been already posted a couple hours earlier:

  https://lore.kernel.org/bpf/20200710150439.126627-1-jean-philippe@linaro.org/

Please ignore.
