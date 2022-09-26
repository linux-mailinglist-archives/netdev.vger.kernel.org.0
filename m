Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E819D5E9D8F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiIZJ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiIZJ0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:26:33 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CD30541
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:25:14 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o2so9819803lfc.10
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=uaiDp3kvgnG0ypPaVSIUeFXmDz7x/JwiryUmZAc4dU0=;
        b=PyO4KmrNHFYEQ2ZSdZDB9CJMxLJPpUpBGMGKh9bgd9hRACeXmb9UggP1Ckt0tYZz9/
         uCV0ecW3jGWwuoWqrExby2NFlaUorzLvbzRUfup6GCd57qnaK43AI/qIIp+Ia2F32yzb
         eML2C9ZIpA5DUZ2ertJVHvfrfQO+2TN9FmLJyTkdSLS0GdQxsjTXwAqh1tpb8UZLdzW3
         bFlbnuauudKC8IZGW6d/n8mpCLavtYa/XbXfkOBkSi5RFjOiazQvPQ5OOToaWb/Pew35
         AM6foqUUGXko3iGqd5K0xt2gDPcxx3nb0ctV252Wj+GkrB0Ai2GP7+mPLgQsE4ekG1we
         /fDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uaiDp3kvgnG0ypPaVSIUeFXmDz7x/JwiryUmZAc4dU0=;
        b=kqE0alVQNSm2S5e13lVGldeKylFao7WRk439SmWBDWQQV8x3DtwhOjJbid6E1snVus
         o5ljDytRg1H5LDSpQjt4zuLQaphb5BM1roULqlS51PDbwjHROfJfm45RmQ4lqHW0X1Zn
         ZAOlbKJPIpNVpsGRtLgilyxWHwLQc9axjJJ4RN9pTppHKtAtHjh1NN2SiO9Uxtlqh+od
         zWsTkRdr7rGelGQPcWU991sd20jwxnlSx++U4xFW8f5VFU7SVD9eeH6NHo/+8q1Zcw0l
         PMLTtWMTl5Qy1xTvMm19BgdI0AhIAHqaHy1hBq/ed5IdwkaCu5/yRw/lPrYUmT4zN4Cu
         boyA==
X-Gm-Message-State: ACrzQf03JU2IDn9owtnvoNxEa7F4h2B3clvizxaREy6PmS2jINfkd2n9
        FicTyw7xcC7lXd3A5KUngHB7YQ==
X-Google-Smtp-Source: AMsMyM4+r8FKGhQFjLKSZbEOMsnV8nGHobCDs01XOaZyixiXEKtNbP3l8DQcAeEF5kNVLcEbUGz+2g==
X-Received: by 2002:a05:6512:3409:b0:499:faa6:edb0 with SMTP id i9-20020a056512340900b00499faa6edb0mr7944823lfr.682.1664184305962;
        Mon, 26 Sep 2022 02:25:05 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id be25-20020a05651c171900b0025fdf1af42asm2308859ljb.78.2022.09.26.02.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 02:25:05 -0700 (PDT)
Message-ID: <7dbdb43a-0ffe-58db-5f8a-f3bd62a4feea@linaro.org>
Date:   Mon, 26 Sep 2022 11:25:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
 <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <d31dc406-3ef2-0625-8f5e-ff6731457427@linaro.org>
 <TYBPR01MB5341B5F49362BCCF3C168D11D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <TYBPR01MB5341B5F49362BCCF3C168D11D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2022 11:14, Yoshihiro Shimoda wrote:

>>
>> Don't drop, but instead put it before "properties" for this nested object.
> 
> Oh, I got it. Thanks!
> I'll put this before "properties:" like below:
> -----
>   ethernet-ports:
>     type: object
> 

Without blank line here.

>     additionalProperties: false
>>     properties:

This is ok.

>       '#address-cells':
>         description: Port number of ETHA (TSNA).
>         const: 1
> 
>       '#size-cells':
>         const: 0
> -----

Best regards,
Krzysztof

