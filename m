Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71CB6AFDCF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 05:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCHEUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 23:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCHEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 23:20:18 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D899E310;
        Tue,  7 Mar 2023 20:20:16 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3284JkNt116986;
        Tue, 7 Mar 2023 22:19:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678249186;
        bh=IORDEtukZF4j1fvmSt9qIQDEcCv14014bX6b0oyW4J0=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=LS+RdFjNdUJh39dqJSR9dNpbjFm6JwXOVvpHcXIXAvCbWwvxT7bpcoPRsAbhUTor7
         iJQ4DFXflaIsfulvU8m3G3hxARtcNgX/J4VCIVzXVqox76PkO/mdGXdibflu+ykexA
         qO0uXUc9cHbhZNQgHEz6fUVOb0GDGucBsgw45yVc=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3284JjDJ073294
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 7 Mar 2023 22:19:46 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 7
 Mar 2023 22:19:46 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 7 Mar 2023 22:19:45 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3284JeXX118018;
        Tue, 7 Mar 2023 22:19:41 -0600
Message-ID: <28de6e62-5bc3-b986-b069-32150b0c81eb@ti.com>
Date:   Wed, 8 Mar 2023 09:49:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
To:     Rob Herring <robh@kernel.org>
References: <20230306094750.159657-1-s-vadapalli@ti.com>
 <20230307140139.GA48063-robh@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20230307140139.GA48063-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 07/03/23 19:31, Rob Herring wrote:
> On Mon, Mar 06, 2023 at 03:17:50PM +0530, Siddharth Vadapalli wrote:
>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>> when the Serdes is being configured in a Single-Link protocol. Using the
>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>> driver can obtain the Serdes PHY and request the Serdes to be
>> configured.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>
>> Hello,
>>
>> This patch corresponds to the Serdes PHY bindings that were missed out in
>> the series at:
>> Link: https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>> This was pointed out at:
>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 21 +++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index 900063411a20..fab7df437dcc 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -126,8 +126,25 @@ properties:
>>              description: CPSW port number
>>  
>>            phys:
>> -            maxItems: 1
>> -            description: phandle on phy-gmii-sel PHY
>> +            minItems: 1
>> +            maxItems: 2
>> +            description:
>> +              phandle(s) on CPSW MAC's PHY (Required) and the Serdes
>> +              PHY (Optional). phandle to the Serdes PHY is required
>> +              when the Serdes has to be configured in Single-Link
>> +              configuration.
> 
> Like this:
> 
> minItems: 1
> items:
>   - description: CPSW MAC's PHY
>   - description: Serdes PHY. Serdes PHY is required
>       when the Serdes has to be configured in Single-Link
> 
>> +
>> +          phy-names:
>> +            oneOf:
>> +              - items:
>> +                  - const: mac-phy
>> +                  - const: serdes-phy
>> +              - items:
>> +                  - const: mac-phy
> 
> Drop this and use minItems in 1st 'items' entry.
> 
>> +            description:
>> +              Identifiers for the CPSW MAC's PHY and the Serdes PHY.
>> +              CPSW MAC's PHY is required and therefore "mac-phy" is
>> +              required, while "serdes-phy" is optional.
> 
> No need to state in plain text what the schema already says.

Thank you for reviewing the patch. I will implement your feedback and post the
v2 patch.

Regards,
Siddharth.
