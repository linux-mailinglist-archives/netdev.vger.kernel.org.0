Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801B8566421
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiGEH1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiGEH1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:27:18 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CD41147C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:27:16 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s14so13451987ljs.3
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 00:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+QFXCnTSTR0Kr9R8Fc+oNGxMhItBGDWdsnZiQxdsy5M=;
        b=ZfxdfBUPZgB7VjeXtnZSksbT/rVit/QkXFKzFCwoxi9+Sq2TAuf0j2xUuSCh8taB//
         /sHKO/RwsBLmlcyxtYzJGaWerzyLsgUY875kFwkkFN6HO7NwSE4EsTnm7+RLdonX0tV7
         cYuEqcl7Fra+mdLZ8nrmveBxAiF3Irpz7UI2jtR1cDK/AUzEbH/ZkbMeQRnYNHHZrpuN
         e+EIb2ab8Jp61xTJNaruGZ/3exgVKRA5HI9kWHAT5MI0VVur2+neQ2yB++AcBImCDaiQ
         oBy66s0yMrv9f5aYVn6D1nLSkR4N+fJVi0KrHW0nNHJwqXYNiKzKXxWjH5B7crYhsUMI
         99rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+QFXCnTSTR0Kr9R8Fc+oNGxMhItBGDWdsnZiQxdsy5M=;
        b=YKHcBYMwf5FQvY4eeiucEO3E45u9PYrzoar/OFbOUKqED0q1hFGO/8Uu8hL2J/aKQA
         qfN4yWkSl7n0EeeB+cpe9DdOS4uU6huhRKWc+mOeoUTcXSq5hEUnUskm8XWiL6hyRPCc
         ikudO4KQpN1LF8ie1VoygJojXVsA2NJeE2RfPnsiCprOGfkvVY4WvDy2pl8cMNsXkYlx
         yg4m24Rp6p06X2/oTIp4dB66TRGn3L8l7aeQa8dt1x93sYlUf7CJcaoIdGnAFOogn9C+
         rWSwO+PmThVYTJYQF7LmbEL/S4rFhoE5V4q0hSIB2/uYkp+mUjtIlIAdYh5nYi4og6CQ
         rgGA==
X-Gm-Message-State: AJIora93djxGWSrWIILLi9zK8mvRFwWoODAsgMuyQcYDPJQGxPv28y14
        EEDkr8IZhMQxjf30DeJexq+MUw==
X-Google-Smtp-Source: AGRyM1ukj+l3sk2QLPIIc66Cc/pLkr3DjDBPYKgWOFQ9YtSkxRYWUvxyXVn9YfbaLNrU3JypcU8FJA==
X-Received: by 2002:a2e:bc11:0:b0:25a:9530:e30e with SMTP id b17-20020a2ebc11000000b0025a9530e30emr18132882ljf.180.1657006035336;
        Tue, 05 Jul 2022 00:27:15 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id c7-20020a19e347000000b00478fc1eca9bsm5536117lfk.131.2022.07.05.00.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 00:27:14 -0700 (PDT)
Message-ID: <78f2423b-d803-5b3c-40a8-b51f4f276631@linaro.org>
Date:   Tue, 5 Jul 2022 09:27:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [EXT] Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible
 item
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <AM9PR04MB900371B6B60D634C9391E70288819@AM9PR04MB9003.eurprd04.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <AM9PR04MB900371B6B60D634C9391E70288819@AM9PR04MB9003.eurprd04.prod.outlook.com>
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

On 05/07/2022 04:47, Wei Fang wrote:
> Hi Krzysztof,
> 	
> 	Sorry, I'm still a little confused. Do you mean to modify as follows?
>> +      - items:
>> +          - enum:
>> +              - fsl,imx8ulp-fec
>> +          - const: fsl,imx6ul-fec
>> +          - const: fsl,imx6q-fec

Yes

> 
> And as far as I know, the imx8ulp's fec is reused from imx6ul, they both have the same features. However, the fec of imx8ulp(and imx6ul) is a little different from imx6q, therefore, the functions supported by the driver are also somewhat different. 

I understand. But if imx8ulp is the same as imx6ul and imx6ul is
compatible with imx6q, then I expect imx8ulp to be compatible with
imx6ul and with imx6q.

Best regards,
Krzysztof
