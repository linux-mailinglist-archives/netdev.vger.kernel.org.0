Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F67419F3D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhI0TgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbhI0TgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:36:15 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70247C061604
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 12:34:37 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w19so27011694oik.10
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 12:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pdma3bMI5gliI9oqeEnm97FccftqJE98K0Dh887pnNQ=;
        b=WVPFDQNK770vz+ck/y4hEWZ+49oN8ujdogKHg7gvnwprkeS3T1uJ+Ocgo2lFq+oPDX
         i2m9fo8GJ/K+KmilUq/8i4m38zHDrcuh09qGqKvDiYOfXfjnYwitKW51ke/1FpmYO/eK
         OSsEMx0fvjU1dPggkzmlQz+rfQg2M98FXeJoHCLRacKt48B/OnBmAqhHmuxYk12+3vqd
         7yDFWM0bUIgzyqoYDrJMOHdINfWegOJhfrKzDi4RdXNgaUGPD+i7eLPeqsRuSfDW0DKO
         UK2YGLVWGzpYAgypXBNzmmxOuVyy76ENPpybBGUGoyd4fISEMT7p/eYH6nIyTVq+Iq6G
         sLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pdma3bMI5gliI9oqeEnm97FccftqJE98K0Dh887pnNQ=;
        b=xsD5y0HNIWzfNRofWIqtG8T915csGtnBi8Shvy6h5GM455FKxRy7bSPF/rb3csVq/W
         0MKWP+FPhgAsGccIWD3tuODGpSTMSXDCSnfb7YeYQ0JADfbfK3KYu1b+bHBJ19Wg3orP
         Sq8UgsgZwytpT4wPB/5j48+KTX3bAhiNU6kPhig3s19qmK7+UZIUMakYYm+9s2axXHUj
         WoJKj8fEYHUu9nH0VpoVlZHXOlkoI+SxwB38pbesA/5+QTWyQZ2gT8LIyjW51Igtqr3a
         k+L9eMhmkiIQzKeg9RqXVXVfm2Uj3II+yDzXDI9p7uTE6HCCf6yY90xTATFBVPw73Oin
         BWRQ==
X-Gm-Message-State: AOAM532JOnSY1/15kywWm4Jim0A8FNvNCO8MMDtJOdJqJwsv6j5E2KGV
        HI562ZKSuW0exS8mFHic8kVTjw==
X-Google-Smtp-Source: ABdhPJycD7BOLJ2aT0AvHZm7xpV9acfCi2Vp3tsj3NC9Tv9wqRTI1TLp6jpiF21h1ftBOvP9jYYS1g==
X-Received: by 2002:aca:b7d6:: with SMTP id h205mr633473oif.84.1632771276788;
        Mon, 27 Sep 2021 12:34:36 -0700 (PDT)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id v2sm4304221ooh.28.2021.09.27.12.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 12:34:36 -0700 (PDT)
Date:   Mon, 27 Sep 2021 12:35:11 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Steev Klimaszewski <steev@kali.org>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipa: Declare IPA firmware with MODULE_FIRMWARE()
Message-ID: <YVIc77g464EpLtyN@ripper>
References: <20210926065529.25956-1-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926065529.25956-1-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 25 Sep 23:55 PDT 2021, Shawn Guo wrote:

> Declare IPA firmware with MODULE_FIRMWARE(), so that initramfs tools can
> build the firmware into initramfs image or warn on missing of the
> firmware.
> 
> W: Possible missing firmware /lib/firmware/ipa_fws.mdt for module ipa
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/net/ipa/ipa_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index cdfa98a76e1f..264bebc78d1e 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -545,6 +545,8 @@ static int ipa_firmware_load(struct device *dev)
>  	return ret;
>  }
>  
> +MODULE_FIRMWARE(IPA_FW_PATH_DEFAULT);

I think it's fair to say that no device that is capable of running
mkinitcpio should actually use IPA_FW_PATH_DEFAULT, but rather some
device-specific firmware file.

Regards,
Bjorn

> +
>  static const struct of_device_id ipa_match[] = {
>  	{
>  		.compatible	= "qcom,msm8998-ipa",
> -- 
> 2.17.1
> 
