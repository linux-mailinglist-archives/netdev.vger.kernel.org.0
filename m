Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA93C51B76C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbiEEFXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243354AbiEEFXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:23:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96F325289;
        Wed,  4 May 2022 22:19:44 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id p4so3949459edx.0;
        Wed, 04 May 2022 22:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=gDZB9prqVEcRFYfiG16SNiYfWZ6Q9f/8/MXT90OAgZ8=;
        b=bv9KrtI3RA77JCJVR2qt7R5lnHFDu+Xe8/ZzP7+c46p0aPbKfRKCzlskn2fYlLXDTD
         EZEcFYBV2bGdscBMqAydn1lpdTN8CYEqXQrQfaZRsUWFoln5WbmJnN+ke+2Kzbm4jmIg
         8TeRZS/kGxau2ZNysPi+30BdSdKVccx0KK75D210v3SD3kiAhMtSzjj1wNrfKaF2fno7
         Y807dkWXxhGp3Fy5mXM1ml1AHdyfvuf/kSaS+udKJOJnXw27hYkx0pbgBkOoqJRwqQc8
         Ekjl1Tq1wh71koCvu6S4JVDh6+p0xStScb32bz87plJt77nAYhOta8hFw1HcVUNiOSdQ
         vSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gDZB9prqVEcRFYfiG16SNiYfWZ6Q9f/8/MXT90OAgZ8=;
        b=iemVji4ORRHELATagIAqSDeBnCc/TrP76xZmtXzO2sBc8yh7tvBj9+ZqHdUsmeznap
         YNYZp9PqrGDl9QGs9FOyL/CThovkfTlcCN2TsbTYn+rcfvgIHGjjTH3cyuoZuLpN7A2F
         HpnIITTO1VnVGQd/hRAcNWqAUzCF30Fi1hvU6AJi1cvHzGBriEnAQ30u+8e2TGX7Ndy2
         m3ADvcUqlpAnsJiJHgZp0NhxzfU6pJJlOmSa3rWh/VM7a3DOSnGLUgLB0JG13vgc1Ctf
         BzISUKTV5d1ojMUHjMSOcm+qd7Wo7Y5JB2N50V3fdfgX6fReGJWQL3U6gkmWsLRkDSIH
         ricw==
X-Gm-Message-State: AOAM5306nC5Y2rkfxeOSE5Fe/reDehjSpoJ/OwFE82IzPVtSKG8zkoVt
        YxyxgoVw8ghunz9caAIJkDI=
X-Google-Smtp-Source: ABdhPJwLXgyXMU8n4ziKV1g4zpamdPhfaEMCo/cW+4nZdSp3Auy4zRSa6TJUEDujyzGieTQSjs+oLw==
X-Received: by 2002:a05:6402:2692:b0:427:ddba:d811 with SMTP id w18-20020a056402269200b00427ddbad811mr14604494edd.343.1651727983284;
        Wed, 04 May 2022 22:19:43 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id v16-20020a17090690d000b006f3ef214da8sm343529ejw.14.2022.05.04.22.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 22:19:42 -0700 (PDT)
Message-ID: <235aa025-7c12-f7e1-d788-9a2ef97f664f@gmail.com>
Date:   Thu, 5 May 2022 07:19:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 1/4] dt-bindings: net: add bitfield defines for Ethernet
 speeds
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org
References: <20220503153613.15320-1-zajec5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20220503153613.15320-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3.05.2022 17:36, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows specifying multiple Ethernet speeds in a single DT uint32
> value.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Ansuel please check if my patchset conflicts in any way with your work.

Andrew suggested to combine both but right now I don't see it as
necessary.

I'd still appreciate your review of my work. Such binding may be
required for some hardware controlled LEDs setup too I guess.
