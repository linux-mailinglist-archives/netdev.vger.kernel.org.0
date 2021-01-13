Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EC92F4013
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405068AbhAMAna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438311AbhAMAnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 19:43:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BE0C061575;
        Tue, 12 Jan 2021 16:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=bPgoEtYh/+xKSzjfuhxemtKThbUaZv3b+Daj8zLM6WU=; b=aEMWkap2gnIVjTFHxeq2mLAE84
        YuszMuWs1jbfcoN2/QDnB9Q4q++gVWTV8QwOqadNAKb9/IChFVchJbNOEb/f5wRjgWE+CyfSD9MFl
        9DTl3IUL9huo848e/i2k65+iOXzZpkC/qL+WrqBIyrdL6x6z4dX8YLbuDhJCYPkcFIdrHwCvug7qs
        WsOjWnZF/EjO8+HjL+Nqoiqja4hWL/fFwId650wcSRggQdXxW9oQNmneAZNtLO9ZihTzBzFdBOdgO
        uGa0SDV+nznKKaJcktB4ORQPmdm8UnUftutN23Tdq2DjoaPgxxAJu1vR0Ra+6nJLrj1s3LP3PEE1Z
        haX90mxw==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzUF5-0000oi-E5; Wed, 13 Jan 2021 00:42:31 +0000
Subject: Re: [PATCH] kernel: trace: uprobe: Fix word to the correct spelling
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rostedt@goodmis.org,
        mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210112045008.29834-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f6e08753-b268-bd14-5775-571545f486e5@infradead.org>
Date:   Tue, 12 Jan 2021 16:42:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112045008.29834-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 8:50 PM, Bhaskar Chowdhury wrote:
> s/controling/controlling/p
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  kernel/trace/trace_uprobe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 3cf7128e1ad3..55c6afd8cb27 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1635,7 +1635,7 @@ void destroy_local_trace_uprobe(struct trace_event_call *event_call)
>  }
>  #endif /* CONFIG_PERF_EVENTS */
> 
> -/* Make a trace interface for controling probe points */
> +/* Make a trace interface for controlling probe points */
>  static __init int init_uprobe_trace(void)
>  {
>  	int ret;
> --
> 2.26.2
> 


-- 
~Randy
You can't do anything without having to do something else first.
-- Belefant's Law
