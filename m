Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C075933B0
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiHOQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiHOQ5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:57:42 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7FB275C1;
        Mon, 15 Aug 2022 09:57:41 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id b7so5761627qvq.2;
        Mon, 15 Aug 2022 09:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dT9Pg0cgomgnI0kkqHjm6eb1hxEl1p1LNNw04+pYAiw=;
        b=UAbnyBq77vyYNRVvJhwDaocodBZTdW/rY26aTPJ3tUoVcG8kLbkvDeuHoCDVazGTqp
         U3sWT1HisJNc/seNXOnderJHWURJq9o4MgfiwPF0JBbdfW64WPTclAeuu4L0OJZbxuLR
         TcysGwk8ohcgr0uCvm6OGzo6qR8haErFewbD2I0+n3DaZN4NDE5GhwIJaJ5iAKsS7YjB
         J67OCySu8M6iaLP6QU0K9qUMuaaQNz53rc7Mc+kihyUpk4ZXKxciQTtZMWWmzwdTR1iK
         ylcJ2kUbrNKv0MWTDSbr31gytziDJYbVssAOt0Ez9SBA8elvqQr5y6onp0bOpYZVWs0k
         Af3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=dT9Pg0cgomgnI0kkqHjm6eb1hxEl1p1LNNw04+pYAiw=;
        b=0YCUM/sxNd+XW1rz+aOEJFmU57WhC3pLKbfffXI+n+rlWZk/W6rfXokcDwTazXcrcX
         GrAtRd2P5GGgLddw68da9ChN+9CKbg1BHAPEvRJgHQ0VFe1HiWEDPLDTwsFykjTDCLGL
         HEji4/S47365BacyPSsIxbr5Irak2OkclqzoQy766AlbS/7tp0H4h7WUQbXZy5IIR8y2
         KvPEU6TP3pLZ+bbYB/IY4zj0rHl+qBjvYvDZgl2uszYsiKn5QRqvTf+1d+KuDvs/1vzH
         ulKQQjHs1HFVDk3PXBkMr/05Pr/cyRbqeG60jBRrIhZDtP+XIoPVZeFDjuXvWjcII6gR
         tIRQ==
X-Gm-Message-State: ACgBeo3DUcLc2Ozbkn9bG7AbqpJLfbvrnk3QCoU3BpvkIr4IkcAdHZAk
        yFGtlHJ5BxNJWxby0g1qYnw=
X-Google-Smtp-Source: AA6agR5+e4ITrllG9Zdjcav/qnQ/K77ki/+NPhNuFZ+FfibDMeCZLlBPNoSOkBpDKq1B9dRdFkv1qQ==
X-Received: by 2002:a05:6214:62a:b0:476:858d:b2c8 with SMTP id a10-20020a056214062a00b00476858db2c8mr13917327qvx.65.1660582660417;
        Mon, 15 Aug 2022 09:57:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f8-20020ac84648000000b0033e51aea00esm8459756qto.25.2022.08.15.09.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 09:57:39 -0700 (PDT)
Message-ID: <584ebb0e-2d55-348f-18f7-a555c3a359b9@gmail.com>
Date:   Mon, 15 Aug 2022 09:57:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Content-Language: en-US
To:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        joel.peshkin@broadcom.com, dan.beygelman@broadcom.com,
        f.fainelli@gmail.com, krzysztof.kozlowski@linaro.org,
        rafal@milecki.pl, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Wolfram Sang <wsa@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
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
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>
References: <20220803175455.47638-1-william.zhang@broadcom.com>
 <20220803175455.47638-7-william.zhang@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220803175455.47638-7-william.zhang@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/22 10:54, William Zhang wrote:
> With Broadcom Broadband arch ARCH_BCMBCA supported in the kernel, this
> patch series migrate the ARCH_BCM4908 symbol to ARCH_BCMBCA. Hence
> replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.
> 
> Signed-off-by: William Zhang <william.zhang@broadcom.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net> (for watchdog)
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)
> Acked-by: Wolfram Sang <wsa@kernel.org> (for i2c)
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de> (for reset)

Applied to https://github.com/Broadcom/stblinux/commits/drivers/next, 
thanks!
-- 
Florian
