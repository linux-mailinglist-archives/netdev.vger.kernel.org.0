Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76C571721
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiGLKUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiGLKUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:20:21 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A3ACF6C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:20:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id d12so13131540lfq.12
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=t7/ucNQCCiiuq1lYv5Z+Jjy2njk0BrGXCMsPnOpnEsI=;
        b=DGmPDi3ayHIU8BQ7IKVXKYteM5mjUPkbfi3lzehrtWp40ZH3GqyPK2XuKA1PruIoNs
         nJhKS/HMmhjC0IbCvtF3Jemw5wNHSXMHBcp9i5MQ0AAAvtf//7XrH7IFs7vuHLl7MKJY
         b44FO3qRt1Z6G4dQrM2Vra0pFn2A8Q7wW6N8pRbgTtUWsR5lH+aMTVRJKuUfFiprAsNJ
         7yy8MTKKobNOlGDwKOb6zIhEpRrqiicsQUCZ6J1DyKc3F+dJpplcA3mZXK+boL0/ih8V
         NGudIRcHBtsgOFGy4xoUQMQFzdcAdugd8jC3/0Etzh7p/U++LL1bmJWjan0g/NSVLbI2
         NBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t7/ucNQCCiiuq1lYv5Z+Jjy2njk0BrGXCMsPnOpnEsI=;
        b=2V2ZIYR6rh6QyNPhN5zHXvdQnZMQv4ypd+ClKs+n+NOp9V9szEvoyH9O0RBMPdO092
         ewJsWDjUZi8B6BO7HJYiuX3+HRp9FM/MFShDuQKLvOph36qRvFK4y+lW0FM80E7zSL99
         IL26fCu6bP+4UMKLAWjjBcXPs5c9L0uWVs7/ZJ96beV4bNRl6DQeOAC0mVNczS9DCTBW
         /ESiVBcExZASPgjWLhY1Gk18sU2+UOHBalzCS4q7QWP56nC3C6mnSo9ON3nNLeXoliSb
         lNJw9eW+dwA/zFX9+whMjyI9jqyVegRupyjedNM7oZUEhNGXajk1RRJVN4APW5HU4EuY
         cgtA==
X-Gm-Message-State: AJIora+1YVTvnKmgWNtzSHpmkVGzRvGgekJex9g1AFCX/N268KIHHsLw
        OYjuKyYfEH5V6vaLu2fzk+C6ZQ==
X-Google-Smtp-Source: AGRyM1tM3Xyno5SjCdck0sIgXGeRuglfN7S9zBkB+eG2ozjVAtqbU+rY+0T3cPyD1quc3uFKvvhBMA==
X-Received: by 2002:a05:6512:280d:b0:489:d766:5e3 with SMTP id cf13-20020a056512280d00b00489d76605e3mr7973832lfb.499.1657621217465;
        Tue, 12 Jul 2022 03:20:17 -0700 (PDT)
Received: from [10.0.0.8] (fwa5da9-171.bb.online.no. [88.93.169.171])
        by smtp.gmail.com with ESMTPSA id v1-20020a05651203a100b0047f7419de4asm2098315lfp.180.2022.07.12.03.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 03:20:17 -0700 (PDT)
Message-ID: <9f9acf66-a9a0-c055-2113-ba40dbfbae69@linaro.org>
Date:   Tue, 12 Jul 2022 12:20:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-3-biju.das.jz@bp.renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220710115248.190280-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2022 13:52, Biju Das wrote:
> Add CAN binding documentation for Renesas RZ/N1 SoC.
> 
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback (HW doesn't see tx messages on rx), so introduced a new
> compatible 'renesas,rzn1-sja1000' to handle these differences.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
