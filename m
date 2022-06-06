Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0953E30D
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiFFIJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiFFIJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:09:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B807D5EDEA;
        Mon,  6 Jun 2022 01:09:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x17so18765833wrg.6;
        Mon, 06 Jun 2022 01:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=55gnPINtsFPFd2IhvtfL5C51CaXoml0DfEKveP/xXyE=;
        b=FY14aHG+M1ivaNxoVyt6bw617tg7SLpmHKJkKnw7ZiBFa5bcMH28PRhbF+5/CxEB4M
         RWPw5VAU3V8FsqwgzENi2il9HokLiJ8/fX8mE8TDBR3hWvJkacNEF+ErJKm9tHl7RaB+
         npldND8zTlpuqQsFRhYByq9G+D4Rnstqaxn3Bi56xRS2uT6Di07qbbS0s52dunRaqaCC
         K7yISRTRLLu4/QXGVd+wO+NorRCg958iO5PSHn8wCNESTQTickgj7RU28Mtrdu/leXNh
         0iOXFuJiyJ/CeYgIwRwkvOTKjJarPOO26jtKGRF4jZLOLnPHZx5wvC5WTL2AgPiWiwyK
         0tUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=55gnPINtsFPFd2IhvtfL5C51CaXoml0DfEKveP/xXyE=;
        b=fQas94U0twhcYI7nNfTl4cGk7kf6CuvIpQLcV2sY4i06feks2yTtZ8SGDyYPzkn6cC
         m/eLgirnQhH2kjLwnwTjHMrd37P+WXC/wLzeaaBxvM8dy5W7XvUrQe+t7tF0wDbyenIK
         nvabE3CxnRbb92aEF6lCLRiY0Az9TRkW0qkuEU0jCYQl/pqQh2BGq+IpVPO91AnQa+AZ
         sEnLWV1lELBQrMH/bSEdBI5vE+9h3tGPke+4pQVWw51DGuKZUsl3fhi7b21R4jio5hg+
         M78fDHhxTTuBEo6uwn76WmEPQy8MLuTiheFursTKubApKDCn5Nm2gTpzSY4zhVVGKr2N
         cTWw==
X-Gm-Message-State: AOAM533Dn0JcsKx+GZoPfqbCTINrDNA2pdxe6xNxvuirTzuq1JefPfh0
        QeSQnfwcfvLFOVHgxHjXc7M=
X-Google-Smtp-Source: ABdhPJxs7oVThXBAjBXXkUL5eYBbt54XbarGQN20qK31IXQ/6R4+6z2LD1zS/sezB+Av3llV24Ko0g==
X-Received: by 2002:adf:ed41:0:b0:210:20a5:26c2 with SMTP id u1-20020adfed41000000b0021020a526c2mr19871874wro.603.1654502968088;
        Mon, 06 Jun 2022 01:09:28 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:86cb:1c00:f508:89e3:8d18:b335? (2a01cb0586cb1c00f50889e38d18b335.ipv6.abo.wanadoo.fr. [2a01:cb05:86cb:1c00:f508:89e3:8d18:b335])
        by smtp.gmail.com with ESMTPSA id y3-20020a7bcd83000000b0039747cf8354sm16206206wmj.39.2022.06.06.01.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 01:09:27 -0700 (PDT)
Message-ID: <53818857-18b8-c7d8-8003-43452c9aa003@gmail.com>
Date:   Mon, 6 Jun 2022 10:09:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/3] net: mdio: unexport __init-annotated mdio_bus_init()
Content-Language: en-US
To:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
References: <20220606045355.4160711-1-masahiroy@kernel.org>
 <20220606045355.4160711-2-masahiroy@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220606045355.4160711-2-masahiroy@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/6/2022 6:53 AM, Masahiro Yamada wrote:
> EXPORT_SYMBOL and __init is a bad combination because the .init.text
> section is freed up after the initialization. Hence, modules cannot
> use symbols annotated __init. The access to a freed symbol may end up
> with kernel panic.
> 
> modpost used to detect it, but it has been broken for a decade.
> 
> Recently, I fixed modpost so it started to warn it again, then this
> showed up in linux-next builds.
> 
> There are two ways to fix it:
> 
>    - Remove __init
>    - Remove EXPORT_SYMBOL
> 
> I chose the latter for this case because the only in-tree call-site,
> drivers/net/phy/phy_device.c is never compiled as modular.
> (CONFIG_PHYLIB is boolean)
> 
> Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
