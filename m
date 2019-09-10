Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5038AF159
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfIJTBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:01:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40487 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfIJTBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:01:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id y10so9007539pll.7;
        Tue, 10 Sep 2019 12:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7H5tszDGC6FfQhd69mW6cc7M8L7GsdmMMVOWQYCICHw=;
        b=MtpWksnl4dcn1LAwRq+jQmfg4Dr3Se/ahaYHvIvwlmRP9Bvku/A5kwvO2Xs9IGwqrP
         VZaw0qMXPbQpER/olFjxrzjLVtXHhGELHaop2PopibC92Rv6Dww9Q764zA+qwBRT1vbz
         25Oe2GFFC9rbMIvRUZMaUAndWu8lrz5HbUPKasA4qWhE7lYqHCKP2qXehh2dgUFgZoQ9
         8oLvnD8kNFDSeRUH/mEWxRQvzYJNnhjxMXGTIS3ipvZKWKTleR9lBvYDmMUoxakWQxI1
         ZTzYVOY/Uklzp0bxtl5qYPtYdOogWChLjcgsakPuPWqvM5OqJI9Ad5MRKfp9pOIHJhvq
         axhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7H5tszDGC6FfQhd69mW6cc7M8L7GsdmMMVOWQYCICHw=;
        b=aHGZ20hSkM/1L/ib0x+NJh8wbuNx94rAN8ozhR3o6s9JVhAoh2bNvInVRZk/T/nQXI
         NrMkU+mmgRdv5PYctugm4QwwPJcnpRXZSbxA402m8PbpV9ewOAYUCtuDZLEDJtdHHltn
         D1JSvZpnpohuBV8UhqYOyFxW8baetV4zfpX8Zyy2Gr9qQTq6lZiQqMqXvBkfyw55M/Nb
         3ystVsMLOwn9jvSnuPG4n+H1rRlN1UDnhgdkgI+RNjfb0+i3Yiis48dLth6Wo5Oq1Kv8
         CLVWKXR6uMR5rWkUqE9+SJ37Akcc+f09L3DXZXauwY/SzHLXKFrt/ihNdCrmJ9g2Vc9I
         e+zg==
X-Gm-Message-State: APjAAAX6gQv48gn+S9T2diWQ0/JlmHxAx+K97QDb89t72PO28CRu8o8z
        aGdePEl5zAPkUjOtDUcBc2vp7kK0M6o=
X-Google-Smtp-Source: APXvYqw+yoUzul/mIjF7vaCzUNhNWkvGJ3fFPavWyyqo3J5Tpa91ECu3J0qpDhdf3Cocgwz6r4eMcA==
X-Received: by 2002:a17:902:581:: with SMTP id f1mr32450596plf.246.1568142064332;
        Tue, 10 Sep 2019 12:01:04 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k95sm404010pje.10.2019.09.10.12.01.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 12:01:03 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: stmmac: Support enhanced addressing
 mode for DWMAC 4.10
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <20190909152546.383-2-thierry.reding@gmail.com>
 <BN8PR12MB3266AAC6FF4819EC25CB087BD3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190909191329.GB23804@mithrandir>
 <BN8PR12MB3266F021DFC2C61CDEC83418D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c8d419d3-6cf6-e260-a2e2-6a339c6c321b@gmail.com>
Date:   Tue, 10 Sep 2019 12:01:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266F021DFC2C61CDEC83418D3B60@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 1:35 AM, Jose Abreu wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Sep/09/2019, 20:13:29 (UTC+00:00)
> 
>> On Mon, Sep 09, 2019 at 04:05:52PM +0000, Jose Abreu wrote:
>>> From: Thierry Reding <thierry.reding@gmail.com>
>>> Date: Sep/09/2019, 16:25:46 (UTC+00:00)
>>>
>>>> @@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
>>>>  	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
>>>>  	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
>>>>  
>>>> +	if (dma_cfg->eame)
>>>
>>> There is no need for this check. If EAME is not enabled then upper 32 
>>> bits will be zero.
>>
>> The idea here was to potentially guard against this register not being
>> available on some revisions. Having the check here would avoid access to
>> the register if the device doesn't support enhanced addressing.
> 
> I see your point but I don't think there will be any problems unless you 
> have some strange system that doesn't handle the write accesses to 
> unimplemented features properly ...

Is not it then just safer to not do the write to a register that you do
not know how the implementation is going to respond to with one of a
target abort, timeout, decoding error, just dead lock?

Also, would it make sense to consider adding an #ifdef
CONFIG_PHYS_ADDR_T_64BIT plus the conditional check so that you can be
slightly more optimal in the hot-path here?
-- 
Florian
