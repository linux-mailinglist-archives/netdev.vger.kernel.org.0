Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0842F1AE8FA
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 02:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDRAj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 20:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgDRAj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 20:39:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A78FC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 17:39:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so1373720pgo.3
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 17:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SZxy5y72/Sp72T07hIpZnuMntRydrEzaDbn7LPiw3+0=;
        b=U4YJ6dksD9WOjqTO0wFfDRPXNKXsTINB47MurT8Wc4r+77l2YWPwjiC6d/EENdt+mP
         bPXM9e5bc4NqyBtQFsx7vOUeIGHyrzhPaoDJgHkxUiixe6nICAjSyYjD078vhXO4DlMu
         HIKoynvjPtVN7gnXD4Djo8vhXsRmc9+IxewtnObiYKONlBQDhKjSoAQ2LaPJoXXkBCUx
         ckg+TmvwuvJmS/HT5ilCfxdkeZizG0ru04RRF3NqERttqfC/+ZwwRlGX6sY5R2KbF+I/
         YcxGOrrfxJVoMUkOD6CkfC7dGGYWKqvH2Boy7FSADnEHgSvjTStFG/iZcSqnHZAoC13m
         aefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SZxy5y72/Sp72T07hIpZnuMntRydrEzaDbn7LPiw3+0=;
        b=Oa/x8lYDn/la6rQDl6DA1eYWDExkxA+lirdNs1xNpqlOYO3Gkk740H+Kh93Z3Fgp3V
         IXX4H6RUX3LVyAd7kW+6T7BgG/V/PdG7pi9PD3ijkU6xMd0VGJKcS+DtO1GgeU5RgjdH
         RmEOw12MQmqS0hy64NlRVvTT1NBBAztkjVX0/vL2P9/auVT97wX2PMLU50bZXHP9NciT
         uXhpfqzy/ouzOo+CvBBkiOOBn/ebuz5L+TE9Q2pRrUaGwjn5q5GAeq+2S40rxXpmB+PE
         oOR5Bjk3x2qgpfnwbeSave42cUp1ChGD7y2PzI8CpJO50JDcnr2vwjldYUAOcjiqxIHu
         J52Q==
X-Gm-Message-State: AGi0PuZUm01cVjNBB3SPB/5BWAeVmH1XO009KtN4kBCDc+HWreteS6c0
        YGYzfogm++oeGi2DCX7QAy8FskKq
X-Google-Smtp-Source: APiQypIg7fCkwI0I9RbOVQRs7eps2JqOwxOtwClBQbMKbDoQk+t3RemCFIJljjDGMTj4Nn8heXy5BA==
X-Received: by 2002:a63:575f:: with SMTP id h31mr4974197pgm.200.1587170365982;
        Fri, 17 Apr 2020 17:39:25 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z6sm19079885pgg.39.2020.04.17.17.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 17:39:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: fec: Allow the MDIO
 preamble to be disabled
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bde059d8-5a95-d32b-7e28-ac7385cc0415@gmail.com>
Date:   Fri, 17 Apr 2020 17:39:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418000355.804617-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> An MDIO transaction normally starts with 32 1s as a preamble. However
> not all devices requires such a preamble. Add a device tree property
> which allows the preamble to be suppressed. This will half the size of
> the MDIO transaction, allowing faster transactions.
> 
> Suggested-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   Documentation/devicetree/bindings/net/mdio.yaml | 4 ++++
>   drivers/net/ethernet/freescale/fec_main.c       | 9 ++++++++-
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
> index bcd457c54cd7..41ed4019f8ca 100644
> --- a/Documentation/devicetree/bindings/net/mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
> @@ -43,6 +43,10 @@ properties:
>       description:
>         Desired MDIO bus clock frequency in Hz.
>   
> +  suppress-preamble:
> +        description: The 32 bit preamble should be suppressed.
> +        type: boolean

This is a property of the MDIO device node and the MDIO bus controller 
as well, so I would assume that it has to be treated a little it like 
the 'broken-turn-around' property and it would have to be a bitmask per 
MDIO device address that is set/clear depending on what the device 
support. If it is set for the device and your controller supports it, 
then you an suppress preamble.
-- 
Florian
