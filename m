Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851BD63B37A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiK1UlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiK1UlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:41:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464B6CD9;
        Mon, 28 Nov 2022 12:41:19 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so13250289pjt.0;
        Mon, 28 Nov 2022 12:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4x2cz+pUzL04s2YSBAxT7mnqCl4qRr39+TaQ3gkx5oI=;
        b=iidy2FUOryjm0jjaNj2NymgdPB5HRgqMNmCGJQLaotAJ3yjn1YbQFvvXO0RizYfjTQ
         3ItqJt2G/ptOW3oQ2OsVdEB765CmmChan0XipIbiPtXEPeWsxjyVToTzhJ3zXcTdZa7M
         xQHPzbzXcXkYNG9b+NgcFHVXgxRrvEpiw30VtTUb5B3/hMyOgHzmHWETeLZEy4HMKb8P
         woIfEeWzLmxRo9ElND+n11UPs2P1yd+da9VnCTaiiP/BckvrSegV/plN9W1Dys0WikLP
         JYNldVYC3SP3csLffBukhjbHOOUqnu3ENvxYYBAoUJOX42XVf019M+S4VVklLYRGwNbk
         PbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4x2cz+pUzL04s2YSBAxT7mnqCl4qRr39+TaQ3gkx5oI=;
        b=f0e782mzsOQeHxj0LRqBGV4IX6tFV3cX2qcNS/FTu9tRC1b9E5RSu2mTdixMYoK4A4
         TluqDz6Xlc4wOmVuRV2FiebjnJTUdjCXN5tSASxnS3agHU7TSBs36ho5gyCiH6Gz/PYQ
         37/jAK4ye5bgHeRHHiNhTPL4zFLm0/+7xI9fPzCNnL3ml4W6XE2+1dv99wx7AS9E6bO1
         csHNpqe3bh/LnP/h7gr94tVuwcjL3SeeEwtRfoUWHkJ/weZq9bnP3F/GLTQgIN759Iee
         yJCZZPnTggR8wSA9Sl4dVxqjU9H5tY94iOGSpa5e3Baaf+zF53oWP+wavmXjbwqVCfT0
         2D5w==
X-Gm-Message-State: ANoB5plmE4L8E3UZgharroAuhArvtAl5TjN1/MxrxQcsESwiNdVj47V8
        F0jxEbfBMRljpdcwadAid5s=
X-Google-Smtp-Source: AA0mqf6ssz6JOkao1UdO0ZcUpDH1YQsSUV4r2p30DFnhEHqRbNvtup+TOhbAedXIcdbTRibkC7VCtQ==
X-Received: by 2002:a17:903:22c4:b0:171:5092:4d12 with SMTP id y4-20020a17090322c400b0017150924d12mr34420239plg.107.1669668078666;
        Mon, 28 Nov 2022 12:41:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170903234500b001885041d7b8sm2435267plh.293.2022.11.28.12.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:41:18 -0800 (PST)
Message-ID: <a25a1d87-2fb8-6ddc-f208-27db3db0e4e6@gmail.com>
Date:   Mon, 28 Nov 2022 12:41:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 02/10] dt-bindings: net: dsa: qca8k: remove
 address-cells and size-cells from switch node
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-3-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-3-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/22 14:47, Colin Foster wrote:
> The children of the switch node don't have a unit address, and therefore
> should not need the #address-cells or #size-cells entries. Fix the example
> schemas accordingly.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

