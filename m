Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7606B6B8C34
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCNHwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCNHwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:52:14 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865A69660D;
        Tue, 14 Mar 2023 00:52:06 -0700 (PDT)
Received: from [10.196.200.216] (unknown [88.128.88.188])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 37525C01E7;
        Tue, 14 Mar 2023 08:52:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678780324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mq6eXg1wvxEuVfFUKMPv5WXkwBa0PhpyXmFCkxWLv6A=;
        b=LldZbbGDbS42HhL3szZLFNu0SMTWXcdpnjAK/is24DJeNq3w9zOolqiqEWBJPAiR6AW0Rz
        nsveQM/BXHwq2eCCHs9/n305OFRn8gUA6dxOpAQgj9qscKQI5fbrKfFBOmSGKl6ZofADuD
        3q1iJutmIof4bBPFuCFWBsf59vH7ri1SOVkNrn7S34IHNynTbBpcxpgM4Ux4MfaL/1Cady
        5ahL2jlN3WHlQe/hl5hfctI9QwnxXlrz/DWz2w1E5fPdugq+TRV72kp8J+FtL7vAssvH4q
        Ifm8FeBU/iqO5de1jcX1f0A2gxvRodoR541/jHEa2kPDm0nRvl5hq2Qw4siWHQ==
Message-ID: <9b240897-17b3-747e-2c41-54298002fb83@datenfreihafen.org>
Date:   Tue, 14 Mar 2023 08:52:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 08/12] net: ieee802154: mcr20a: drop of_match_ptr for ID
 table
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
 <20230311173303.262618-8-krzysztof.kozlowski@linaro.org>
Content-Language: en-US
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230311173303.262618-8-krzysztof.kozlowski@linaro.org>
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

Hello

On 11.03.23 18:32, Krzysztof Kozlowski wrote:
> The driver will match mostly by DT table (even thought there is regular
> ID table) so there is little benefit in of_match_ptr (this also allows
> ACPI matching via PRP0001, even though it might not be relevant here).
> 
>    drivers/net/ieee802154/mcr20a.c:1340:34: error: ‘mcr20a_of_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   drivers/net/ieee802154/mcr20a.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
> index f53d185e0568..87abe3b46316 100644
> --- a/drivers/net/ieee802154/mcr20a.c
> +++ b/drivers/net/ieee802154/mcr20a.c
> @@ -1352,7 +1352,7 @@ MODULE_DEVICE_TABLE(spi, mcr20a_device_id);
>   static struct spi_driver mcr20a_driver = {
>   	.id_table = mcr20a_device_id,
>   	.driver = {
> -		.of_match_table = of_match_ptr(mcr20a_of_match),
> +		.of_match_table = mcr20a_of_match,
>   		.name	= "mcr20a",
>   	},
>   	.probe      = mcr20a_probe,

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
