Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117D16B8C3A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCNHx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjCNHx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:53:27 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0031F92A;
        Tue, 14 Mar 2023 00:53:24 -0700 (PDT)
Received: from [10.196.200.216] (unknown [88.128.88.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 14658C0149;
        Tue, 14 Mar 2023 08:53:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678780403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KXWjgVTL/b1pmxrfnTF9ga428rWm29ujpxzR55Wk55g=;
        b=ODrj5LeOagYuxm0cSqh9ngbp/8Dnu0eVDDjd0OKk1xq5r0SLJc0aROVYnEJ7OrVb8DOmcw
        JpbNfpZzXkK0EiVjGf6cFGDqtRw+DE9QnZwFgLgROLHSKbC0Ih6Gz9pXLkT7cpAIvIy9P8
        CdR73F8H51eEp2XKjlLt2T5KfR11A8pWMh8noAUU0MNriXi41LHGndpxClqczNszvCVqq3
        jfb4x8UkE42Ur/SEa/0HYlmflfmW0pJU6wrBG8CcHDRQRySE2ihm6c8KNiNfafFPD4s71E
        dZVHOgAopBySUApPNJqzf8aQpnVLqG+40YlqfowTnhkLxqZMXk3YwHrPMEMpWQ==
Message-ID: <96cc8936-c73f-31d9-cb31-ea50c91ec90d@datenfreihafen.org>
Date:   Tue, 14 Mar 2023 08:53:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 10/12] net: ieee802154: ca8210: drop of_match_ptr for ID
 table
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
 <20230311173303.262618-10-krzysztof.kozlowski@linaro.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230311173303.262618-10-krzysztof.kozlowski@linaro.org>
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
> The driver can match only via the DT table so the table should be always
> used and the of_match_ptr does not have any sense (this also allows ACPI
> matching via PRP0001, even though it might not be relevant here).
> 
>    drivers/net/ieee802154/ca8210.c:3174:34: error: ‘ca8210_of_ids’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   drivers/net/ieee802154/ca8210.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index ed6cb79072a8..65d28e8a87c9 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -3181,7 +3181,7 @@ static struct spi_driver ca8210_spi_driver = {
>   	.driver = {
>   		.name =                 DRIVER_NAME,
>   		.owner =                THIS_MODULE,
> -		.of_match_table =       of_match_ptr(ca8210_of_ids),
> +		.of_match_table =       ca8210_of_ids,
>   	},
>   	.probe  =                       ca8210_probe,
>   	.remove =                       ca8210_remove

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
