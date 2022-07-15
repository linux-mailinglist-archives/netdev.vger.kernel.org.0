Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA785765D2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiGORVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiGORVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:21:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D32D79682;
        Fri, 15 Jul 2022 10:21:00 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y141so5181216pfb.7;
        Fri, 15 Jul 2022 10:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v35aC/SET8Nt1lF58i2LVSGI7TVYKhXpN56HeHPhY4A=;
        b=QYRuWFCmTvZa/x5P+uESITLhb+SAnK3Ep6RjijQpXs9D9HQ6zQtjDb73w8plJ7rrTN
         jl9TfKRIr00Y3U4c2O7IK+l52IfmISjdi5DVoOjQuaZRup6uS7Zr3K0ncXMTg8Qth2S+
         YjK81IU2OOpN0VPXjCGK9FYDqDEur07qD4W2lFxHiX7RFLZstkKrPM9XjqL7l2cJ6kur
         SeL7QRXbm8BwPLNS/cwAAkRIow9e+DD8dHprPzQ/rc36raoPBVQv/Ar1FXytFjBJP3os
         gqEOZlIgjrszm0i74uR/LUDHByRmKG4im7M5Tqfx5rz+s8jfFMTlNp4BawIxEr2QvlQF
         1jUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v35aC/SET8Nt1lF58i2LVSGI7TVYKhXpN56HeHPhY4A=;
        b=LP2izyH7hW0MLFzJzz0Ef5EJ4OgRAvvcH93cR/cO4FoSL8qG1i6CW/mr/G5BLErdDQ
         VbF8UOGP0F4wT19qSr+jr4aipnj2BHp1Yg8GJzD6qPAK2HmdWgXftaJAQhDBMZDAPPrT
         9GcZh8RXn3bNM47Mwf5suWbzn6CU4etzvUPQw3TVNI+9nDi/a+UA33Lb+LNAAM9m2o3S
         NY760hBsoO3SQ612IJawTzDHkkjryq8NufXYibGCg4qrqgyTnYxQwld/mebt5W5vBwEU
         HWwl+ccgTJsJi0IvXK16yJbXXHXQ/Wxv0GgTw0feD9MrFdMuGvMzqt2OZ9vVWqlLAn2S
         zN+A==
X-Gm-Message-State: AJIora9W2A+BJbF9s98oZEDVMwzbaWV4+xrdjsmf2Y0tzbCnXS6FZMWM
        cxtHVojxsUbMoKHdt72zLdo=
X-Google-Smtp-Source: AGRyM1vINHbIiII2lUdhE4U0lB3RwsmwOrfFF+r+w8TiBpauAFR5zNUGcFsSpEsGUrmUqgFtL4r48A==
X-Received: by 2002:a05:6a00:993:b0:52a:dd93:f02d with SMTP id u19-20020a056a00099300b0052add93f02dmr15211567pfg.12.1657905659970;
        Fri, 15 Jul 2022 10:20:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ot8-20020a17090b3b4800b001ef89019352sm13427194pjb.3.2022.07.15.10.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 10:20:58 -0700 (PDT)
Message-ID: <a5b55fb3-3326-eb3c-99e6-3fd6b7e4c2fe@gmail.com>
Date:   Fri, 15 Jul 2022 10:20:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next: PATCH v2 1/8] net: phy: fixed_phy: switch to fwnode_
 API
Content-Language: en-US
To:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
References: <20220715085012.2630214-1-mw@semihalf.com>
 <20220715085012.2630214-2-mw@semihalf.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220715085012.2630214-2-mw@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/22 01:50, Marcin Wojtas wrote:
> This patch allows to use fixed_phy driver and its helper
> functions without Device Tree dependency, by swtiching from
> of_ to fwnode_ API.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  include/linux/phy_fixed.h   |  4 +-
>  drivers/net/mdio/of_mdio.c  |  2 +-
>  drivers/net/phy/fixed_phy.c | 39 +++++++-------------
>  3 files changed, 17 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
> index 52bc8e487ef7..449a927231ec 100644
> --- a/include/linux/phy_fixed.h
> +++ b/include/linux/phy_fixed.h
> @@ -19,7 +19,7 @@ extern int fixed_phy_add(unsigned int irq, int phy_id,
>  			 struct fixed_phy_status *status);
>  extern struct phy_device *fixed_phy_register(unsigned int irq,
>  					     struct fixed_phy_status *status,
> -					     struct device_node *np);
> +					     struct fwnode_handle *fwnode);

I think this ought to require a forward declaration of struct fwnode_handle and a removal of the forward declaration of device_node.

With that fixes:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
