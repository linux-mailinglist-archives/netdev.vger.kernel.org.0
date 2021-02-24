Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A480E324212
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhBXQ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhBXQ16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 11:27:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B852AC061574;
        Wed, 24 Feb 2021 08:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=oAPR85te3dRyKOTRlbHy17l5x3IzK2Fd4bEuFT+f54M=; b=mRzsInAJ+KnoCbdwoY6jAmutJ+
        Yp9V7hrJHkvk0gC0cjonBKykXmZWJuyXs4ITsJD++W6544IIPMHGOyFko1U3PFLiDAoV21/BmBZoi
        B3WA1nsunYjcr+5Xww+G5VNTEaB8v2jEyAKLAGCwL1mZYdivopOmfvGi18ZG2/q/qYak1UMLShBlY
        yL8IDsuCrMeLHAjNqlAioxlQqTASExnJI6uxMu5e43dcuFV6XASgnAZGpaVNbTSAIPzHYc8YEwC1A
        hS48Ha0EDUN+QCv4LwQ5ko2mfunB3pOWgC4NNaM06DojK8o/iRUegXQSbbgyOlocaHL7OZ/h4Y2wI
        Re9thVkA==;
Received: from [2601:1c0:6280:3f0::d05b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lEx0J-0003Gu-JA; Wed, 24 Feb 2021 16:27:11 +0000
Subject: Re: [PATCH] init: Kconfig: Fix a spelling compier to compiler in the
 file init/Kconfig
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, masahiroy@kernel.org,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        terrelln@fb.com, qperret@google.com, hannes@cmpxchg.org,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210224081409.824278-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <64923623-633f-12cc-41bb-fd705f2c8aa3@infradead.org>
Date:   Wed, 24 Feb 2021 08:27:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210224081409.824278-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/21 12:14 AM, Bhaskar Chowdhury wrote:
> 
> s/compier/compiler/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

in Subject:, "Fix a spelling" is whacked. Maybe "Fix a spello" or
"Fix typo".


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


-- 
~Randy

