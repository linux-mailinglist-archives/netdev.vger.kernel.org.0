Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239BD57C2B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGUDca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGUDc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:32:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704257754C;
        Wed, 20 Jul 2022 20:32:26 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g12so596655pfb.3;
        Wed, 20 Jul 2022 20:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A8HrmDvRv1JakyZpN804KG9pBcPVPRqNbucKySDvZx8=;
        b=DeydGXUokqbTAfkMTdhkxGIMSYPy7nK8D5QqnmYkaXYJEW7hS/wMNKa3uAVcH7gM7V
         gnKP1RGFKgrePwa5YfAxymhfcVJn/vYjWx/KUv6kJNYgDdO2Q9NG9LfxtliBJjwfGm9l
         6mgBhFQeTUCC7xn9/vAVWB9dJTh9vjZ/k2t2fdRsRMeMHtS9V+YkL+HwmtVka7H8CL6U
         LUDHQjIcR3tjXSnubP9KZNCODXRr8aLKLOMG1SzYOG2i0yJMTkVy0CkVE90TIdTg7RSG
         Z4O4MrUdDJvbrIARuuuH1hD42TxMMgltX5uUBZzwF8BpY7H93D8ItgsQFe83b7w4/9H4
         qo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A8HrmDvRv1JakyZpN804KG9pBcPVPRqNbucKySDvZx8=;
        b=r52GN6K2k3tfe4L++TVmsHCDx65wvwTns8QoycYwaiGWnkazjJxj6LtySf48mXOw/c
         1cVrF5ZO6GUrsllvMdmMjvWISwO5bEI7JBUeKXJLiw838GiR0+Aesdtho6Xo5wKx90Y7
         26FKUCOdb4/pfP5BZaBp7Y+yEg4NmBOxzoua4EI9cZ7Tyxg21nQpsg4lYQVJHY/Qz41v
         pqDtxVJncSTDzDXnOKdTDeYeqpYZQdADJuUxafhA86G5Y5e+vuu1putuHlDO3VNhZtVQ
         /QgussU+GvrlYc6pQRugWX/nOvjHsgtSQYbVE5qg80/sQnyPAiOLSbSJ0DRH089GHmag
         CvIw==
X-Gm-Message-State: AJIora/KZn65neO+xtBTe5Vga4j7RSFva3gvmK7/rC7c+qn7PHzayqe1
        rje84E6IvND/rb9jHvxDhLGRgY28VFg=
X-Google-Smtp-Source: AGRyM1s2c7kx2CPskFMkXV18L/Cpvzm04GClJp5KDYPz6G2bzxDd1OK62cNrHq1IAkl8WxsajAq4EA==
X-Received: by 2002:a05:6a00:1386:b0:52a:d5f9:2837 with SMTP id t6-20020a056a00138600b0052ad5f92837mr42945885pfg.5.1658374345861;
        Wed, 20 Jul 2022 20:32:25 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id gm17-20020a17090b101100b001f200eabc65sm246533pjb.41.2022.07.20.20.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 20:32:25 -0700 (PDT)
Message-ID: <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
Date:   Wed, 20 Jul 2022 20:32:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Content-Language: en-US
To:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     joel.peshkin@broadcom.com, dan.beygelman@broadcom.com,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20220721000626.29497-1-william.zhang@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220721000626.29497-1-william.zhang@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 7/20/2022 5:06 PM, William Zhang wrote:
> RESEND to include linux arm kernel mailing list.
> 
> Now that Broadcom Broadband arch ARCH_BCMBCA is in the kernel, this change
> set migrates the existing broadband chip BCM4908 support to ARCH_BCMBCA.

Looks like only 1, 2 4 and 5 made it to bcm-kernel-feedback-list meaning 
that our patchwork instance did not pick them all up.

Did you use patman to send these patches? If so, you might still need to 
make sure that the final CC list includes the now (ex) BCM4908 
maintainer and the ARM SoC maintainer for Broadcom changes.
-- 
Florian
