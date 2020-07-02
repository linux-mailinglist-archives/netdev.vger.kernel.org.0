Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2A212D92
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGBUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:04:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0052CC08C5C1;
        Thu,  2 Jul 2020 13:04:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so9696459wmc.1;
        Thu, 02 Jul 2020 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXq9disgHLt9GBV0pwwRmM40yiapw6jXrYFzU9ELtYE=;
        b=dKCPjOpmYL9C4m73nq3Bb1NKmDYjXgXmdng67PHDhQPObjGKzqS3BJ0vmTFBbr62Jr
         9D80+DX+He0RerTsGOvLbjLqC9W3NoJ8jvq2pdbW66jZZFJ0dQ22RY7KJIYzGDutYZL+
         3YkL3qjkXoEtPknTR3cUebjRMG0WpBXG60oYsycec8q9ZdwHWG/qMeHxl9ljkAhF+rEJ
         Uf09n3Ylgjac1IAU2yZvjueQsI/haWiE8mWxZ7EdTGIwRFtyDc8BcJuuJJFLoQDfg9vL
         iW0YolB6LKEhtWPXw4P0iaZG/e6tzLpJSBkjQimmbvo/xMoBd8VkoNoQug0RhSFgcOvL
         i1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXq9disgHLt9GBV0pwwRmM40yiapw6jXrYFzU9ELtYE=;
        b=Xi6XEh9/zUVxVruOiBPnUQvXKlE+i/xbCMAGgx3zOJF0dWIpb5mAtb2dKuG6/niK/K
         /g4dvk206Cji7BNlOWSoA79/QjDrE8paE42xgSp5myVzOB0afnq0mELwcUn4Uz5nA/No
         HkrW7EQ2rLUbPadZa3QEMo6xldIXh2TL6YMjmVjcsK3b/ucMkjL/FL3gL+1lPe8LfrpJ
         DB9EeWTR5jMiFfcW7n+gewokn/xpY/q4qR+QgQRqIFz/Jr0WKN1Bni3iswhkxpvKTtIE
         8Nbkgd4R7/cNdXg1eRdAxyFoNcJXwz75SPmuArSX9RfoH7Iy0Rd1If8whXCuq9QKVDTd
         UF3Q==
X-Gm-Message-State: AOAM53122aTj5WvPJVKneToY/y/MN0i7osRb0RyABxnVKOVdI4OKtZfv
        A/lzTCuPNulBrmoxQcwiiYs=
X-Google-Smtp-Source: ABdhPJwUZcL1Xeu7gExBO2h9ZoAaNCI8QVciXggW2GVVON9/DsAkuiBiamu0YWMY0kXQ1AtCcyJRIw==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr31598111wmn.167.1593720281729;
        Thu, 02 Jul 2020 13:04:41 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w17sm12674826wra.42.2020.07.02.13.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 13:04:41 -0700 (PDT)
Subject: Re: [net-next,PATCH 4/4] dt-bindings: mdio-ipq4019: add clock support
To:     Robert Marko <robert.marko@sartura.hr>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-5-robert.marko@sartura.hr>
 <20200702133842.GK730739@lunn.ch>
 <CA+HBbNGcV0H4L4gzWOUs8GDkiMEOaGdeVhAbtfcT5-PGmVJjfA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <42ebc500-35ba-48f6-c4d1-3743abde1852@gmail.com>
Date:   Thu, 2 Jul 2020 13:04:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+HBbNGcV0H4L4gzWOUs8GDkiMEOaGdeVhAbtfcT5-PGmVJjfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2020 12:18 PM, Robert Marko wrote:
> On Thu, Jul 2, 2020 at 3:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>> +  clock-frequency:
>>> +    default: 100000000
>>
>> IEEE 802.3 says the default should be 2.5MHz. Some PHYs will go
>> faster, but 100MHz seems unlikely!
> This MDIO controller has an internal divider, by default its set for
> 100MHz clock.
> In IPQ4019 MDIO clock is not controllable but in IPQ6018 etc it's controllable.
> That is the only combination I have currently seen used by Qualcomm.

Not sure I understand here, the 'clock-frequency' is supposed to denote
the MDIO bus output clock frequency, that is the frequency at which all
MDIO devices are going to operate at. Is this 100MHz a clock that feeds
into the MDIO block and get internally divided by a programmable
register to obtain an output MDIO clock?
-- 
Florian
