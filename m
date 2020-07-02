Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A903212D7F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGBT7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 15:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBT7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 15:59:15 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC27CC08C5C1;
        Thu,  2 Jul 2020 12:59:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o8so28704897wmh.4;
        Thu, 02 Jul 2020 12:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Sn8FkMa3krbqM8mmfm6ud5V1sSg7l8Y8Fkbs+NZhIHk=;
        b=pW3OTAOnVEGuX+d9PS4rXy5WEU6yN/BeJXnezhxh50m2JTgSCrclOfQ1qWilAtkUw1
         IuPFMFAy7M2qwsfmJvM5Ws9EuLGFyg+eTqx6EfNWdVmWl5Qhnf9Iz4zUwp4iPBHErUf+
         VW6wdvFAp4AXrMO2912e/baqJVly/MFmcSOKnw6nfHRueOIhudKE6TmCTs3V6OzJ9mNG
         Hkp9ihaNJG9RCwaCpJfnLpsUQa+97HWfJ18DuBDNnxNIJtSRgt77S7FPVirQrd9DfRCH
         A7fP4tKYte+W0Oq4HM2jPs7W3kgHpC+y9yE/cKXxGczDGflwQXkzygMPb7441UDHtspg
         JL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sn8FkMa3krbqM8mmfm6ud5V1sSg7l8Y8Fkbs+NZhIHk=;
        b=HRKQJCR0K9hB7vBbbUw/e5hG2PfvI3iQE9D5mBcpx6ZBi+GsBZTGU0QzfyZR3PSRa/
         g4cF3bF8I0w48PsR1fdOpoo/u6gLMxiojT3zG/PSAVw2hQI7dEgD38QUoRlIDOZ1AMX7
         YfBAbX+suBalh7TRCFVtKyr3hDnLQ1rOjffwhc7H+9TnrpS3L6KcolgUmH+nD0GszK/B
         +n++iT0EFOowstc7OFW9Kdtut1vlccIxL1dTWnpVfFSZ8UKtP94v/A9+T2tqr3eLuGYj
         WjEvNJ9rV3seuNUDPTp4g5kBqbuxI870VbfHRi7tu8RM1ltzzpXlVU9BAZDsLHXcp/2r
         nYXw==
X-Gm-Message-State: AOAM533oFmVroDjPhe6GId8mLuTk0Ygv4d7a8Bzhd2Q1llbKJ4fLKJHI
        0Rde00GNLDq9igW8wnDsaDs=
X-Google-Smtp-Source: ABdhPJwJiDR/PXzZEsvkH2mruteSVvKaUqVs/VBrynpu4Ag0rUBsGLoSfBkfYHGnonZIkZozd2RLjQ==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr34925368wmc.51.1593719953696;
        Thu, 02 Jul 2020 12:59:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j24sm13143317wrd.43.2020.07.02.12.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 12:59:13 -0700 (PDT)
Subject: Re: [net-next,PATCH 2/4] net: mdio-ipq4019: add clock support
To:     Robert Marko <robert.marko@sartura.hr>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-3-robert.marko@sartura.hr>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e4921b83-0c80-65ad-6ddd-be2a12347d9c@gmail.com>
Date:   Thu, 2 Jul 2020 12:59:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702103001.233961-3-robert.marko@sartura.hr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/2020 3:29 AM, Robert Marko wrote:
> Some newer SoC-s have a separate MDIO clock that needs to be enabled.
> So lets add support for handling the clocks to the driver.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> ---
>  drivers/net/phy/mdio-ipq4019.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
> index 0e78830c070b..7660bf006da0 100644
> --- a/drivers/net/phy/mdio-ipq4019.c
> +++ b/drivers/net/phy/mdio-ipq4019.c
> @@ -9,6 +9,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/of_address.h>
>  #include <linux/of_mdio.h>
> +#include <linux/clk.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  
> @@ -24,8 +25,12 @@
>  #define IPQ4019_MDIO_TIMEOUT	10000
>  #define IPQ4019_MDIO_SLEEP		10
>  
> +#define QCA_MDIO_CLK_DEFAULT_RATE	100000000

100MHz? Is not that going to be a tad too much for most MDIO devices out
there?
-- 
Florian
