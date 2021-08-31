Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EB93FC04B
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhHaBDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhHaBDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:03:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29AAC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:02:09 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l3so378348pji.5
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 18:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mz9vr3xIaxXtLOjA4gv8t+LygJbJqK965fGn38UFSVE=;
        b=pxvLjqotuqbVuJDLt+Oxiwbmf54JO9MG1q5w+ZBI6IpItxBWY3V/uNWxKB1eG+Hj2h
         Xrw8ycs7iH4tMq3ePwYCfrBUeelc5TYWrfoQPMsQbDCrsE3gCDamxH83cZ5nnNG/1jXU
         Q+YfmC0gldgiLQaDUSB37awCwVjaEj6LLlHSLz/cmJlSf7qYW0mEf3cTC70kN7tre8L6
         P2ThpmZl/YDIv7gtcK/ezsZS84WgPIkU8kX176FoKoae6u8dwWeBjQ8sqCdYTqmZTJg3
         B4rZOEvCYAGIcZcDH0RHmEPQC8g82suJP2WdmX9UQKdMc6S9+Tomo21YdXZyjN07ZCFK
         S+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mz9vr3xIaxXtLOjA4gv8t+LygJbJqK965fGn38UFSVE=;
        b=pBA9CbnX1TrugveNSVHuEXmheR5SkRMNTbKZdcN6CB0xqXC0Zr/cx5WadrdKjmMs0W
         tW8tNYbCgXpXT0Kdd4XT8I4i6RdRglrFljSpTYoWfja9nF45Ri/uHVl3bK/bLW+SsnmA
         8qzwh+g5cnIN/+l/FzC/O7SnWfHWmaa72VOBtFPojqWVFLHPftfW4h/SHZSgNMOCCQlI
         jIrdmqwditNrxU79Hf/wDw6LQmYnOlqJqZctJroWam5cJF8p0IgQ+MSVkcDC3GD+64Ev
         F9rN3vMu6zbeqIzbudGiI5eg9TWFiyYW/KqroUoeipoLLSxvQAfsVqFTh2XUnICrjXxO
         /azw==
X-Gm-Message-State: AOAM532xiIg3pkLAwNNVZZ/mgdquVADA+EtwtHMFbxzI17c2u+t9KHbH
        qC+lKnutGj77xEnu+3Xt0vs=
X-Google-Smtp-Source: ABdhPJy8nYkNTjgufFqQefCVZguLCTHQkuNVE/kdGdtFg9G+p/p72I/tRreLgmX174N/pNg4OcKHlQ==
X-Received: by 2002:a17:902:edd0:b0:135:b351:bd5a with SMTP id q16-20020a170902edd000b00135b351bd5amr2165564plk.52.1630371729520;
        Mon, 30 Aug 2021 18:02:09 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with UTF8SMTPSA id r2sm182247pgn.8.2021.08.30.18.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 18:02:08 -0700 (PDT)
Message-ID: <43b34ea3-9037-510e-5bfd-d25e39899eda@gmail.com>
Date:   Mon, 30 Aug 2021 18:02:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net-next 2/5 v2] net: dsa: rtl8366: Drop custom VLAN
 set-up
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210830214859.403100-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/2021 2:48 PM, Linus Walleij wrote:
> This hacky default VLAN setup was done in order to direct
> packets to the right ports and provide port isolation, both
> which we now support properly using custom tags and proper
> bridge port isolation.
> 
> We can drop the custom VLAN code and leave all VLAN handling
> alone, as users expect things to be. We can also drop
> ds->configure_vlan_while_not_filtering = false; and let
> the core deal with any VLANs it wants.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
