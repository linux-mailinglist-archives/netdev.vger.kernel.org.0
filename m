Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD382E7779
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgL3Jie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgL3Jid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:38:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5152AC06179B;
        Wed, 30 Dec 2020 01:37:53 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id p22so14841386edu.11;
        Wed, 30 Dec 2020 01:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/hMCew1Zrbs9U+h/kunHwBDwzyG1fgaDdekyBTSHGcE=;
        b=dKX0kyohpawdO/Y06Yib6KxKLsEM5szQbXTDfi5FWDtA870x3xrVntLvqeqfIB0D4V
         OW74CeuVj5LQEZGqpEaqFyanyKoGCYVWBpo4oam1+ow6MbquyBQ4OOD6aVyQTg8zta4s
         qvjLV18Raz4TZRKgdCfo2S1rVekEkxMS0HCXJXkZm1bQsS6aBL7S9vE72zGWQzJak1e6
         pvoO2MGHP20wZ6tfbjRXWdvZVA8lv7V9Fb1XfqmbypuiTtZi5tEAn7i3t0ffqeQD9vwi
         Yfta5FmV675fiOoRiAT3cFnrJCst/39BmsOVDu19zvwnxuLtUs8DzgKBEXywBfLJMLAA
         Zqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hMCew1Zrbs9U+h/kunHwBDwzyG1fgaDdekyBTSHGcE=;
        b=BNwfEcbCnsAZ3qVFgYAPot+Qd3hXf/Vg9/vT5dtU4AdgK7ha7iyugprkm3P27xNwgh
         dbOySnOi1TQkDBsau4I64uPwR058wXumAQnS/fBVSD5ujUvFyik4pRicAIP9sxUDTVpk
         st5HFH+z6kuJ5DdgqCKs7cPEoxol9bcAmbyN7ftzHM0OmaLmB1el8sUhHCZWtIRG3Se4
         eK0BljQY9AI18SfdoODtIximBnBeR4s0MG5dUfA3qtCUzdJRbtEojE58/mfIkwNHUCf7
         uamcVa5Q7oq/a9DAaq2rybQciRNLTfkZEmgdMpsf1eHojpb4V6HW2+y88uzrmPuM8+dL
         yeHA==
X-Gm-Message-State: AOAM5316zATsksRcAx7F/qP8r0cIV+3ey4S3Au0n3dFo1NVGEP74qwYi
        BrEdRWvbbksMDoeKSRyfIK7nMwJ75zQ=
X-Google-Smtp-Source: ABdhPJzED01427ee+y7EssPXm15JKvCnhwcBoTgaAqo7LCQeN3et81V9ByC88Hku+dbnzFh5/rxKhw==
X-Received: by 2002:a05:6402:100c:: with SMTP id c12mr51593560edu.356.1609321072006;
        Wed, 30 Dec 2020 01:37:52 -0800 (PST)
Received: from [192.168.0.112] ([77.126.22.168])
        by smtp.gmail.com with ESMTPSA id m24sm18941836ejo.52.2020.12.30.01.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 01:37:51 -0800 (PST)
Subject: Re: [PATCH] mlx4: style: replace zero-length array with
 flexible-array member.
To:     YANG LI <abaci-bugfix@linux.alibaba.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
References: <1609309731-70464-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <e7a8eff0-d6b0-58ef-29a9-650bf0baa7bf@gmail.com>
Date:   Wed, 30 Dec 2020 11:37:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609309731-70464-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2020 8:28 AM, YANG LI wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use "flexible array members"[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/
>      deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index e8ed2319..4029a8b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -314,7 +314,7 @@ struct mlx4_en_tx_ring {
>   
>   struct mlx4_en_rx_desc {
>   	/* actual number of entries depends on rx ring stride */
> -	struct mlx4_wqe_data_seg data[0];
> +	struct mlx4_wqe_data_seg data[];
>   };
>   
>   struct mlx4_en_rx_ring {
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
