Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A691224432
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgGQT0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgGQT0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:26:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB13C0619D2;
        Fri, 17 Jul 2020 12:26:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so12284239wrs.0;
        Fri, 17 Jul 2020 12:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AkK4eyDYfDukVVGQtgB78a5zI96VA608ufKkpODlhC0=;
        b=fMjzFzVm1SOC5vGih5G//3tySgQLem+30D4ao6tDLAhb1tX1YQWkGlw9X/r0X2DbHs
         fNDxKs03oWU4VSYYEGt9DlHrweDMGuR7Apnt2al4Zhuu2Uo5eiYk9ITPNQBWYHqEC92s
         fQnbFXg4yMKnIiiQzm/EAknzsouXtS3jPLt0lKkWPLkudB3rPgaiJ/NdjBgDsqhUMcmp
         P3QSHNt+YyIN8a0l/zzvlu/we9WyfUTuOjyEMT2tHce7ydUcfMmfjApTu4fGG3dRaIQU
         nK8ztcvOZqrDbDZ1VCtsXCjugObMoYw79hHv8dibXYPRTCr8+JjFxfEk/Y7afjzuFfAo
         NsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AkK4eyDYfDukVVGQtgB78a5zI96VA608ufKkpODlhC0=;
        b=S7BbXtUNP/NOTCo1vOufAfFr/HiDH4IZeQHPNi5TOwfJ8txuMvaDV6mcVWHMP6BZyM
         XbA/R5oXIsH/zKtkptXEAg7WdvCknvFBoXBYw6ceKhSLrneAFuRs32hGpOq9dvL0il0G
         ibCqmaUcs3i0rlEtAiKAv70w9AHobZ/WciYReVEuk935kOVINrQEkJgC+kEO9rmhaNbD
         KShojIj6EPqhuUQGC9GiIv2KHGdrxjBsH0NwHFDKn5dJyzbG3QJeRkEbB/S+6Wm/TctZ
         tbZiFOdS4DR0ML4iaoU+25F3FB24bqRhMXaTIHQKiTiw0Med99roGcOGc7f5HNfgCW9o
         wGOA==
X-Gm-Message-State: AOAM532Vx94ns8mvNH7azKGCQf7Bm5N2BmDkBTGHlI06SMIdkiUxBzDr
        8fpvGe4Y+ETvIGRoI7fO4jfkobHT
X-Google-Smtp-Source: ABdhPJyzzgQauzZrXRLBUtlDbHT36pCVhtn35Z5SW1bVvs345TJZd2iZoA/uNDwvVculMX3hyFJrOQ==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr11792085wro.359.1595013965061;
        Fri, 17 Jul 2020 12:26:05 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id g145sm20090812wmg.23.2020.07.17.12.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 12:26:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716223236.GA1314837@lunn.ch>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <c86c4da0-a740-55cc-33dd-7a91e36c7738@gmail.com>
Date:   Fri, 17 Jul 2020 20:26:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716223236.GA1314837@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/07/2020 23:32, Andrew Lunn wrote:
> On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
>> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
>>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
>>>
>>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> index ccbc6d89325d..3d34c4f2e891 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> @@ -13,6 +13,14 @@ Optional properties:
>>>  
>>>  - reset-gpios: GPIO to be used to reset the whole device
>>>  
>>> +Optional MAC configuration properties:
>>> +
>>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
>>
>> Perhaps we can say a little more here?
>>
>>> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
>>> +				falling edge.
>>> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
>>> +				falling edge.
>>
>> These are not something that other vendors may implement and therefore
>> something we may want to make generic? Andrew?
> 
> I've never seen any other vendor implement this. Which to me makes me
> think this is a vendor extension, to Ciscos vendor extension of
> 1000BaseX.
> 
> Matthew, do you have a real use cases of these? I don't see a DT patch
> making use of them. And if you do, what is the PHY on the other end
> which also allows you to invert the clocks?
> 
The use case I am working on is the Cisco Meraki MX65 which requires bit
18 set (qca,sgmii-txclk-falling-edge). On the other side is a BCM58625
SRAB with ports 4 and 5 in SGMII mode. There is no special polarity
configuration set on this side though I do have very limited info on
what is available. The settings I have replicate the vendor
configuration extracted from the device.

The qca,sgmii-rxclk-falling-edge option (bit 19) is commonly used
according to the device trees found in the OpenWrt, which is still using
the ar8216 driver. With a count through the ar8327-initvals I see bit 19
set on 18 of 22 devices using SGMII on MAC0.
>        Andrew
> 

Matthew
