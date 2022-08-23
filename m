Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8418659E4B7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbiHWNyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241972AbiHWNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:53:57 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144C321FA26
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:59:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e21so12668517edc.7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=tRYEKF+JKDUe+/4PWEAoIKSUJrQI9kSn3rwTj50a5SI=;
        b=IDvQiUDTFC9ng1VOeMeft4QD0fVE013eX0K61+0kW9iWz3RrjcL9jCHyEL8sz8Xdx1
         J01hMvc8yMKanFAuR2qOZbWLBmvFaNRuSEPzoL6qNUfCuQZfMXFrJlXHkn+4zkPUnXIK
         I4/VUXdVyxDHp5VTGswiy9yRgjzmd3CXEyH+CX/F7yUKrAKk8y92IFZhLRzoXYCGJpEB
         EieSmaRPNhS1brHHT+K+IWUr7AitagA6BJxTmnuwL9R1voPpwSJcZ6picYFHPuy/DWVZ
         CigslD767IEBjaDns0EJYUUvgErGiiSZb7ttvw+SEAbSgKDmoJ8K5+LsJWhYx/auRdBo
         qm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tRYEKF+JKDUe+/4PWEAoIKSUJrQI9kSn3rwTj50a5SI=;
        b=E2PKywzjxnb0JxFiRhdCdhsRlcUeHICx4XbJwlR8JpKAoLK0C6xUy87v+6KV7kbrKf
         hzqEO+gODBFdaWlNnEn8OvrW+hOhe/6VdtI63iCHA7dI/M6v5oCLSJZ8YPvzf+rVMSCK
         8nw/82VHHAooGuEJue2o1JSErB+4dd2P2ZCss0scVuvSjthM//+nArdrr9m/aDcotqHZ
         PFJBT1dmDHhBd+XJAYfK8RolXctnNU4iTJlGd1E5MEZ40GUqBJKNmDpebBHK4Q5IWGG9
         17iIBlWzhoRqL9rQY1prFmtdLBuP52pUDJqoYSZv1/EHmXeHwHHjEcejAZ+VtMSgUfmk
         kZGA==
X-Gm-Message-State: ACgBeo1xfI2fhrNQdU7fKBx2Qc/460xu3z75EczIRmfiWyF/dChpYnte
        BOiaVrPGj3QFMGItSvw5VZ7YempUUSHee50g
X-Google-Smtp-Source: AA6agR7ghepHiUVhQI6lvQs9qB/m0STf+QZAEU8jUCMP/jFawUcPMZeqMdrPF9kXmcLsoAQDZOhTXw==
X-Received: by 2002:a05:651c:1208:b0:261:cc0e:7555 with SMTP id i8-20020a05651c120800b00261cc0e7555mr3006288lja.198.1661251747077;
        Tue, 23 Aug 2022 03:49:07 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id f7-20020a05651c03c700b00261cc46f4a1sm1053004ljp.0.2022.08.23.03.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 03:49:06 -0700 (PDT)
Message-ID: <5d5cf5e4-543b-ecdb-6719-0e6ca3c05640@linaro.org>
Date:   Tue, 23 Aug 2022 13:49:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 6/6] dt-bindings: net: dsa: mediatek,mt7530: update
 binding description
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-7-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220820080758.9829-7-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2022 11:07, Arınç ÜNAL wrote:
> Update the description of the binding.
> 
> - Describe the switches, which SoCs they are in, or if they are standalone.
> - Explain the various ways of configuring MT7530's port 5.
> - Remove phy-mode = "rgmii-txid" from description. Same code path is
> followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
