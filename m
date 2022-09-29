Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237205EF820
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiI2O6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiI2O6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:58:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355F813EAF7;
        Thu, 29 Sep 2022 07:58:28 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e129so1667644pgc.9;
        Thu, 29 Sep 2022 07:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nr6Fhgb0cGlu1dPd52kqIp4KaVbgoSDCKH+cB3O1Lsc=;
        b=AdNva7Y2eLNK0fCyd0/cBCH/j9CQQC60CbnvM99Xwu5MnPemyU/VN/NiVTAkurlKJd
         6dHyoD3TfvDpu7ffPoqNIjrQd54Nmw07WrvIC6vr1G02RVURdNQ0PhSllYHRY4lGQSIj
         5MMccAB6iM39gOkkEstr++TPURu6SH3oTFEJfNnkFmyHB9DIJH1poUmUj49x5Kg7IigC
         WWdAAH2H4nArdcrXvThT+3ncAzaW+vBBdkvv4rQoKDydN4GuK+rFgPxXQ8PSkO2TNhdc
         XGVHZql8c7x46keBQSfYawtnJoKktoKOaivFv4O67Gvt1xhKyw09onlr8gfdbg4STipi
         jc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nr6Fhgb0cGlu1dPd52kqIp4KaVbgoSDCKH+cB3O1Lsc=;
        b=Pytz6Dd2+6V7+0YDABeuxtyOpuP4uiPaNRd0HeSsWy3UfRsYasKDYsy6Em5n/VZqZI
         bKD2bWB71zYRAiNAXqZykCva1f2xSQCDtsKiH6Be9+D/jJ6KybvFcMIZwvLuMJYUNSkg
         3IfW80VOH+W5ty1siiEcaebxmkr2TbkW6Ru8FS4Ng17wEWF0LYz1UrO8GG+ckVvi0ifN
         ulX6bGE8fCVSa1G7cv5FOFMc3SrHCRkQDBPDcpBrozXi0Mied9DUA6mGrMS1MtbZfoMl
         QQ6rZ51mJN6mpcBLnfYnX8mQ6vDKfZuKb/lcDSucEN4lnw86hFKWmhoKpZc9b9B8kKdk
         sOUw==
X-Gm-Message-State: ACrzQf3/hLHivMs6vs+OvP0yGvjParNLtBKhvNZh3VWhQs4OsCtuqjsA
        Vqq38OmyTcSuhIWrZXODweM=
X-Google-Smtp-Source: AMsMyM6cm7L6JZsqutWuz6gExoMH+POuZBdq4Dy2Bi2iJM5dtfYvk4oIYGhwEAM5lnBgXCwLircMDA==
X-Received: by 2002:a63:488:0:b0:43a:9392:2650 with SMTP id 130-20020a630488000000b0043a93922650mr3165534pge.546.1664463507487;
        Thu, 29 Sep 2022 07:58:27 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:637c:7f23:f348:a9e6])
        by smtp.gmail.com with ESMTPSA id h1-20020aa796c1000000b00540a8074c9dsm6290198pfq.166.2022.09.29.07.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 07:58:26 -0700 (PDT)
Date:   Thu, 29 Sep 2022 07:58:24 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] nfc: s3fwrn5: use
 devm_clk_get_optional_enabled() helper
Message-ID: <YzWykMgcJ6nZBi19@google.com>
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
 <20220929050426.955139-2-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929050426.955139-2-dmitry.torokhov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:04:26PM -0700, Dmitry Torokhov wrote:
> Because we enable the clock immediately after acquiring it in probe,
> we can combine the 2 operations and use devm_clk_get_optional_enabled()
> helper.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/nfc/s3fwrn5/i2c.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> index fb36860df81c..2aaee2a8ff1c 100644
> --- a/drivers/nfc/s3fwrn5/i2c.c
> +++ b/drivers/nfc/s3fwrn5/i2c.c
> @@ -209,22 +209,16 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> -	phy->clk = devm_clk_get_optional(&client->dev, NULL);
> -	if (IS_ERR(phy->clk))
> -		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
> -				     "failed to get clock\n");
> -
>  	/*
>  	 * S3FWRN5 depends on a clock input ("XI" pin) to function properly.
>  	 * Depending on the hardware configuration this could be an always-on
>  	 * oscillator or some external clock that must be explicitly enabled.
>  	 * Make sure the clock is running before starting S3FWRN5.
>  	 */
> -	ret = clk_prepare_enable(phy->clk);
> -	if (ret < 0) {
> -		dev_err(&client->dev, "failed to enable clock: %d\n", ret);
> -		return ret;
> -	}
> +	phy->clk = devm_clk_get_optional_enabled(&client->dev, NULL);
> +	if (IS_ERR(phy->clk))
> +		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
> +				     "failed to get clock\n");

I forgot to remove clk_disable_unprepare() in remove method, I will
resubmit.

Thanks.

-- 
Dmitry
