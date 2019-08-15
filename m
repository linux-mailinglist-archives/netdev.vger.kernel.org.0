Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D988F000
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfHOQCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:02:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36125 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOQCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 12:02:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so2683789wrt.3
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 09:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ElWmbfy3ghK86ayEzY044PYSfCfg/f08IA+QEvdMfUM=;
        b=Z0tvmr059faZ5uxybM0+mCWvDj2fWpBozggi4wVippTKKofb6by2J7jTUNMYGmFWyH
         fWO5RGQCN+Y5lvsZcmSI+5lQCASjqUv70AWRp32IiBsCurRW0QDIYu/cM1fIi5Hqsq2p
         PcUPIGA8B394Qh64rMwhPJtHbbdUv7pDbubGqosf9RC7LxZvka6P42DJN9z6aC8k8LWh
         ngjrhaxVmbzw2oXxqKkA5K61XCqZ91N8M+k3DOvJBPAekMRISmUTWiSfYoFEDFEbHTZ1
         YVyK/lD4EzMjTGIxXRR0CAHporBnrgocQoDnKPMYlLQVX/r2puv6fEDe/YpMsUdNsCEy
         jZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ElWmbfy3ghK86ayEzY044PYSfCfg/f08IA+QEvdMfUM=;
        b=RJWJmQW+mn+VDA6oPOC2N9rr5QcWZN60IwcwHwDL3jPbM+68a41USiWOLgjzCj2N1T
         21i1k0pgUX+yp4op/XodNEZed4BH0qqcZaB1bO2RRTsOBv9RG30/R9Css2fUiwEb0xnD
         UGTRZqKADTKZ9plr3lEztJSOVrPnvr4NLGvhOe7DLD41ItNmLb+JowNIO82qR1ReFJ+6
         hMO3j6cKWBM5L0Vnncbjv/jFgaDo92uv6XWuyFamGsNzQJxGedXydbctzgKdxhjVdKek
         X9KK3rrMhFhVX9LbLNWoL7Lw/UgWNvG3Q+IvPYDM0CIKpNqAVorEWPq731jY3N90pgF8
         UrRQ==
X-Gm-Message-State: APjAAAUFHx0kM/K3pgqC9ys7P36SaUuG1oZ6DVBUOiLRIW3nYc0Fy+CE
        9QPv0YnwLpYAXevWJl3CSX0cNFJv
X-Google-Smtp-Source: APXvYqyWe9y8sdSQJD/5n/uWTnojnDJGiK1VXVCf3eUBo+fp2BEOWef3s6BRORxQ5fFBktk903cdbA==
X-Received: by 2002:a5d:604d:: with SMTP id j13mr6075664wrt.244.1565884960383;
        Thu, 15 Aug 2019 09:02:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:c0f5:392f:547b:417a? (p200300EA8F2F3200C0F5392F547B417A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:c0f5:392f:547b:417a])
        by smtp.googlemail.com with ESMTPSA id w13sm6376934wre.44.2019.08.15.09.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 09:02:39 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] r8169: use the generic EEE management
 functions
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
 <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
 <20190815123558.GA31172@lunn.ch>
 <bfd67eb3-0da7-b8a5-928a-a66802185b68@gmail.com>
 <24146e48-c498-d13a-8c12-76519455d0d4@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c536f0bf-d271-ec89-d219-69cd19c28c65@gmail.com>
Date:   Thu, 15 Aug 2019 18:02:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <24146e48-c498-d13a-8c12-76519455d0d4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 17:43, Florian Fainelli wrote:
> 
> 
> On 8/15/2019 6:02 AM, Heiner Kallweit wrote:
>> On 15.08.2019 14:35, Andrew Lunn wrote:
>>> On Thu, Aug 15, 2019 at 11:47:33AM +0200, Heiner Kallweit wrote:
>>>> Now that the Realtek PHY driver maps the vendor-specific EEE registers
>>>> to the standard MMD registers, we can remove all special handling and
>>>> use the generic functions phy_ethtool_get/set_eee.
>>>
>>> Hi Heiner
>>>
>> Hi Andrew,
>>
>>> I think you should also add a call the phy_init_eee()?
>>>
>> I think it's not strictly needed. And few things regarding
>> phy_init_eee are not fully clear to me:
>>
>> - When is it supposed to be called? Before each call to
>>   phy_ethtool_set_eee? Or once in the drivers init path?
>>
>> - The name is a little bit misleading as it's mainly a
>>   validity check. An actual "init" is done only if
>>   parameter clk_stop_enable is set.
>>
>> - It returns -EPROTONOSUPPORT if at least one link partner
>>   doesn't advertise EEE for current speed/duplex. To me this
>>   seems to be too restrictive. Example:
>>   We're at 1Gbps/full and link partner advertises EEE for
>>   100Mbps only. Then phy_init_eee returns -EPROTONOSUPPORT.
>>   This keeps me from controlling 100Mbps EEE advertisement.  
> 
> That function needs a complete rework, it does not say what its name
> implies, and there is an assumption that you have already locally
> advertised EEE for it to work properly, that does not make any sense
> since the whole purpose is to see whether EEE can/will be active with
> the link partner (that's how I read it at least).
> 
> Regarding whether the clock stop enable can be turned on or off is also
> a bit suspicious, because a MAC driver does not know whether the PHY
> supports doing that, I had started something in that area years ago:
> 
> https://github.com/ffainelli/linux/commits/phy-eee-tx-clk
> 
Not related to this patch, but to EEE support in general:

There's something in the back of my mind to create linkmodes for all
EEE modes. They could be used with the normal supported, advertising,
and lp_advertising bitmaps. Means:
- extend genphy_read_abilities to read supported EEE modes
- extend genphy_read_status to read lp-advertised EEE modes
- let genphy_config_aneg handle EEE advertising
- ..
This should help to make EEE mode handling consistent with link mode
handling.
Also still missing is support for the new C45 registers for 2.5Gbps and
5Gbps EEE (3.21, 7.62, 7.63).

Open for me is how to deal best with the scenario that older PHY's
use the C22 MMD registers for proprietary purposes. Writing to the
MMD address register then may cause misbehavior of the PHY (that was
the case for RTL8211B), and MMD reads may return random data.
Maybe we need a flag to explicitly state whether MMD is supported
or not.

Heiner








