Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C05A5FD7
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiH3Jvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH3Jvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:51:39 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FDEA99E6
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:51:38 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id y10so7614142ljq.0
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=OZx7CXPFdb10H0xu0NSPqWrYCSjPK24Uy/HfTWOH//4=;
        b=kC5A1mX+xDikgnDcr7JMJ7Xh9FA5m6m/stgKGiyrNn7X1h4MSJQr3CKRu3mcr0IVx6
         G8v6uEAhqkW/LNunRbgLqfwXKtS9F9O6f/It3ql33artcKjJATnx32DCvQy3CIoVkWOQ
         7Ej9rIdgH3JzgwL1zn8mrBUbk8710oRo/QNyzf0A4PLc1lmThYPckg8BHj9o38qkt5RK
         KDX58RY6Un0UvirfySmINKbNRGx5lgZxxbQIShWD4DR+KNO2Ug/sjbTq3vjEQHqp+I80
         ujHrLu5sZQduZIOTZL0GAgBpwttvFpPn6jt9WDH5eJTeCG+93pAGr6jofOp1IF1Etcxf
         0FBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OZx7CXPFdb10H0xu0NSPqWrYCSjPK24Uy/HfTWOH//4=;
        b=w3c1LzX5TPiXqiyReB0suNGdw8jYokx206McOq6pFhhIUswKakKepMr/7TtsF/+m8R
         ZvAsTEAtpTfyjOyRkzg/LPPHni0zwREdBBmneKM+pFUKBvhfWTbBYwLaIVeMcOjeojq9
         SZUoltIQ0BXQbOIlO1cz3nA1PI8/VQtU9tXKAwR45RWSWLcMSowyPARzLYuQd8k45gCK
         5TK1flR6O4C8A0pagejGgl5mAhL7VIr0T3bNpQlVo+HgbUH+n+QusUz96nlLNP3bu8X/
         07uur+C9wxOCY8bu6alm+1gbITgxAWgfbzF/VsAJIRRnGvV4OUzFeGNAs/j4QMA7daoj
         Dacw==
X-Gm-Message-State: ACgBeo24JApCPk3H+ZyyHASzgyXiiNErLAZF233ll1L1TnuA6j0sfbmE
        V+j6f8H+f8VOnng3SCPE5WVnMA==
X-Google-Smtp-Source: AA6agR5v85O5PIwaAIzwgZ0Qweg2MSL5uz1/BanFJtMm/TtLQSKoRfwm/67TG+/dKxbrv7SQ53m9aw==
X-Received: by 2002:a2e:8553:0:b0:265:d5df:e137 with SMTP id u19-20020a2e8553000000b00265d5dfe137mr2107520ljj.70.1661853096592;
        Tue, 30 Aug 2022 02:51:36 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id c28-20020ac244bc000000b00492ef1ee7b0sm1541791lfm.290.2022.08.30.02.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 02:51:36 -0700 (PDT)
Message-ID: <e4d6eba8-497f-adb2-6f34-35883b8ec50d@linaro.org>
Date:   Tue, 30 Aug 2022 12:51:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rv1126
 compatible string
Content-Language: en-US
To:     Anand Moon <anand@edgeble.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>
Cc:     Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220829065044.1736-1-anand@edgeble.ai>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220829065044.1736-1-anand@edgeble.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/08/2022 09:50, Anand Moon wrote:
> Add compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> ---
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> index 083623c8d718..346e248a6ba5 100644
> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> @@ -26,6 +26,7 @@ select:
>            - rockchip,rk3399-gmac
>            - rockchip,rk3568-gmac
>            - rockchip,rv1108-gmac
> +          - rockchip,rv1126-gmac

That's not a complete change. What about the other place listing
compatibles? Did you test the bindings on your DTS?

Best regards,
Krzysztof
