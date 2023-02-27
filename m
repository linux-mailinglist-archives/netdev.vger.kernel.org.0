Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5036A4D3F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjB0Vdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjB0Vdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:33:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1673710A9C;
        Mon, 27 Feb 2023 13:33:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so11550428pjb.1;
        Mon, 27 Feb 2023 13:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ve+EiTDRh+FfVslrvuW6ND3c+EkAOghkR0bTRqY34mw=;
        b=nG9k5PUYyTk9cXwSYUmLu0yrF4No7aZ7/j/GCfuUY5xgoHrZDPNfM6zHTPp6CPMQrY
         csPNNfaU2qBj8SAfH/+FRhs6L9iiigqIukeS1JKzOFYXdxgPJW9yuXz5NpirfvhXGTCb
         xLFxSpabRXJSKcez/VAzL+YUFQe/4F+bEo6+4nDc1eRH55IE0SfVyz8HaCTTg9cbdV7r
         kH4ZCAOqn5JxHem9siLOwV41VN+cFDUUQKB5J7Nfk88i+KLc80ilAXEqTW029nF8qaqO
         om9JYmf34845ZmPzQpQ2Xaek4r4bQU5nQVzyT6saIbpJ0JcoiyI3H7xcSfEr0na88oO0
         yOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ve+EiTDRh+FfVslrvuW6ND3c+EkAOghkR0bTRqY34mw=;
        b=MrTgiGCqkmZqCHuTC7LL52+sEGU/VOTEiIkY60Z6PZykCJVGAziEZElLjd+2S2+dMF
         5UeVS0bR8SbIW00nJ1x8Dd1gVBA8hwsVq8HGcobKizhUBg4ZPGaMiVWNnnYzEzlaEUS5
         R7phhHvTlCiR/bma5dgf/iZG2pmbXOrxKmBCTTKZKLvIY+yLkdAsEQIL9L0A/zRuYIPt
         a6qrQlCVxyGkPyyxe63RQa9gBCtpQaxZqV9lnw2Jvcjh1O9tIM0yn8Qp7Quv5Dcxf9Bx
         vq7ZVPJ2JA2B3YH2vsogtwu3Rh0bhuCqIc/q7s2B+17NUzKVNb1We5a/uo90GSb8aspG
         mExA==
X-Gm-Message-State: AO0yUKVVv4gbNnLKx4Eq94q4Ih+AeXYxzO4vCiBh1h+w6okKm81yxSt1
        7cH2Yp8AK86WDm/3y0B/XWM=
X-Google-Smtp-Source: AK7set82EY0Ze9K+PMz/2QqLiZ2lBwEKU9+cegh7cYoTwIxLBwjgTCUujf+sWWp9lby0tECEwsoCcA==
X-Received: by 2002:a17:902:ea04:b0:199:4be8:be48 with SMTP id s4-20020a170902ea0400b001994be8be48mr793237plg.19.1677533617451;
        Mon, 27 Feb 2023 13:33:37 -0800 (PST)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id iw9-20020a170903044900b0019cc28bfc0fsm5079465plb.34.2023.02.27.13.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 13:33:36 -0800 (PST)
Message-ID: <8d6896f5-3710-0b35-582a-fb482e5f4196@gmail.com>
Date:   Mon, 27 Feb 2023 13:33:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 1/6] pccard: remove bcm63xx socket driver
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230227133457.431729-1-arnd@kernel.org>
 <20230227133457.431729-2-arnd@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230227133457.431729-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Maxime,

On 2/27/2023 5:34 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The bcm63xx pcmcia driver is the only nonstandard cardbus implementation,
> everything else is handled by the yenta_socket driver. Upon a closer
> look, this seems entirely unused, because:
> 
>   - There are two ports for bcm63xx in arch/mips, both of which
>     support the bcm6358 hardware, but the newer one does not
>     use this driver at all.
> 
>   - The only distro I could find for bcm63xx is OpenWRT, but they
>     do not enable pcmcia support. However they have 130 patches,
>     a lot of which are likely required to run anything at all.
> 
>   - The device list at https://deviwiki.com/wiki/Broadcom only
>     lists machines using mini-PCI cards rather than PCMCIA or
>     Cardbus devices.
> 
>   - The cardbus support is entirely made up to work with the
>     kernel subsystem, but the hardware appears to just be a normal
>     PCI host that should work fine after removing all the cardbus
>     code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This is probably fine because PCMCIA on BCM63xx was only needed for the 
very old and early devices like the 6348 which modern kernels are 
unlikely to be able to run on since they are usually RAM constrained 
with 16MB or 32MB of DRAM populated. Maxime, do you care if this driver 
gets removed?
-- 
Florian
