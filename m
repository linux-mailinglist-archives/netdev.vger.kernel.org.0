Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC66D5783E9
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiGRNkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiGRNkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:40:09 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2271A05D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:40:07 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y11so19369142lfs.6
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qP9Fo5KBG1bSRd2Jktw44saL7dv2bZtKwCgW6wpScEo=;
        b=LydNAbpiOiDlshy5VPw8GM+ohK5mAteiOjn9DViBMZcAdgGLZgOluNcnR2js6hMa2d
         7hJ1zcRoNeGwk/OLqK/9NnXjVQillG9u7p5R1Wsyw2Rn6BE13YJO9Udn3uLjF1Fo41jf
         bCcFwqcXI/WAJbdHXX5XBSPeCutlv07HBSTzrjpUCjAWfhO0cNUk05Vv1by2t8j9N/QS
         Ne2YRcvdW8w42bnprFuMwwlZXMPD+viCFITy89/Toygy+8fWax3argEtwmAxhLksNAoP
         ur5TUpos4VK+1Z3FJ+o+sfUEVSktZ7JbPQEtvAAi0HcATRTI0nQGEjg2hILU9NMYlHmB
         EM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qP9Fo5KBG1bSRd2Jktw44saL7dv2bZtKwCgW6wpScEo=;
        b=y5iIIWNdwhetUfyo69km6ivxE2JJ4mR2fCVeQeDqbJl/z5wcLFdZ1liB1+0CBBFAuD
         Vg/bkydrLVX+OeLwy9Wbx1cLp+oefjI2hcWbg+iIwBisNAGgA3aLz1xEcwVwJplxMRrG
         TajsrO1PmzOk8Gb389rDx/HNU+anRzjcleMJAsCM3Y2khgqEMMyuAFEl562AvJf5l/4X
         gwUfbYzUDY/2x62nxsk1PQ6GYcQlGdWaUHZONkYq8wrDahlJ9oSuxM7tr50MImcXmbLQ
         tqBhBujIk7uuXvTyL7/4WssutoxzbUnu/EmpNeAGGltFFhhvHWUvwMufpnqIx3b5Sd7J
         LSOw==
X-Gm-Message-State: AJIora9BAP8JIzzleeW3CZyo4Cnh5uyUoGTkuSlUn8cHJPM9wMzLZT65
        tyM5hiLAkQuNk6do8dYpt9tnQX2M4ePyMT2M
X-Google-Smtp-Source: AGRyM1s1qWe+cRpioSO8Ixn5A2yF3sZewgmBHH5fFTqKY8HJ5V1AGYKl/UMTkIk31fZ8gW3ypTjz3g==
X-Received: by 2002:a05:6512:3b23:b0:48a:4a8c:2a27 with SMTP id f35-20020a0565123b2300b0048a4a8c2a27mr956367lfv.372.1658151605709;
        Mon, 18 Jul 2022 06:40:05 -0700 (PDT)
Received: from [192.168.115.193] (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id s11-20020a05651c048b00b0025d681fbebdsm2050116ljc.100.2022.07.18.06.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 06:40:05 -0700 (PDT)
Message-ID: <0d758fae-efde-eb0c-5fc9-2407826ac163@linaro.org>
Date:   Mon, 18 Jul 2022 15:40:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Content-Language: en-US
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
References: <20220718142257.556248-1-wei.fang@nxp.com>
 <20220718142257.556248-2-wei.fang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220718142257.556248-2-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/07/2022 16:22, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add fsl,imx8ulp-fec for i.MX8ULP platform.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submitting-patches.rst#L540

If a tag was not added on purpose, please state why and what changed.



Best regards,
Krzysztof
