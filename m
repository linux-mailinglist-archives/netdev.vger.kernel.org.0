Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4243692564
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjBJSeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBJSeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:34:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BAF677B3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:34:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j23so5973717wra.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itUHF+gJAOR68gNrNXTOhv2YTwp1LN4BGzGEfAiI2PA=;
        b=OaHJvANNeMAGzvf2uYI2xzLCi6qVzIoIMRJNUMUHlzvdQB4946tyfjwuc64G0AuREt
         YuNu/sR7FoiaVytT1wVaU5lS9eCpEu+2qZzqFTXe8g0PKYQ8cn7vuhmv1w2DLp6+rjPA
         VwOA/5nkkyxSNWkLJwLwBdi4zTMzi2yWNOmuPS3e0bp1oXuv0KGwifRBRdkJDANIcHba
         R3SJAVIxCBohLDCUmxIZjPJ21/NShmd2frAAkS2VIIGuJGHBcjEwfjIq9x3inxKTiZ9g
         VG+SmLQxhW1N+uckd3zByXCY+rK10AxGZ+y40dNt15bf8dXcveDzkzi962Xg7HQX+XtT
         EisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itUHF+gJAOR68gNrNXTOhv2YTwp1LN4BGzGEfAiI2PA=;
        b=1xc2mglE61zhqQty++/roZJdvH+844wrsIc0OsBl4lowELAP09VcGfaCMdkuT65vYI
         gVEuXkzcbCfVAyVXoSAc73HLvGJSW3lfdCtxCBPNyREHxw9D9ac0bE6I70REP8erivfx
         OBg1Xh2Nw3zbAh2vqC/KD1qFBvcM/c94M9HpZseIcHgL5SQY3Frt+pSaIfjO6a6sYpb4
         4Rgf3UJ0keyczTQfEMew+NBNBP4v6+4KepLHNYLfTuL/qPiKGTiXVcyDpcINf7i7XGEa
         q5wvy06GfVcIRNLyZJFKhy5NozS2w+Tjy2jlrHPOcAxxZ4xkgHI6cLhWLqRjia1IpoHz
         Q3IQ==
X-Gm-Message-State: AO0yUKWXQ2DoxDiB8Jn98jkWXkWUvKre3eqJSEQMgYlUKcJ6+vb5A68s
        NgDVfLSVrAQgZP1zkzcB8tbZgg==
X-Google-Smtp-Source: AK7set+sfAI5v+pm+Ta+c+I585wZnYR7ZKSMkHtr+epDPjtPngGn8hHOvj4Pt1bfuGTly/qfkXFNSg==
X-Received: by 2002:adf:f80c:0:b0:2c3:cdcd:f0b3 with SMTP id s12-20020adff80c000000b002c3cdcdf0b3mr13276955wrp.9.1676054045329;
        Fri, 10 Feb 2023 10:34:05 -0800 (PST)
Received: from [192.168.10.46] (146725694.box.freepro.com. [130.180.211.218])
        by smtp.googlemail.com with ESMTPSA id i12-20020a5d438c000000b002c512f56859sm4135084wrq.70.2023.02.10.10.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 10:34:04 -0800 (PST)
Message-ID: <8f557084-e185-6bf5-ab2b-4e1ebf4fc516@linaro.org>
Date:   Fri, 10 Feb 2023 19:34:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 06/11] thermal/drivers/st: remove syscfg based driver
Content-Language: en-US
To:     Alain Volmat <avolmat@me.com>, Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20230209091659.1409-1-avolmat@me.com>
 <20230209091659.1409-7-avolmat@me.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20230209091659.1409-7-avolmat@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2023 10:16, Alain Volmat wrote:
> The syscfg based thermal driver is only supporting STiH415
> STiH416 and STiD127 platforms which are all no more supported.
> We can thus safely remove this driver since the remaining STi
> platform STiH407/STiH410 and STiH418 are all using the memmap
> based thermal driver.
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> ---

Applied, thanks

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

