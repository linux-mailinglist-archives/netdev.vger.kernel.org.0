Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716072A3040
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgKBQur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgKBQuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:50:46 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDA1C061A04;
        Mon,  2 Nov 2020 08:50:46 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id m26so13183325otk.11;
        Mon, 02 Nov 2020 08:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WeSrGYLmFdGYxbtS+mGUMm9s3GCfZsGCQvg8JHBs8ZU=;
        b=VGqUmIVdu1XcnXCfFrxWSjh6a+T+wt/Fl8lOf9LQsK94hwG7zo2zCHYRaQGAFxy637
         +hYVDKCfNPxEbUC8WSwoSgEI4EXdjXwOkGpYJMt3T01jXz/6vTqWLkmIiiYLGax2YWZB
         p6o1XnOiU7o5MeUmZlDTmpJm4CpQjqg9YNyhUaeTIL0QSigk+4x2P7aMeDHzfLx6ODFz
         O+FWvlhuVxFVUv6i+Cjp4C4l5l84THFvpLwVceuHbXjiRzgCOdEwa6Du+PMX+1d0WqOe
         EMiRZYqWgswPOFmJHEQLRxnKgZr5eWHVdxTAT5yqwxWHEPOqdZd0++k8S2C58z58NsTC
         H9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WeSrGYLmFdGYxbtS+mGUMm9s3GCfZsGCQvg8JHBs8ZU=;
        b=s/3nI1PbyfvLyLqKvhDY/EyvECx1yZuVlfvsvw2YirqnivjkylMTgMK6scsXL3bHvb
         ndrv3HeirRGWEO+UrCXgETT2nUho00i6CLolLuqGiuD48osETQc3ROFeg7XhhB7nFixv
         2gNcRlIuvFJVnj7LWNJFMy7AQfvbiv4A4VCCHvfjWr/ip/4lhYXjk7yK6etIdAicm6nC
         ZatbY4ijLAybQKDpW/30KnPAU00WdLJncGPQM6CmQ8W92Dx8mI2W+s9hzz9fG/yVi2l6
         NQ26ULQuAzztleE2/OO1Gbos/o7JhYzgHOI7rghF/L7lXdlOEQZJquUrKyPsoB68KFQF
         aQ9g==
X-Gm-Message-State: AOAM532sErZnWKu8JAIS6QA8WPslVwQUrfp9vODhoN5B9LnsQGFNZXvb
        ISgyaka0hPNMUuaiVdlUmTkf0/F3Pb0=
X-Google-Smtp-Source: ABdhPJxJgGdm9pPmTHzsJyw72b7iyET2Fz+OTPGgxPmrB+pKhV7INE5MshZ2SNI2NKicCE+bJDT/Aw==
X-Received: by 2002:a9d:2cc:: with SMTP id 70mr13153645otl.346.1604335845591;
        Mon, 02 Nov 2020 08:50:45 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id r21sm3236526otc.0.2020.11.02.08.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 08:50:44 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH 05/41] rtl8192cu: trx: Demote clear abuse of kernel-doc
 format
To:     Lee Jones <lee.jones@linaro.org>, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20201102112410.1049272-1-lee.jones@linaro.org>
 <20201102112410.1049272-6-lee.jones@linaro.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <be7ae9a4-a9ec-8670-208b-44f9117e0f04@lwfinger.net>
Date:   Mon, 2 Nov 2020 10:50:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102112410.1049272-6-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 5:23 AM, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:455: warning: Function parameter or member 'txdesc' not described in '_rtl_tx_desc_checksum'
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> index 1ad0cf37f60bb..87f959d5d861d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> @@ -448,7 +448,7 @@ static void _rtl_fill_usb_tx_desc(__le32 *txdesc)
>   	set_tx_desc_first_seg(txdesc, 1);
>   }
>   
> -/**
> +/*
>    *	For HW recovery information
>    */
>   static void _rtl_tx_desc_checksum(__le32 *txdesc)
> 

Did you check this patch with checkpatch.pl? I think you substituted one warning 
for another. The wireless-testing trees previously did not accept a bare "/*", 
which is why "/**" was present.

This particular instance should have
/* For HW recovery information */
as the comment.

Larry


