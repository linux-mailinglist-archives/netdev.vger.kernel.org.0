Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D101A6BCE32
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjCPLad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCPLaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:30:09 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E277B9506;
        Thu, 16 Mar 2023 04:30:03 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32GBTsUk079250;
        Thu, 16 Mar 2023 06:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678966194;
        bh=vsLT/SA0q3vJadiP5dGVnj0Uw+vIHx49mLDPRkaN43M=;
        h=Date:Subject:From:To:CC:References:In-Reply-To;
        b=t/jaOZ2DVJs/LE79ksyHKct4jTZVDDK6kIzZoUS0ShiRP/MXjBmkCBe3kLTm4Sxj8
         nN/qfjTS2aG3iGlac8Iq+e43wMyxIcIuTA5mCRu9zdE+x0jC+HC3HlOyjDwm8Pbv8U
         MwYqSAHqSw/+UB2hoH45aR6JvjMpCAqSg9OmAHrk=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32GBTsAC077054
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Mar 2023 06:29:54 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 16
 Mar 2023 06:29:54 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 16 Mar 2023 06:29:54 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32GBTnSO028548;
        Thu, 16 Mar 2023 06:29:50 -0500
Message-ID: <a3e26ef1-b7e7-f6da-94ff-4a8bf80649f6@ti.com>
Date:   Thu, 16 Mar 2023 16:59:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [PATCH v4 3/5] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
To:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
CC:     <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-4-danishanwar@ti.com>
 <91481d4f-2005-7b33-d3be-df09b7d27ef6@kernel.org>
 <c52ae883-b0c9-8f92-98ae-fb9e9ad30420@ti.com>
Organization: Texas Instruments
In-Reply-To: <c52ae883-b0c9-8f92-98ae-fb9e9ad30420@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roger,

On 16/03/23 16:38, Md Danish Anwar wrote:
> 
> On 15/03/23 17:37, Roger Quadros wrote:
>> Danish,
>>
>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>> From: Suman Anna <s-anna@ti.com>
>>>
>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>> the PRUSS platform driver to read and program respectively a register
>>> within the PRUSS CFG sub-module represented by a syscon driver.
>>>
>>> These APIs are internal to PRUSS driver. Various useful registers
>>> and macros for certain register bit-fields and their values have also
>>> been added.
>>>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>>> ---
>>>  drivers/soc/ti/pruss.c           | 39 ++++++++++++++
>>>  include/linux/remoteproc/pruss.h | 87 ++++++++++++++++++++++++++++++++
>>>  2 files changed, 126 insertions(+)
>>>
>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>> index c8053c0d735f..26d8129b515c 100644
>>> --- a/drivers/soc/ti/pruss.c
>>> +++ b/drivers/soc/ti/pruss.c
>>> @@ -164,6 +164,45 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>  }
>>>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>>  
>>> +/**
>>> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
>>> + * @pruss: the pruss instance handle
>>> + * @reg: register offset within the CFG sub-module
>>> + * @val: pointer to return the value in
>>> + *
>>> + * Reads a given register within the PRUSS CFG sub-module and
>>> + * returns it through the passed-in @val pointer
>>> + *
>>> + * Return: 0 on success, or an error code otherwise
>>> + */
>>> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val)
>>> +{
>>> +	if (IS_ERR_OR_NULL(pruss))
>>> +		return -EINVAL;
>>> +
>>> +	return regmap_read(pruss->cfg_regmap, reg, val);
>>> +}
>>> +
>>> +/**
>>> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
>>> + * @pruss: the pruss instance handle
>>> + * @reg: register offset within the CFG sub-module
>>> + * @mask: bit mask to use for programming the @val
>>> + * @val: value to write
>>> + *
>>> + * Programs a given register within the PRUSS CFG sub-module
>>> + *
>>> + * Return: 0 on success, or an error code otherwise
>>> + */
>>> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>> +			    unsigned int mask, unsigned int val)
>>> +{
>>> +	if (IS_ERR_OR_NULL(pruss))
>>> +		return -EINVAL;
>>> +
>>> +	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>>> +}
>>> +
>>>  static void pruss_of_free_clk_provider(void *data)
>>>  {
>>>  	struct device_node *clk_mux_np = data;
>>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>>> index 33f930e0a0ce..12ef10b9fe9a 100644
>>> --- a/include/linux/remoteproc/pruss.h
>>> +++ b/include/linux/remoteproc/pruss.h
>>> @@ -10,12 +10,99 @@
>>>  #ifndef __LINUX_PRUSS_H
>>>  #define __LINUX_PRUSS_H
>>>  
>>> +#include <linux/bits.h>
>>>  #include <linux/device.h>
>>>  #include <linux/err.h>
>>>  #include <linux/types.h>
>>>  
>>>  #define PRU_RPROC_DRVNAME "pru-rproc"
>>>  
>>> +/*
>>> + * PRU_ICSS_CFG registers
>>> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
>>> + */
>>> +#define PRUSS_CFG_REVID		0x00
>>> +#define PRUSS_CFG_SYSCFG	0x04
>>> +#define PRUSS_CFG_GPCFG(x)	(0x08 + (x) * 4)
>>> +#define PRUSS_CFG_CGR		0x10
>>> +#define PRUSS_CFG_ISRP		0x14
>>> +#define PRUSS_CFG_ISP		0x18
>>> +#define PRUSS_CFG_IESP		0x1C
>>> +#define PRUSS_CFG_IECP		0x20
>>> +#define PRUSS_CFG_SCRP		0x24
>>> +#define PRUSS_CFG_PMAO		0x28
>>> +#define PRUSS_CFG_MII_RT	0x2C
>>> +#define PRUSS_CFG_IEPCLK	0x30
>>> +#define PRUSS_CFG_SPP		0x34
>>> +#define PRUSS_CFG_PIN_MX	0x40
>>> +
>>> +/* PRUSS_GPCFG register bits */
>>> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL		BIT(25)
>>> +
>>> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT		20
>>> +#define PRUSS_GPCFG_PRU_DIV1_MASK		GENMASK(24, 20)
>>> +
>>> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT		15
>>> +#define PRUSS_GPCFG_PRU_DIV0_MASK		GENMASK(15, 19)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE		BIT(14)
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT		0
>>> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL		BIT(14)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_SB			BIT(13)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT		8
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK		GENMASK(12, 8)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT		3
>>> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK		GENMASK(7, 3)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE	0
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE	BIT(2)
>>> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE		BIT(2)
>>> +
>>> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK		GENMASK(1, 0)
>>> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT		0
>>> +
>>> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT		26
>>> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK		GENMASK(29, 26)
>>> +
>>> +/* PRUSS_MII_RT register bits */
>>> +#define PRUSS_MII_RT_EVENT_EN			BIT(0)
>>> +
>>> +/* PRUSS_SPP register bits */
>>> +#define PRUSS_SPP_XFER_SHIFT_EN			BIT(1)
>>> +#define PRUSS_SPP_PRU1_PAD_HP_EN		BIT(0)
>>
>> Can we please move all the above definitions to private driver/soc/ti/pruss.h?
>> You can also add pruss_cfg_read and pruss_cfg_update there.
>>

There is no driver/soc/ti/pruss.h. The pruss.h file is located in
include/linux/remoteproc/pruss.h and there is one pruss_driver.h file which is
located in include/linux/pruss_driver.h

Do you want me to create another header file at driver/soc/ti/pruss.h and place
all these definitions inside that?

Please let me know.

> 
> Sure Roger, I'll move all these definitions to pruss.h
> 
>>> +
>>> +/*
>>> + * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
>>> + * PRUSS_GPCFG0/1 registers
>>> + *
>>> + * NOTE: The below defines are the most common values, but there
>>> + * are some exceptions like on 66AK2G, where the RESERVED and MII2
>>> + * values are interchanged. Also, this bit-field does not exist on
>>> + * AM335x SoCs
>>> + */
>>> +enum pruss_gp_mux_sel {
>>> +	PRUSS_GP_MUX_SEL_GP = 0,
>>> +	PRUSS_GP_MUX_SEL_ENDAT,
>>> +	PRUSS_GP_MUX_SEL_RESERVED,
>>> +	PRUSS_GP_MUX_SEL_SD,
>>> +	PRUSS_GP_MUX_SEL_MII2,
>>> +	PRUSS_GP_MUX_SEL_MAX,
>>> +};
>>> +
>>> +/*
>>> + * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
>>> + *			 to program the PRUSS_GPCFG0/1 registers
>>> + */
>>> +enum pruss_gpi_mode {
>>> +	PRUSS_GPI_MODE_DIRECT = 0,
>>> +	PRUSS_GPI_MODE_PARALLEL,
>>> +	PRUSS_GPI_MODE_28BIT_SHIFT,
>>> +	PRUSS_GPI_MODE_MII,
>>> +};
>>> +
>>>  /**
>>>   * enum pruss_pru_id - PRU core identifiers
>>>   * @PRUSS_PRU0: PRU Core 0.
>>
>> cheers,
>> -roger
> 

-- 
Thanks and Regards,
Danish.
