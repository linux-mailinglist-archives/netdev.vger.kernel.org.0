Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5DE5BAA17
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiIPKIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiIPKIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 06:08:14 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBEAAB1AB;
        Fri, 16 Sep 2022 03:08:02 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28GA7kjG068027;
        Fri, 16 Sep 2022 05:07:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663322866;
        bh=aXAVZIYPKGzUSDwCBbqD8+m0IZ7vLkkmtiVjqwDBATU=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=zJ9O6OFY/onL2RwISQyxmhmN1u93vD197spJSwxZJjamxa2uCuWHiETe7w+HueS7N
         EUX4OWjV7lOC+nyYq8iG+6dYbxXuYhGCVQkwiv4W0jK9y+XpLYFVSgerS7Lo4Ry24n
         FoTJVNrhBcquV9wtyaN3xqVxB07alKbw03dYczH4=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28GA7kaa008764
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Sep 2022 05:07:46 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 16
 Sep 2022 05:07:46 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 16 Sep 2022 05:07:46 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28GA7fFR036036;
        Fri, 16 Sep 2022 05:07:41 -0500
Message-ID: <a8a27850-ad83-d010-235b-e97454fde9a9@ti.com>
Date:   Fri, 16 Sep 2022 15:37:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 0/8] Add support for J721e CPSW9G and SGMII mode
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <e6ecf9a3-4e8a-ff2a-aa82-5e65f99d76ac@linaro.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <e6ecf9a3-4e8a-ff2a-aa82-5e65f99d76ac@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 16/09/22 15:27, Krzysztof Kozlowski wrote:
> On 14/09/2022 10:50, Siddharth Vadapalli wrote:
>> Add compatible for J721e CPSW9G.
>>
>> Add support to power on and configure SERDES PHY.
>>
>> Add support for SGMII mode for J7200 CPSW5G and J721e CPSW9G.
> 
> I got two same patchsets from you... version your patches instead. See
> submitting-patches doc.

I had posted two series, both v1, with the series corresponding to
patches meant for the PHY and the NET subsystems. I did not realize
while posting, that the cover letters for both of them had the same
subject, making them appear as the same series, but of different
versions. I apologize for the confusion.

Regards,
Siddharth.
