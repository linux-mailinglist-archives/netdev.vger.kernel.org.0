Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B132D53A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhCDOXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbhCDOXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:23:07 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC54C061761;
        Thu,  4 Mar 2021 06:22:27 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id e10so27609565wro.12;
        Thu, 04 Mar 2021 06:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VnG4tu4VgSlUkh5WwEH2QyWi6B9WiJssSBKAtiBStGM=;
        b=iuycZa+F+vtISNTPXCWqu6NyoSjc78qNC7lctybLJBDC8RepTQibIElKvgblS1lt1R
         fShdhag9+n7w3EoTkk0cDWiJss3Y+TVo2uzl3ddLcVYAXw0b/366cKhKRMC7HgaX+K8X
         CeHQ3/A3l2Ke+SvG70chT4E8BAJTqa4L8MkbCEEbDnvKyDrJSwb6e0uNXkK7IZ7vZ8z7
         ZwxoM3btIU5GIP1JQtqI7ALH+/u+WAOPlmElTGO5EcYa8bYJd55pC+z+XsvuvneQdFrG
         dSZND5WVL4lVOrtxMr7zGzGg9o+4VK9xBNoesn/bgCTpOn9w8uPc8FPCsR67wzregTfS
         V7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnG4tu4VgSlUkh5WwEH2QyWi6B9WiJssSBKAtiBStGM=;
        b=NHA7k2wuCD1jKtMfmN3x6wDWvr2kFlyAWQ0lflVEE3CMLd1RRrmC+aoQJHCzBQd3OE
         ttcLeLIOgvVKXDEh8mm1htgOtCjHta31dO5w6z+QXNGoFaGI/8l036RaFlfmmAVW5hnC
         jLx+GzSxdQvn8UW9wU1c9iS4SP+uVJe5N9LSYGPexv6vZwxxzJHmHnp62ZNhmirZbnRk
         Wz1556ilzdUOXDBTA4/WTwymJp3i+nknGKlXvVx5k1kE0YnGg5dQnEK14UwsBWdV5nMJ
         kieBDaqu62VVCE4fZzxxmhWp1Or/dZsPr5t/TNjwK3ShqPC4G4Am5MnbEvvop1reHmsl
         kR7w==
X-Gm-Message-State: AOAM532+05OSLk78RlIYJVUuz4UaalJkQ7sl31FM2KHeQvszhMEm9Jnp
        kv9Lmy+R8hZMO5gxfvUjGwPbBxrgHOPmeA==
X-Google-Smtp-Source: ABdhPJzTdLStXYk0J9Ktu6ilg4ACfPbm1fzFL0y0p4yBuqDQhZH7uMsAbQ+g0rVak6P7DJ5H15cnKA==
X-Received: by 2002:a5d:4743:: with SMTP id o3mr4512397wrs.108.1614867746226;
        Thu, 04 Mar 2021 06:22:26 -0800 (PST)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id h20sm10121146wmb.1.2021.03.04.06.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 06:22:25 -0800 (PST)
Subject: Re: [PATCH 10/11] pragma once: delete few backslashes
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        vgupta@synopsys.com, linux-snps-arc@lists.infradead.org,
        jiri@nvidia.com, idosch@nvidia.com, netdev@vger.kernel.org,
        Jason@zx2c4.com, mchehab@kernel.org
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
 <YDvNSg9OPv7JqfRS@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <91f4ba8b-38a0-dfcf-1fec-31410a802f5f@gmail.com>
Date:   Thu, 4 Mar 2021 14:22:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YDvNSg9OPv7JqfRS@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/02/2021 17:05, Alexey Dobriyan wrote:
> From 251ca5673886b5bb0a42004944290b9d2b267a4a Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Fri, 19 Feb 2021 13:37:24 +0300
> Subject: [PATCH 10/11] pragma once: delete few backslashes
> 
> Some macros contain one backslash too many and end up being the last
> macro in a header file. When #pragma once conversion script truncates
> the last #endif and whitespace before it, such backslash triggers
> a warning about "OMG file ends up in a backslash-newline".
> 
> Needless to say I don't want to handle another case in my script,
> so delete useless backslashes instead.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  arch/arc/include/asm/cacheflush.h          | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/item.h | 2 +-
>  include/linux/once.h                       | 2 +-
>  include/media/drv-intf/exynos-fimc.h       | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arc/include/asm/cacheflush.h b/arch/arc/include/asm/cacheflush.h
> index e201b4b1655a..46704c341b17 100644
> --- a/arch/arc/include/asm/cacheflush.h
> +++ b/arch/arc/include/asm/cacheflush.h
> @@ -112,6 +112,6 @@ do {									\
>  } while (0)
>  
>  #define copy_from_user_page(vma, page, vaddr, dst, src, len)		\
> -	memcpy(dst, src, len);						\
> +	memcpy(dst, src, len)
>  This changebar also removes a semicolon.
It looks plausibly correct, but the commit message ought to mention it.

-ed
