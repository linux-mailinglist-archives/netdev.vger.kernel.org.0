Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4C2CE26
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfE1SCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:02:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40248 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1SCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:02:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id t4so12978310wrx.7
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o2XAqYHBRRXqop92/vhzf3wD+OKxfbcncqhMQPcozi4=;
        b=M/yIHzKgVqh0UBB5/QA5jnarOszKyb1+VtN1R8DRpijg7FNikO81wbVRQsNWOc+RzJ
         pkylpHEinS3tupuRXyq8WPtHydexuhLkEvzN1/o6Qz7nokdFDSnMUObYj+/5QWnUw1v+
         jYAqMpWiuDgMH13CtagwjaX66dmA4CHEF0FR7/DJSpkg4WsB1ZLe7G9xfqcRNrH8pt8D
         Dtv7VrGd79j6rpf9OFzFH4NJVsd17VVMTwcnlVuuTQw0XBC+nlD9dJIvOsb/QSn6y+DY
         S4B06PZ5uGnliwZ8d7uZW10bfCDWN0J6xNLVCyJ1c4Gi79rJkv6DxcTP5GfnEn0SJdcd
         ucRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o2XAqYHBRRXqop92/vhzf3wD+OKxfbcncqhMQPcozi4=;
        b=XR17+833LUS9s5GXkYrpN/NEoV3PJhRKwqnfhpbjRjbygDTi6SO/CZ0k9LiEWj5Q5t
         Yx1LAJWXEcI6mabSz0e9LSy+nYMYDTZIioU8VzbD/0PTbw7nWYm9/BzhJLuHhSMx9y4P
         y+8Sn6MYcR+XwWLgtFDVjlIkixXH7XRmynqzEMauC0VhuiehpRzrvJHT2x/f6eZ7VeA/
         CwxBWE9rYpNm85N6G153s+F9bSQFgc9ns4qVyb9HP9OKMmT7mX9UGp6v0HRvpExoDZQS
         2s/ss5pxlBtsyJR9pXfMiKaMgeR4XjS4y6fevJq4+J2oG5WG8po1OVtpqft+l11A+Ab6
         Mqsw==
X-Gm-Message-State: APjAAAWKFvJV8M7V4qtFkgKdsT8lPTfbehY7OWVwGyKGNOwS4+C1efUk
        ktcj+N4Mo+S+NoyavillutVkB7KR
X-Google-Smtp-Source: APXvYqw2/MGBUxNuW426Lc+XLeIGze2WzEpVPnJePX7WapSrpEFhloe4qXCgPafs3AqOhLKSW7V/RA==
X-Received: by 2002:a5d:5048:: with SMTP id h8mr1925883wrt.177.1559066536681;
        Tue, 28 May 2019 11:02:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id w10sm2723055wrr.67.2019.05.28.11.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:02:16 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: remove 1000/Half from supported modes
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac29e5b9-2d8a-f68d-db1b-cdb3d3110922@gmail.com>
 <9b73d283-c284-1ccf-7a43-15f66084cba1@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4d22f35c-4f1c-48e8-b32d-dcbed59d3dd2@gmail.com>
Date:   Tue, 28 May 2019 20:02:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9b73d283-c284-1ccf-7a43-15f66084cba1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 19:40, Florian Fainelli wrote:
> On 5/28/19 9:43 AM, Heiner Kallweit wrote:
>> MAC on the GBit versions supports 1000/Full only, however the PHY
>> partially claims to support 1000/Half. So let's explicitly remove
>> this mode.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Don't you want a Fixes: tag for that?
> 
I'm not aware of any problem caused by that. And according to what
I've read 1000/Half has been specified but never really been used.
So it should be sufficient to treat this as an improvement.

>> ---
>>  drivers/net/ethernet/realtek/r8169.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
>> index 61e7eef5e..0239a3de2 100644
>> --- a/drivers/net/ethernet/realtek/r8169.c
>> +++ b/drivers/net/ethernet/realtek/r8169.c
>> @@ -6397,7 +6397,10 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>  	if (ret)
>>  		return ret;
>>  
>> -	if (!tp->supports_gmii)
>> +	if (tp->supports_gmii)
>> +		phy_remove_link_mode(phydev,
>> +				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
>> +	else
>>  		phy_set_max_speed(phydev, SPEED_100);
>>  
>>  	phy_support_asym_pause(phydev);
>>
> 
> 

