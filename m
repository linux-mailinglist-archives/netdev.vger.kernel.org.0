Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D267259107A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbiHLMEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237228AbiHLMEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:04:48 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0089499242
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 05:04:46 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z25so1079803lfr.2
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 05:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=6Kp8Yta0WaKZAcq5lDGwXYhuy7Bp52cXQEeMVR/1+WI=;
        b=e0NTS05OhsARZawCS+Q9V5QJklC7TFmJvLAbC9/1Rjz6b9TNijx7oX6q1vyROu9TGa
         L0GarXzM939iDPY+j88jTWrXvpr9+jisqiOo01vBWL1rq457Qd3WlrD8H1S4k/iyc/KW
         8m6xzKOXbjIKqyrTLY8QI+2M8TRkN0S3NV+UvwHCa5I1GSdFXUD6MMrkpWz65uVrwObF
         PA3IZWAZB1iE5H7/JTu5WF383hEt5cRcvSZhQ8ip1G17tF0MhvQBe4pXSF7jqPU2bbaT
         EydDQkwel042igDTE9+/sVIgg700h2ooG4BGxWR50lm/Q3fqPMW0/zKODvwTJB4/cqXZ
         m9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=6Kp8Yta0WaKZAcq5lDGwXYhuy7Bp52cXQEeMVR/1+WI=;
        b=0+EH2PYSJhQI2OeSmAD21n+M0se7buGMGK19iLC47NcRxxzPbx49Vl1NAcGN2bwOmH
         1yM36fc1IfC99GO6ACEQQUt/r+JXwwA+P+DA+sj++W9h1oL3FQ74PT3sDUVDmQaUUPiE
         pLL1XBI7W6bYesQCDJP4PDysagnywAEOk+g2a1eaz1vldW3YKivJxxtec4/gHe01E708
         5ZKHcdaU+3R/Qo4FGUTBylKTqBeUrIyJazkZyNK98zCLiH9K2E47dhylHYNCdGREFJkk
         e88ZrjV8OwDjWwCZuncNsE/KDPyMIPfOj74fiiL0SRD1ydinrQBTFhbOEBiUPMFazD1B
         ucJw==
X-Gm-Message-State: ACgBeo3FjSZfxDO3tD2FlvsVjLh4JE/R82RBkLSIGUJ04st8c/tYD7oP
        hJpXCzD1mjBn7qZD/zRC0KZTKQ==
X-Google-Smtp-Source: AA6agR4sqXxxKi4mb3+0CFJc4qCyD4xvAMcIyGUn9NI4/7Ff/JuoW8K5vFDg7SS1M6jSetsvVHzWQQ==
X-Received: by 2002:a05:6512:401b:b0:48b:32f5:de20 with SMTP id br27-20020a056512401b00b0048b32f5de20mr1268909lfb.33.1660305885359;
        Fri, 12 Aug 2022 05:04:45 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id r3-20020a2e8e23000000b0025e60089f34sm333216ljk.52.2022.08.12.05.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 05:04:44 -0700 (PDT)
Message-ID: <4cf8d73e-9f14-fe8d-d6e2-551920c1f29e@linaro.org>
Date:   Fri, 12 Aug 2022 15:04:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Wei Fang <wei.fang@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
 <YvY7Vjtj+WV3BI59@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YvY7Vjtj+WV3BI59@shell.armlinux.org.uk>
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

On 12/08/2022 14:36, Russell King (Oracle) wrote:
> On Fri, Aug 12, 2022 at 02:25:42PM +0300, Krzysztof Kozlowski wrote:
>> hibernation is a feature, but 'disable-hibernation' is not. DTS
>> describes the hardware, not policy or driver bejhvior. Why disabling
>> hibernation is a property of hardware? How you described, it's not,
>> therefore either property is not for DT or it has to be phrased
>> correctly to describe the hardware.
> 
> However, older DT descriptions need to be compatible with later kernels,
> and as existing setups have hibernation enabled, introducing a property
> to _enable_ hibernation (which implies if the property is not present,
> hibernation is disabled) changes the behaviour with older DT, thereby
> breaking backwards compatibility.
> 
> Yes, DT needs to describe hardware, but there are also other
> constraints too.

I did not propose a property to enable hibernation. The property must
describe hardware, so this piece is missing, regardless whether the
logic in the driver is "enable" or "disable".

The hardware property for example is: "broken foo, so hibernation should
be disabled" or "engineer forgot to wire cables, so hibernation won't
work"...

Best regards,
Krzysztof
