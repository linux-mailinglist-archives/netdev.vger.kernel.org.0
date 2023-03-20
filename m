Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD66C221B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCTUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCTUAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:00:44 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F4FBDD5;
        Mon, 20 Mar 2023 13:00:23 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id q88so2100400qvq.13;
        Mon, 20 Mar 2023 13:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342422;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uK4an5IRfEdpcLHvzRWsxmJ6vlYV0PkLamta65Wo9WM=;
        b=BiZjGvdnJU2MQaQfHwoFOFhNRFz3PtJqwdiLljGre/M1uxpBCXW11o1bAAK04SkOj0
         2EJcwCcD4JiGRZKX4H3KqWvlzBA0ZWLSrYOxfvBfKKXaBSAAN4B9Z7p6wQzwizOS0PQU
         ycnu/dESAn3f6psN8fLxGRkYRUNCUfiPrg+JQREbO9fzXaR53fKv9qjS1jMCuN8eMVna
         ck+eYNtADgnscR1+UCdaC0oRs48VtmKA6N/R6FT7nVa0Pz5Aw7Ly9FGt0NLDOruSlto8
         lEGyeKLoXGc3nDvZm+PhKSztdJYzWuPbEtawBB5DHvRR/77+bHCMqe1RY1myVRxVUJXm
         lxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342422;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uK4an5IRfEdpcLHvzRWsxmJ6vlYV0PkLamta65Wo9WM=;
        b=AA9Q6wkMVLcOnh9O94qgs2iupzkliPZGdqZzKAz+U6YgJpJac7ya3A2lX8cU1nRMW/
         b9mtbWHrnqKXqUwy4TCdiKsitCj2w1VIJgRrmIam+6Fq/kFQ2kterM0Q5miFXzgIkR5l
         INoAb/c8ihGf7qHZr49Vi2kIoPjaYPzmS5EAUyEMpwY40NH8RGA59s+l/Y1yKk3IEUdU
         X0wOAbIh/2Aa2bZYSQk/QadqWPT6CCR42DONd6Ty+TGfqUA+romV1z77u0eIu3QmhFJx
         Nds47GJXNum2D92ysI6KJJS3kTROJYExEcmHptwmABapafmjVWOYiHzhCCZuhLBF3ApW
         zdYw==
X-Gm-Message-State: AO0yUKVr12PsQFM1fKaFaxbR1/Ly3+JutwVjTFcXP31UbceT3icQFjIR
        LFiegeCgQ5sx69T7XER5EjQ=
X-Google-Smtp-Source: AK7set8am0n0iqcCczejb+M4mjKbMTpHk7CLBVNcxZJA3LDgnUvfmg6PZvWWWiRzrEo0DCsbzv2F7A==
X-Received: by 2002:a05:6214:19ed:b0:5c8:ad0d:3b7e with SMTP id q13-20020a05621419ed00b005c8ad0d3b7emr205412qvc.35.1679342422543;
        Mon, 20 Mar 2023 13:00:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s127-20020a37a985000000b007469b5bc2c4sm104393qke.13.2023.03.20.13.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:00:21 -0700 (PDT)
Message-ID: <6f7e9b8c-6256-e7dd-b130-8e1429610faa@gmail.com>
Date:   Mon, 20 Mar 2023 13:00:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4/4] net: dsa: b53: add BCM63268 RGMII configuration
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230320155024.164523-5-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320155024.164523-5-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/20/23 08:50, Álvaro Fernández Rojas wrote:
> BCM63268 requires special RGMII configuration to work.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>   drivers/net/dsa/b53/b53_common.c | 6 +++++-
>   drivers/net/dsa/b53/b53_regs.h   | 1 +
>   2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 6e212f6f1cb9..d0a22c8a55c9 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1240,8 +1240,12 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
>   		break;
>   	}
>   
> -	if (port != dev->imp_port)
> +	if (port != dev->imp_port) {
> +		if (is63268(dev))
> +			rgmii_ctrl |= RGMII_CTRL_MII_OVERRIDE;

AFAICT the override bit is defined and valid for both 63268 and 6318, 
essentially whenever more than one RGMII control register for port 4, 
but also for other ports, it seems like the bit becomes valid. The 
comment I have says that the override bit ensures that what is populated 
in bits 5:4 which is the actual RGMII interface mode is applied. That 
mode can be one of:

0b00: RGMII mode
0b01: MII mode
0b10: RVMII mode
0b11: GMII mode

even though this is not documented as such, I suspect that the override 
bit does not only set the mode, but also ensures that the delays are 
also applied.

Once you update patch 3, this LGTM and you may add:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

For your v2. Thanks!
-- 
Florian

