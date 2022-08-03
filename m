Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D07B588B5E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiHCLdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbiHCLdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:33:45 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214894AD44;
        Wed,  3 Aug 2022 04:33:44 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m8so21027269edd.9;
        Wed, 03 Aug 2022 04:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KXL+wsO6+KWhNl500Va3imWuFwV+AbGMm2r8SqpxuDc=;
        b=FSAQ0xUMfOMb5wt248xYlSSHNp59Ll5IufE2s/qJkJCE7nuoXK3tNOteQWcrWWCQQc
         uHLr+8SonE+aDCEXjPmi3aHU/f16fGnoi6uEllREUBSqHft2uBOBs+eiFyF9wiELhTLD
         KxxzJZueSTUeDVqBZW/iK/L8ayG9+YDPbWCNtnH2TOjT/GR3JZn6va6rTMeBU0I7RAXV
         31Rbz7nSddoBscjd6befms3jmOEd4p1TNS6psbXBYZNhM34eWdhWbosnZykqXBmvebqg
         W0jUXPt1ipA08dSqHg9Zt4pLlugEv1iJ9CPSiNB80PxZosj8xbKcYaVT9q+5axt0vjZP
         jIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KXL+wsO6+KWhNl500Va3imWuFwV+AbGMm2r8SqpxuDc=;
        b=epr/R/9ViJu3xabxyrHg366zV9bk2VrsDI0lCprUkXgpZVwZ1FQQY9CO4JFQUc40Si
         JX8SeyS8e0vxZMMoDdQyPLkofFdM2MyAVys0ACBS1kLBYjJ9u+ei8aw9yPJSMtx9CdYe
         aV5eYkV3Jro5Ix2AdcjgTHTmreI31mdRdXNS7j62QZTIY8jdiwtVj4YYUs0kZZSGzbsC
         uW0qCSh708+1qAZZlkTu8MZ7UR4dMf1HN/lw0Sk2Hmg4Ur8uLQoZ5iDd8jnilF0iBmZc
         YP3dux90SuS6rLD+Ah7xUiuo3v88jeaKCwdoyg8k6SNnamh9T9SRpJorX20BYG/VKJGB
         XWCA==
X-Gm-Message-State: ACgBeo1dYHi2mNn4aSKYU1PFUFAL9oevZp8tndNEpTCK9iF3Oa001i3p
        mdm96oGE6n4D7HNktuLIDsS+GI1J+KUXVzwr4IA=
X-Google-Smtp-Source: AA6agR5wJ9sLFYiPSdtu65r2JT69FHXwjD3opg5RdPb71aO16fTfJujyvAEGsfTBGdVHAclWRxChXpwdy9vk9Dm81gE=
X-Received: by 2002:a50:cccb:0:b0:43d:efd3:88fb with SMTP id
 b11-20020a50cccb000000b0043defd388fbmr8059376edj.265.1659526422550; Wed, 03
 Aug 2022 04:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-8-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-8-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:33:05 +0200
Message-ID: <CAHp75VfV037eyOs9C=pPtG5wg_DLAWkJBk6oyxQNth_YRBeeFQ@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 7/9] resource: add define macro for register
 address resources
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 7:47 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> DEFINE_RES_ macros have been created for the commonly used resource types,
> but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
> to all other resource types.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>
> (No changes since v14)
>
> v14
>     * Add Reviewed tag
>
> ---
>  include/linux/ioport.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index ec5f71f7135b..b0d09b6f2ecf 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -171,6 +171,11 @@ enum {
>  #define DEFINE_RES_MEM(_start, _size)                                  \
>         DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
>
> +#define DEFINE_RES_REG_NAMED(_start, _size, _name)                     \
> +       DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
> +#define DEFINE_RES_REG(_start, _size)                                  \
> +       DEFINE_RES_REG_NAMED((_start), (_size), NULL)
> +
>  #define DEFINE_RES_IRQ_NAMED(_irq, _name)                              \
>         DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
>  #define DEFINE_RES_IRQ(_irq)                                           \
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
