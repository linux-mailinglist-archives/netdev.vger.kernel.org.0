Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F68030235
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE3SuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:05 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37507 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:50:05 -0400
Received: by mail-oi1-f195.google.com with SMTP id i4so5393019oih.4;
        Thu, 30 May 2019 11:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ce2QS3RaYP3t12+eJA77KiPxw6iF0JqafgY8edP/dg4=;
        b=G7HSSszzgsZ7kMPqLK8cM+CY5UsKu62Ea/q7i+LyTDA4xrhkFUNRs+jCjsnhF9H+oU
         CzIhFI6Rcur/hSUwBimnINlrG2je6NUBdofvj6hfb4z6egCHEv+AIHf28mnAdj9uNEhA
         cONMmB3oqiGlJ2Iqskv+17F9rYvLreUVbLnR1KgQihbs0P4SwmYdS1v2qaaTh2QfJzwY
         W0NESuOMiDPDeCnWMarQ4I9gaoKhiohJ/jZm2BHXqxzHU+PGo8it4UrXd4eKFrmidCN1
         8X3PAvd3aWeV+OMWl+GmhXOsnp4gtRWyMWrmDja7TOBCjzxshVxpy/vn80AkEjUbALkZ
         iWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ce2QS3RaYP3t12+eJA77KiPxw6iF0JqafgY8edP/dg4=;
        b=JUOhY1p547lXMycBNF3ee4AVPpsR9lpm8ffh+n6xwoZEOoIFRxT0afWoFj98JGt/ia
         dlLKR5xFl2CV3WL4plY1qupKo73RP3UU5/5q3Ss3RipUZOMecdtVnxLc/gud0KZ92khv
         42wixF96BXtSew1Mn+w4oqK5pPyI51k8bG4zHTH/J6hmlhR7cVAQkafMa6boykXSqaK9
         UqhhU5Ib4KLSMTU+M+nZnZhm8Tc6rOUcuy4NaLhgGLcShbGFRcTjmCEQzarPvGVTi4h8
         9wdDkcTdUfpeO3eFirxkgAHbNrDysD7vqeElkSfvObIEH7oqvjLRQkN+XnDiHbsCF7sT
         EqCw==
X-Gm-Message-State: APjAAAXNQVryk2LUfbSeiegD3lvl7PyR07y1o3XejVhgZt8L3zpTSv+4
        6IAHfamg3qRBJi1amW/XKPGTxE2+
X-Google-Smtp-Source: APXvYqx6B3eEw5o1YxwFS//iW2ShUftFt8HYlMd2e7NAQMOnB00Ilq+mSvSonEh+Jc9QZafJO2EnOA==
X-Received: by 2002:a05:6808:603:: with SMTP id y3mr51487oih.74.1559242204523;
        Thu, 30 May 2019 11:50:04 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k83sm1254259oia.10.2019.05.30.11.50.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:50:03 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: remove redundant assignment to variable
 badworden
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190530184044.8479-1-colin.king@canonical.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <da50d69f-0117-3911-e15f-cf7731300886@lwfinger.net>
Date:   Thu, 30 May 2019 13:50:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530184044.8479-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 1:40 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable badworden is assigned with a value that is never read and
> it is re-assigned a new value immediately afterwards.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>   drivers/net/wireless/realtek/rtlwifi/efuse.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> index e68340dfd980..37ab582a8afb 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
> @@ -986,7 +986,6 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
>   		} else if (write_state == PG_STATE_DATA) {
>   			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
>   				"efuse PG_STATE_DATA\n");
> -			badworden = 0x0f;
>   			badworden =
>   			    enable_efuse_data_write(hw, efuse_addr + 1,
>   						    target_pkt.word_en,
> 

