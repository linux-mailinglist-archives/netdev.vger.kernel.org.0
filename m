Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F0D11E2F9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 12:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLMLqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 06:46:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38350 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLMLqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 06:46:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so6325048wrh.5;
        Fri, 13 Dec 2019 03:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HCgiaWMI/x6U67hIPPycQp/x3zK3ZvfDXctut3Mj0H8=;
        b=ntCYo4fm2d/zzZ4lTMIHE2k18++eeMkvDoPsZ2tVIeLuOwZKRH3Xl0/iqsxYzseV32
         9JtOFz1k8zwhM7rcEfbl4Ul3T7p2HVGhxihyrWvvbKJ9c8Ti9MqToNwSmdA1M4cTmY4g
         FE4K278750sNT48xziH/Hxs6RpB4M7bQuLqunBAH8s3sO8vnCqtvZeG+a+zC7r+HAqW2
         KMRmPH93e5UhTfshDBVhWpsVneNuClqdHMb/bI1GEB4bmHsAed3iODeq1gPJxb+S2IfL
         Xg7AzfAEQOGD6GGdnskwH/MkDQnpX1HilwhQvVmxk2Otg1pDMOCSx9jdIDda6roJYSko
         TN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCgiaWMI/x6U67hIPPycQp/x3zK3ZvfDXctut3Mj0H8=;
        b=srnIf4YEVAB/826wJhFwKBUkJ6HZLjlkdvI2EJo2hRt2fg/knN3lWA07ZCb+cbiDB6
         l/eE4YpqtV46Wtv0AG5CEfoR2ri0ySz/69uMeEFQwAXjqER4N6etzF3aVmSjJd8vGZ3f
         gIGEE2pLvdbqrBDLJGohrMUnWhUexMHoyKrlxc5gYgg61tVitOTBYoZyndsNN72q6gLF
         yVqRYeZ0JPpJbabsIlvqcD9MJB9Bd3xeOeirENfubOtH11iOPYgZXrASeo/H98qZrEst
         2VCNWsppQwtquvPX6f64fx68WRxfXbqoQRc9rIUia/ycu9643YQDejM1Sn8Qqkiny5UW
         xrcw==
X-Gm-Message-State: APjAAAUMZHxIoNsf7wIF63BUMZTpytENzQpEaHTLme08Z6K5hEIIr1kP
        u66nbvkMc2kTI+EipK2sNB8xdvhB
X-Google-Smtp-Source: APXvYqwijV//FwSD6ZdUbelYpMbehqqqYrxwCr2pcHvthrmHzwmG+JKUW2lWiTI9HuHu8NHjX/ZVbQ==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr13203522wrp.17.1576237596862;
        Fri, 13 Dec 2019 03:46:36 -0800 (PST)
Received: from [192.168.178.26] (ipservice-092-219-207-064.092.219.pools.vodafone-ip.de. [92.219.207.64])
        by smtp.gmail.com with ESMTPSA id a184sm10170022wmf.29.2019.12.13.03.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 03:46:36 -0800 (PST)
Subject: Re: [PATCH 0/6] rtlwifi: convert rtl8192{ce,cu,de} to use generic
 functions
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191211154755.15012-1-straube.linux@gmail.com>
 <1576115241.2733.1.camel@realtek.com>
From:   Michael Straube <straube.linux@gmail.com>
Message-ID: <84f3ec5e-eda7-c955-2705-482263eb1ee6@gmail.com>
Date:   Fri, 13 Dec 2019 12:46:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1576115241.2733.1.camel@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-12 02:47, Pkshih wrote:
> On Wed, 2019-12-11 at 16:47 +0100, Michael Straube wrote:
>> This series converts the drivers rtl8192{ce,cu,de} to use the generic
>> functions rtl_query_rxpwrpercentage and rtl_signal_scale_mapping.
>>
>> Michael Straube (6):
>>    rtlwifi: rtl8192ce: use generic rtl_query_rxpwrpercentage
>>    rtlwifi: rtl8192cu: use generic rtl_query_rxpwrpercentage
>>    rtlwifi: rtl8192de: use generic rtl_query_rxpwrpercentage
>>    rtlwifi: rtl8192ce: use generic rtl_signal_scale_mapping
>>    rtlwifi: rtl8192cu: use generic rtl_signal_scale_mapping
>>    rtlwifi: rtl8192de: use generic rtl_signal_scale_mapping
>>
>>   .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 48 ++----------------
>>   .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 49 ++-----------------
>>   .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 47 ++----------------
>>   3 files changed, 14 insertions(+), 130 deletions(-)
>>
> 
> For all patches:
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 

Thanks.

> Curiously. How can you find these function are identical?
> 
While sending cleanup patches for some staging wifi drivers I noticed
that these functions are used in many of the realtek drivers and all
looked very similar. Then used grep and diff to verify.

Michael

