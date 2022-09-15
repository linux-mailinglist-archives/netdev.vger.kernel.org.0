Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F585B976B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiIOJ3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIOJ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:29:21 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436A680F70;
        Thu, 15 Sep 2022 02:29:20 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F9Sx4k123160;
        Thu, 15 Sep 2022 04:28:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663234139;
        bh=I2K32vA2lgUmiXzBYb3fBHYBUakCcdVOGjJp84HLIok=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=dd3iJHo8sI5xKsMtmCSyf21XC0+DBvQIT4J0MMsy+3ntAmtHHbtG8J6ALgs3V7y4B
         K/q1ptHc2mmAkFLSsFwfm61U7eVupHnaq78vci0xtmqh0PpRoHFJ69MCJswooHI4j9
         A6iIyZ1YtGzaVRaQI/o24d/EY2TBDGzKRT/Kapkk=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F9SxZo016129
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 04:28:59 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 04:28:58 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 04:28:58 -0500
Received: from [10.24.69.241] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F9SrSC079482;
        Thu, 15 Sep 2022 04:28:53 -0500
Message-ID: <ab683d52-d469-35cf-b3b5-50c9edfc173b@ti.com>
Date:   Thu, 15 Sep 2022 14:58:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for
 fixed-link configuration
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-6-s-vadapalli@ti.com>
 <YyH8us424n3dyLYT@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <YyH8us424n3dyLYT@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On 14/09/22 21:39, Russell King (Oracle) wrote:
> On Wed, Sep 14, 2022 at 03:20:50PM +0530, Siddharth Vadapalli wrote:
>> Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
>> am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
>> am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
>> the relevant operations in am65_cpsw_nuss_mac_config() itself.
> 
> Further to my other comments, you also fail to explain that, when in
> fixed-link SGMII mode, you _emulate_ being a PHY - which I deduce
> since you are sending the duplex setting and speed settings via the
> SGMII control word. Also, as SGMII was invented for a PHY to be able
> to communicate the media negotiation resolution to the MAC, SGMII
> defines that the PHY fills in the speed and duplex information in
> the control word to pass it to the MAC, and the MAC acknowledges this
> information. There is no need (and SGMII doesn't permit) the MAC to
> advertise what it's doing.
> 
> Maybe this needs to be explained in the commit message?

I had tested SGMII fixed-link mode using a bootstrapped ethernet layer-1
PHY. Based on your clarification in the previous mails that there is an
issue with the fixed-link mode which I need to debug, I assume that what
you are referring to here also happens to be a consequence of that.
Please let me know if I have misunderstood what you meant to convey.

Regards,
Siddharth.
