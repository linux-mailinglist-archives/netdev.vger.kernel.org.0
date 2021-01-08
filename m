Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D502B2EF850
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbhAHTmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbhAHTmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 14:42:03 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A4C061380;
        Fri,  8 Jan 2021 11:41:22 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id d203so12666597oia.0;
        Fri, 08 Jan 2021 11:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bloxaOqCPwKMlXiotLGhy7r42MyPMqUNsVDO+0panUs=;
        b=Q2DzmpC6G2Ho+ySgesuMl1NfH6wgvOBvMZMqDPTmWwZwzJaVdGXpVMAhro6CX4tRcq
         S9Uvu5qVrQ/H86tGDUh4OAoxNSYhEsNukqWtRGZ9R8aHSiXu8VIMWeFoTRXGow6ffZYO
         H3ydzODDh6Llg7GAsQqLjX8Ad7ShyJo8bDPR87i47yAiQ+TdVEkjKn97oWC++DecWqjD
         WZdSuHbhf1HRiVX1as76/AbKbRp67ExuQ29fvyeoRJW9+W/qUyy3Xy/HFDCedjQ7HZEb
         e87xvAR18pSwDwvbalm6HE8whTUkkO7n5G5aTYj4nBichdWM9DZ2m6NuJiaBPTHMNIgb
         Q6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bloxaOqCPwKMlXiotLGhy7r42MyPMqUNsVDO+0panUs=;
        b=SEt5UUEIG0D3555jaL2+NrkXfm69PdCwH4yVcFKe5qFHWEfE00RxwNA21gBnTKoaa9
         03FTyQr7T/XBKrZCm695e8N0P3MDeooUDz9DTcaZf9pO9wfLUbR1YVnfElBdJNzudE8+
         hzDR+PBygAUfH+JGuQDSI1GWenMEJp5MA3K1mV1Tnko7WOOyFyVk9EOHDi15fFRf7Es+
         RS0USW2B7qc41D4N6+/jQ6ZsYQXbQij+wbkTho686KeqhvwTC7w9zlZlfL+kKaB6nmOz
         C23aL5wlg2ShI0fbEbfAlKa3CZZpP4T+mjd5NmHqJHXF2UP/sSWHtYQQJl+Vnha1911W
         PVcQ==
X-Gm-Message-State: AOAM533WHyGmHyQu6I0PQ5Z4Kpv+Ji7kfPutXseBmeXaXEJz2qAl6/cS
        viVkb4u4xo8HWyYIMDpfPPM=
X-Google-Smtp-Source: ABdhPJxbMX6pytlq+5CKW1fXJu7TJe79uCuJJ3Ws0aKgQt7kTLqX8B6mwICmkpDxQwsivSHS4Qg0dg==
X-Received: by 2002:aca:3784:: with SMTP id e126mr3332568oia.170.1610134882338;
        Fri, 08 Jan 2021 11:41:22 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t72sm2130001oie.47.2021.01.08.11.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 11:41:21 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: rtlwifi: fix bool comparison in
 expressions
To:     Aditya Srivastava <yashsri421@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com
References: <20210108153208.24065-1-yashsri421@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
Date:   Fri, 8 Jan 2021 13:41:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108153208.24065-1-yashsri421@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/21 9:32 AM, Aditya Srivastava wrote:
> There are certain conditional expressions in rtlwifi, where a boolean
> variable is compared with true/false, in forms such as (foo == true) or
> (false != bar), which does not comply with checkpatch.pl (CHECK:
> BOOL_COMPARISON), according to which boolean variables should be
> themselves used in the condition, rather than comparing with true/false
> 
> E.g., in drivers/net/wireless/realtek/rtlwifi/ps.c,
> "if (find_p2p_ie == true)" can be replaced with "if (find_p2p_ie)"
> 
> Replace all such expressions with the bool variables appropriately
> 
> Signed-off-by: Aditya Srivastava<yashsri421@gmail.com>
> ---
> - The changes made are compile tested
> - Applies perfecly on next-20210108
> 
>   drivers/net/wireless/realtek/rtlwifi/ps.c                 | 4 ++--
>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c       | 8 ++++----
>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c       | 4 ++--
>   drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 4 ++--
>   drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c       | 4 ++--
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c      | 8 ++++----
>   6 files changed, 16 insertions(+), 16 deletions(-)

As has been stated several times, this form of the subject is incorrect. It 
should be: "rtlwifi: <driver_name>: <subject>

I would prefer that there be separate patches for each driver, not that the 
changes be lumped into a single patch as was done here. Such organization makes 
it a lot easier to find the patches for a given driver in case something goes 
wrong.Note: The driver for ps is rtl_pci, and that for rtl8192c is 
rtl8192c-common. The other driver names match their directory.

Larry

