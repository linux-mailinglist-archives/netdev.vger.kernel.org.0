Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03843247BD
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhBYACj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhBYACh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:02:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545EB64F0A;
        Thu, 25 Feb 2021 00:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614211317;
        bh=RZw7aXwSowOYZ/ITqJac2+QYEPCN7r6HREQezJSZFr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9yj+qpJ3hActRg6sCxeY/X+EHaBUdpyapD29YzS3wrUIbE/y2V+D3vzYPeRy5Mij
         JQuYYO9RZnFAXgEj5vsx/DDVPn4h9c5P3EBqv7zDsWxiyW46kopjYwcAiDjqkCiFpj
         t9UYFJc9foAHbSJiQF/yKtbqVVvzzOUWraJ5fVJpG84DP3pLmULVxtohI+oF3dDi6w
         kCTES+n8TXjWKwyU6DeMu3aDa4BNlUQluIPtCvQgVlEHaHhDXawajnXGna+8YHiyJc
         HBLVEvaPDl+KUwps9eFKbbpmFaOAAfxQJdRuMG+pNBDNbqeCiITY6ZRHyiOtmDSgmd
         IpF2tUq7HdU9g==
Date:   Wed, 24 Feb 2021 17:01:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        masahiroy@kernel.org, akpm@linux-foundation.org,
        valentin.schneider@arm.com, terrelln@fb.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        rdunlap@infradead.org
Subject: Re: [PATCH V2] init/Kconfig: Fix a typo in CC_VERSION_TEXT help text
Message-ID: <20210225000154.GA7875@24bbad8f3778>
References: <20210224223325.29099-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224223325.29099-1-unixbhaskar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 04:03:25AM +0530, Bhaskar Chowdhury wrote:
> 
> s/compier/compiler/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

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
> 2.29.2
> 
