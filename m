Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D32334308F
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 02:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhCUBrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 21:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhCUBrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 21:47:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A36C061574;
        Sat, 20 Mar 2021 18:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uYDZvvaNGmPpkVhQLZEx2KCIag/oP+2xFHKcxdlqhQo=; b=qqQNtG+JY/kxtaf/R2TzOhWWOH
        J+1eb530ifNxarbBJoAvv3VGjBZNZ0f07MMVeQ0LZZpZvLPuNsHweJHuTHcyYe6MmA88hm0R/JHOW
        vzzWOkQZNVHmLBYqJ4cLPuj1ntihVdYyeSwLZ5n/N6+xjFTDuxwUrOs+TQ8/M5+Im6ggoSg7F19q6
        V27GNuNZIq2I5qmsQGQSNDgc3SwA/pYD+Uz1PLZpn9tS2WJKKW+pQyS7E+4Qva+ia7nbZTLxk0bcq
        o5CnCpv4q2P/NFDbeJp3pIgI8xaeynXakohEDv5F+1OMIuZS4X6fcyCJU/3cptvhI4JlaqskrmRYO
        HH1P4EwA==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNnB6-0028L0-UY; Sun, 21 Mar 2021 01:46:54 +0000
Date:   Sat, 20 Mar 2021 18:46:52 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf evlist: Mundane typo fix
In-Reply-To: <20210321010930.12489-1-unixbhaskar@gmail.com>
Message-ID: <525238d-54ba-a2f7-710-7abb9b42aacc@bombadil.infradead.org>
References: <20210321010930.12489-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210320_184653_004486_F5A1524E 
X-CRM114-Status: GOOD (  11.25  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote: > > s/explicitely/explicitly/
    > > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com> Acked-by: Randy
    Dunlap <rdunlap@infradead.org> 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sun, 21 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/explicitely/explicitly/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> tools/perf/builtin-top.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 3673c04d16b6..173ace43f845 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1607,7 +1607,7 @@ int cmd_top(int argc, const char **argv)
> 	if (status) {
> 		/*
> 		 * Some arches do not provide a get_cpuid(), so just use pr_debug, otherwise
> -		 * warn the user explicitely.
> +		 * warn the user explicitly.
> 		 */
> 		eprintf(status == ENOSYS ? 1 : 0, verbose,
> 			"Couldn't read the cpuid for this machine: %s\n",
> --
> 2.30.1
>
>
