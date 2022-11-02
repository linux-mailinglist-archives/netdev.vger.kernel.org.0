Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5EA616A64
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiKBRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiKBRQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:16:14 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494B240B2;
        Wed,  2 Nov 2022 10:16:06 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id l2so7049413qtq.11;
        Wed, 02 Nov 2022 10:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOws5RrrraQdImG7NAEUZloT5JDKMF2E4x52BNGTp6o=;
        b=M4Nnssqn0CLZ6bbqRAXUeda+p4sEo2IVnHL5NiHzr+9OjC/1dvnz1f0eX+eMN0YM54
         5wsDIp1jbQAhrAXR1VLjaGmA8ao2/w1zPdv/vpVWZIJRfNigbJta3XU5EFsIHUvy2lfn
         mmkGPcKBSl1a2Fyp771XfMUZ0sPCdX8ICQc6cmKQePvDGJAD221Q9nVglpVhD4G5f6xp
         ctmZrUGxrvfveHphhy4/uzKPWSx7v+Ot9DIJ29wfUP8kgwbLI/9peoHpcpvf3Fox7Oh2
         z6PRaJV7UGJMliATe7e9D+6ggzmJpBUvZHFx0RMeOfBDK4oKIvBSLGvDlD3NqecFozSJ
         0jkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOws5RrrraQdImG7NAEUZloT5JDKMF2E4x52BNGTp6o=;
        b=RPISGnk242uMkfL27Um9IU/Ll9d66bJMKaUiSwSKCaQM+THogPgbXxxchFaG9xrwRa
         FkpTUcVjwnRpj0WTBouL+Vg0ELyCPifaNGJxAALU0D+AGToFAOFkn3GauGLS7msYn0SM
         pOE3cdOwnsW0rchbvE4kuOje8muGvSZZTZzu+5fc/apHmUsNrxYrfHKbFd7+XoKHGFf1
         nHiGAoI9cQnInTEUS4sO5KjODpCObc/khDRTQA3gs5d8UrS3qkqJLmy1/+MN5cW+XTzl
         C5AGkORjYytWMdOBXp2ANesqP0kM8VuewIG9tLIf3F+GBlaw97yoqOv3b3SN0SGbr7Cw
         hylA==
X-Gm-Message-State: ACrzQf2KOcTlG/GnvDX8BicsBBJ6eRbFvjKdN0RbvQbJBjS9lzyUCNXL
        sKbpi6PmApCIKgH+4GBsne0=
X-Google-Smtp-Source: AMsMyM4d5BBr3cpnwag87E2VXkpTPiRwe4/d3whuL1AvHhdmwd8wNJwXCpAKO2uwCl8bxsLc/gMZ9g==
X-Received: by 2002:a05:622a:1cc8:b0:3a5:30df:5e0f with SMTP id bc8-20020a05622a1cc800b003a530df5e0fmr10831574qtb.634.1667409365696;
        Wed, 02 Nov 2022 10:16:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id hg24-20020a05622a611800b00398a7c860c2sm6807322qtb.4.2022.11.02.10.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:16:05 -0700 (PDT)
Message-ID: <cc5dd02f-7285-dfcf-76b1-bb258c8029fb@gmail.com>
Date:   Wed, 2 Nov 2022 10:15:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next 1/6] net: dsa: microchip: lan937x: add regmap
 range validation
Content-Language: en-US
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
 <20221102041058.128779-2-rakesh.sankaranarayanan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102041058.128779-2-rakesh.sankaranarayanan@microchip.com>
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

On 11/1/22 21:10, Rakesh Sankaranarayanan wrote:
> Add regmap_range and regmap_access_table to define valid
> register range for LAN937x switch family. LAN937x family
> have sku id's LAN9370, LAN9371, LAN9372, LAN9373 and
> LAN9374. regmap_range structure is arranged as Global
> Registers followed by Port Registers but they are distributed
> as Global Registers, T1 PHY Port Registers, Tx PHY Port Registers,
> RGMII Port Registers, SGMII Port Registers. On 16 bit addressing,
> most significant 4 bits are used for representing port number.
> So valid range of two different T1 PHY ports within a sku
> will differ on upper nibble only.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---
>   drivers/net/dsa/microchip/ksz_common.c | 1760 ++++++++++++++++++++++++
>   1 file changed, 1760 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index d612181b3226..b0905c5b701d 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -1030,6 +1030,1756 @@ static const struct regmap_access_table ksz9896_register_set = {
>   	.n_yes_ranges = ARRAY_SIZE(ksz9896_valid_regs),
>   };
>   
> +static const struct regmap_range lan9370_valid_regs[] = {

Suggest you employ some macros for generating the valid register ranges 
for ports since there is a lot of repetition, and chances are that new 
registers may have to be added in the future, or corrected.

Between the fact that regmap makes you pull an entire subsystem into the 
kernel image thus adding to code sections, plus these big tables of 
register ranges adding to read-only data sections, this really makes me 
wonder what benefit there is just to expose a debugfs interface for 
dumping registers... value proposition does not seem so great to me.
-- 
Florian

