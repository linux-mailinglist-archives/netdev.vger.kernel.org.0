Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4284730C7
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240192AbhLMPpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:45:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbhLMPpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:45:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 871D5B81170;
        Mon, 13 Dec 2021 15:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A9BC34603;
        Mon, 13 Dec 2021 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639410331;
        bh=Ao91dUn6XXbxJljUQAY30y01sFzBbCwfaEKGZFOIXhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qigBmnQIrUB/Z6ggANp9VM7BGGs44upAt7O007zkJqQk/mn1q4OTf3WIEdH5HK9+x
         B+Q0iBi5BWaYj/cfaDxKkhl4hOxx1gTHcIowtBlEgN4z3uvISpgoO5HHr+6ano8l0S
         It4eAJsC0e3ljcohdb+OUOqaRyFIvStktwhY7dp0wNQF/k14Ok+R18DQF3n0fLDfZv
         13rNXb+tfSFXyz+G3r4gOALvKxPUZPkh8BKsvy95s3Q6GTFFOOhvk8iD6J0iUUa2yT
         A6eL+gWTg/1AA9aD8MLX3mREy9hvdeijzP17GU20aLl3hYOMsbSUzydQiXdku7nFJ7
         3HoKzNWwYKygg==
Date:   Mon, 13 Dec 2021 15:45:25 +0000
From:   Will Deacon <will@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     catalin.marinas@arm.com, shuah@kernel.org, keescook@chromium.org,
        mic@digikod.net, davem@davemloft.net, kuba@kernel.org,
        peterz@infradead.org, paulmck@kernel.org, boqun.feng@gmail.com,
        akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 02/12] selftests/arm64: remove ARRAY_SIZE define from
 vec-syscfg.c
Message-ID: <20211213154524.GA11839@willie-the-truck>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
 <7f6d7252af5c8efda140b6b5f626b9e5a267016a.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f6d7252af5c8efda140b6b5f626b9e5a267016a.1639156389.git.skhan@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 10:33:12AM -0700, Shuah Khan wrote:
> ARRAY_SIZE is defined in several selftests. Remove definitions from
> individual test files and include header file for the define instead.
> ARRAY_SIZE define is added in a separate patch to prepare for this
> change.
> 
> Remove ARRAY_SIZE from vec-syscfg.c and pickup the one defined in
> kselftest.h.
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/arm64/fp/vec-syscfg.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/arm64/fp/vec-syscfg.c b/tools/testing/selftests/arm64/fp/vec-syscfg.c
> index 272b888e018e..c90658811a83 100644
> --- a/tools/testing/selftests/arm64/fp/vec-syscfg.c
> +++ b/tools/testing/selftests/arm64/fp/vec-syscfg.c
> @@ -21,8 +21,6 @@
>  #include "../../kselftest.h"
>  #include "rdvl.h"
>  
> -#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
> -
>  #define ARCH_MIN_VL SVE_VL_MIN
>  
>  struct vec_data {

Acked-by: Will Deacon <will@kernel.org>

Will
