Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC228538D67
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245060AbiEaJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEaJGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:06:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97373369C9
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:06:15 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id er5so16608112edb.12
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=B2NZyh+cIzrC0yFlwkj26EY9e6xfk3X9ZOP0bB7w4RU=;
        b=evfYu89qrruMy5yGwmxBJhM8KXCVIu/OZBaUQPkSOXRQHIJSgPxnAPck4/CEMxA2xS
         9A7fxfcNylHRm04f+y4UMLYh/5/ugmpXz/dtkGEleESJNaRVi5nItdPU3zCXw6R/FyTk
         pEAm6gxRh8AHpjMqWy7kfyHE+70PbcPRhs25Ua0PkuS/i6eLr4f2Yr8nPe5tFyqo7g8k
         RFDYapRfPijF2lpkcIgRSma8knwy6R00DZgglmSmZVwx0/EoggbEtqt+ZvIHxilNQgjW
         jMhwJHDaFGIg960qPHjNUv7zjTAy5mCruh52XrxatfsES+i/H1XvXEfg8VsinY91pwT/
         FOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B2NZyh+cIzrC0yFlwkj26EY9e6xfk3X9ZOP0bB7w4RU=;
        b=fWst4ao+cqLVgu1DpFGlroAhfemPH+gFg7hVneLUk5Fb2cyGiGYXv48oabJ7/smOl7
         5QubQeapnJo0jU2BtZDDlgNcAJaQ8pDFggrXydU/i1tp0eRMngjMH5Q8GE+TcttIxlmS
         GtPFVIEnXffvxBuAAcOgXX7q5ARq6Xpt0MajnjzMgnZYK6vgG0scCEnajcGjVPbLHmER
         Fs5TRnDgTKAZWAXvJ0MlOjvVkbi/3hHXEMNlVNw2MiJOd+uael4xCCssMeA+4y3lh2+D
         t4EGBgOH69//H2nVPau9uRkh03dQEPEmj04tdQiAReBT97h39XLkt4SJRfVF++ZY6/Nl
         zDrQ==
X-Gm-Message-State: AOAM531s45qid7Y+Mz5FdzFdUuyo/nzlFj4ZtSh7ZfKvIyRKTqT1fKxk
        rWGdhOr0yplbst0z5s9OzqqiwQ==
X-Google-Smtp-Source: ABdhPJzfU8m5rdIdp7q9S5qXsHiz9hvCjAboBg4T85QPihizQhore6X/2gC1ZgEh7FJCE7skEc8wyA==
X-Received: by 2002:a05:6402:d0e:b0:413:3d99:f2d6 with SMTP id eb14-20020a0564020d0e00b004133d99f2d6mr63612187edb.189.1653987974122;
        Tue, 31 May 2022 02:06:14 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id fi5-20020a1709073ac500b006fed93bf71fsm4808930ejc.18.2022.05.31.02.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:06:13 -0700 (PDT)
Message-ID: <ae36420f-847b-c53b-24ad-22e3181bff51@linaro.org>
Date:   Tue, 31 May 2022 11:06:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] net/ncsi: use proper "mellanox" DT vendor prefix
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220529111017.181766-1-krzysztof.kozlowski@linaro.org>
 <48cb78ebd38dfe4ac05e337d5fb38623b7ee0e8f.camel@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <48cb78ebd38dfe4ac05e337d5fb38623b7ee0e8f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2022 10:21, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2022-05-29 at 13:10 +0200, Krzysztof Kozlowski wrote:
>> "mlx" Devicetree vendor prefix is not documented and instead "mellanox"
>> should be used.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
>>  net/ncsi/ncsi-manage.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
>> index 78814417d753..80713febfac6 100644
>> --- a/net/ncsi/ncsi-manage.c
>> +++ b/net/ncsi/ncsi-manage.c
>> @@ -1803,7 +1803,8 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
>>  	pdev = to_platform_device(dev->dev.parent);
>>  	if (pdev) {
>>  		np = pdev->dev.of_node;
>> -		if (np && of_get_property(np, "mlx,multi-host", NULL))
>> +		if (np && (of_get_property(np, "mellanox,multi-host", NULL) ||
>> +			   of_get_property(np, "mlx,multi-host", NULL)))
>>  			ndp->mlx_multi_host = true;
>>  	}
>>
> 
> I can't guess which tree are you targeting, devicetree? net-next? could
> you please specify?

Both independently. The patch here for net-next (although it is closed
now). The DTS patch can come later via ARM SoC maintainer tree.


Best regards,
Krzysztof
