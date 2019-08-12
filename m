Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7508A959
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfHLVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:31:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37334 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLVbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:31:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so3925544wrt.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uvDclDPVZmwzB/B/xYypZolToawot09ez26hu2XcVu0=;
        b=nK2prIcS985QqV36Tu2cq3NI8S0G0L9VXWE5lJ07xfywigjJjcSqVUVP4a56qK4xpe
         axwEKeFiD8cp2umplIfRp+CIV1n0/dZqOU5G2w5b9XNpTnXmwu9Ou30RNz5IkvySkt+7
         9oW7RulUbdtuMg43SvzooWHAofbf2wlaOLIxRSwi5UD9e8PpSih+LjeiQiJQSwPxfsqy
         L8cUiD0slqgOvNNRZ7eqayiwp7ZERV+ZQxTIqVhbkqEvWwSFMw/sXbLayxvasC/oxQfm
         G/h/P8oWr2B1RARj8jUunCAHSqZOKu3QiscMjiHgNIUgZ+MUmdEE/YfOKrbR8LIKAfot
         QFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uvDclDPVZmwzB/B/xYypZolToawot09ez26hu2XcVu0=;
        b=d4kIXooMegNkPkWI5+vaF5qP67I94S50EIX2BlhnyoDuopgcbtv6Ao1m9ZdnbpP5TB
         85efmPcApmfwyyXP2yf1ziqJGD5MZaT+Pn9FvBBHdpLXdrrWloWoUb7j0E7HBCe3zRXo
         tXXUkO7qAmxbuBdnJs44PNWqM9E2awQt3p7duH0tH7jtoRFYyOI0n1s+7wRvd16c4U4K
         g+YQZMmZhyZ+0Pvn7N2QuYIu+vEuBu+WjFjbK6rktZO9jLn+zNetT2QYIUAz7pxPaPxk
         /cOCE1PjhhCWyOjmIgamuMDsGdayZDYp0rqk8rNocWldgbpjH8qvws21u9GBXkWY9uZl
         a3EA==
X-Gm-Message-State: APjAAAV+ngM+LJswVupWvUnQZQLTs43wZB/cRh8KWJik4Z+/HB8L4bsc
        StxmjV2ajvkI1j9PNKziNAwb+gZs
X-Google-Smtp-Source: APXvYqwU4gVBzv5KqEaCe3RxL2SKSZX2cUAZ2M0LdakB4yBAuWe0EQ4mm9qubWM1DK6Cw/2VpvZJhg==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr42450298wrl.79.1565645492557;
        Mon, 12 Aug 2019 14:31:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id m7sm955236wmi.18.2019.08.12.14.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:31:31 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add __set_linkmode_max_speed
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
 <5067e168-7b49-7ba9-1f17-89d17509d423@gmail.com>
 <20190812212715.GB15047@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a33b460b-e6ad-6714-4f3a-b23abb215d94@gmail.com>
Date:   Mon, 12 Aug 2019 23:31:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812212715.GB15047@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.2019 23:27, Andrew Lunn wrote:
> On Mon, Aug 12, 2019 at 11:19:31PM +0200, Heiner Kallweit wrote:
>> We will need the functionality of __set_linkmode_max_speed also for
>> linkmode bitmaps other than phydev->supported. Therefore split it.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy-core.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 9ae3abb2d..de085f255 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -207,14 +207,15 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
>>  	return count;
>>  }
>>  
>> -static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
>> +static int __set_linkmode_max_speed(struct phy_device *phydev, u32 max_speed,
>> +				    unsigned long *addr)
>>  {
> 
> Hi Heiner
> 
> It looks like phydev is an unused parameter. Maybe it should be
> removed?
> 
Right, it can be removed. Thanks!

> 	Andrew
> 
Heiner
