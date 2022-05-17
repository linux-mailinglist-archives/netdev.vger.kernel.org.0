Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ABC529787
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiEQCz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiEQCz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:55:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801EF4579B;
        Mon, 16 May 2022 19:55:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j6so15683233pfe.13;
        Mon, 16 May 2022 19:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7t+yr5PSxmyHPiQydXEm95PxBfziKJLC8tef/GiEBdI=;
        b=YE0ewza8SlcsYTzxymlpnhscRtVSG3upAHEtVA3LuQLXBpJLDhTt+GA2ymPrJvZxMm
         0SbLhBa/UOyQ1govr2p4ir+A7dFusA7ShKsqCgt0WWKvbc4ohUXc2ZF9wIKd3Qs9lWre
         76xEDe7hpLY1QtcwtMqBaPG+Tj7nPfolGTr5HjntyV5+wZIVxy1tnPdeMyupopceioeE
         MjZxE6JGT/OYclH5QBNMv0BwWAZuXY9UHfi3NYqClxHt5/sTgI0od7aY9B4X4D0Yd9I8
         xRBWnhZLDQS2abRMxqr5Hv/agiystoRgPeSdQYLkZzgqAMedPzQvotbBCDw9QVmCViNP
         jgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7t+yr5PSxmyHPiQydXEm95PxBfziKJLC8tef/GiEBdI=;
        b=J4WmktvxSD/78rhxCbQBxFfqK/VtUK3QcRWL79bS4TY2Fc28JwoR8GS7dPzR4hmppn
         DjbRlTUh3485QARej7mSttNwbA58z0IDd8M0r9U4OJgkmjDwhmwC7z2YsIs7Jvgf6Uqj
         zszVVvX0nFEdR4yFCePEE3it70/AhvSSdnd5YW6G7PX+PseWUUbmOBYPFaI62LT/XwGs
         UBe8J6OmBxLIaEE1BPc+rleUhQNVQlL0XVXUcuRYKKBMsn3TkrE1EG8NKUvN3kt+I3vv
         fjY1zJeDVmNTxe9gcye2PR+QJV1VoQVs0w72A7Fxmp0Fsl6p0TXA+9uu2UN73lVnmiqa
         6LtA==
X-Gm-Message-State: AOAM532l2CfbQhcuPbSKese370iUDR0arTt9fqxafddj2ACvJwtP8+R0
        1BeBoQOUWiiDuuZFDRBf8H8=
X-Google-Smtp-Source: ABdhPJysmMdsSRi5ubrwTSTniBlOVVC/4pXQx8ZJXakI7OjkpNNyHbslhjnjxN9O9A0nG7wqyKNAjA==
X-Received: by 2002:a65:6d06:0:b0:3c6:890:5609 with SMTP id bf6-20020a656d06000000b003c608905609mr17412638pgb.357.1652756125023;
        Mon, 16 May 2022 19:55:25 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b14-20020a62a10e000000b0050dc762817bsm7476299pff.85.2022.05.16.19.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:55:24 -0700 (PDT)
Message-ID: <cfda56c6-391b-16e4-e9f1-290ae2bcb728@gmail.com>
Date:   Mon, 16 May 2022 19:55:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 2/9] net: dsa: microchip: move
 ksz_chip_data to ksz_common
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-3-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-3-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2022 3:22 AM, Arun Ramadoss wrote:
> This patch moves the ksz_chip_data in ksz8795 and ksz9477 to ksz_common.
> At present, the dev->chip_id is iterated with the ksz_chip_data and then
> copy its value to the ksz_dev structure. These values are declared as
> constant.
> Instead of copying the values and referencing it, this patch update the
> dev->info to the ksz_chip_data based on the chip_id in the init
> function. And also update the ksz_chip_data values for the LAN937x based
> switches.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
