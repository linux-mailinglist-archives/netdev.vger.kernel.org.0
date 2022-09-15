Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821BB5B958A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIOHkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIOHkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:40:31 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC717B78D;
        Thu, 15 Sep 2022 00:40:30 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F7eApx122114;
        Thu, 15 Sep 2022 02:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663227610;
        bh=3kXPFE0Dwu+KNKAHPXvESsbQM9s3XasfCfut6IwhQvw=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=JyYVKs+J4hrM+J2sKL/SEixuv6/ymTNqNa7XBhurC1lk8oVsceF/5EwtFiNbd9qng
         veF40vg8z0v8wpM9DBZ9oFOaAY4aBY0KzQ35QpGUtPV62Vos3zJ43S4aUCVji0ZpxC
         Ad+HN9DVwkeeyEH2zRPYESma43syV3/JOIKktTO8=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F7eACB124604
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 02:40:10 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 02:40:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 02:40:09 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F7e4W0090036;
        Thu, 15 Sep 2022 02:40:05 -0500
Message-ID: <ada95ea4-3c90-e780-2ba6-a448cf95eda9@ti.com>
Date:   Thu, 15 Sep 2022 13:10:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 1/8] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-2-s-vadapalli@ti.com>
 <20220914162302.GA2468487-robh@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220914162302.GA2468487-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 14/09/22 21:53, Rob Herring wrote:
> On Wed, Sep 14, 2022 at 03:20:46PM +0530, Siddharth Vadapalli wrote:
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
> 
> What's the base for this patch? It didn't apply for me.

I was working with linux-next tagged: next-20220913.

> 
> Run 'make dt_binding_check'. It should point out the issue I did. If 
> not, let me know.

Sure. Thank you.

Regards,
Siddharth.
