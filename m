Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDEB69147B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjBIXeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBIXe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:34:29 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64A6663F5;
        Thu,  9 Feb 2023 15:34:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id be8so4700123plb.7;
        Thu, 09 Feb 2023 15:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xldWbIGpXMTnrefHQWDXpkkoKsv33xh/2i/KG0k0JDg=;
        b=NjXRAeQL5FLMO+RiG2BtZhPCoVZjoDMMIXxZBmjrRt0iacUfFOUdlY5MdGHNh1oTZD
         bzjLh3SRyGP2PC5qI2quzUSNrwkiQQOBldgtaLAtmYgzU+O8iLlvD06US0LcH1oIbDTF
         7RHDsGM/TrKcqrUIWFv8VtO7lecOgpvuVzY0u4/KVu0iDc1ypPZoa6eZps2Ul3oM/JyC
         zeHq2sgKsvVbExV8Wt9Fh+9yurjZZHFPFIYE8djGYaezBpAf2KdxbsloBH93/h/wyeuD
         qbq0s2knlxN9x1U16/3dJqpoObynXzX3G9WtTwmgSFXRjBBDBqziplt7XZZuAU8oD0lC
         nSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xldWbIGpXMTnrefHQWDXpkkoKsv33xh/2i/KG0k0JDg=;
        b=mKEaN9zHtc60xKj0QEu75VcayiZjkttHd/Jt4SVyWwlNYtJiAYLmWspXpEwKYoOx3v
         ARm0ZpKfBbAKLymss87e3WVm21c4VK8KD3IYBOGBKfMfkGGevwsxkIqzDMAgmpPgNns1
         HiW1kdYtWmJhP6L7yC2mj+h8rFiL4M6KVxvPSpfjKve8VdEzH0ReA0M6Zg6S5+3vcwm+
         IYkH7BVY2WVxopQb+bSi0a7r1zs+k1BaSczw9E44/pkvs4z/OACaJDUmqjwhZ4A4Fdrs
         kYSMhqCCsGVjZAD3XFH0b/jN8yxM9MMu0THN5WcHy6NMbXw4LCB6WZG5mwyziYljibxw
         d4+A==
X-Gm-Message-State: AO0yUKW8rRBd5k6CiLMdskIy68mDoE78ARfZoHBEcCZaIXABJi4M9alS
        kXRJCzlZtH+hj9v9JsEVsrA=
X-Google-Smtp-Source: AK7set+ZbmQJCHkZwQdqkQ09wIlENUWsTGxnw1cGQ5bcfUHWp8xH4cTZdhcFaulc5u659K1TRqSfpw==
X-Received: by 2002:a17:902:d48e:b0:199:39ff:3b2d with SMTP id c14-20020a170902d48e00b0019939ff3b2dmr11166821plg.53.1675985642616;
        Thu, 09 Feb 2023 15:34:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q9-20020a170902bd8900b0018099c9618esm2037601pls.231.2023.02.09.15.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 15:34:00 -0800 (PST)
Message-ID: <4c153c46-65bb-ecca-9d48-3dfb8f206264@gmail.com>
Date:   Thu, 9 Feb 2023 15:33:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 05/12] net: ethernet: mtk_eth_soc: set MDIO bus clock
 frequency
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1675984550.git.daniel@makrotopia.org>
 <af9646f282ccef7f1c6cc9884ec8264d605e3f66.1675984550.git.daniel@makrotopia.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <af9646f282ccef7f1c6cc9884ec8264d605e3f66.1675984550.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 15:30, Daniel Golle wrote:
> Set MDIO bus clock frequency and allow setting a custom maximum
> frequency from device tree.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

