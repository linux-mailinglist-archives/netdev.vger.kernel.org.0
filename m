Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F456B8C36
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCNHws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCNHwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:52:45 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F65968E5;
        Tue, 14 Mar 2023 00:52:35 -0700 (PDT)
Received: from [10.196.200.216] (unknown [88.128.88.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6E0B5C027C;
        Tue, 14 Mar 2023 08:52:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678780353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DnmsYAcwdz8HnkbJr5iwCASTjMMpe8alTslg1Sn7Ts=;
        b=rayWYp9fyFT5j/+Hs2TpMKTeBPCGi3SJP4fPz/2b/ZFXDz5OnlFvHlB54TVeNKj4PArL+d
        is4RpCDjhUd1xVpc/W4OHhuSf7fD0PoalCADm84uVx8799VMPRe/NshC4VbdkqCI3Kkzsr
        ieQpNlFPWR1iYTkX8wS2y4i9PRTRms1TVN+P00C6uaWgWAcN1YhjfvYdSVgabFcAHj3JiB
        JOQrQUCbZbdgOp+Zbecy4YBA7ecx6s0P1syBljgR8VmxyicqRx6BT36jqjdIP05XFsfxm8
        z31RjaZI7tX1bAeeC/yMkJ//DRENRNHUbQaA8N/OWkuinyU/vIAhs60vL7CCJA==
Message-ID: <9378bf46-566e-2b83-3cb3-dfd662ec88da@datenfreihafen.org>
Date:   Tue, 14 Mar 2023 08:52:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 09/12] net: ieee802154: at86rf230: drop of_match_ptr for
 ID table
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-9-krzysztof.kozlowski@linaro.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230311173303.262618-9-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 11.03.23 18:33, Krzysztof Kozlowski wrote:
> The driver will match mostly by DT table (even thought there is regular
> ID table) so there is little benefit in of_match_ptr (this also allows
> ACPI matching via PRP0001, even though it might not be relevant here).
> 
>    drivers/net/ieee802154/at86rf230.c:1644:34: error: ‘at86rf230_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   drivers/net/ieee802154/at86rf230.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> index 62b984f84d9f..164c7f605af5 100644
> --- a/drivers/net/ieee802154/at86rf230.c
> +++ b/drivers/net/ieee802154/at86rf230.c
> @@ -1662,7 +1662,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
>   static struct spi_driver at86rf230_driver = {
>   	.id_table = at86rf230_device_id,
>   	.driver = {
> -		.of_match_table = of_match_ptr(at86rf230_of_match),
> +		.of_match_table = at86rf230_of_match,
>   		.name	= "at86rf230",
>   	},
>   	.probe      = at86rf230_probe,

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
