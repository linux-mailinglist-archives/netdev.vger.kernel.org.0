Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B1C673E73
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjASQTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjASQSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:18:37 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415708B31D;
        Thu, 19 Jan 2023 08:18:28 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so3933250wmb.2;
        Thu, 19 Jan 2023 08:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KhPMpyCMJ6HvS//S3CCRmvmmRPsh8wUIotQ8o5eWPTs=;
        b=jQvSiB/9uA+iE5dsg7wfyWi+LLwGEDq/f6nxvkTMShJdbRvcFi24Meli3gQyT8mno9
         1FtjziZRBWHgEjDq+mTvL22zo9h+6YWvPqsCzK+HA1EPLe2LLThLJdD/5lQ9lnK1Jush
         MTyiLJv1MBy/JnJCix1LHtCij0CrMKYarK1Miixztllbm1UDdzg9r8eT3U7I7s6P2KbH
         5XD9NRTrkhLojIt+/st6oK15m78nFKGUQ1ig+WgSqwxivBVX77HgZSQQewZ5DqUDCrQ6
         k4BRe7Q+sUZcDYFmw0YYQiJWXgILlus7GyQk1tEdVPDceRnpHDbf1UajTBQGUboBuMD0
         y7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhPMpyCMJ6HvS//S3CCRmvmmRPsh8wUIotQ8o5eWPTs=;
        b=tOyqFyYeQJoLSxQ2/aeIxM1rc6mBuGVi2rZmlLT+AFsUkDyVP9zbSV23YLkpfRrU0C
         nW7thBLWNDVXuruI9uAQi11dWJoC2KytE79cxWsunnsvfyd71CrQ3FC2rGS/l3NgqFZN
         fBF77Wj4FDIWdHAz2ozoVKR+4VTi567rjVGzT0vA4yUxzH9ZRaIyQNKiDTEB37xxbwiU
         P5Nkjg2VW1eCXDM+gDTLvd6oyRKupP+8XyeJXhZ1COd4hGieGAePOIevQ8Rc84ksTdG+
         2CQSzkvtIgbc0XjRdazKN+jPeOVMHReq53FQFT7WldZ29vs+TDSmild6fqVjGqvsm+1Z
         pmIg==
X-Gm-Message-State: AFqh2kpSiHsDIXcJOdxSXqyvylYqDvClcusHqqBxURldI3IKHJjxO8k/
        Y/XaILalhygr0VIFQiGnAlD4kxLTziY=
X-Google-Smtp-Source: AMrXdXtCGQp1kAxCJDbhPvGR36ilJzrNwfl2z1ISaXawuwRYgIvh1dVNxvHTArbGulOwqCZe1wxaJQ==
X-Received: by 2002:a05:600c:3b29:b0:3da:f678:1322 with SMTP id m41-20020a05600c3b2900b003daf6781322mr11301935wms.38.1674145107419;
        Thu, 19 Jan 2023 08:18:27 -0800 (PST)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003db15b1fb3csm4718879wmr.13.2023.01.19.08.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 08:18:27 -0800 (PST)
Message-ID: <3c30c805-243b-5ca9-06a3-2807fd76e3b2@gmail.com>
Date:   Thu, 19 Jan 2023 17:18:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 0/2] Add power domain support for MT8188
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20221223080553.9397-1-Garmin.Chang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20221223080553.9397-1-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both applied, thanks!

Matthias

On 23/12/2022 09:05, Garmin.Chang wrote:
> Base on tag: next-20221220, linux-next/master
> 
> changes since v2:
> - 	add MTK_SCPD_DOMAIN_SUPPLY cap to MFG1
> - 	add MTK_SCPD_ALWAYS_ON cap to ADSP_INFRA
> 
> Garmin.Chang (2):
>    dt-bindings: power: Add MT8188 power domains
>    soc: mediatek: pm-domains: Add support for mt8188
> 
>   .../power/mediatek,power-controller.yaml      |   2 +
>   drivers/soc/mediatek/mt8188-pm-domains.h      | 623 ++++++++++++++++++
>   drivers/soc/mediatek/mtk-pm-domains.c         |   5 +
>   .../dt-bindings/power/mediatek,mt8188-power.h |  44 ++
>   include/linux/soc/mediatek/infracfg.h         | 121 ++++
>   5 files changed, 795 insertions(+)
>   create mode 100644 drivers/soc/mediatek/mt8188-pm-domains.h
>   create mode 100644 include/dt-bindings/power/mediatek,mt8188-power.h
> 
