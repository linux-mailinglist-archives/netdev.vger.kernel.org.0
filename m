Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF529ED81
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgJ2Nsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgJ2Nsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 09:48:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B1CC0613D3;
        Thu, 29 Oct 2020 06:48:50 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y12so2845456wrp.6;
        Thu, 29 Oct 2020 06:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MhOdAb3GUlXn5NpD6bsBRyTzuZEHVoS2KxYXcSrX7X8=;
        b=T8eLFX12h4WdXk98R5zB1UZ28+eODp+PY7rtqA4A648mCawRWlXW3GQhb96BZsLKh7
         UkqkYcMu8INa+mMa7IMkMQEmR6ue9cGkQuU2iIYB2v6KR5A7q+5AJB8ESmimZqSKdUvA
         NOjDXIDcXNG3Tv/Y4Ae4Rh2iK0I+cE6eh4VZBeUaGy+xEMOVPzLeiEI1wJzyMHxEHHm5
         3UhiUPydFXQlHofuuRZv+LOi37pjnm0XZJNXvff3ODyxpDVjTQfF6WM5W5M9pV6cljVq
         5+pLArDqSo/p6+OyPrvWGeneeQ8GYoe/+75a7ZtbQ1tAoaHy9bhBQlsNB4m/7mXNyGOk
         qXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MhOdAb3GUlXn5NpD6bsBRyTzuZEHVoS2KxYXcSrX7X8=;
        b=LuTptH259VH2Mi+CSANETKHE6w37sQtiMvKDWUAxSz4xB9bzCESKzD+02A/8TONwCn
         yFqSE5Z3lCYwvsPunP59g2dMdk0Z8/FwDs1XXKh5Ego/wfDQpgr1asyUt/9yqDNBXHV2
         xVMRMcOTv0caqhvxxrA578EoLW3IZyt5aeCJ/7NyGladTjvAHHOHaJAKWUVmH4ijRNsr
         LUs5ODBfQYzLmgp7cOIomkePofd0RCRkthQ5+7RkcW2CyZRuZdidRjd3VNv9ckf2Ot9f
         MMH2iWBN3YUR+yOyj/V1+VxKL1bosFLknAMBlcB1ckHQsACPVaz6AUrkNzDxNJ8OefQI
         cQuw==
X-Gm-Message-State: AOAM531maFnWXBn6MexdZuX4CuEaCyrLuPkjNf/ee7wWu+SgsTAhxPF3
        URYbQRfoGKW3E/8zgim6a86+2zAoQL8=
X-Google-Smtp-Source: ABdhPJxUuaR+i71RRE4BRbsMuddT+c3Q9uFdR+ug87WMYTiAkQHMH/XMvk1USkK8Ghu+U+PAZlTpiw==
X-Received: by 2002:adf:f2c9:: with SMTP id d9mr5686614wrp.319.1603979329293;
        Thu, 29 Oct 2020 06:48:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:c8fb:cb3e:2952:c247? (p200300ea8f232800c8fbcb3e2952c247.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c8fb:cb3e:2952:c247])
        by smtp.googlemail.com with ESMTPSA id m4sm5196383wrr.47.2020.10.29.06.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 06:48:48 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for
 RTL8226-CG/RTL8226B-CG
To:     Andrew Lunn <andrew@lunn.ch>, Willy Liu <willy.liu@realtek.com>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
 <20201029133759.GQ933237@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2cca91c7-99eb-3109-9958-c3db43a43a9b@gmail.com>
Date:   Thu, 29 Oct 2020 14:48:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029133759.GQ933237@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.10.2020 14:37, Andrew Lunn wrote:
> On Thu, Oct 29, 2020 at 08:07:57PM +0800, Willy Liu wrote:
>> Realtek single-port 2.5Gbps Ethernet PHY ids as below:
>> RTL8226-CG: 0x001cc800(ES)/0x001cc838(MP)
>> RTL8226B-CG/RTL8221B-CG: 0x001cc840(ES)/0x001cc848(MP)
>> ES: engineer sample
>> MP: mass production
>>
>> Since above PHYs are already in mass production stage,
>> mass production id should be added.
>>
>> Signed-off-by: Willy Liu <willy.liu@realtek.com>
>> ---
>>  drivers/net/phy/realtek.c | 18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>  mode change 100644 => 100755 drivers/net/phy/realtek.c
>>
>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>> old mode 100644
>> new mode 100755
>> index fb1db71..988f075
>> --- a/drivers/net/phy/realtek.c
>> +++ b/drivers/net/phy/realtek.c
>> @@ -57,6 +57,9 @@
>>  #define RTLGEN_SPEED_MASK			0x0630
>>  
>>  #define RTL_GENERIC_PHYID			0x001cc800
>> +#define RTL_8226_MP_PHYID			0x001cc838
>> +#define RTL_8221B_ES_PHYID			0x001cc840
>> +#define RTL_8221B_MP_PHYID			0x001cc848
>>  
>>  MODULE_DESCRIPTION("Realtek PHY driver");
>>  MODULE_AUTHOR("Johnson Leung");
>> @@ -533,10 +536,17 @@ static int rtlgen_match_phy_device(struct phy_device *phydev)
>>  
>>  static int rtl8226_match_phy_device(struct phy_device *phydev)
>>  {
>> -	return phydev->phy_id == RTL_GENERIC_PHYID &&
>> +	return (phydev->phy_id == RTL_GENERIC_PHYID) ||
>> +	       (phydev->phy_id == RTL_8226_MP_PHYID) &&
>>  	       rtlgen_supports_2_5gbps(phydev);
> 
> Hi Willy
> 
> If i understand the code correctly, this match function is used
> because the engineering sample did not use a proper ID? The mass
> production part does, so there is no need to make use of this
> hack. Please just list it as a normal PHY using PHY_ID_MATCH_EXACT().
> 
Right. My understanding:
These PHY's exist as standalone chips and integrated with RTL8125 MAC.
IIRC for RTL8125A the integrated PHY reports RTL_GENERIC_PHYID, since
RTL8125B it reports the same PHYID as the standalone model.
