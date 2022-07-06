Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF94568B8F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiGFOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiGFOoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:44:14 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CFF23166;
        Wed,  6 Jul 2022 07:44:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j22so1245055ejs.2;
        Wed, 06 Jul 2022 07:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mT/RRR0q2krpQza4SQONoGJNf6L6P3d7WWsnXLKGbq8=;
        b=ElncPov73QAOpqBGAJC6f5+Ka/ZM2MGnqkBkCHKbrvnHFscloo64QKsFunlPhOpfYX
         ReqVW0t+g//JS11zPGGnmFjryzk6ztLYqjPWo4b4CxtJuKWpccn8zMsTxmQJMnQQ9Cwg
         fvrhrep08sTjNNJiQCmIGj4JpbjrgFhzbL94JwKBTPT2JsCFgH7P/FyzWBfBFlwl/gQq
         +SpPQ4MN3lb8n84j7uQOHHun4v6YfUxlPgvmLP35ud+43Gsj9av1SfvyGxSu5CF1/EGA
         ych3djr5OuMPna/MgfjH75fD+zyZ7c0rMQ2ENDhnKNC7EqN1Ujw0mZnoGHkICboJwOxd
         qgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mT/RRR0q2krpQza4SQONoGJNf6L6P3d7WWsnXLKGbq8=;
        b=MsPT7hZm3mleVRiLOQwqAPnUkVds+YPaXPtH52YzhMES1sevnICVxKdhbzUXDcE6+C
         Mbpi2ySdwewhvYlK5ItRsKgNT6eV6QFJRphPzGuzrQ6CZvwFYWiIEXsqkFht0ruV3PUH
         0GbP+yQQozFSrCCXRPNivBANp+O0Y1URNvOAqzT2v9uoVgTaZrTAQnnL/8s3WcUdzF19
         hBm4FjaOf6StnGK0FOLTYOimKSw/AeCy1F2SPsPHcHbV37+PFfSi5pmwB7bMj4cDJzUQ
         HqQNNvk9gcLQj2NbvbHVh01coil6y15XThEvybX92xEKWjo/6GU5rp6Rl6bB9zGDHxdJ
         eceg==
X-Gm-Message-State: AJIora/F71ZZWODSHTssf5CYYCI0szibEc5e/5hCROS2rvB8waj961rn
        DNq6MpSYVSrPcaZK5NfqrLuQRH+elzeOT6/lWQQ=
X-Google-Smtp-Source: AGRyM1ufdjho1nB5oX1vLj0QNnI5W8VKz9cjYxKIGoUI4SuOHcFWWvas8RfAGVbH0/2Wfp9o8Yp1SdorwTOwTFjHd+8=
X-Received: by 2002:a17:907:7627:b0:72a:9098:e4d3 with SMTP id
 jy7-20020a170907762700b0072a9098e4d3mr27044101ejc.389.1657118652003; Wed, 06
 Jul 2022 07:44:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
In-Reply-To: <20220630071013.1710594-1-o.rempel@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 6 Jul 2022 17:43:59 +0300
Message-ID: <CA+h21hrTxNM93M34iusYAO+L=37o-BJ33o7UXW0rwyKk2EOoKw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: sja1105: silent spi_device_id warnings
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Thu, 30 Jun 2022 at 10:10, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> Add spi_device_id entries to silent following warnings:
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105e
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105t
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105p
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105q
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105r
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105s
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110a
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110b
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110c
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110d
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

This was marked as "Changes Requested" in patchwork. Could you please
slap a Fixes: tag onto it and resend to net?
Also, would you mind applying the same treatment to
vitesse-vsc73xx-spi.c so that we get rid of the warnings for all DSA
drivers?
You can blame the spi.c commit that introduced the warning.

Thanks!
