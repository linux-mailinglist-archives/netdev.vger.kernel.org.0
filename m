Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2CAEB636
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbfJaRfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:35:23 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37240 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729023AbfJaRfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:35:23 -0400
Received: by mail-ed1-f67.google.com with SMTP id e12so5495418edr.4;
        Thu, 31 Oct 2019 10:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZFAx3QQzSW+8qSQgyxZ6PMXrg7rafMU/DhNrSSUFEQ=;
        b=tWC/rycnO7564v/pwSyYM3U0PH50b8/wqDxg0QaLL1dqqZmsTO7rvz1h8VWKl/rJAW
         8TiXZEsOprcKYAt9OW0R9hkcupq31yojNZ7P01mL8NOBdjECwoLr/iI7TCLe6emF2PbV
         tCft2vunx5rZw5HtWXpK9/Ej1Zi0jljoLqV8ABrMni6sxWQDl3Z+OOwlxvCzIVfHSt9h
         wwhu1ntA5+zzhQwDZOuuZ9tUM3iKCCN+0sYz05dwVLGIgQ4FPV3kMDDpfJexMzqZrkWQ
         D7N73EYOeHqx8GY7u9V3ByAy9SJssGTaF+Hs+rByvOfSvdGTWWsr2MWDCVd6uVkBKIgB
         uwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rZFAx3QQzSW+8qSQgyxZ6PMXrg7rafMU/DhNrSSUFEQ=;
        b=kANAW83m+sWckTmWh1XklodkrRE4BMJ29qqRN9nfpzlQchIu18grJJDvgyGl0t/w6I
         UTNDScr+fw2PNikKi/CKNnqYMrqEL85TgdWTM1DqZQ9F8m20s7DtTEUVg31NkLm2FlBo
         C68OwFgSJtztwBOb64j6kdBPsiZn6+6StLKAg416tCMi7b0hPtKj9YjIZCSO9hl50bFF
         jN3fxQtJWQllyQGVkzd7ttlORndN48qXHyeUObQTfO64d9M6KwU5KhohBi3iJasdcYJQ
         BJD9z5NSQCe6wU3kuumlLyCndUW/JFWZiqcYFZLy3mafDQaR0BMeOE7f7PweT3GJvYet
         b9ww==
X-Gm-Message-State: APjAAAVwCO5Oo7MKJtFUoVz55x04Xo+KiOfrYw44CcrNmLgBHbD9tq3t
        iQpoV9XEd1nLcEmn+2V5uVU=
X-Google-Smtp-Source: APXvYqwszFnEDfj8eJSJb8KiGMTk6dwWKPVFo3SoUFWUBNCq25aG+3htwAOPLRj9tkQ1aJALM09AKw==
X-Received: by 2002:a17:907:1189:: with SMTP id uz9mr5291010ejb.201.1572543320820;
        Thu, 31 Oct 2019 10:35:20 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n11sm102138eds.89.2019.10.31.10.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 10:35:19 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] net: phy: at803x: add device tree binding
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-4-michael@walle.cc>
 <754a493b-a557-c369-96e1-6701ba5d5a30@gmail.com>
 <B3B13FB8-42D9-42F9-8106-536F574FA35B@walle.cc>
 <e867d1a9a1e4b878aa0dafe413e9a6f7@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <64c0dda8-d428-643e-5edf-ac5108c7ec5c@gmail.com>
Date:   Thu, 31 Oct 2019 10:35:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e867d1a9a1e4b878aa0dafe413e9a6f7@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 10:22 AM, Michael Walle wrote:
> Am 2019-10-31 00:59, schrieb Michael Walle:
>>>> +
>>>> +    if (of_property_read_bool(node, "atheros,keep-pll-enabled"))
>>>> +        priv->flags |= AT803X_KEEP_PLL_ENABLED;
>>>
>>> This should probably be a PHY tunable rather than a Device Tree
>>> property
>>> as this delves more into the policy than the pure hardware description.
>>
>> To be frank. I'll first need to look into PHY tunables before
>> answering ;)
>> But keep in mind that this clock output might be used anywhere on the
>> board. It must not have something to do with networking. The PHY has a
>> crystal and it can generate these couple of frequencies regardless of
>> its network operation.
> 
> Although it could be used to provide any clock on the board, I don't know
> if that is possible at the moment, because the PHY is configured in
> config_init() which is only called when someone brings the interface up,
> correct?
> 
> Anyway, I don't know if that is worth the hassle because in almost all
> cases the use case is to provide a fixed clock to the MAC for an RGMII
> interface. I don't know if that really fits a PHY tunable, because in
> the worst case the link won't work at all if the SoC expects an
> always-on clock.

Well, that was my question really, is the clock output being controlled
the actual RXC that will feed back to the MAC or is this is another
clock output pin (sorry if you indicated that before and I missed it)?

If this is the PHY's RXC, then does the configuration (DSP, PLL, XTAL)
matter at all on the generated output frequency, or is this just a
choice for the board designer, and whether the PHY is configured for
MII/RGMII, it outputs the appropriate clock at 25/125Mhz?
-- 
Florian
