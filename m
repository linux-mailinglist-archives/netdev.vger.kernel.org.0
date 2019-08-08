Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2347B86ABF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390169AbfHHTsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:48:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51285 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732544AbfHHTsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:48:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so3508859wma.1
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/2fxFs41NwQWIty5xzwZL2Xf3rruq63o4Zcf2usdTGg=;
        b=NSBF00O7rk4P1rDI4j1iTl9OKHfC7TYFtRvUWKw1KOYKSaZD9fuhImzSTdAynL6k32
         Z/tbd97cPOxku4ASMVaMBvmB1I/WdvDScuo0S+4Zhx7//3nBzt8O7cwHILr6gDZbL0I8
         1nJGagkbMm1wIWoKUc9LIsl2N8yazgHrxSTI87dLfzo3iTipI+8Ok3gifUFUXgSryWaH
         3A89VVr765GZg2sqeyEPdRsTlr4GiQQ+xK6be0RNc6jq08YyalEjiajHpgh79yh1nAnb
         XmbxIGRKKJ2ogPJU/htg8SmWkgeUFnpIagfVE2PUSrD3+A5tbNahfbVhRUlIVTVwEq72
         KGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/2fxFs41NwQWIty5xzwZL2Xf3rruq63o4Zcf2usdTGg=;
        b=UbGDS2lbv1OLIWO/a7wuvnosmA9Z3oU0YtUVFrWiwITBpjQxeQWca3gnxMtmyXYAqL
         jJ7q7zI1M4fJShUJ1bRfze9UXKftnwwSP1fdqvOrz3X5Fr6IIT3AvRaTYchRNPbihqdF
         kmhaSX/xzXGICYeI07HXbU+m4LTJFfof/gZV/wdblXymT7QLmN5v2ognTUgIUJ9aXnx/
         hN21b7gQw5+gxdzP60jEA7nH8DRr17/sNFbzm39gd9GVb4YzpIPlH6ZkLo26cuK/ZCl/
         zFjQ1WPTDn+Gusn4v+JM7yiA1QlI59RmaTxHiYwtjShzocTV7H9T9rr5JhfhkK8ZitNw
         BuWQ==
X-Gm-Message-State: APjAAAXTYSRn/PStIU709TBc+BuPNUp14iiCWy+vvMuUSfMU98LpSeG5
        RAyxhlGKTKVLO2uig8jS/u0NR8Xh
X-Google-Smtp-Source: APXvYqwlf7pMTDvWiZujNDPE6HX2l7GNJ+1gAuNMUKbb3X/MAw0uKhLWw29MXGTZMPeH/Rw720OggQ==
X-Received: by 2002:a05:600c:551:: with SMTP id k17mr6155324wmc.53.1565293688909;
        Thu, 08 Aug 2019 12:48:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id v5sm145582782wre.50.2019.08.08.12.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:48:08 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
 <20190808193743.GL27917@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
Date:   Thu, 8 Aug 2019 21:46:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808193743.GL27917@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 21:37, Andrew Lunn wrote:
> On Thu, Aug 08, 2019 at 09:05:54PM +0200, Heiner Kallweit wrote:
>> This adds support for the integrated 2.5Gbps PHY in Realtek RTL8125.
>> Advertisement of 2.5Gbps mode is done via a vendor-specific register.
>> Same applies to reading NBase-T link partner advertisement.
>> Unfortunately this 2.5Gbps PHY shares the PHY ID with the integrated
>> 1Gbps PHY's in other Realtek network chips and so far no method is
>> known to differentiate them.
> 
> That is not nice.
> 
Indeed.

> Do you have any contacts in Realtek who can provide us with
> information? Maybe there is another undocumented vendor specific
> register?
> 
I have a contact in Realtek who provided the information about
the vendor-specific registers used in the patch. I also asked for
a method to auto-detect 2.5Gbps support but have no feedback so far.
What may contribute to the problem is that also the integrated 1Gbps
PHY's (all with the same PHY ID) differ significantly from each other,
depending on the network chip version.

> 	Andrew
> 
Heiner
