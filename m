Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759AE3246FA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhBXWiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 17:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhBXWiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 17:38:50 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D1C061574;
        Wed, 24 Feb 2021 14:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=hF+4yCBHQa17tqR3iHLnQ3LH8re9yqS55BXFv+jnqgU=; b=yOG2LMnRC6eIKUrqSstoLdq4Mz
        6Zzg2x6Zc7P/C2SR6jDwP4s/0b5RJnMWv1SJc7U50A+5tyyLTzZz/xESDEXZNsUpKdFdUxvYB9wUc
        rFbRB1j+dnzksrwAQzLm4zx6Fc4O2hY8ofYxzNyiw9KH8zY05WyKtMy1xx2L5tCnfwlaeZLixHOd9
        tkDtKB4rDoGRqykmdipJb42sMCZGC6J/3tRUt3ySQGMfGzc6Fwyk9JlyOEMnFZ3s3Z6k0zuBvKomc
        5+SiuUxgg0vYQ1NLPPHeVrWdJKiNIggpFoBvQYqeeKYqI2cx2KPns++snRhS49z1KgDep2+01BMrl
        U3lgGhgg==;
Received: from [2601:1c0:6280:3f0::d05b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lF2nG-0004y3-K7; Wed, 24 Feb 2021 22:38:06 +0000
Subject: Re: [PATCH V2] init/Kconfig: Fix a typo in CC_VERSION_TEXT help text
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, masahiroy@kernel.org,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        terrelln@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210224223325.29099-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <116fc2d7-91e7-7d6f-b8bb-50fdeddc9d0e@infradead.org>
Date:   Wed, 24 Feb 2021 14:37:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210224223325.29099-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/21 2:33 PM, Bhaskar Chowdhury wrote:
> 
> s/compier/compiler/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Changes from V1:
>  Nathan and Randy, suggested  better subject line texts,so incorporated.
> 
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index ba8bd5256980..2cfed79cc6ec 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -19,7 +19,7 @@ config CC_VERSION_TEXT
>  	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
>  	    When the compiler is updated, Kconfig will be invoked.
> 
> -	  - Ensure full rebuild when the compier is updated
> +	  - Ensure full rebuild when the compiler is updated
>  	    include/linux/kconfig.h contains this option in the comment line so
>  	    fixdep adds include/config/cc/version/text.h into the auto-generated
>  	    dependency. When the compiler is updated, syncconfig will touch it
> --


-- 
~Randy

