Return-Path: <netdev+bounces-1220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2CB6FCC44
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2B331C20C17
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EC4F9F0;
	Tue,  9 May 2023 17:04:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968117FE0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:04:20 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34D9E709;
	Tue,  9 May 2023 10:03:57 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 349H2UD8043853;
	Tue, 9 May 2023 12:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683651750;
	bh=zQSHmgj5otF+Z4E0oN3jBRCBSbpgAADGlJPQwaAVMV8=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=DH2oK3rwIFAdYCwxcdE62TriABAvB0KUUoPAED9Y1a62g62VABnScrE+zEO8EY51K
	 QbpD7qTS7vbza5JeRB3729cS26Ca7fWLmWwoaofBGFylEmMptvtzOolXz6bgC53ain
	 XNKUOvw1dZL+EWbDkFwWaHMDRm57t8oKmrkD/LsA=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 349H2UGp014138
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 9 May 2023 12:02:30 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 9
 May 2023 12:02:30 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 9 May 2023 12:02:30 -0500
Received: from [128.247.81.95] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 349H2UjK114180;
	Tue, 9 May 2023 12:02:30 -0500
Message-ID: <674f0aac-3f4c-7c9e-4f1d-50a2e14348a3@ti.com>
Date: Tue, 9 May 2023 12:02:30 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 1/4] dt-bindings: net: can: Add poll-interval for MCAN
To: Marc Kleine-Budde <mkl@pengutronix.de>, Rob Herring <robh@kernel.org>
CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger
	<wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth
 Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo
	<kristo@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon
 Horman <simon.horman@corigine.com>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-2-jm@ti.com> <20230505212948.GA3590042-robh@kernel.org>
 <20230509-strike-available-6b2378172a59-mkl@pengutronix.de>
Content-Language: en-US
From: Judith Mendez <jm@ti.com>
In-Reply-To: <20230509-strike-available-6b2378172a59-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello all,

On 5/9/23 07:27, Marc Kleine-Budde wrote:
> On 05.05.2023 16:29:48, Rob Herring wrote:
>> On Mon, May 01, 2023 at 05:46:21PM -0500, Judith Mendez wrote:
>>> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
>>> routed to A53 Linux, instead they will use software interrupt by
>>> hrtimer. To enable timer method, interrupts should be optional so
>>> remove interrupts property from required section and introduce
>>> poll-interval property.
>>>
>>> Signed-off-by: Judith Mendez <jm@ti.com>
>>> ---
>>> Changelog:
>>> v3:
>>>  1. Move binding patch to first in series
>>>  2. Update description for poll-interval
>>>  3. Add oneOf to specify using interrupts/interrupt-names or poll-interval
>>>  4. Fix example property: add comment below 'example'
>>>
>>> v2:
>>>   1. Add poll-interval property to enable timer polling method
>>>   2. Add example using poll-interval property
>>>   
>>>  .../bindings/net/can/bosch,m_can.yaml         | 36 +++++++++++++++++--
>>>  1 file changed, 34 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>>> index 67879aab623b..c024ee49962c 100644
>>> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>>> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>>> @@ -14,6 +14,13 @@ maintainers:
>>>  allOf:
>>>    - $ref: can-controller.yaml#
>>>  
>>> +oneOf:
>>> +  - required:
>>> +      - interrupts
>>> +      - interrupt-names
>>> +  - required:
>>> +      - poll-interval
>>
>> Move this next to 'required'.
>>
>>> +
>>>  properties:
>>>    compatible:
>>>      const: bosch,m_can
>>> @@ -40,6 +47,14 @@ properties:
>>>        - const: int1
>>>      minItems: 1
>>>  
>>> +  poll-interval:
>>> +    $ref: /schemas/types.yaml#/definitions/flag
>>
>> This is a common property already defined as a uint32. You shouldn't 
>> define a new type.
>>
>> A flag doesn't even make sense. If that's all you need, then just enable 
>> polling if no interrupt is present.
> 
> Ok, then it's implicit. No IRQs -> polling.

Ok, will send out a v5 with these updates. Thanks.

regards,
Judith

