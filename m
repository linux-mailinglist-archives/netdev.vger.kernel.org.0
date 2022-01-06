Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F476485F33
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiAFD2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiAFD2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:28:04 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AB3C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 19:28:04 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u20so1373766pfi.12
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 19:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2cFMqoeTw+2LNGWbw4OEvH28MN1hqxzwmuu4PTpBt5w=;
        b=RTZqExoh789Hx9AIbWjh7dKaSUR5LXsb0jZoJrj4BijjORxr0alR93zIp+y0wRDT5h
         +PPxb5VwPOLUJBe6bLpjJTIyDsPQaGUV8HPQwj8drj5D0rjhJdgu1Er1cB8iYaR8n/BA
         rVcZbi9kILUDuIY989woAwcSqc4mHfEL8kPC0w/rP7elE8uK85ksgx0MzeRrKn8+GmHj
         Ka7jf3t0hr7iALfKLu2iunMaKY8HBajboeQi//5mrqZO/7Bc+m3NMxwQT2TJ8rwNwjDZ
         mgB+dTwRWDus2ycOohDrRd/x3fNZQpGnaTfxE7YyFS8OJvn3JSTtnoZ8tl0YVC2+xtOo
         kEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2cFMqoeTw+2LNGWbw4OEvH28MN1hqxzwmuu4PTpBt5w=;
        b=z59l5T9iqR+r36m7RPDoPTE08XlOUbLXEv0VCvgQhpqbV+zdktpIxcBQQewKNEeP2w
         96sJEhqbPm6ImjNinqR2ASv5chqlQ+n+I/MDJYm6dqsXOtz7CgvrFjwjTP1eLzbUVGOr
         dXlrCFN1TRDoFmjvrTr2XCJbEDsMEUvLFMnbUZ5VBq642IXk9Tik5vW5oXdp0ok0fxDj
         5lceXO+HZfPjnSjJwUzRGQ/0SVSu3JliqzvV40+v8S6ZgdJYgMKAIFGS8ftI/v1kM1CI
         2+XQe1Vesr54IomqgQWIYHraGTou7AiCEMW0Kp5U2Z3NLIp/PigASOn/+yYjYwMaVNZm
         SwvQ==
X-Gm-Message-State: AOAM531cuK7WXQVDahGxOLM0DvHgKR+Emt/VYNcuSLLJlXfqsYICx+K4
        6JRdo/eL5FXWzIdWcDTpvW8=
X-Google-Smtp-Source: ABdhPJzkfIvdOintzieeBh09NJcZCjvodSe1Tg3fYrJUJ/8XXYgiG5abnc2AKlR3R4cVuDb+jCrxrA==
X-Received: by 2002:aa7:8c05:0:b0:4bc:a73a:dc9f with SMTP id c5-20020aa78c05000000b004bca73adc9fmr16560953pfd.75.1641439683616;
        Wed, 05 Jan 2022 19:28:03 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:bd65:1cb5:9ad8:4f58? ([2600:8802:b00:4a48:bd65:1cb5:9ad8:4f58])
        by smtp.gmail.com with ESMTPSA id q16sm477039pfu.31.2022.01.05.19.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 19:28:03 -0800 (PST)
Message-ID: <4a8f5b90-2fb6-ea40-c04e-25d5436f5036@gmail.com>
Date:   Wed, 5 Jan 2022 19:28:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 net-next 1/6] net: dsa: reorder PHY initialization with
 MTU setup in slave.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
 <20220105231117.3219039-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105231117.3219039-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2022 3:11 PM, Vladimir Oltean wrote:
> In dsa_slave_create() there are 2 sections that take rtnl_lock():
> MTU change and netdev registration. They are separated by PHY
> initialization.
> 
> There isn't any strict ordering requirement except for the fact that
> netdev registration should be last. Therefore, we can perform the MTU
> change a bit later, after the PHY setup. A future change will then be
> able to merge the two rtnl_lock sections into one.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
