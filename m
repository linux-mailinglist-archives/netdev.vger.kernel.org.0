Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0EFEEFD2
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfD3FGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:06:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37993 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfD3FGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 01:06:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id w15so2259046wmc.3
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 22:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1bh8dfyt2GCkUeU1GfAVChHm0XE+SZs0+JfK3cPAldI=;
        b=IItZLrNs99/sMwbpTa/Bq7SFEFFjKGcUJb84Lclfz/N4Ib+vGvdpPZsfk3un+jWkCZ
         uYrBLHuranIV5viHiNxDWe7fzRN8WkOtKVMWFlYr/E1qvommIy9sBxR26J7uaKDf6Fvt
         SSyFJIzD4y+sBP6P/a67gXvQ5ZPDuWimyNczRiPnmefIarVmTKh861DhuvnfE3ASbXwH
         Fz0yp8Zj6mhJWImgnkL2rZ5NNpmwtvXIMZevYUzPULVNzQAT6p2X8bQYdiy+dJymptWI
         UGnM1tOORBMyBHefI3uXZeP+gEpaEP0xMey6YMTu9Lan9B1wz4RdevArE5hImpSBSw6P
         IymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1bh8dfyt2GCkUeU1GfAVChHm0XE+SZs0+JfK3cPAldI=;
        b=fDggQ8XdpcooDKcm9/O9skjEhP8RLVV1bTWmGRxnyYdq2mcLSBbR4w8sNEP4sdB8Ij
         M0KAP2LM+yIt/g2TyUFW5ZCtpGdARGa16ebe5I7Yl9nhyxq5gMNs/kDd05F39yzdkcf3
         VSYOgkROlpvCitiNoczm6fp37OTHCggCLres+bi9Nr4FpgvRi6hiDwMX2x8QXY42cgCa
         LJ3vpcrEGfngoOT+Lj3HZphRHIv0IqjLh7em6lCyywt3Y3PSP221bixJFOxSpLVwbyHq
         mAoMMEWJ9aeZTtBYVWSoazoESIo9EjeMYCdtWuCgFqx7WiZlRewpXr/Mm21VRK9R3nfb
         JRmg==
X-Gm-Message-State: APjAAAVnIAB0ykywKh8nAzOxSU0HJaNYHs6824t9AbEOlhixqSTY9rFx
        Dtp6RJPirFrm+6Gd18W+EduuiMSXCjU=
X-Google-Smtp-Source: APXvYqxLytOHfffqX1U6Of97pw4C5/fwLsXbsfL4BnHphM8HoigJWMvun20YcRhkdXD/pZnO+dx7fA==
X-Received: by 2002:a7b:cb58:: with SMTP id v24mr1546059wmj.107.1556600782918;
        Mon, 29 Apr 2019 22:06:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:99bd:4903:47b8:eba4? (p200300EA8BD4570099BD490347B8EBA4.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:99bd:4903:47b8:eba4])
        by smtp.googlemail.com with ESMTPSA id n1sm1124770wmc.19.2019.04.29.22.06.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 22:06:21 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: improve phy_set_sym_pause and
 phy_set_asym_pause
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
 <f5521d12-bc72-8ed7-eeda-888185c6cee6@gmail.com>
 <20190429215254.GG12333@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <40b84e7e-24ed-bf14-f55d-c943ac9f4f4c@gmail.com>
Date:   Tue, 30 Apr 2019 07:06:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429215254.GG12333@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2019 23:52, Andrew Lunn wrote:
>> @@ -2078,6 +2089,11 @@ EXPORT_SYMBOL(phy_set_sym_pause);
>>  void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>>  {
>>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
>> +	bool asym_pause_supported;
>> +
>> +	asym_pause_supported =
>> +		linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +				  phydev->supported);
>>  
>>  	linkmode_copy(oldadv, phydev->advertising);
>>  
>> @@ -2086,14 +2102,14 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>>  	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>  			   phydev->advertising);
>>  
>> -	if (rx) {
>> +	if (rx && asym_pause_supported) {
>>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>>  				 phydev->advertising);
>>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>  				 phydev->advertising);
>>  	}
>>  
>> -	if (tx)
>> +	if (tx && asym_pause_supported)
>>  		linkmode_change_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>  				    phydev->advertising);
> 
> Hi Heiner
> 
Hi Andrew,

> If the PHY only supports Pause, not Asym Pause, i wounder if we should
> fall back to Pause here?
> 
I wasn't sure about whether a silent fallback is the expected behavior.
Also open is whether we can rely on a set_pause callback having called
phy_validate_pause() before. Another option could be to change the
return type to int and return an error like -EOPNOTSUPP if the requested
mode isn't supported.

>      Andrew
> 
Heiner
