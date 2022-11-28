Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25FB63B381
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiK1UmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiK1Uly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:41:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C6C25D0;
        Mon, 28 Nov 2022 12:41:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so11295850pjj.4;
        Mon, 28 Nov 2022 12:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R2QDZwY4CCKZmNIQN3jmma88d1GFVM4ZLSSSQWOn36o=;
        b=Xy/8UNSRDI14S5r0lI5NHz5yMWMIJomnO930/oPO687du/EgM4z7agC56GWFp4O2qd
         894TaMTpkf7AIDl+6B5wbhBferQc3OIZE17EJmwuFtR4qwWMP3nHVgrQTKz28IJSZ0l4
         QFoYTH/uNeqfRC9SBaL6yeY3/pFrUs5ZWrKQbHH1QFc02LF+zzKLh5/i/9Z69TJtZxfN
         wUzRpH9wIHaTQ6NbNYWEkpLCoWyAA3Bp0G4Blp3p95lja+aRWblqWIHmKEXWfUrXXFKM
         Z17lk7nwvD40Ov3BUauew6xx8oYbb4SEsvyII0+w8v19OSAdQR/OqD2xMlgrSfeq4rmn
         l3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R2QDZwY4CCKZmNIQN3jmma88d1GFVM4ZLSSSQWOn36o=;
        b=7TK4iDM9SzTfdBbzUJX1RM5xzNAMLf35iUIt87FEeKKdH2n4rQ8mF7Oj8YvN47VHeD
         GXhO67MflUWaUPEc2uypzSgFcW6BdcQdSyM4f0h02dmfNEEXyd9ByGFUie/r2ffomRvW
         CGuqelscVYmxez+4Mb2xAt2eiezC9Av3fwS1RvksNVIxA1oMCxHOnpvTiDYcVj+OlCrB
         UWXAgexO7D3YEUo6ahrzUAZuffdoCBhMwdG5pZjGhoKdsXd8LzjmcWksptQVmBloH7cC
         KDRSo+TeEGs28OsiLMH7Yrl1UVmpz6NbkjLB/DrW18ckWFPzTAivvWaQ2C49XaerDyqL
         Vzhg==
X-Gm-Message-State: ANoB5pnEr4HtcSVUxKOvY356XSChyp1BrvDQkcGdEsqLw3rgTBS9LXZB
        WumToDOz/V8A9fb7LSq10u8=
X-Google-Smtp-Source: AA0mqf5T65D0cVowEV40u2H0G66KM/pmPVf8ZDlEgTcIAnihxpqbp3I/1QWdQBCby8PMC2lmxJK3Aw==
X-Received: by 2002:a17:902:7793:b0:189:24b3:c86 with SMTP id o19-20020a170902779300b0018924b30c86mr34062307pll.84.1669668113599;
        Mon, 28 Nov 2022 12:41:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w20-20020a17090a529400b00218b32f6a9esm8101579pjh.18.2022.11.28.12.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 12:41:53 -0800 (PST)
Message-ID: <1b36a516-6c67-3ae0-ed9d-34dc85df3ae9@gmail.com>
Date:   Mon, 28 Nov 2022 12:41:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
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
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221127224734.885526-4-colin.foster@in-advantage.com>
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
> DSA switches can fall into one of two categories: switches where all ports
> follow standard '(ethernet-)?port' properties, and switches that have
> additional properties for the ports.
> 
> The scenario where DSA ports are all standardized can be handled by
> swtiches with a reference to 'dsa.yaml#'.
> 
> The scenario where DSA ports require additional properties can reference
> the new '$dsa.yaml#/$defs/base'. This will allow switches to reference
> these base defitions of the DSA switch, but add additional properties under
> the port nodes.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

