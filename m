Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E814580574
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiGYUXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiGYUXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:23:32 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FA821836
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:23:30 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id w15so11717068lft.11
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JLb9CbSpiNdOgJDUAuv2Zt5Yd8g+aFxtzAStsVxZY9k=;
        b=mFmAzSBoYF+o76gSz6AaLS9j6o3aTDGO0uJAEnOGo/75ymCn+VDu+ksvxWf6td27PB
         +j7U5ZFaYSWp/xfnASdl1MjX9vOTzxTlgYJULgIhyIorJcdzmWhaAWBwgRlyKxGG8QlZ
         y4CPAInsj5oJOdGAQRobvY7itZ36NhGxz4hVLBv8PDNGcjOynJL4RUsWM5XWSM2c/s/w
         wVPPLtMhZDLlIbdtwOBtac/dVCYlL0WxbBfozkCwFV7NWGFOeHl1CslUmg9gaqJRolig
         YzkGqT1i5rON0+HH7nabg9QitJ3Lde731NCNPFJWuN7Tko3tbMLSe6o8oGYwYbgKEsR2
         IGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JLb9CbSpiNdOgJDUAuv2Zt5Yd8g+aFxtzAStsVxZY9k=;
        b=10VH8rFhsR0900q+xxXJspPszALAG5hJ10y9ICzFucSPQbhNnQ22uyT/u0uMMv0kfR
         ESnKv4KjWMtlvPomyFrMd8QsUcR3F1FSfLupvhOynoHsN/ieBuko0ThoNC5PUxkTG2g0
         peTbyP3XPaZELqhSGoQtsdCfmCA8dQdGa3Rqsb6qnO+kpwdSlY3BD2MWUO0o/ucgzPIO
         fA5aAX/dvzgMKGHLbTjJyHVnV/ob09KHmu++8N1g1X3Ttxe4j/zIYLZ8DWf1zQNh9q3C
         K7qF/eJnFMd7xEXdP7p1cJYPn4q2S36UH44aReQEaxd3dMEvA17V1lzK+DArsTUmEnD4
         KRqQ==
X-Gm-Message-State: AJIora9l3BQsU0ZUMln4qIFmywT0M+JRgQvFwzN1k6Fj9usVsUhAFjZ1
        OoS6yioQ+1pd/Zh/2ysuMKUEbw==
X-Google-Smtp-Source: AGRyM1sCiSDLLOOuitAkFwBg8EoKLh7+ATInvPdRsltkb5V4wOYSIncUG4AfvJlfN0I8hi8WFfhXAw==
X-Received: by 2002:ac2:4141:0:b0:48a:e59:dd9f with SMTP id c1-20020ac24141000000b0048a0e59dd9fmr5672063lfi.478.1658780609185;
        Mon, 25 Jul 2022 13:23:29 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id 4-20020ac25f44000000b0048a87fbe245sm975755lfz.258.2022.07.25.13.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 13:23:28 -0700 (PDT)
Message-ID: <80707e86-9ac6-3f6b-1271-931d4036e3ba@linaro.org>
Date:   Mon, 25 Jul 2022 22:23:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next v2 3/3] dt-bindings: net: adin1110: Add docs
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     alexandru.tachici@analog.com, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gerhard@engleder-embedded.com, geert+renesas@glider.be,
        joel@jms.id.au, stefan.wahren@i2se.com, wellslutw@gmail.com,
        geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
 <20220725165312.59471-4-alexandru.tachici@analog.com>
 <a7d0f6c7-1943-8bef-71ff-736455609cde@linaro.org> <Yt70avEl443NkbJq@lunn.ch>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Yt70avEl443NkbJq@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2022 21:52, Andrew Lunn wrote:
>> You had phy nodes here, but they were not replaced with the phy-handle.
>> No ethernet-ports or mdios with phy?
> 
> Since this is integrated silicon, much of that is not required. There
> is a fixed relationship between the MAC and the PHY, so phy-handle is
> pointless. There is no need to describe the MDIO bus, because nothing
> can change.  phy-mode is pointless, since it can only be internal.
> 
> ethernet-ports might be useful, if you want to use two different MAC
> addresses. However, with Ethernet switches, you generally use the same
> MAC address on all ports.
> 
> So i don't see a need for any of these properties.

Thanks for clarification, appreciated!


Best regards,
Krzysztof
