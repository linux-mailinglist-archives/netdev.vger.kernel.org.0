Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7315D6038E1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 06:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiJSEar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 00:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJSEap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 00:30:45 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890BA37FAF;
        Tue, 18 Oct 2022 21:30:44 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29J4UB9g047912;
        Tue, 18 Oct 2022 23:30:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666153811;
        bh=ZJsJDB45gJCSopNcBJ7tG0ngepWd/dQzLt2AFNiyxN8=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=A3WwfimL1hItwCQp/DpcTptxayHSXkOCrd9WuAF+JbTC3vLiMIUJ3Hj6qaBrbWXbQ
         xJWX6DYk4ssIU8xD67e6tEpx798dm/P8TIbby+BzitN9TP84dQ9xBES4uMCMOmMZbV
         2hDdFFAfXc1cu9d8Fy+IyRf3zu9KaW6jCvP319Is=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29J4UBqM002789
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Oct 2022 23:30:11 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 18
 Oct 2022 23:30:11 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 18 Oct 2022 23:30:11 -0500
Received: from [172.24.145.87] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29J4U5h1098101;
        Tue, 18 Oct 2022 23:30:06 -0500
Message-ID: <0a895e05-4134-d129-2b3d-e09242d8798f@ti.com>
Date:   Wed, 19 Oct 2022 10:00:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vigneshr@ti.com>,
        <nsekhar@ti.com>, <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <linux-arm-kernel@lists.infradead.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>, <edumazet@google.com>,
        <krzysztof.kozlowski@linaro.org>, <s-vadapalli@ti.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
To:     Rob Herring <robh@kernel.org>
References: <20221018085810.151327-1-s-vadapalli@ti.com>
 <20221018085810.151327-2-s-vadapalli@ti.com>
 <166609952162.171762.3639347443256680406.robh@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <166609952162.171762.3639347443256680406.robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 18/10/22 19:02, Rob Herring wrote:
> On Tue, 18 Oct 2022 14:28:08 +0530, Siddharth Vadapalli wrote:
>> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
>> ports) CPSW9G module and add compatible for it.
>>
>> Changes made:
>>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>>     - Extend pattern properties for new compatible.
>>     - Change maximum number of CPSW ports to 8 for new compatible.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> ./Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml:196:25: [error] syntax error: mapping values are not allowed here (syntax)

I will fix the errors in the v3 series and ensure that there are no
errors or warnings with dt_binding_check, using the updated dt-schema
and yamllint.

Regards,
Siddharth.
