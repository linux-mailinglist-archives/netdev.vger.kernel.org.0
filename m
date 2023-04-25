Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159B96EDF10
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjDYJU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjDYJU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:20:57 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAF64EF3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:20:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50685f1b6e0so10108709a12.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682414449; x=1685006449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WsdCNQzIoPz+lH63xj1YaKKNKo3iDm5pfw23qiYoBOQ=;
        b=wOvkX2oC5ZHyFMdylx8IkrryNZeg23DU/Ch9AChLKbcB/sx0DFV8Yb/H7vUSsHm/ay
         6vKeAhZHqi4KvKzBL9RsojhjUK4oU8lb+V+mupjRsr3d4Ozv9ezhvySx+DHEhqR+hjMA
         gaiJOqLYT51c8eBo6o+cG8x82KOH/6WDLxVffZqZup0JrvMaRV4XDFiPQxHmTy81GMpM
         QIfjcv/pPcyMi1TiLUVU+h31xU2FfOzqmTSR6PnZ45uP7vvaFC3j0EA3bBbvXBOdzaR3
         fHRbyuMSy1Dp046zUXSSm/0Gjosdxp/aEC/NPYM4X7lNjpFDITb7o57bkR9W209v9XtR
         w4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682414449; x=1685006449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsdCNQzIoPz+lH63xj1YaKKNKo3iDm5pfw23qiYoBOQ=;
        b=EsJq/ZEx7RoZ9KltjJnTeNs5UAls9Ce1F30+CeLTMWodo102jKngModC9GKUueUnZz
         xrPaUyrDLAgyMyO/DMpZomCic2Qa6luQtw5etlM5Cv1wJT+KXlz6TOhlUJrWIpfZBev/
         z+PMH65xOUGkUOI3kqhEMjXlNk68Ct13eQrtBM/A8x5h107my1uix/GOrNYPFW9Jnyz5
         X/E5P9ZMncJbuP28sbQlHbS0SOC7KU8dTuhT4buBiqguCHBu8w+HCfq+SxBW7hdYwT9l
         NAj2FfmbdU57J9qLl6/oKFbc7TMt6tlxQzqfh6/Xrm1+1ku4x94KJobFpWfVf2xt4gtW
         WRZA==
X-Gm-Message-State: AAQBX9eWnXXbutikkUfYKlvNY8idqxHEvZU2ebB3C+WpyflcyuP6ji34
        fTGVDMkaRrp7CHsV4qP4emmJfg==
X-Google-Smtp-Source: AKy350YuXymrw7So4UOjZjef+iEPyi/CshywTQ5AjTJZJr/4WaSMcccmVMSSXrgcRBO0CsBCTlwDVg==
X-Received: by 2002:a17:907:b9d9:b0:94f:1a23:2f1c with SMTP id xa25-20020a170907b9d900b0094f1a232f1cmr14815686ejc.50.1682414449568;
        Tue, 25 Apr 2023 02:20:49 -0700 (PDT)
Received: from [192.168.9.102] ([195.167.132.10])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906828b00b0094f23480619sm6620286ejx.172.2023.04.25.02.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 02:20:48 -0700 (PDT)
Message-ID: <0210316b-9e21-347c-ed15-ce8200aeeb94@linaro.org>
Date:   Tue, 25 Apr 2023 11:20:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 00/43] ep93xx device tree conversion
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Nikita Shubin <nikita.shubin@maquefel.me>,
        Arnd Bergmann <arnd@kernel.org>,
        Linus Walleij <linusw@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Jonathan_Neusch=c3=a4fer?= <j.neuschaefer@gmx.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Brian Norris <briannorris@chromium.org>,
        Chuanhong Guo <gch981213@gmail.com>,
        "Conor.Dooley" <conor.dooley@microchip.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jean Delvare <jdelvare@suse.de>, Joel Stanley <joel@jms.id.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Liang Yang <liang.yang@amlogic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lukasz Majewski <lukma@denx.de>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Qin Jian <qinjian@cqplus1.com>,
        Richard Weinberger <richard@nod.at>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Stephen Boyd <sboyd@kernel.org>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Peter <sven@svenpeter.dev>, Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Walker Chen <walker.chen@starfivetech.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Yinbo Zhu <zhuyinbo@loongson.cn>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        soc@kernel.org
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
 <8101c53e-e682-4dc3-95cc-a332b1822b8b@app.fastmail.com>
 <20230424152933.48b2ede1@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230424152933.48b2ede1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2023 00:29, Jakub Kicinski wrote:
> On Mon, 24 Apr 2023 13:31:25 +0200 Arnd Bergmann wrote:
>> Thanks a lot for your continued work. I can't merge any of this at
>> the moment since the upstream merge window just opened, but I'm
>> happy to take this all through the soc tree for 6.5, provided we
>> get the sufficient Acks from the subsystem maintainers. Merging
>> it through each individual tree would take a lot longer, so I
>> hope we can avoid that.
> 
> Is there a dependency between the patches?

I didn't get entire patchset and cover letter does not mention
dependencies, but usually there shouldn't be such. Maybe for the next
versions this should be split per subsystem?

Best regards,
Krzysztof

