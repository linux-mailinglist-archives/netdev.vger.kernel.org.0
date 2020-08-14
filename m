Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FDE244BBC
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgHNPOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHNPOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:14:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317ECC061384;
        Fri, 14 Aug 2020 08:14:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so10291114eje.7;
        Fri, 14 Aug 2020 08:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YfxBvA2aWYrgE+5pWWC12w5X51+Qhmlb7pIk34TG7p0=;
        b=jVBoK0ayiDeTelEO57sqcmDDqZLwjimjPMGEOK+yRJvJPLCPM+Ge3kM3KqRutrsUFw
         PPDBhSMUz3xDL6SSFkQR9AlASsZzYMe3vmMXeWRcgBDJzzixXdiVM69JoZ928OgrcZMv
         XZwsZEgx9zFBnziHsDtw/+TN33ZuePc9pF5Sma2tIbopcl+JfOyEwmY0Obi6uZ8MtaCj
         K2DjkJJwLHMKG4QH1Tz+HgM8BlxV2/KRMe1bR8sE7xFBujRwyZZldvuYPk816xx9EYpz
         jLMKTaRvdtwCg2oLe1CsViiCze+bxp+dLSUa92CTWjGeDsx56bHvn1/5bSRUi70bVSnz
         oq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YfxBvA2aWYrgE+5pWWC12w5X51+Qhmlb7pIk34TG7p0=;
        b=rRjWUHpzBCj/nvZ1VjfHjYsQG9x8brlI9yrr2oLWHGUjgJ8pyiO02L93lk6YPPwNPU
         oXTexR5Rmc6qPgNdfk1hSPBlnxG1FaiG9ARDmhYotInrBoYjdase6pERECGb94e2JMKL
         MkDXiLClOs4x2tEUVMAml6weZe1I9XJzuoMQBtPJ/EH+Q+Wo+nkWWbXyHLczjcQRXQlL
         /qWU1WRkhlP7kkkteeWb2MXvp1TOqi5bRvOyn67YlxIrGwvB9IvXHWND9uwvvotKMbqV
         CdawQwd0WZ/7ruOCSfhQVKo3Q/xMU9v4pFSN/MqXJk114VrqmV+ghtfQGVCTU+PtLRTu
         8jjw==
X-Gm-Message-State: AOAM533xKVC15sAJ/W76Gk/pRJKY3ljKL4PjDuEP//i80aZaSXaIjtTc
        C8BS/lm1bgrJgffEiubU0tM=
X-Google-Smtp-Source: ABdhPJxuKuRkyCb9SfjJFenDwHO0J078ZO21miEKj6OvxD26iBNePoKDdvNd2NOndct1afGijBNSqw==
X-Received: by 2002:a17:906:a141:: with SMTP id bu1mr2779462ejb.303.1597418076922;
        Fri, 14 Aug 2020 08:14:36 -0700 (PDT)
Received: from debian64.daheim (pd9e292cf.dip0.t-ipconnect.de. [217.226.146.207])
        by smtp.gmail.com with ESMTPSA id g27sm6854911edf.57.2020.08.14.08.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 08:14:36 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k6bPa-0002da-Rw; Fri, 14 Aug 2020 17:14:32 +0200
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as
 __maybe_unused
To:     Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
Date:   Fri, 14 Aug 2020 17:14:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200814113933.1903438-9-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-14 13:39, Lee Jones wrote:
> 'ar9170_qmap' is used in some source files which include carl9170.h,
> but not all of them.  Mark it as __maybe_unused to show that this is
> not only okay, it's expected.
> 
> Fixes the following W=1 kernel build warning(s)

Is this W=1 really a "must" requirement? I find it strange having
__maybe_unused in header files as this "suggests" that the
definition is redundant.

>   from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>   In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>   drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]
> 


> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/net/wireless/ath/carl9170/carl9170.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
> index 237d0cda1bcb0..9d86253081bce 100644
> --- a/drivers/net/wireless/ath/carl9170/carl9170.h
> +++ b/drivers/net/wireless/ath/carl9170/carl9170.h
> @@ -68,7 +68,7 @@
>   
>   #define PAYLOAD_MAX	(CARL9170_MAX_CMD_LEN / 4 - 1)
>   
> -static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
> +static const u8 __maybe_unused ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
>   
>   #define CARL9170_MAX_RX_BUFFER_SIZE		8192
>   
> 

