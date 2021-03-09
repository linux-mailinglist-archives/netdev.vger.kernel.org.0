Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F9B3324D5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 13:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCIMKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 07:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230437AbhCIMKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 07:10:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979846522B;
        Tue,  9 Mar 2021 12:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615291803;
        bh=5H0ofGIXCbizaDWx7RqmfTZXx4TbcZuHEwJsCBpIim8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=abIERcnMnkQoqYKMIf12tNCIn54cSlOsRY67TXg0yk+79rIH4FVQosWFBeNOVKNLn
         421XThUOWngEP4y5B10BRFENBh9uuQnV1WRT424tG2+l6TPsCgeaczjRAK7BgGRhaW
         Wy5MvpRNalMHpL/HTtjzf7P/TX9AoIT+ynlwZ5m4q6jPjoqkAo94mmM47ZLcC6/xeZ
         ov/q+7j8URut00UWV2xUx5otcRdxhfEDagm9VHu80r/3FK5Ta6I5MXIVekJ+Oh8SFM
         s5YSTqXbNfPCJhzONtoo7DlMF02dKMKJhzJGSa+R9ulXJWn5PYA8vWtS8UwKhHJdUB
         XOOCiQTauQIxw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8786240647; Tue,  9 Mar 2021 09:10:01 -0300 (-03)
Date:   Tue, 9 Mar 2021 09:10:01 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     peterz@infradead.org, mingo@redhat.com, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf machine: Assign boolean values to a bool variable
Message-ID: <YEdlmcl+lPxsPJzs@kernel.org>
References: <1615284669-82139-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615284669-82139-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Mar 09, 2021 at 06:11:09PM +0800, Jiapeng Chong escreveu:
> Fix the following coccicheck warnings:
> 
> ./tools/perf/util/machine.c:2041:9-10: WARNING: return of 0/1 in
> function 'symbol__match_regex' with return type bool.

Thanks, applied.

- Arnaldo

 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/perf/util/machine.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b5c2d8b..435771e 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -2038,8 +2038,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
>  static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
>  {
>  	if (!regexec(regex, sym->name, 0, NULL, 0))
> -		return 1;
> -	return 0;
> +		return true;
> +	return false;
>  }
>  
>  static void ip__resolve_ams(struct thread *thread,
> -- 
> 1.8.3.1
> 

-- 

- Arnaldo
