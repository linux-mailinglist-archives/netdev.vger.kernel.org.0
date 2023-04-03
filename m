Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69616D3F00
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjDCIcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDCIcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:32:10 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5449C2;
        Mon,  3 Apr 2023 01:32:07 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3338Vpul058187;
        Mon, 3 Apr 2023 03:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680510711;
        bh=lgfPx1evUUMdkoqBOH4tAB2qzNFrhhX1gZ9kjndYKyw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=KIsprksEU00AQnVW2+onEFLhJqRMgMEBaU4Cc+rwUyo1j90cshWeDgsLRSUbfHumq
         b2s9Ay9f3KPZwZai6J3ZSK+c7hwtLqh/DGSBcJvKE4QbevxdexL3lV2ApELu9DGoCs
         txBb9kN1x1VebEutVREs5wKq2J2yI8kjHIQKVN8U=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3338Vp3S013019
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 03:31:51 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 03:31:50 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 03:31:50 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3338Vikd099122;
        Mon, 3 Apr 2023 03:31:45 -0500
Message-ID: <19c82e73-2e37-582b-06aa-6f83776a562d@ti.com>
Date:   Mon, 3 Apr 2023 14:01:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [EXTERNAL] Re: [PATCH v6 3/4] soc: ti: pruss: Add
 pruss_cfg_read()/update(), pruss_cfg_get_gpmux()/set_gpmux() APIs
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230331112941.823410-1-danishanwar@ti.com>
 <20230331112941.823410-4-danishanwar@ti.com> <ZCg6lzWMTuLa4gAC@corigine.com>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <ZCg6lzWMTuLa4gAC@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.9 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On 01/04/23 19:37, Simon Horman wrote:
> On Fri, Mar 31, 2023 at 04:59:40PM +0530, MD Danish Anwar wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>> the PRUSS platform driver to read and program respectively a register
>> within the PRUSS CFG sub-module represented by a syscon driver. These
>> APIs are internal to PRUSS driver.
>>
>> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
>> to get and set the GP MUX mode for programming the PRUSS internal wrapper
>> mux functionality as needed by usecases.
>>
>> Various useful registers and macros for certain register bit-fields and
>> their values have also been added.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>> Reviewed-by: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> 
> ...
> 
>> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
>> new file mode 100644
>> index 000000000000..4626d5f6b874
>> --- /dev/null
>> +++ b/drivers/soc/ti/pruss.h
>> @@ -0,0 +1,112 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * PRU-ICSS Subsystem user interfaces
>> + *
>> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
>> + *	MD Danish Anwar <danishanwar@ti.com>
>> + */
>> +
>> +#ifndef _SOC_TI_PRUSS_H_
>> +#define _SOC_TI_PRUSS_H_
>> +
>> +#include <linux/bits.h>
>> +#include <linux/regmap.h>
>> +
>> +/*
>> + * PRU_ICSS_CFG registers
>> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
>> + */
>> +#define PRUSS_CFG_REVID         0x00
>> +#define PRUSS_CFG_SYSCFG        0x04
>> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
>> +#define PRUSS_CFG_CGR           0x10
>> +#define PRUSS_CFG_ISRP          0x14
>> +#define PRUSS_CFG_ISP           0x18
>> +#define PRUSS_CFG_IESP          0x1C
>> +#define PRUSS_CFG_IECP          0x20
>> +#define PRUSS_CFG_SCRP          0x24
>> +#define PRUSS_CFG_PMAO          0x28
>> +#define PRUSS_CFG_MII_RT        0x2C
>> +#define PRUSS_CFG_IEPCLK        0x30
>> +#define PRUSS_CFG_SPP           0x34
>> +#define PRUSS_CFG_PIN_MX        0x40
>> +
>> +/* PRUSS_GPCFG register bits */
>> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
>> +
>> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
>> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)
> 
> There seems to be some redundancy in the encoding of '20' above.
> I suspect this could be avoided by only defining ..._MASK
> and using it with FIELD_SET() and FIELD_PREP().
> 
>> +
>> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
>> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)
> 
> Perhaps this should be GENMASK(19, 15) ?
> 

yes this should have been GENMASK(15, 19). But this macro is not used anywhere
so I'll just drop it.

>> +
>> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
>> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
>> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)
> 
> Likewise, I suspect the awkwardness of using 0 to mean not BIT 14
> could be avoided through use of FIELD_SET() and FIELD_PREP().
> But maybe it doesn't help.
> 

This Macro is not used anywhere in code. I'll just drop them.

>> +
>> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
>> +
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
>> +

All these above macros are not used anywhere in the driver code. Also in the
planned upcoming driver series, there are no APIs that will use these macros.

I'll be dropping all these redundant macros. The below macros are used in
driver so I'll keep them as it is.

>> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
>> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
>> +
>> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
>> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
>> +
>> +/* PRUSS_MII_RT register bits */
>> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
>> +
>> +/* PRUSS_SPP register bits */
>> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
>> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
>> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
> 
> ...

-- 
Thanks and Regards,
Danish.
