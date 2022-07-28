Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF270584647
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiG1TWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiG1TWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:22:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DBA1A05E;
        Thu, 28 Jul 2022 12:22:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 6so2256476pgb.13;
        Thu, 28 Jul 2022 12:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=EFOAo/QdtEPRv+rmfrGIwUMKLAu+6hzcQDL1f3TAQNM=;
        b=lB+pWhhlv93nZ1uF9MlIOnX5O59BjNqfBlzyuwaJ9IcEqZIikDytWL8FxK9mRR7bGC
         CP0N3vcVC4GRQyBqp/aXDsHM+Rp/kL+AcBtbGgawHiyB0n2SQ/S9YTLhVKYgLJzYvnfa
         DRgHjFYGggf4djkLYGpyCKIAfFc4nCcIoEjsFfGVMZ1/sB2/Jgb8jz20AGsMwpQd4Rhb
         5lHHgqgPkKGl66JAg/+e1Wkvj9UiHeRANwaOr3+bwehcQ5WJ52Rwi+bf7sjW1dQxqAEB
         0wInCPsCu9FBE5kiqsjVn81pQZUQnEayOJ4Rp+zGMKxlzT+3V1MGecumxQBkOPnllvzK
         p+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=EFOAo/QdtEPRv+rmfrGIwUMKLAu+6hzcQDL1f3TAQNM=;
        b=irglV27uulHB7xGlavq7wJq+OWG1Pi6Aw9k9FKOFJIio3ETkwpBw5qFVt7bbmNwKOw
         TH/ON1/OYg+Us/xaO0vhBaIxyfbP7BpbGTIAL0qZTDHb2xBEeUj7E40VDt7T5T52W0Vy
         u+tbtfA9XkbkCiL5nWaXAIoyzmwAtdDWPl+xvQrlHOB1cjN+xVaRxVoMpW9iw3oP5bDx
         0UZvB2cVuzafW0Uuf6UxC5LKRROo/pujw6NV4LKVFu4dz4WJMfxIqezIrV2g24OVcstg
         9U2NPvkEQmS/YHSetnMDgOGEZ1juTFEhSBCYR9VGI1DyWjZ+EgkFYiiEg6ItedX4RV1G
         aOhA==
X-Gm-Message-State: AJIora8+ABlM6yjJXM2FAwHDWGyDzeLeYqPgJAiXgl2znlIaaqu8Dml8
        juVaIkI+9S2i0adDs/H8kY0=
X-Google-Smtp-Source: AGRyM1tj9cuz/W4LAd9BMq4WIOZkxkrW2UJLCS/AeNw+AhegYlhfdsgfmykyQIPR9LbFViQAWRDZ3w==
X-Received: by 2002:a63:ce0f:0:b0:41a:f0ee:c28e with SMTP id y15-20020a63ce0f000000b0041af0eec28emr190116pgf.43.1659036138925;
        Thu, 28 Jul 2022 12:22:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m8-20020a654c88000000b0040cfb5151fcsm1282985pgt.74.2022.07.28.12.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 12:22:18 -0700 (PDT)
Message-ID: <db9560c1-7fc7-405e-bee1-3827a943b712@gmail.com>
Date:   Thu, 28 Jul 2022 12:22:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        William Zhang <william.zhang@broadcom.com>
Cc:     Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        joel.peshkin@broadcom.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, krzysztof.kozlowski@linaro.org,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-watchdog@vger.kernel.org
References: <20220725055402.6013-1-william.zhang@broadcom.com>
 <20220725055402.6013-7-william.zhang@broadcom.com>
 <63797827553783061a0ad5e897ed6538@milecki.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <63797827553783061a0ad5e897ed6538@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 05:31, Rafał Miłecki wrote:
> On 2022-07-25 07:53, William Zhang wrote:
>> With Broadcom Broadband arch ARCH_BCMBCA supported in the kernel, this
>> patch series migrate the ARCH_BCM4908 symbol to ARCH_BCMBCA. Hence
>> replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.
>>
>> Signed-off-by: William Zhang <william.zhang@broadcom.com>
>> Acked-by: Guenter Roeck <linux@roeck-us.net> (for watchdog)
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)
> 
> I still think it may be a bad idea for all below drivers. Please see my
> previous e-mail:
> Re: [RESEND PATCH 6/9] arm64: bcmbca: Make BCM4908 drivers depend on ARCH_BCMBCA
> https://lore.kernel.org/linux-arm-kernel/eee8c85652e6dac69420a876d03f67c4@milecki.pl/
> 
> I think we should:
> 1. Keep ARCH_BCM4908 for 4908 specific drivers (e.g. mtd, pinctrl, net)
> 2. Use ARCH_BCMBCA for more generic drivers (e.g. I2C, PCI,serial, WD)

IMHO here is no point in keeping an ARCH_BCM4908 anymore when the whole point of the patch series is to do a broad conversion of ARCH_BCM4908 into ARCH_BCMBCA. Even if some of the drivers are considered or thought to be 4908-specific, this is not going to be an issue in practice because there ought to be appropriate compatible strings such that even if you built a 4908-specific driver into a generic ARCH_BCMCA kernel, the actual probing would only happen on 4908.

Now let us flip it the other way round, let's say we keep ARCH_BCM4908 as a sub-arch of ARCH_BCMBCA, then this sets a precedent for adding more and more of those ARCH_BCM4906, ARCH_BCM4912 etc. etc to future kernels under the same reasons that we might want to gate certain drivers to certain sub-arches. But what good does that do?

At some point we got to make it simple for the users, and the simplest way is to have ARCH_BCMBCA only and let DT dictate the device specific probing.
-- 
Florian
