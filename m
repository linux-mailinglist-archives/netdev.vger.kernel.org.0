Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4E10D37
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEATcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41930 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfEATcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 15:32:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id c12so25713521wrt.8
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 12:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mEUGlVwEFwACHWYLiLq66kqXDolevcELyCsdP2CXGSM=;
        b=I2Hd62zPwgbxiLIV1+AZinEkAmbnuftGgAmTC8VqwqzrPgTU2qjuJmEHe7medO7BBX
         PAN6sAbNe1VnY7kdegoT1OvcydY/+yGef8jlfabz2JgIZ47OjcpWcBsyvrFKv/BbVr6E
         p3Fz2eIt1DfEUuuBzDr6dVPz21TR/hlVfwRg3do92FL1q5YC3R6zYuOPoQ32G2J1QjIw
         m4R9F3xKE519SplyYciQU13v7zPJhMKmya8nCSYmQWEvOuMaissHli1UjUBFalfmciQl
         GcZKVznGHfGGEcQmYT+vYhNbI4x0QCUVS7Hf9Raae/90SRIFmQXU4oFpuatouFVQ8K+V
         vIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mEUGlVwEFwACHWYLiLq66kqXDolevcELyCsdP2CXGSM=;
        b=fjDYBtCBJF8SWxMKnGMjAl1E52HECKLTflI89B3SHgCBYEatHG1LblY0Clu/tEfSKK
         yV7SPtpmDbgJ1mcxW+JTJAeffRCCAt1X89oWZdal8zhfGW5ktuaLbi2AvLke3ArGn/Fn
         rLvIzWfJfQEYL6p0ELh5n9JYhxK4AMKudiyhoNgsgK0yXDAPe8lyyyDuCEaB/gWhFOrT
         pEwb03Lw8jMisUVuSr7NXtpCICATt/KcREWFufaRn6XF076l4wU751frdKMMJJZgY2Ku
         FpvA9pzhV18mBphBZgFRgMXZjAarFfGtlIyfFyaAPQdz3MWdDHnX+xZXRE6pJvQtdJv/
         tUgw==
X-Gm-Message-State: APjAAAUHeS7FsawmCvbLJoPvRSWfP8OSeWu7C/fE/56snekX/xOiUALO
        CUltp3Id9n6CtKvYFTEoPN6TzV9pN5s=
X-Google-Smtp-Source: APXvYqzsYYgsIYTw8Na672wbR6vb9y7j9y305CRp+/Q+bDVqC3GzvZPTuqozK4LTdPnoJLOifLTyAg==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr28854113wrm.188.1556739139154;
        Wed, 01 May 2019 12:32:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:a160:62e9:d01f:fc0a? (p200300EA8BD45700A16062E9D01FFC0A.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:a160:62e9:d01f:fc0a])
        by smtp.googlemail.com with ESMTPSA id g28sm15907997wrb.50.2019.05.01.12.32.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:32:18 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: improve phy_set_sym_pause and
 phy_set_asym_pause
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
 <f5521d12-bc72-8ed7-eeda-888185c6cee6@gmail.com>
 <20190429215254.GG12333@lunn.ch>
 <40b84e7e-24ed-bf14-f55d-c943ac9f4f4c@gmail.com>
Message-ID: <f2fb8c83-c824-9c61-0660-22c164cde5c7@gmail.com>
Date:   Wed, 1 May 2019 21:32:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <40b84e7e-24ed-bf14-f55d-c943ac9f4f4c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.04.2019 07:06, Heiner Kallweit wrote:
> On 29.04.2019 23:52, Andrew Lunn wrote:
>>> @@ -2078,6 +2089,11 @@ EXPORT_SYMBOL(phy_set_sym_pause);
>>>  void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>>>  {
>>>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
>>> +	bool asym_pause_supported;
>>> +
>>> +	asym_pause_supported =
>>> +		linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>> +				  phydev->supported);
>>>  
>>>  	linkmode_copy(oldadv, phydev->advertising);
>>>  
>>> @@ -2086,14 +2102,14 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>>>  	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>>  			   phydev->advertising);
>>>  
>>> -	if (rx) {
>>> +	if (rx && asym_pause_supported) {
>>>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>>>  				 phydev->advertising);
>>>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>>  				 phydev->advertising);
>>>  	}
>>>  
>>> -	if (tx)
>>> +	if (tx && asym_pause_supported)
>>>  		linkmode_change_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>>  				    phydev->advertising);
>>
>> Hi Heiner
>>
> Hi Andrew,
> 
>> If the PHY only supports Pause, not Asym Pause, i wounder if we should
>> fall back to Pause here?
>>
> I wasn't sure about whether a silent fallback is the expected behavior.
> Also open is whether we can rely on a set_pause callback having called
> phy_validate_pause() before. Another option could be to change the
> return type to int and return an error like -EOPNOTSUPP if the requested
> mode isn't supported.
> 
Most drivers call phy_validate_pause() first, this seems to be the
expected pattern. Therefore I will remove patch 2. However there seems to
be an error in phy_validate_pause(), the fix I will submit separately.

>>      Andrew
>>
> Heiner
> 

