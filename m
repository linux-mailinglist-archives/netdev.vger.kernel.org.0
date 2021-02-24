Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D843242F7
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhBXRMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 12:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234040AbhBXRL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 12:11:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA5364F04;
        Wed, 24 Feb 2021 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614186677;
        bh=D6GS8765FDJLWrNF8yJDKSQvLQdP5HHbAMpPeWl0CHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i11fhSKiPKT8gGQ9LjWlroDEvnj9IzZmNOZd2w9lyT9ZlMAEBX18fCa4A9vgRGHsU
         ioeNippgXZIddPLLhm345bmJM3HplHvXdLpCutBEhQxLzEqNy+rpx9IXYjirkTBESS
         kEIIVkFiCf6KzOEG1mUYmwX1buN/8iZPCJiuwo+4aNOtAty+rnlxujck+PYRBuw80r
         fSM5AKKc/3bV1Q8YQ18ctIC2Y8NREyuDqCtwED7q9DXX5ZNAhSytbAblvkwhmO/lOu
         Uc7d1Ujllsgg4eXwldpBQxMWjungS3FA8agDvRw7mcLo1o5qAjwprrvxYcSpg0vDLM
         l875Q2n8c4jRw==
Date:   Wed, 24 Feb 2021 10:11:14 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        masahiroy@kernel.org, akpm@linux-foundation.org,
        valentin.schneider@arm.com, terrelln@fb.com, qperret@google.com,
        hannes@cmpxchg.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        rdunlap@infradead.org
Subject: Re: [PATCH] init: Kconfig: Fix a spelling compier to compiler in the
 file init/Kconfig
Message-ID: <20210224171114.GA38192@24bbad8f3778>
References: <20210224081409.824278-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224081409.824278-1-unixbhaskar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 01:44:09PM +0530, Bhaskar Chowdhury wrote:
> 
> s/compier/compiler/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

I agree with Randy about the awkward wording of the title.

I think "init/Kconfig: Fix a typo in CC_VERSION_TEXT help text" would be
succinct and descriptive.

With that change:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..739c3425777b 100644
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
> 2.30.1
> 
