Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD8270BB
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfEVUUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:20:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42126 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbfEVUUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:20:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id l2so3705696wrb.9;
        Wed, 22 May 2019 13:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hJ3ej8py+Wxc2VlvlHjY1p/wLt20dzwN/+OWPey88w4=;
        b=okwRlntBU/e5X4mU8CUmzNTKs2XHciHl2wuUT5pqGMkObNP67qyaI433fg7oHAXrxA
         ZFztQH57w39AD3fW01Eoz9Sg7I9c3RfnaAX16WH7aLbjyqRWGAmGlWoneqTFvm74LNR5
         9qeeEjZEs/7H6J6KJLHDUeWvEwgCxG067lz6euHyA17EhEKRnxiK5FQQbs3ew+nbPifo
         hOi2WuW0QE7QtgXI6jtFUG3pIhFE47XtP3DTxwewJwB+jcuUKu5XhNZkGKwsHjzGEQZf
         e9i6RVehYBi4HSpQ+37DhD2hugVQ7GsjnHZdm4MPmBOyNa8pqhXlPXzXNexutX6VBVkj
         zh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hJ3ej8py+Wxc2VlvlHjY1p/wLt20dzwN/+OWPey88w4=;
        b=N6RDIXALzUTkfOS+Nc++yaSBgZx+uLwEBHKJFkeaytkGbP6JV1EchX9hDO++VhzJNu
         8o8vlrAmni8wNyqIrhxXI9zf0xaYLKvNoSAF0sJDPRQkFJC2WoZSDm3pQerEhqKAaRZX
         nu5RsPJzJ1uqBrilcsbrCRqtw5NBQsMWrTsGGIIb5NkBzoWeBI68vz7j05372vUFSRXx
         zkNuYiEn9ODaoN1RkNKEUCGZjeNplXQ6kr82Pf1mC/05ephDM81uHrTory6c+NrF1cQb
         xooxdbETtKhs3K9NLqVhNHRThQflLxRRirXHrP9i24O2UzsCSG3ADmQPsQRxPNfVlWjj
         4dPg==
X-Gm-Message-State: APjAAAVgsQHi7RwtwdnNnWYG9JGa2EdJ8g/KuA4LDlSzPModkeZy2W77
        NvwO3sFJDgoB6Ay54i1l8SprnK1h
X-Google-Smtp-Source: APXvYqxDZmQjYjYbsKSkIyAXGUGxumciwy7DHsXsBPbF76xPyEEQ9fvSgLgcYUta8wO/UjUUMWNoxQ==
X-Received: by 2002:adf:f9c3:: with SMTP id w3mr9446188wrr.271.1558556409448;
        Wed, 22 May 2019 13:20:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:3029:8954:1431:dc1e? (p200300EA8BD45700302989541431DC1E.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:3029:8954:1431:dc1e])
        by smtp.googlemail.com with ESMTPSA id v5sm51881143wra.83.2019.05.22.13.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 13:20:08 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: aquantia: add USXGMII support
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
 <2c68bdb1-9b53-ce0b-74d3-c7ea2d9e7ac0@gmail.com>
 <46a141c7-f838-ae4b-4a47-5b1fb44ef063@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e7a7c38c-ebe7-1cea-4099-3cf3a4483ac7@gmail.com>
Date:   Wed, 22 May 2019 22:18:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <46a141c7-f838-ae4b-4a47-5b1fb44ef063@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.2019 22:07, Florian Fainelli wrote:
> On 5/22/19 12:58 PM, Heiner Kallweit wrote:
>> So far we didn't support mode USXGMII, and in order to not break the
>> two Freescale boards mode XGMII was accepted for the AQR107 family
>> even though it doesn't support XGMII. Add USXGMII support to the
>> Aquantia PHY driver and change the phy connection type for the two
>> boards.
>>
>> As an additional note: Even though the handle is named aqr106
>> there seem to be LS1046A boards with an AQR107.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> You can probably split the DTS changes and the PHY driver changes into a
> separate commits and just have the DTS changes come last? With that:
> 
To split the patches I would have to do:
1. Add USXGMII support to Aquantia PHY driver
2. DTS changes
3. Don't accept XGMII any longer in Aquantia PHY driver
This seemed to me to be too much overhead considering the very small
change.

Just making the DTS changes a separate patch would break bisecting.

> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 

