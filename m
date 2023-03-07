Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282AD6AD6A3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 06:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCGFA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 00:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGFAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 00:00:55 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828F15650C;
        Mon,  6 Mar 2023 21:00:54 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32750Lsm100699;
        Mon, 6 Mar 2023 23:00:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678165221;
        bh=glyCP2C4zVZ3Ju+NR/13yw7VIJRH559KMd68tnndd1I=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=xbUXOu4sv+XTZkI6KJCY1sWZrySEXPPMikR17pzKG4vM6I79O4knMSiKgtgzBfgyj
         EiuuNXbRcpMAP+zUQzRCVio5R9RHxPgv2bdBS1AIDW92SRVvT87DXsZl4ExkDHpYjW
         0GVRdULxVAhhc1Vhi1H2J8miWQuoP6zEC04+/MHM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32750L36017881
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 23:00:21 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 23:00:21 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 23:00:21 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32750FRn004333;
        Mon, 6 Mar 2023 23:00:16 -0600
Message-ID: <d5be2bfc-aee8-2203-da04-d8ee9f831e99@ti.com>
Date:   Tue, 7 Mar 2023 10:30:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v5 0/2] Introduce ICSSG based ethernet
 Driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>,
        <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210163816.423a0ee9@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <20230210163816.423a0ee9@kernel.org>
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

Hi Jakub,

On 11/02/23 06:08, Jakub Kicinski wrote:
> On Fri, 10 Feb 2023 17:19:55 +0530 MD Danish Anwar wrote:
>> This series depends on two patch series that are not yet merged, one in
>> the remoteproc tree and another in the soc tree. the first one is titled
>> Introduce PRU remoteproc consumer API and the second one is titled
>> Introduce PRU platform consumer API.
>> Both of these are required for this driver.
>>
>> To explain this dependency and to get reviews, I had earlier posted all
>> three of these as an RFC[1], this can be seen for understanding the
>> dependencies.
> 
> And please continue to post them as RFC :( If there are dependencies
> which the networking tree doesn't have we can't possibly merge these :(

Sure, I will post the next revision of this series as RFC. Once the
dependencies are merged, I will send this series to networking tree so that
this series can be merged.

-- 
Thanks and Regards,
Danish.
