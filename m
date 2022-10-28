Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A361086B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiJ1Cun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiJ1Cul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:50:41 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949FE5B724;
        Thu, 27 Oct 2022 19:50:40 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id cr19so2798123qtb.0;
        Thu, 27 Oct 2022 19:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t5Ep/zI57uGQ7BXyZF7xK1sUrnH2cyShmygiCTP45g8=;
        b=AQ7qcREf/U8bAmbf+h4JnB6/o/Uu6HOjga3pgyuFvwQxblNMssad/GBme48+gOtEBx
         z/PK323Fqm1Pz5bHf47hZUhaKxZj0K73NRnww6/R19YvLdCEVjzIFbIFCAqrtGBRJ1ix
         iwNcNWxef3t8RIrw5/tdqKL1wcXCE1dtcnWx6HTe/K0Q7ktWn22R3sHlda3hZDkNn8V1
         U/2Sk7UZUuiPs+zO/bCSbwPh6WogqOEYvucSrlztTQ3JjRKA+a3wm4TcF40GK5XtWM0H
         TkCIbOo1l7BND1byVT8Z0N4a4fMMISRqm+vbbudKLrp44/+qOMc1oZ37833TJvddwKUD
         ZRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5Ep/zI57uGQ7BXyZF7xK1sUrnH2cyShmygiCTP45g8=;
        b=EDypVPIv2UKriM8tkzUGBVRPLMFDdcFmvcuuSFjB8fGzn0QEjllwZZdIM8wmkpRWaI
         bMR/6BXQl1qHcCaMeJ2rqWGO/ua4VYu4q0jpG+epwx3zgU3+2eLninJEi3zBngBCqor9
         /SCjE3fQ1yflpUpi4ElLZD65nvNq/GCX0940W2Pivv8VzF/gUN/42Fb1VGEMM1ukfry+
         bFF+pAHX/BY3GhaCIA1hGCTDp695GGDRZrvaf/UuDUynT9X3ZhPZGPo+tHbZeG43ruKF
         tWEUL0BDmowhD35mPAocFzxKkZn6h7rztaIhrGZeDfsKhZswf9VTDnAc0+FRP4CMXUHi
         yDvA==
X-Gm-Message-State: ACrzQf38EL7xgAPrwXbiEs+Jo7v/zdKHft2h2KtaOLPKdkgJzrmZwTTD
        RMoxroHwPWGbUexw2SuATqU=
X-Google-Smtp-Source: AMsMyM4Nv+0m8bYMqzbLGds5n2zHneZr8/7WguTYFwvf8/0ldTHVdVXBDWN9aEgdh+A0B3cGmcx6QQ==
X-Received: by 2002:ac8:5b4d:0:b0:3a4:f759:5ac9 with SMTP id n13-20020ac85b4d000000b003a4f7595ac9mr6278306qtw.454.1666925439446;
        Thu, 27 Oct 2022 19:50:39 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id bs15-20020a05620a470f00b006ec09d7d357sm2143569qkb.47.2022.10.27.19.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 19:50:38 -0700 (PDT)
Message-ID: <880ede37-773e-c2bd-8a69-6e3d202983d9@gmail.com>
Date:   Thu, 27 Oct 2022 19:50:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY
 down events
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, michael.chan@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
References: <20221028012719.2702267-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221028012719.2702267-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/2022 6:27 PM, Jakub Kicinski wrote:
> The previous attempt to augment carrier_down (see Link)
> was not met with much enthusiasm so let's do the simple
> thing of exposing what some devices already maintain.
> Add a common ethtool statistic for link going down.
> Currently users have to maintain per-driver mapping
> to extract the right stat from the vendor-specific ethtool -S
> stats. carrier_down does not fit the bill because it counts
> a lot of software related false positives.
> 
> Add the statistic to the extended link state API to steer
> vendors towards implementing all of it.
> 
> Implement for bnxt and all Linux-controlled PHYs. mlx5 and (possibly)
> enic also have a counter for this but I leave the implementation
> to their maintainers.
> 
> Link: https://lore.kernel.org/r/20220520004500.2250674-1-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
[snip]

Looks good just one nit/comment, feel free to respin or add:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> @@ -723,6 +724,8 @@ struct phy_device {
>   
>   	int pma_extable;
>   
> +	unsigned int link_down_events;

Should not this be an u64 to match what the extended link state can 
report? Not that I would hope that anyone had a chance to witness 4 
billion link down events using PHYLIB.
-- 
Florian
