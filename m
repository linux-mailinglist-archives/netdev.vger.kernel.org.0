Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6F5638A3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 19:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiGARdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 13:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiGARds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 13:33:48 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA3C33E06;
        Fri,  1 Jul 2022 10:33:47 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id z7so2318151qko.8;
        Fri, 01 Jul 2022 10:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SHhBE8CI4B3o2M2bAXCcRFfwKa+1iU8UL1Vjje2dYXw=;
        b=PSCUjp4Nzi5zeNQGbM5iSQUJex8IzVLR1ESS39LBfdUAsq4EGoNupdr7aI1A2leikl
         Ir8KgHMTmm2G8EG9E8a3rlN1RAdQIiSR8dR+dizbIXV5/paxqmWQkataO1XgnftwJJDs
         rI4vHbn5UtDuM+UBXNiHkBV0FJ9x+3wSUYQR/Y83/XktSzxhS5ZEciDJeukm+HrsQmpt
         qCEOhrb64oRpP5qiLxBdxjVEAfjivUfl4bchJ4NpNJTsAi6Nd3PR9aQ2YA7S4X6YFh+6
         WrkE6p44ldO8EaGKgp5ZnUwYl4PGC/I0pq/vISFnWwC6g5Eueyx/aldWkP8Yzo1Qm0YI
         boVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SHhBE8CI4B3o2M2bAXCcRFfwKa+1iU8UL1Vjje2dYXw=;
        b=jRgUzGpt1CXFDs0oaxP6/5qlHF6MryceqsW/rnUZQu0tlmzyHClJH2Oo5XnsqwYhHa
         l4KAUrHDcqYMP456ila6Dzsj2FTEH6sN4sQpNdKDD41MN+/WpsyhcFXvG2krGFPZbHgR
         sv/3ukbX9LrRmjZKmNg4NNfur44wVAbQi1DnkaRH+98UicYlW9lqXf2nfxkOQOx3mNgR
         RYTZmuB0YxVjLved3fLvJPh2NCbpYsUlRKDavBmfnRLhyf8MViyBAeI1tI6hPS0hOd2Z
         tGSKuK9GG87mioayb2IA1c+kcYmapdgBk0U3bUbzzVUZ9ARxlwhMt3H3L5O7Vu8+frUU
         dstA==
X-Gm-Message-State: AJIora+lNcrb4Tqzl2avhYe0HX0KO8Pl4b7GCxnoAWOstSF6rTDE/sSh
        LlLVTY+cG+ZVso3uZxR+A9w=
X-Google-Smtp-Source: AGRyM1vDCOmfmGaXpcdnuW3G/6iyoSrk9anyUwrVugo5igKcfUTLDTAoUQk1GL6x25ZM/gzuzQ+5Lw==
X-Received: by 2002:a05:620a:15b:b0:6ae:e3b8:ea2c with SMTP id e27-20020a05620a015b00b006aee3b8ea2cmr10911412qkn.214.1656696826152;
        Fri, 01 Jul 2022 10:33:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ci27-20020a05622a261b00b00316dc1ffbb9sm7911248qtb.32.2022.07.01.10.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 10:33:45 -0700 (PDT)
Message-ID: <386c80a0-538f-df32-665c-cd10d62a8db3@gmail.com>
Date:   Fri, 1 Jul 2022 10:33:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v1 1/1] net: dsa: sja1105: silent spi_device_id
 warnings
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630071013.1710594-1-o.rempel@pengutronix.de>
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

On 6/30/22 00:10, Oleksij Rempel wrote:
> Add spi_device_id entries to silent following warnings:
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105e
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105t
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105p
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105q
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105r
>   SPI driver sja1105 has no spi_device_id for nxp,sja1105s
>   SPI driver sja1105 has no spi_device_id for nxp,sja1110a
>   SPI driver sja1105 has no spi_device_id for nxp,sja1110b
>   SPI driver sja1105 has no spi_device_id for nxp,sja1110c
>   SPI driver sja1105 has no spi_device_id for nxp,sja1110d
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
