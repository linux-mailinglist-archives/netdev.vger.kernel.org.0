Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD976F13D6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbjD1JHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjD1JHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:07:36 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DFD2D5B;
        Fri, 28 Apr 2023 02:07:34 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33S96pq1060684;
        Fri, 28 Apr 2023 04:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682672811;
        bh=o1rSdOmMRwFvIuaD+mfrZqbuIO8xyaxUVPv2FuoJHCs=;
        h=Date:Subject:From:To:CC:References:In-Reply-To;
        b=KIsIiiv9JP3wRNCZzTczcPRGEINj/pPz2AFDsHVpxyCA2/o4cRoOW2lL2lZ3/l0YU
         PdqEjdZTfBffRphiZC6YVweUmXGVoGYX1NK8HZou+lP1yS4NxUeMbZJAuF6gjyenl9
         Ix1W0RPb0l6+71ZyouOCEUmsMJ+wUchuJd40yLEc=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33S96p0k057141
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Apr 2023 04:06:51 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 28
 Apr 2023 04:06:50 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 28 Apr 2023 04:06:50 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33S96hWV077030;
        Fri, 28 Apr 2023 04:06:44 -0500
Message-ID: <ff6fe35f-ca4b-a48d-777f-196b771a14d3@ti.com>
Date:   Fri, 28 Apr 2023 14:36:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [EXTERNAL] Re: [RFC PATCH v6 2/2] net: ti: icssg-prueth: Add
 ICSSG ethernet driver
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
To:     Simon Horman <simon.horman@corigine.com>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <kristo@kernel.org>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>, <nm@ti.com>,
        <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230424053233.2338782-1-danishanwar@ti.com>
 <20230424053233.2338782-3-danishanwar@ti.com> <ZEl2zh879QAX+QsK@corigine.com>
 <9c97e367-56d6-689e-856a-c1a6ff575b63@ti.com>
Organization: Texas Instruments
In-Reply-To: <9c97e367-56d6-689e-856a-c1a6ff575b63@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon.

On 27/04/23 12:42, Md Danish Anwar wrote:
> Hi Simon,
> Thanks for the comments.
> 
> On 27/04/23 00:39, Simon Horman wrote:
>> On Mon, Apr 24, 2023 at 11:02:33AM +0530, MD Danish Anwar wrote:
>>> From: Roger Quadros <rogerq@ti.com>
>>>
>>> This is the Ethernet driver for TI AM654 Silicon rev. 2
>>> with the ICSSG PRU Sub-system running dual-EMAC firmware.
>>>

[ ... ]

>>
>> ...
>>
>>> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
>>> +MODULE_AUTHOR("Puranjay Mohan <p-mohan@ti.com>");
>>> +MODULE_AUTHOR("Md Danish Anwar <danishanwar@ti.com>");
>>> +MODULE_DESCRIPTION("PRUSS ICSSG Ethernet Driver");
>>> +MODULE_LICENSE("GPL");
>>
>> SPDK says GPL-2.0, so perhaps this should be "GPL v2" ?
>>

I am getting checkpatch warning while changing GPL version.

WARNING: Prefer "GPL" over "GPL v2" - see commit bf7fbeeae6db ("module: Cure
the MODULE_LICENSE "GPL" vs. "GPL v2" bogosity")
#3602: FILE: drivers/net/ethernet/ti/icssg_prueth.c:1866:
+MODULE_LICENSE("GPL v2");

Should I ignore this warning and change it to "GPL v2"

-- 
Thanks and Regards,
Danish.
