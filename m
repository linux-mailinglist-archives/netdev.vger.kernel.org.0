Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC0319473
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 21:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhBKU1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 15:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhBKU1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 15:27:45 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C859C061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 12:27:04 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id g9so6293086ilc.3
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 12:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BhGQshN1SJ6FzYvK/Ylak5i6bTCB8ww2nvYRmIy1Hhg=;
        b=dB8jc5NwlVjd5jAbswz4S6tGscnbR1vlEnvWXzmI5VGKQxt92AINve6Ax5LT703TnI
         HX50/z+Qhm+1paetK0Na84hXoIqb6Up1iN8socEjg9gbMDWyCcb87Rbykh1peungcU2T
         Ei0LSx02rQCMLWO3IolI/80HT2YrDpmKhTBWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhGQshN1SJ6FzYvK/Ylak5i6bTCB8ww2nvYRmIy1Hhg=;
        b=F3hAG2lNjR7ce5H1TMDwZ1Pg0kaXm3Y8lJ2G66iT/aHwO8r7dpxUOOjNoy08kLsKC9
         0XyG6v8CxvCH6Jyknmjqt1RDZYp+iQcjMP9plii6MpFjGGooNlVTzFRgIOlHjCQfaas6
         oyX8KZ7sirPd1uGnN4m6OJWfrLHlLywS6VIibCBcRtkeDMsj3XSSaADiHivoluEQGp8R
         dBT4723DAULw0YECBaO8UOYcgn+5IoDbxwOEqCbHkMam0RhjJTJ7FsvnLvzQuGFBPoib
         K5ykKJMadUT88Ymi09QGykDNqThtHPiw6Jh5kbEWkiIzw6zW7X6sGpS2r4y9yLEz1Joj
         +CFQ==
X-Gm-Message-State: AOAM5311gvN9KBgMw6Om1xPZMm5ZrqrxBoU5VipIY3ZDiH3TlVwqdxEW
        XfrM1FsVmFmSgCSoRBYEIsLojw==
X-Google-Smtp-Source: ABdhPJzMlL6cxuNZc0DR632e+CNV3R+bRT9mM+nrr2xk1U1V2+1gi/DwvLGaJVPrlE7F5QiYXbEqsA==
X-Received: by 2002:a92:730a:: with SMTP id o10mr7310122ilc.160.1613075223595;
        Thu, 11 Feb 2021 12:27:03 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h2sm3009479ioh.6.2021.02.11.12.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 12:27:03 -0800 (PST)
Subject: Re: [PATCH v1 0/7] Add support for IPA v3.1, GSI v1.0, MSM8998 IPA
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <3a596fce-9aa3-e2eb-7920-4ada65f8d2ee@ieee.org>
Date:   Thu, 11 Feb 2021 14:27:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> Hey all!
> 
> This time around I thought that it would be nice to get some modem
> action going on. We have it, it's working (ish), so just.. why not.

Thank you for the patches!

I would like to review these carefully but I'm sorry
I won't be able to get to it today, and possibly not
for a few days.  But I *will* review them.

I just want you to know I'm paying attention, though
I'm sort of buried in an important issue right now.

I'm very impressed at how small the patches are though.

					-Alex

> This series adds support for IPA v3.1 (featuring GSI v1.0) and also
> takes account for some bits that are shared with other unimplemented
> IPA v3 variants and it is specifically targeting MSM8998, for which
> support is added.
> 
> Since the userspace isn't entirely ready (as far as I can see) for
> data connection (3g/lte/whatever) through the modem, it was possible
> to only partially test this series.
> Specifically, loading the IPA firmware and setting up the interface
> went just fine, along with a basic setup of the network interface
> that got exposed by this driver.
> 
> With this series, the benefits that I see are:
>   1. The modem doesn't crash anymore when trying to setup a data
>      connection, as now the modem firmware seems to be happy with
>      having IPA initialized and ready;
>   2. Other random modem crashes while picking up LTE home network
>      signal (even just for calling, nothing fancy) seem to be gone.
> 
> These are the reasons why I think that this series is ready for
> upstream action. It's *at least* stabilizing the platform when
> the modem is up.
> 
> This was tested on the F(x)Tec Pro 1 (MSM8998) smartphone.
> 
> AngeloGioacchino Del Regno (7):
>    net: ipa: Add support for IPA v3.1 with GSI v1.0
>    net: ipa: endpoint: Don't read unexistant register on IPAv3.1
>    net: ipa: gsi: Avoid some writes during irq setup for older IPA
>    net: ipa: gsi: Use right masks for GSI v1.0 channels hw param
>    net: ipa: Add support for IPA on MSM8998
>    dt-bindings: net: qcom-ipa: Document qcom,sc7180-ipa compatible
>    dt-bindings: net: qcom-ipa: Document qcom,msm8998-ipa compatible
> 
>   .../devicetree/bindings/net/qcom,ipa.yaml     |   7 +-
>   drivers/net/ipa/Makefile                      |   3 +-
>   drivers/net/ipa/gsi.c                         |  33 +-
>   drivers/net/ipa/gsi_reg.h                     |   5 +
>   drivers/net/ipa/ipa_data-msm8998.c            | 407 ++++++++++++++++++
>   drivers/net/ipa/ipa_data.h                    |   5 +
>   drivers/net/ipa/ipa_endpoint.c                |  26 +-
>   drivers/net/ipa/ipa_main.c                    |  12 +-
>   drivers/net/ipa/ipa_reg.h                     |   3 +
>   drivers/net/ipa/ipa_version.h                 |   1 +
>   10 files changed, 480 insertions(+), 22 deletions(-)
>   create mode 100644 drivers/net/ipa/ipa_data-msm8998.c
> 

