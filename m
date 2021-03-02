Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AE32B3BA
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573251AbhCCEFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581634AbhCBTBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:01:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E251C0617AA;
        Tue,  2 Mar 2021 11:00:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b15so2554347pjb.0;
        Tue, 02 Mar 2021 11:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:newsgroups:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pm2aM6FEgY+3tAqdPcwvE3RwWA9gxzo2YpOjuF17cv8=;
        b=AWkypi6kEjBrXnQanyv1xj1pAvw7NlbLFHxY6hoohSjAaPeKGWIFd3M81Sag8pdaoP
         +JPVudjBLkVHVlG+41WBpr1mAUV6lkiBp7iT3t6w4tww08wHWhNyK64lATI/D7n9+vJw
         bnF2U78ssFQ9aCHREawwYrs9s8u4debDn/V6z+uFBNNkupCO1Hyionu886RnqIlACM49
         DN41Zkwo7XpblLXpV4IBdJ9J7wKMHFhD8VZgYvnd1y9hpQnUjLypc/VnLVavowuLW0J0
         BnpjwTeHpv3CSASet/dblY2H7nEeeoEH9T2z8v6SohRwU1CueqpUGJmvoOSpmhwjXBW7
         9qOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:newsgroups:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Pm2aM6FEgY+3tAqdPcwvE3RwWA9gxzo2YpOjuF17cv8=;
        b=HbvzMIqeSg2ac87sgyjqDrpX+rG63Qc2e2SwTwVRa+SgNT5JjG3J9tn5pV5dJrypp7
         KrHgtyN729Ou9UEPb+77c8IC3D/O1eo2Dco50CqhGAuunfKwGSmy1E9HM0MLti2E1fhv
         /74w5fW47fc8HH/VJZ/F/SbqwZTG+reJrHyDJkLr1iwyxx1OVUhm7r5eCRWIvu7Qi8P3
         3cPP3gQyDc6Xp//MAXNB0prC8J0LH9tffZDjGljvAmxWl51W1kWF0DY0P32l2qrf9LAD
         e3CLcWlxDlrPR7sCUiUoh+3L+rXdLrYCBdTTum2LVItTaxnrYv1ol+4JacT9gnYC6DRa
         fawA==
X-Gm-Message-State: AOAM532GMgUYy9h15Q6jrcMJ2TdKbGdyxQILmKZoQ9MP7DuIaQ9qN3BZ
        I7ReGFQIkcfmbNoNtrFp8Kw=
X-Google-Smtp-Source: ABdhPJw6tjn8/TxNf1rBIHrhfEfbfG5tHMVi2iYMOvI69cprxwH+TD8cO83WIZRUx4dqD3JFR7WXMg==
X-Received: by 2002:a17:90a:a106:: with SMTP id s6mr4897313pjp.146.1614711613646;
        Tue, 02 Mar 2021 11:00:13 -0800 (PST)
Received: from [192.168.50.50] (c-24-4-73-83.hsd1.ca.comcast.net. [24.4.73.83])
        by smtp.gmail.com with ESMTPSA id o5sm4146300pjq.57.2021.03.02.11.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 11:00:13 -0800 (PST)
Sender: Vineet Gupta <vineetg76@gmail.com>
Subject: Re: [PATCH 10/11] pragma once: delete few backslashes
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-snps-arc@lists.infradead.org, jiri@nvidia.com,
        idosch@nvidia.com, netdev@vger.kernel.org, Jason@zx2c4.com,
        mchehab@kernel.org
Newsgroups: gmane.linux.network,gmane.linux.kernel,gmane.linux.kernel.arc
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
 <YDvNSg9OPv7JqfRS@localhost.localdomain>
From:   Vineet Gupta <vgupta@synopsys.com>
Message-ID: <5783abae-c7af-0e82-8f28-09f30ff67904@synopsys.com>
Date:   Tue, 2 Mar 2021 11:00:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDvNSg9OPv7JqfRS@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/21 9:05 AM, Alexey Dobriyan wrote:
>  From 251ca5673886b5bb0a42004944290b9d2b267a4a Mon Sep 17 00:00:00 2001
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

Acked-by: Vineet Gupta <vgupta@synopsys.com>   #arch/arc bits

Thx,
-Vineet

> ---
>   arch/arc/include/asm/cacheflush.h          | 2 +-
>   drivers/net/ethernet/mellanox/mlxsw/item.h | 2 +-
>   include/linux/once.h                       | 2 +-
>   include/media/drv-intf/exynos-fimc.h       | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arc/include/asm/cacheflush.h b/arch/arc/include/asm/cacheflush.h
> index e201b4b1655a..46704c341b17 100644
> --- a/arch/arc/include/asm/cacheflush.h
> +++ b/arch/arc/include/asm/cacheflush.h
> @@ -112,6 +112,6 @@ do {									\
>   } while (0)
>   
>   #define copy_from_user_page(vma, page, vaddr, dst, src, len)		\
> -	memcpy(dst, src, len);						\
> +	memcpy(dst, src, len)
>   
>   #endif
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/item.h b/drivers/net/ethernet/mellanox/mlxsw/item.h
> index e92cadc98128..cc0133401dd1 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/item.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/item.h
> @@ -504,6 +504,6 @@ mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u16 index, u8 val)		\
>   	return __mlxsw_item_bit_array_set(buf,					\
>   					  &__ITEM_NAME(_type, _cname, _iname),	\
>   					  index, val);				\
> -}										\
> +}
>   
>   #endif
> diff --git a/include/linux/once.h b/include/linux/once.h
> index 9225ee6d96c7..0af450ff94a5 100644
> --- a/include/linux/once.h
> +++ b/include/linux/once.h
> @@ -55,6 +55,6 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
>   #define get_random_once(buf, nbytes)					     \
>   	DO_ONCE(get_random_bytes, (buf), (nbytes))
>   #define get_random_once_wait(buf, nbytes)                                    \
> -	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
> +	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))
>   
>   #endif /* _LINUX_ONCE_H */
> diff --git a/include/media/drv-intf/exynos-fimc.h b/include/media/drv-intf/exynos-fimc.h
> index 6b9ef631d6bb..6c5fbdacf4b5 100644
> --- a/include/media/drv-intf/exynos-fimc.h
> +++ b/include/media/drv-intf/exynos-fimc.h
> @@ -152,6 +152,6 @@ static inline struct exynos_video_entity *vdev_to_exynos_video_entity(
>   #define fimc_pipeline_call(ent, op, args...)				  \
>   	((!(ent) || !(ent)->pipe) ? -ENOENT : \
>   	(((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
> -	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
> +	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))
>   
>   #endif /* S5P_FIMC_H_ */
> 

