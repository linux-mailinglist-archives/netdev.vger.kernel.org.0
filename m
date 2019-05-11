Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606E91A7D0
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfEKMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 08:32:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33370 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfEKMce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 08:32:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id d9so2124171wrx.0;
        Sat, 11 May 2019 05:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z36DBF8uzaNUXPe6+Cpp2JzXZTaHD3wGKITgeF7biT4=;
        b=dknuyWvFFKylY5XCdzE5sBKt2uEzimW5P4awc66inlGSOVg0JWO0rd755IH79nY1fO
         qdi1NuDbkgW22cj7Wqq8TKwAg1UAPG7WtwO3akTNa1iXw/a5/r8GmqkMI45SI0dV1+zo
         CnO0Yyyq1TOyTH2d80Yg2E8oVg1d+Y/MY6RoEk7f2pHDdsTHRMMIseanui5XzJi8YjM3
         CF0K7RROTGa/LajkdrFW4G3cgiDNUpjB2+7M8hfF2k3nNmqcWHuhrfV4q9YZqvd+t/UY
         99I3sSpZphwKHd0SVghqERMYCX/336CwaoJjoeiEUvnJHjfh9bADrCn74r6Jznfo3nOs
         HgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z36DBF8uzaNUXPe6+Cpp2JzXZTaHD3wGKITgeF7biT4=;
        b=SWlA593OUtCXeuZsELiwpyonchnnfhtzCpghWOkkKc1l9WXBUFKPWOPFVocv22jX4G
         kEVAsmucB6vP1soKdjT3JslFkItZhtCaR3K/KDMeL1NOGFL4OqBSv64LfwtMy4/DiJrd
         v06BO8OsJguUXxO4S1L5TP4GySs8FqONfpYzu7P0+nDpos8D/Siz32zyJE6GZ/coIw68
         jMR30lI7f1/pHJbFJnPPvLK6nmTwShsJ+Y3JuvqS723K4HeaxKt8NyLqqiWxd9gOoMKX
         TWpVq5wxEPI1Zszii83CaKZb5DTCVf/gqLpOr0YHHg4B/mZKsMdTX/8JcSHvz8v9p254
         S6Ww==
X-Gm-Message-State: APjAAAWPtljGYawj+57E2ogMj5yKmtjHLHbqjz/3j9iQo4d1mggtslyh
        REJE60/N95g2Zq3GJjUvsD4=
X-Google-Smtp-Source: APXvYqzQcX7d6RmTgy5kRsYvGJ7rFqeqLG/nmPQ1vpcZVjcaexthsPMcqhpfBFGYW8EmLjT1+7ca7Q==
X-Received: by 2002:adf:dd43:: with SMTP id u3mr11652089wrm.302.1557577952422;
        Sat, 11 May 2019 05:32:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:152f:e071:7960:90b9? (p200300EA8BD45700152FE071796090B9.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:152f:e071:7960:90b9])
        by smtp.googlemail.com with ESMTPSA id n2sm14130454wra.89.2019.05.11.05.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 05:32:31 -0700 (PDT)
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Trent Piepho <tpiepho@impinj.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
 <20190510214550.18657-5-tpiepho@impinj.com>
 <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
Message-ID: <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
Date:   Sat, 11 May 2019 14:32:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.05.2019 12:41, Heiner Kallweit wrote:
> On 10.05.2019 23:46, Trent Piepho wrote:
>> The variables used to store u32 DT properties were signed ints.  This
>> doesn't work properly if the value of the property were to overflow.
>> Use unsigned variables so this doesn't happen.
>>
> In patch 3 you added a check for DT properties being out of range.
> I think this would be good also for the three properties here.
> The delay values are only 4 bits wide, so you might also consider
> to switch to u8 or u16.
> 
I briefly looked over the rest of the driver. What is plain wrong
is to allocate memory for the private data structure in the
config_init callback. This has to be done in the probe callback.
An example is marvell_probe(). As you seem to work on this driver,
can you provide a patch for this?

> Please note that net-next is closed currently. Please resubmit the
> patches once it's open again, and please annotate them properly
> with net-next.
> 
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Signed-off-by: Trent Piepho <tpiepho@impinj.com>
>> ---
>>  drivers/net/phy/dp83867.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index a46cc9427fb3..edd9e27425e8 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -82,9 +82,9 @@ enum {
>>  };
>>  
>>  struct dp83867_private {
>> -	int rx_id_delay;
>> -	int tx_id_delay;
>> -	int fifo_depth;
>> +	u32 rx_id_delay;
>> +	u32 tx_id_delay;
>> +	u32 fifo_depth;
>>  	int io_impedance;
>>  	int port_mirroring;
>>  	bool rxctrl_strap_quirk;
>>
> 

