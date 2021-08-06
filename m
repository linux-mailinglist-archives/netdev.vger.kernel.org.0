Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998CD3E2743
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbhHFJa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhHFJaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:30:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C742FC061798;
        Fri,  6 Aug 2021 02:30:08 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k4so10273485wrc.0;
        Fri, 06 Aug 2021 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xVmV3MxgVZtNRkbXJvQYjtW4khHw2wRmtUrVvlrtgOk=;
        b=JdDGjYPx0vws4f7/bOh7rQkoIsWRMU758JX/s46GGNXlb+a0E/SEZ1D0YB6qgSEkyW
         Y2/nuhoeRirGBbHqc0TWVuAKyOglbBBaNdP0e4VewTv+Jlez0zxg6/GCVwaIIuzweWtx
         yjjfEsBBDN5bqLe7/+uo5X8Atfv4/FFfAe6WeE6EY2IsgY4NrzwHOJ/KFS0CKuG42UHx
         lEQ2qsLU2SDpv9cN5XI8k80UGbNfc25zoS4AFH5gEeI4QEuwGyMhz9Irpyag4VHKWwPW
         QTv7ADHi3AC3WTFposFYGuSH9R/iTWjq5/Z1KjxAqM8YW/QRZZqvXr8sVpvkioRyD6u+
         +V+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xVmV3MxgVZtNRkbXJvQYjtW4khHw2wRmtUrVvlrtgOk=;
        b=U/u/PXu+SqX48tzT62bE3NRW7/oGveY0cRoQ5G4cr/unOGd6sgPWF6poG4gbV7M5SS
         3mRTYTB+CsmHaSEc32HHSYd5OlSQp5vullZ3fk7hX3+ceRyWRqHqvvKlwNxTkymaTCm8
         G9zZf6dl6IPuWSgEcSfsk5hVnLezwHrou7hoblUqw2TNseCN4vsdQcXWtQUYEYUyGBUo
         h6+tju85JsMXO1N5YMaUI+yNTkTiadxc9v1u264KuOUi600za+1G7bgkr/lbsPcnMB6b
         4auvgxQVmhF2bx0bmXevjjZBYk810oxN0f4HxjCrZdtWCjoA6pyKIP3GSAdOzIu+hGur
         Axqg==
X-Gm-Message-State: AOAM530beW3/Egz68Ak1e94cIMO2Ow7Q0msyG8MhVaFD63Bun2b8kYmY
        ah7I/W4Cn/QFvdkqqsbxu71QYsHvMTo=
X-Google-Smtp-Source: ABdhPJyWKBaBzS7mYe6OvG66bz3ShW5Ut3+1HkZ2RF2ULlK7GoNl+ZMuTNepzZYoC4LvjBwJsDuzgQ==
X-Received: by 2002:adf:f1cd:: with SMTP id z13mr9862756wro.210.1628242207163;
        Fri, 06 Aug 2021 02:30:07 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.149.227])
        by smtp.gmail.com with ESMTPSA id o22sm10513764wmq.3.2021.08.06.02.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 02:30:06 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.13 184/189] flow_offload: action should not be
 NULL when it is referenced
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-184-sashal@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <caf751a7-ef2d-e31d-85e9-801e748b70dc@gmail.com>
Date:   Fri, 6 Aug 2021 11:30:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210706111409.2058071-184-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/21 1:14 PM, Sasha Levin wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> [ Upstream commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a ]
> 
> "action" should not be NULL when it is referenced.
> 
> Signed-off-by: gushengxian <13145886936@163.com>
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/net/flow_offload.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index dc5c1e69cd9f..69c9eabf8325 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
>  	if (flow_offload_has_one_action(action))
>  		return true;
>  
> -	flow_action_for_each(i, action_entry, action) {
> -		if (i && action_entry->hw_stats != last_hw_stats) {
> -			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> -			return false;
> +	if (action) {
> +		flow_action_for_each(i, action_entry, action) {
> +			if (i && action_entry->hw_stats != last_hw_stats) {
> +				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> +				return false;
> +			}
> +			last_hw_stats = action_entry->hw_stats;
>  		}
> -		last_hw_stats = action_entry->hw_stats;
>  	}
>  	return true;
>  }
> 

This patch makes no sense really.

If action is NULL, a crash would happen earlier anyway in

if (flow_offload_has_one_action(action))
    return true;

Also, I wonder why it has been backported to stable version,
there was no Fixes: tag in the submission.

