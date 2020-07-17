Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434D32244DE
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgGQUCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGQUCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:02:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE725C0619D2;
        Fri, 17 Jul 2020 13:02:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so12285113wrl.8;
        Fri, 17 Jul 2020 13:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QG3TuhYote73k/U/yKrq52X8lFEjdBrRQFB2lYTw5+k=;
        b=eDW8kYcTFzlD8cyyAdIPMU+koKRP3yAJHaX2IZUK69MSgHEiN01CLFJFk4vnf0I4vJ
         FCXSjDFqq8Cve4EUW6uXBaXxxe8ZWYQ5dodnJc3jwqwrxggL/3/8GN3JNO/lkYlHwHps
         LnTlCMZBqCHtGcj9hiQTPPB8ua72rc4wAmB942mVA71a9AdJgW5Bgp+Qj+W+wDqNRyNt
         os/MLA214XjCLHoC4ZEuwgGwK07KkmVil5kC2iPLOCw9+K6bM0PDaoNSRwyRJhHcMqrz
         Cev2fcHCW/wSvBPSM0lO9tBAfJL+P44HbxITZJqgCCG+pI1Wq6A9MWXkMNVar9TIvPdH
         rQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QG3TuhYote73k/U/yKrq52X8lFEjdBrRQFB2lYTw5+k=;
        b=l6Gcjh8TETQTzGP+Ud3gbF4a6wNVhbswV3fiSxzlJm1sdhNYKCgw0Jho8iWjhZrKJR
         KIgy3MepfDKKwMFAFE38RXjByWPg8nSm/hHsQMk+avin8kH4PN0f1GuaMHcV+N4eVP9b
         ft6ScQEdQ/00uMgWaV5uvWoRBgk6vbILDF2en4QB+qy+7m6uBG3BDis5DKE9qwm2775O
         gh3W09fwC5XpxHbE1oULiwMio+eDiqelzv+ngQM0duNa5q4PjWVj/+OQJ1LAVT1cnWih
         8voZHuHl6mtX3m9XcmgPCCy7QsCbEoGU7XvL05R8ZJbwNXlHqPB90R/mATw94ACIeDos
         6mKg==
X-Gm-Message-State: AOAM531LYWo4aAs7ARKRKjZNbfKNNFUDlMfRvhK9BamfJ3ZbA504zqmF
        F5D/X5Q+7xxfXRdwAzQAX93ZoZf5
X-Google-Smtp-Source: ABdhPJxTt19Jk+Xfs9t9m5b+deLwUats7rSLs/EHp3W76etVfwbpmKLH71jWVp0Lk6HEFfOT8wwFVA==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr11381440wru.373.1595016126084;
        Fri, 17 Jul 2020 13:02:06 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm17018118wrc.97.2020.07.17.13.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 13:02:05 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716223236.GA1314837@lunn.ch>
 <c86c4da0-a740-55cc-33dd-7a91e36c7738@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <50179386-08d4-9162-195e-35ca903452e1@gmail.com>
Date:   Fri, 17 Jul 2020 13:02:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c86c4da0-a740-55cc-33dd-7a91e36c7738@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 12:26 PM, Matthew Hagan wrote:
> 
> 
> On 16/07/2020 23:32, Andrew Lunn wrote:
>> On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
>>> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
>>>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
>>>>
>>>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> index ccbc6d89325d..3d34c4f2e891 100644
>>>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>>> @@ -13,6 +13,14 @@ Optional properties:
>>>>  
>>>>  - reset-gpios: GPIO to be used to reset the whole device
>>>>  
>>>> +Optional MAC configuration properties:
>>>> +
>>>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
>>>
>>> Perhaps we can say a little more here?
>>>
>>>> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
>>>> +				falling edge.
>>>> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
>>>> +				falling edge.
>>>
>>> These are not something that other vendors may implement and therefore
>>> something we may want to make generic? Andrew?
>>
>> I've never seen any other vendor implement this. Which to me makes me
>> think this is a vendor extension, to Ciscos vendor extension of
>> 1000BaseX.
>>
>> Matthew, do you have a real use cases of these? I don't see a DT patch
>> making use of them. And if you do, what is the PHY on the other end
>> which also allows you to invert the clocks?
>>
> The use case I am working on is the Cisco Meraki MX65 which requires bit
> 18 set (qca,sgmii-txclk-falling-edge). On the other side is a BCM58625
> SRAB with ports 4 and 5 in SGMII mode. There is no special polarity
> configuration set on this side though I do have very limited info on
> what is available. The settings I have replicate the vendor
> configuration extracted from the device.

The only polarity change that I am aware of on the BCM58625 side is to
allow for the TXDP/TXDN to be swapped, this is achieved by setting bit 5
in the TX_ACONTROL0 register (block address is 0x8060), that does look
different than what this is controlling though.
-- 
Florian
