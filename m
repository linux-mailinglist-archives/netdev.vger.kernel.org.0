Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C386D434A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjDCLTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjDCLTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:19:25 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A800612055;
        Mon,  3 Apr 2023 04:19:11 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333BIxPT077632;
        Mon, 3 Apr 2023 06:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680520739;
        bh=oSyXiB/SZuczuvWxmVtOhJLZhyI+hwqoq1sHbImfLCI=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=BHpALT6JSgy6QF7SjA9ts0ypEF1Ya/CxPETiV8FqWKPhMlnUo7ebwfm+cv1iDEr6v
         97JWX2Mloks04rr3Rhm1sgB6PFe2Uc0JOSPJsV1tW45/66F1pnqb1t7sl6kwk/kC5m
         wOTx2Gz9FR3Zcx+7aqBDxur8O92bhWngR1iamR2g=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333BIxDw080464
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:18:59 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:18:59 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:18:59 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333BIth4118486;
        Mon, 3 Apr 2023 06:18:56 -0500
Message-ID: <4132d106-7fd6-2d5c-1ab6-c0e5a4d13c95@ti.com>
Date:   Mon, 3 Apr 2023 16:48:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: ti: am65-cpsw: Enable
 USXGMII mode for J784S4 CPSW9G
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
 <20230403110106.983994-4-s-vadapalli@ti.com>
 <ZCq0McVarf5D3kB7@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCq0McVarf5D3kB7@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/04/23 16:40, Russell King (Oracle) wrote:
> On Mon, Apr 03, 2023 at 04:31:06PM +0530, Siddharth Vadapalli wrote:
>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>> extra_modes member of the J784S4 SoC data.
>>
>> Additionally, convert the IF statement in am65_cpsw_nuss_mac_config() to
>> SWITCH statement to scale for new modes. Configure MAC control register
>> for supporting USXGMII mode and add MAC_5000FD in the "mac_capabilities"
>> member of struct "phylink_config".
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 6c118a9abb2f..f4d4f987563c 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -1507,10 +1507,20 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>>  	u32 mac_control = 0;
>>  
>>  	if (common->pdata.extra_modes & BIT(state->interface)) {
>> -		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
>> +		switch (state->interface) {
>> +		case PHY_INTERFACE_MODE_SGMII:
>>  			mac_control |= CPSW_SL_CTL_EXT_EN;
>>  			writel(ADVERTISE_SGMII,
>>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
>> +			break;
>> +
>> +		case PHY_INTERFACE_MODE_USXGMII:
>> +			mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
> 
> Following on to my comments on patch 1, with the addition of these
> control bits, you now will want am65_cpsw_nuss_mac_link_down() to
> avoid clearing these bits as well.

Yes, I will ensure this in the v3 series.

Regards,
Siddharth.
