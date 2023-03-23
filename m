Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072C16C6DFE
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjCWQoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjCWQoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:44:15 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B28E5FDC;
        Thu, 23 Mar 2023 09:43:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c19so27278432qtn.13;
        Thu, 23 Mar 2023 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589799;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KngbDLDLHWwJVgnKsTodwutrgVkaNy3euy5YQN5mZYo=;
        b=g86ZuLQbOhJu06WVOvNn+C4skxE03+YPioFTouQbBLfHUlvElCd3dFaS5OMIDIvkao
         bPKaOsoRAbQiIDF4WUytRb9TA5BK5N0jKbar4WPssbHow3J8N9nAfVhzrK2508J3/Hmt
         jRalDZnBiOKL6k8b/znmH9c17ZrTUE0rtntxGSiEIzvZ8pTW0OPBuzKtbfKdiVKkqEql
         u1hnr6GlXXcvjS8AvWpkKy/sukSkiucvANDa3Mhn/m56++s5OJCDOVL6z6WQ9LKLpPj2
         Ja4pn05yTIlEu3AexHxDsYnVDWuIzqsoCEziA0r9yVuL7pi6XcRKGm+Z1py9C4oaccfZ
         siUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589799;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KngbDLDLHWwJVgnKsTodwutrgVkaNy3euy5YQN5mZYo=;
        b=4LiV+Ntr31DOE49X016GZpVtq1FUdoyweEzt5YJ1yCFZmi3ph6N1ac5Aby8aHnXpdV
         0oJpsfBcanSHQQjEnUzc0VOtvSOGQ2BrBOt5TZbwnL+tSZwNuQaFGSJmPoeodzkEa880
         Xr2PKu8i7HqeaRp29tbADvgDqwLdrhDUxpEsmYMerxe86NK8haXejWdSttodh9coaKln
         P+7AI3LvPyCd1gqRec8sWszLhjCxcOt1N/MXzqwnEq42qOYwe089Rt8CYpOdF926T4RH
         uxP+vecdW8SCFpEuLOaippHXeEs+VINzjMMlXEkXkBoqeYvwSCsdgjD7vTGZwKKSslvL
         fX/w==
X-Gm-Message-State: AO0yUKUvMvGSyEXgh8+AZOxZ+0i+mWbkjbEjb9jssp4salJt8F2QgkEA
        JG//LYyfF+wfYozA2zNHIkU=
X-Google-Smtp-Source: AK7set/AVHrsDHxRPKjskTuZRBFHNlO4bwbcOSa76yoI/1gjB6LW1D/3mkTTMpLSQwiiHEO5XkDsuQ==
X-Received: by 2002:ac8:4e82:0:b0:3b6:323d:bcac with SMTP id 2-20020ac84e82000000b003b6323dbcacmr12078478qtp.32.1679589798775;
        Thu, 23 Mar 2023 09:43:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o140-20020a374192000000b007343fceee5fsm7385670qka.8.2023.03.23.09.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:43:18 -0700 (PDT)
Message-ID: <ee867960-91bb-659b-a87b-6c04613608c5@gmail.com>
Date:   Thu, 23 Mar 2023 09:43:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] net: dsa: b53: mdio: add support for BCM53134
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        paul.geurts@prodrive-technologies.com, jonas.gorski@gmail.com,
        andrew@lunn.ch, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323121804.2249605-1-noltari@gmail.com>
 <20230323121804.2249605-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230323121804.2249605-3-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 05:18, Álvaro Fernández Rojas wrote:
> From: Paul Geurts <paul.geurts@prodrive-technologies.com>
> 
> Add support for the BCM53134 Ethernet switch in the existing b53 dsa driver.
> BCM53134 is very similar to the BCM58XX series.
> 
> Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>   drivers/net/dsa/b53/b53_common.c | 53 +++++++++++++++++++++++++++++++-
>   drivers/net/dsa/b53/b53_mdio.c   |  5 ++-
>   drivers/net/dsa/b53/b53_priv.h   |  9 +++++-
>   3 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 1f9b251a5452..aaa0813e6f59 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1282,6 +1282,42 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
>   	if (is63xx(dev) && port >= B53_63XX_RGMII0)
>   		b53_adjust_63xx_rgmii(ds, port, phydev->interface);
>   
> +	if (is53134(dev) && phy_interface_is_rgmii(phydev)) {

Why is not this in the same code block as the one for the is531x5() 
device like this:

diff --git a/drivers/net/dsa/b53/b53_common.c 
b/drivers/net/dsa/b53/b53_common.c
index 59cdfc51ce06..1c64b6ce7e78 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1235,7 +1235,7 @@ static void b53_adjust_link(struct dsa_switch *ds, 
int port,
                               tx_pause, rx_pause);
         b53_force_link(dev, port, phydev->link);

-       if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
+       if ((is531x5(dev) || is53134(dev)) && 
phy_interface_is_rgmii(phydev)) {
                 if (port == dev->imp_port)
                         off = B53_RGMII_CTRL_IMP;
                 else

Other than that, LGTM!
-- 
Florian

