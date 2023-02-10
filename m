Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446D069187D
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjBJG07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjBJG06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:26:58 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796D22ED6D;
        Thu,  9 Feb 2023 22:26:54 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31A6QO7i115307;
        Fri, 10 Feb 2023 00:26:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1676010384;
        bh=lBItCq1W0OP+iyeXFijG9TIsfl3uxMuDtEmrUXvulLE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=EKO2n5rexh5RBrgzzJSkMuo89iGiIb6VS1wv46Z1GwwsDmvyd3KtErN3wZptNMnAv
         r44BB3rZ54zmwc2HfnncZcE5i82Y2scbCKgISQWDoOTW2zoqVf+gFaFHvg2+wcLyey
         Yl9wOseV9syDl3P+zSU79wSkZjbqLOh9AzT2766c=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31A6QOPn067002
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Feb 2023 00:26:24 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 10
 Feb 2023 00:26:24 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 10 Feb 2023 00:26:24 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31A6QI97110407;
        Fri, 10 Feb 2023 00:26:19 -0600
Message-ID: <ea447e7c-8e80-07cd-25c0-3fc2a651eb48@ti.com>
Date:   Fri, 10 Feb 2023 11:56:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re:
 [PATCH v4 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <nm@ti.com>,
        <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com> <Y+ELeSQX+GWS5N2p@lunn.ch>
 <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
 <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
 <4438fb71-7e20-6532-a858-b688bc64e826@ti.com> <Y+Ob8++GWciL127K@lunn.ch>
 <6713252d-6f86-c674-9229-c4512ebf1d72@ti.com> <Y+T7MAu0/s1bjYIt@lunn.ch>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <Y+T7MAu0/s1bjYIt@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/02/23 19:24, Andrew Lunn wrote:
>> Sure, I'll do that. In the list of all phy modes described in [1], I can only
>> see phy-mode "rgmii-txid", for which we can return -EINVAL. Is there any other
>> phy-mode that requires enabling/disabling TX internal delays? Please let me
>> know if any other phy-mode also needs this. I will add check for that as well.
> 
> There are 4 phy-modes for RGMII.
> 
> rgmii, rgmii-id, rmgii-rxid, rgmii-txid.
> 
> rgmii-id, rgmii-txid both require TX delays. If you do that in the MAC
> you then need to pass rgmii-rxid and rgmii to the PHY respectively.
> 
> rmii and rgmii-rxid requires no TX delays, which your SoC cannot do,
> so you need to return -EINVAl,
> 
> The interpretation of these properties is all really messy and
> historically not very uniformly done. Which is why i recommend the MAC
> does nothing, leaving it to the PHY. That generally works since the
> PHYs have a pretty uniform implementation. But in your case, you don't
> have that option. So i suggest you do what is described above. 
> 
>     Andrew

Sure Andrew, I will post new revision with the changes described above.

-- 
Thanks and Regards,
Danish.
