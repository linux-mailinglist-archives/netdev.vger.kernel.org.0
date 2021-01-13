Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0B2F50B4
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbhAMRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbhAMRL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:11:57 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1474C061575;
        Wed, 13 Jan 2021 09:11:16 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g15so1870787pgu.9;
        Wed, 13 Jan 2021 09:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CSMr4NhVemQaIQlRzEmh9o0jMB/AHGUZGs2K3OynXQQ=;
        b=dd6LYrFnIW5RxpTT32/eQgDrjB4n+aPvbv9213hbMjGz9T31yfSsm3+S40KperD5L6
         qobfcZwzN39qpnwhUB3KEFCjH0nJNIDCKqA5+7rN/f9Eb2BdP6L9W+/emmKe1f0xmYl+
         sn0Hg9DEjRxA5isINJcX9+NZ+BCuV0hu1mxtnimyi6Xy2mEOklSDawskgjXv4j+M+aFL
         eC5yf8DoiUF6Sw1zSGwmaAEjOhCebnloFbiB3voItJWmxpVoA+q8+aUqRf2bdJc+MN06
         vahgq8yK1BTFkfcqyy8YGoT2LYK9pSKhQvQUqA21KGvEArnxgVRztgNE5ndaPbfTrGm2
         l0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CSMr4NhVemQaIQlRzEmh9o0jMB/AHGUZGs2K3OynXQQ=;
        b=SCLiun2ClnXV55BTmxHy7O/vUIUfrNV/sZJyFDYPIjxAhccgO6lQ/MJInt00feZyq8
         yIFxME3GP1sUu2sNOgDZ2ULGdKsD8dUBwDbgqw5rIeVO3ikIPo9BfIXjMjaDiB8Xi19v
         mQlOhOPbJ9+cfIKRiJJYta6EUCr2LQp6SzqZixuK48id+LX+wPgjuIXXOmK/Jr8GP/ho
         L2vAZ57xnHjmteJWUxM2uUyJDlQvcj+xvF2SPw5+Vq2U110zVVkqR/vPvRqD0McpN24p
         3I4c1BxERYsIp3ZH+W/KRa6PMELS+nrYv+X60TjaSBHavpAZiwzKEV5WChvltCecaYr1
         gBdQ==
X-Gm-Message-State: AOAM532ih4Mhc2WgN/QGA498BzHDbo7aWu7b2qwuZhbnD+BPqFufcfRL
        C8ySCzBgxzJuooHiGRkhHZ0aAGsUdjEA4g==
X-Google-Smtp-Source: ABdhPJwRqH7PxlXkGYdfi1mlufm1W/jmCyvwbun7hVgpPo4l7c2GM/tq91sAkcfCqgTMg1v/q9vrXw==
X-Received: by 2002:a62:1716:0:b029:19d:b78b:ef02 with SMTP id 22-20020a6217160000b029019db78bef02mr3061335pfx.11.1610557876283;
        Wed, 13 Jan 2021 09:11:16 -0800 (PST)
Received: from ?IPv6:2405:201:600d:a089:2476:46d6:e655:45d9? ([2405:201:600d:a089:2476:46d6:e655:45d9])
        by smtp.gmail.com with ESMTPSA id b5sm3585016pga.54.2021.01.13.09.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 09:11:15 -0800 (PST)
Subject: Re: [PATCH] drivers: net: wireless: rtlwifi: fix bool comparison in
 expressions
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com
References: <20210108153208.24065-1-yashsri421@gmail.com>
 <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
From:   Aditya <yashsri421@gmail.com>
Message-ID: <37f9fb2c-56bb-b593-ae55-db8fce8304f9@gmail.com>
Date:   Wed, 13 Jan 2021 22:41:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 1:11 am, Larry Finger wrote:
> On 1/8/21 9:32 AM, Aditya Srivastava wrote:
>> There are certain conditional expressions in rtlwifi, where a boolean
>> variable is compared with true/false, in forms such as (foo == true) or
>> (false != bar), which does not comply with checkpatch.pl (CHECK:
>> BOOL_COMPARISON), according to which boolean variables should be
>> themselves used in the condition, rather than comparing with true/false
>>
>> E.g., in drivers/net/wireless/realtek/rtlwifi/ps.c,
>> "if (find_p2p_ie == true)" can be replaced with "if (find_p2p_ie)"
>>
>> Replace all such expressions with the bool variables appropriately
>>
>> Signed-off-by: Aditya Srivastava<yashsri421@gmail.com>
>> ---
>> - The changes made are compile tested
>> - Applies perfecly on next-20210108
>>
>>   drivers/net/wireless/realtek/rtlwifi/ps.c                 | 4 ++--
>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c       | 8
>> ++++----
>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c       | 4 ++--
>>   drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 4 ++--
>>   drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c       | 4 ++--
>>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c      | 8
>> ++++----
>>   6 files changed, 16 insertions(+), 16 deletions(-)
> 
> As has been stated several times, this form of the subject is
> incorrect. It should be: "rtlwifi: <driver_name>: <subject>
> 
> I would prefer that there be separate patches for each driver, not
> that the changes be lumped into a single patch as was done here. Such
> organization makes it a lot easier to find the patches for a given
> driver in case something goes wrong.Note: The driver for ps is
> rtl_pci, and that for rtl8192c is rtl8192c-common. The other driver
> names match their directory.
> 
> Larry
> 

Hi Larry!
I sent the modified patches as patch series separately.
I probably missed CCing you :/

The patch series can be found at:
https://lore.kernel.org/linux-wireless/20210110121525.2407-1-yashsri421@gmail.com/#t

Please review :)

Thanks
Aditya

