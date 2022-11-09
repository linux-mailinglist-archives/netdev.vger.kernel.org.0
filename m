Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBC56222E8
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiKID7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKID7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:59:24 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4531A838;
        Tue,  8 Nov 2022 19:59:23 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A93wZeU058517;
        Tue, 8 Nov 2022 21:58:35 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667966315;
        bh=J2NoIk3al2GZi8pyjsvOAoLOl2pIUpuW02w5w7hO/NM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=YJgfda5lIxYSCIHeSbIBup5BB/iEox2tOMfHb3H6qINGRerja9ZpyfB+dIEWYcGcH
         hZ2lfYvZ/sYfL0me2mvRZ1rpL5TEKdYWtHQvhJLCzTMImIDCc4YAHwHuZFjAq35PWk
         rs5bkVR/J55pSXGZ1LOOSGU8lfxP9wW8wUglJM7o=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A93wZnh018528
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Nov 2022 21:58:35 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 8 Nov
 2022 21:58:35 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 8 Nov 2022 21:58:35 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A93wUaX031793;
        Tue, 8 Nov 2022 21:58:31 -0600
Message-ID: <0979ccdc-da5c-8dfa-1be1-e385be085372@ti.com>
Date:   Wed, 9 Nov 2022 09:28:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH v4 0/3] Add support for QSGMII mode for J721e CPSW9G to
 am65-cpsw driver
To:     Jakub Kicinski <kuba@kernel.org>
References: <20221108080606.124596-1-s-vadapalli@ti.com>
 <20221108175343.57f3998d@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20221108175343.57f3998d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On 09/11/22 07:23, Jakub Kicinski wrote:
> On Tue, 8 Nov 2022 13:36:03 +0530 Siddharth Vadapalli wrote:
>> 2. Rebase series on linux-next tree tagged: next-20221107.
> 
> You need to based on the tree which you're expecting to apply the patch.
> Which should be net-next here-  throw that into the subject while at it
> ([PATCH net-next v5 0/3] ....). v4 does not apply cleanly.

I will rebase the series on the net-next tree and use "PATCH net-next"
in the subject and then post the v5 series. It looks like a few patches
got merged to the net-next tree after I had posted my series.

Regards,
Siddharth.
