Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAAC63B396
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiK1Unr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiK1Uno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:43:44 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D0619C22;
        Mon, 28 Nov 2022 12:43:43 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so15226684pjc.3;
        Mon, 28 Nov 2022 12:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vEnIqnlBXltqKqAFyMwZ9D4cXMhUwtre5BGpsyfjDZA=;
        b=ZecIg/2kg1a7dhSGJa3syxbA71E6/awO/n4mN5KEYHdMCgGBR3F/7DVIBBt+9ohuTv
         Ui3/kRi4qLRLuUqLF5xixECLUoHhuxsxM3qV3KwmxIkLqhiDCCWkNTaihd3eYlEr7grp
         +mX1r6/mR/q6/tK0ZDirWff46qujHs8ixoMMmjVD2ob8zk5nAE6qrcoUB8WOkC9umd9+
         7aZLoHNsEivy5y5xjMajj2xiq2tx5gu8qhe+4RKTzEjxH2ftSRvQKj5kZo0+glBdR27p
         mL4u5238LGBZB7HRpmMjzlgjiVk2/dj2Mhs08MD83LAW9hDUhjivBHgN8lakvYMdGyNQ
         DyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEnIqnlBXltqKqAFyMwZ9D4cXMhUwtre5BGpsyfjDZA=;
        b=rLGBqyMpfNm9IiwjmlXsLqjuf+vG2mx6Hre9juQ1YgRvWImL5/PL2gEAjhR8cppr9c
         4zqdYfXWMRQsMDo0WJrc6KZU12tYEcrmlBBryZR8ku7OGzgq7VBA+N+MX+IJPyyRRgKZ
         iRTnnZI9tdhW+1EZ87gzYJxdZHA5kSD9uQ6bA1gQpjTCo8vXCiIUvCqoUbv5nWcbBoal
         JrULJiOIyE95/dGVycno+y9qdgh1YwtGsJZ8oNFI+f8qtxket90Elm0Fx4uwcwSy8uvA
         qF3I41K5e+3DRx4ETtkuy4em2vsrXCfi1LJkA0I1OIGvixxFvfFZYlBiKHPe9FZmyy48
         sU9A==
X-Gm-Message-State: ANoB5pmeiLHf2NZvX/jRpX11gxHaGhrUYtRWjKEmpwZajx9Y+eOk3+X9
        9Pz3N01bfY8h9XDDwIjhlDc=
X-Google-Smtp-Source: AA0mqf60NIuzlcRi+5sNXaNgA7LZBhrZzcytRRa7yn3AAljNCa2kyfI4J5oyEJbXUiEWGgzx5Yrzgw==
X-Received: by 2002:a17:902:74c3:b0:189:8001:b553 with SMTP id f3-20020a17090274c300b001898001b553mr10547033plt.59.1669668222500;
        Mon, 28 Nov 2022 12:43:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ix11-20020a170902f80b00b00186b758c9fasm9291820plb.33.2022.11.28.12.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:43:42 -0800 (PST)
Message-ID: <937638e5-02f0-38be-8a78-942296cf3e44@gmail.com>
Date:   Mon, 28 Nov 2022 12:43:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 07/10] dt-bindings: net: dsa: mediatek,mt7530:
 remove unnecessary dsa-port reference
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
 <20221127224734.885526-8-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-8-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
> dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
> the binding isn't necessary. Remove this unnecessary reference.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

