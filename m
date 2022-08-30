Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC7C5A6CB5
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiH3TDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiH3TDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:03:24 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5E35F20D
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:03:22 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id k18so5976360lji.13
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 12:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=gXK/wYTrdjw1OFwGZvQGSVF4ZM2/PXgjnzR2P4z9JVU=;
        b=RfyVD3awpAa0llxye9rwb8D/ncwSK7kal8kbOTuM8IbDZFVDp3nkj1DLplToMDLPH9
         29f5OmifJuPUSCaaEHSautt/YWR1ko394Ac4+Ke0yY9H8LAKIKnGvXOra5p9wX83TobH
         NC+3MQoXk+6m+I67DPYLhh4r3IBHjXl796aNlSoHAxzoi9U7xscBQorR3pulfB4bkwLV
         zaVyrK2txt0sbDMiOJ57bjrByubi+NWvB97jNTBLHnzP57aUdknZ7o2zUn9M2GeojJqg
         VsxHRqHM4b3XJrCDpFHi8Qkqhh+fuabfsP4hykouZxs3r5PGUipSMx8rhjE+Q44E0Cww
         WJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=gXK/wYTrdjw1OFwGZvQGSVF4ZM2/PXgjnzR2P4z9JVU=;
        b=Z89tFVYkJtExXXOq0XChAZOR7TXHYvhZb8fknCPIv4Upf5AlkFr/SgpIU6HOh8udl/
         57XV75n6U8hnWNlwlUotv/GXuzrT3LJUTHb7Wvj7hsL6dUqk8pc/nnhd2U2Yz6rDjcWO
         /V1WBpaTwWscyuREwPxk19vH8SY5/F42nOMJu4LhsoQmMIUbWeHKSPeugWEYDtjhNkOO
         m0rQ5wKNdmjFWoHy3PNHYDiz9DIb2nKVukXHgyeS/4D5aoEmfxbbQ1EqoQqo1O5TRiGq
         CXlypwRfLm5taHkUohIJhdC70lHk3nGzT9eJjPz34686xRjPGo7hyS3QIrFmGVL01Bw6
         +VJQ==
X-Gm-Message-State: ACgBeo1hV3W7JTvFsiBRYVuLar7iGf6Azo0gE7/37zTWuQCIxU6V3LDB
        /6wtOS4ehb/DT08ZGDEv8VUtVg==
X-Google-Smtp-Source: AA6agR7XX821cAlmC8c6TzfFWW/lCcMRA71i63MiH9w6y67HfOTP74/INxmWqpqcMogEbXBBQEmDJQ==
X-Received: by 2002:a2e:b0f9:0:b0:266:d31e:3061 with SMTP id h25-20020a2eb0f9000000b00266d31e3061mr2075012ljl.391.1661886200513;
        Tue, 30 Aug 2022 12:03:20 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id z9-20020a056512308900b00492f21c161esm1691923lfd.123.2022.08.30.12.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 12:03:19 -0700 (PDT)
Message-ID: <1ef5dbd4-806f-ac1d-0ad5-0f8359a560de@linaro.org>
Date:   Tue, 30 Aug 2022 22:03:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document RZ/N1
 power-domains support
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20220830164518.1381632-1-biju.das.jz@bp.renesas.com>
 <20220830164518.1381632-2-biju.das.jz@bp.renesas.com>
 <23539312-caaa-78f0-cd6c-899a826f9947@linaro.org>
 <OS0PR01MB592292E8BE619470F4C621A186799@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <OS0PR01MB592292E8BE619470F4C621A186799@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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

On 30/08/2022 20:47, Biju Das wrote:
> Hi Krzysztof Kozlowski,
> 
> Thanks for the feedback.
> 
>> Subject: Re: [PATCH v3 1/3] dt-bindings: can: nxp,sja1000: Document
>> RZ/N1 power-domains support
>>
>> On 30/08/2022 19:45, Biju Das wrote:
>>> Document RZ/N1 power-domains support. Also update the example with
>>> power-domains property.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>> v3:
>>>  * Documented power-domains support.
>>
>> You made them required, so it would be nice to see reason in such
>> change. The commit msg says only what you did, but not why you did it.
> 
> It is simple. As you see from [1] and [2] power-domains are enabled by default in RZ/N1 SoC.
> So there is nothing prevent us to document this property for all IP's present in
> RZ/N1 SoC.

Any explanation I expect to see in commit msg.

Anyway you referred to Linux drivers, which is not actually a reason.
What if some device is not in a power domain?

Best regards,
Krzysztof
