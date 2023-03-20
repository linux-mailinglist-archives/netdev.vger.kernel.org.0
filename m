Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3066C2608
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 00:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjCTXsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCTXsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 19:48:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA8C3928F
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:47:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d13so13882497pjh.0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 16:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112; t=1679355989;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CVD5kdtXy54YH3zU4G6cezFVCE0kWaOWnyh3a3H/fVw=;
        b=gqS4hwId4OLnZEQgJI+kyIQkdjmZZrN+nyj53I24mqFbKwumRa3syzV+0mkcoQUlbp
         I3AgRwMOV5tpdFgxUwMOdyobSn6YGJLq5ce4Okpmp1xF8WMyk+AYS/fECsmmnrjwBbvh
         m416ye8JJBLiaMGKdPSU4vq6gcd8bwzfYtt4uBxxudYPXhLppUa4BnHpOAHtMLbQfY1m
         MgvnWpRfkoiw5QiNdjNC8e97mTNXbNTRxWG+QQNHRgAgPLzHdXjluPpcHMXjwu63j5tq
         +AkQmONBFJpyV0p6OQzwTmHpFlFVOZSZARJD9iWGVFgf52pT57vGrjmsDw1ywIryYuNH
         Cqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679355989;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVD5kdtXy54YH3zU4G6cezFVCE0kWaOWnyh3a3H/fVw=;
        b=lAWW9swZ+SE8edHSarGgUO9VGUEEUhOmql1p6SeeTDS/DLLQrhicwfb/G7qrmAhz1u
         fJuTzeqGRVVjiqZ3+DznDyaHef9CbtDL8+jY/oIG62uCGnnjPusdvJiqamp2ChSZz1Vg
         E9D0FyngM4aHU5vM4+uPhMddYJFDW6V1Tig0ejaYRlab4W1hirIyXN8xLkdIIwebBkYb
         41gXI692UAzjFPd76uMlNLJGdjnnGh2A/+KQKMGUvvb+v7Virv6sfPsmMmH0y7VijIjG
         yrSYxACu6APq73+ar8cR1B5as9Tt+C27mpAsgeEA7rJ0DvKYTI81r525Rym0N6pwKeIZ
         EGrA==
X-Gm-Message-State: AO0yUKXVzp2exn5Ak8Qps7hbGvX6gcFT4oSt9xpEXJ27Q9OP9IRcNNKe
        0qqMInGBOZE9C4ns/rAk+3kVrw==
X-Google-Smtp-Source: AK7set+Eo6dVqOrcG8rwMRvHa6vfuVju4SycRcGmgII+64sM2O1goAy6bcstJI4WTVXmjXHmb/WVRA==
X-Received: by 2002:a17:90b:1e43:b0:23f:9fac:6b31 with SMTP id pi3-20020a17090b1e4300b0023f9fac6b31mr367842pjb.25.1679355989349;
        Mon, 20 Mar 2023 16:46:29 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id 30-20020a630c5e000000b00502fd141ffbsm6756689pgm.49.2023.03.20.16.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:46:28 -0700 (PDT)
Date:   Mon, 20 Mar 2023 16:46:28 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Mar 2023 16:45:32 PDT (-0700)
Subject:     Re: [PATCH 01/12] dt-bindings: riscv: sifive-ccache: Add compatible for StarFive JH7100 SoC
In-Reply-To: <Y+vxw28NWPfaW7ql@spud>
CC:     cristian.ciocaltea@collabora.com, lee@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@esmil.dk,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        sagar.kadam@sifive.com, yanhong.wang@starfivetech.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Conor Dooley <conor@kernel.org>
Message-ID: <mhng-49aaa4a3-0280-4401-ba33-7fe2f3b79534@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 12:40:35 PST (-0800), Conor Dooley wrote:
> Hey all,
>
> On Sat, Feb 11, 2023 at 05:18:10AM +0200, Cristian Ciocaltea wrote:
>> Document the compatible for the SiFive Composable Cache Controller found
>> on the StarFive JH7100 SoC.
>> 
>> This also requires extending the 'reg' property to handle distinct
>> ranges, as specified via 'reg-names'.
>> 
>> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>> ---
>>  .../bindings/riscv/sifive,ccache0.yaml        | 28 ++++++++++++++++++-
>>  1 file changed, 27 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
>> index 31d20efaa6d3..2b864b2f12c9 100644
>> --- a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
>> +++ b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
>> @@ -25,6 +25,7 @@ select:
>>            - sifive,ccache0
>>            - sifive,fu540-c000-ccache
>>            - sifive,fu740-c000-ccache
>> +          - starfive,jh7100-ccache
>>  
>>    required:
>>      - compatible
>> @@ -37,6 +38,7 @@ properties:
>>                - sifive,ccache0
>>                - sifive,fu540-c000-ccache
>>                - sifive,fu740-c000-ccache
>> +              - starfive,jh7100-ccache
>>            - const: cache
>>        - items:
>>            - const: starfive,jh7110-ccache
>> @@ -70,7 +72,13 @@ properties:
>>        - description: DirFail interrupt
>>  
>>    reg:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  reg-names:
>> +    items:
>> +      - const: control
>> +      - const: sideband
>
> So why is this called "sideband"?
> In the docs for the JH7100 it is called LIM & it's called LIM in our
> docs for the PolarFire SoC (at the same address btw) and we run the HSS

IIRC it's both: "LIM" is the memory, "sideband" is the port.  I can't 
find any proper documentation of "sideband" outside of DT and errata, 
but there's a hanful of references to it in the bootloader for the 
fu540: 
<https://github.com/sifive/freedom-u540-c000-bootloader/search?q=sideband>.

It's not really clear which is more correct here: sideband accesses are 
only useful when the cache is configured as an LIM, at least for general 
software.  IIRC the accesses to the LIM only go through the sideband 
port for the E core, but I might be wrong about that.

> out of it! LIM being "loosely integrated memory", which by the limit
> hits on Google may be a SiFive-ism?

Yep: TIM is the SiFive version of Arm's TCM (tightly coupled memory), 
and LIM is the flavor that's farther away (L2 instead of L1).

> I'm not really sure if adding it as a "reg" section is the right thing
> to do as it's not "just" a register bank.
> Perhaps Rob/Krzysztof have a take on that one?
>
>>  
>>    next-level-cache: true
>>  
>> @@ -89,6 +97,7 @@ allOf:
>>            contains:
>>              enum:
>>                - sifive,fu740-c000-ccache
>> +              - starfive,jh7100-ccache
>>                - starfive,jh7110-ccache
>>                - microchip,mpfs-ccache
>>  
>> @@ -106,12 +115,29 @@ allOf:
>>              Must contain entries for DirError, DataError and DataFail signals.
>>            maxItems: 3
>>  
>> +  - if:
>> +      properties:
>> +        compatible:
>> +          contains:
>> +            const: starfive,jh7100-ccache
>> +
>> +    then:
>> +      properties:
>> +        reg:
>> +          maxItems: 2
>> +
>> +    else:
>> +      properties:
>> +        reg:
>> +          maxItems: 1
>> +
>>    - if:
>>        properties:
>>          compatible:
>>            contains:
>>              enum:
>>                - sifive,fu740-c000-ccache
>> +              - starfive,jh7100-ccache
>>                - starfive,jh7110-ccache
>>  
>>      then:
>> -- 
>> 2.39.1
>> 
