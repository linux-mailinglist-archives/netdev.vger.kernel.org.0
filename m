Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A693C6B4B87
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbjCJPrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCJPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:46:49 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FF4146260;
        Fri, 10 Mar 2023 07:36:36 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32AFaReT044993;
        Fri, 10 Mar 2023 09:36:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678462587;
        bh=2jS4m1hfS5ZhsM5/IeDXWXfR6o0Vi1UQwqVeeLivIxE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=BOODLewz62gp5gwDnks7ntrRoM4JgqiTTY1m1HL/qZ5qfaWhRBJi0k78aUdMLYQiP
         z5b2lkzuS2G6BilU8Dxlyn+HT74KUGySfGdjn+ZIQ5KjBztrKAoioHg2B0hrxYSYD8
         DIqNN/ekY+3UsA2TT9D3a5iT8K2sa51c3hUCkOt8=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32AFaQUa117350
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Mar 2023 09:36:26 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 10
 Mar 2023 09:36:26 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 10 Mar 2023 09:36:26 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32AFaLdT113550;
        Fri, 10 Mar 2023 09:36:22 -0600
Message-ID: <1c1e67fd-1eaa-30f5-8b2a-41a7e3ff664a@ti.com>
Date:   Fri, 10 Mar 2023 21:06:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v3 3/6] soc:
 ti: pruss: Add pruss_cfg_read()/update() API
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
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-4-danishanwar@ti.com>
 <7076208d-7dca-6980-5399-498e55648740@kernel.org>
 <afd6cd8a-8ba7-24b2-d7fc-c25a9c5f3c42@ti.com>
 <a74e5079-d89d-2420-b6af-d630c4f04380@kernel.org>
 <a4395259-9b83-1101-7c4c-d8a36c3600eb@ti.com>
 <367f6b50-e4cc-c3eb-e8e9-dabd4e044530@ti.com>
 <46415d8e-3c92-d489-3f44-01a586160082@kernel.org>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <46415d8e-3c92-d489-3f44-01a586160082@kernel.org>
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

Hi Roger,

On 10/03/23 18:53, Roger Quadros wrote:
> Hi Danish,
> 
> On 10/03/2023 13:53, Md Danish Anwar wrote:
>> Hi Roger,
>>
>> On 09/03/23 17:00, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 08/03/23 17:12, Roger Quadros wrote:
>>>>
>>>>
>>>> On 08/03/2023 13:36, Md Danish Anwar wrote:
>>>>> Hi Roger,
>>>>>
>>>>> On 08/03/23 13:57, Roger Quadros wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>>>
>>>>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>>>>> the PRUSS platform driver to allow other drivers to read and program
>>>>>>> respectively a register within the PRUSS CFG sub-module represented
>>>>>>> by a syscon driver. This interface provides a simple way for client
>>>>>>
>>>>>> Do you really need these 2 functions to be public?
>>>>>> I see that later patches (4-6) add APIs for doing specific things
>>>>>> and that should be sufficient than exposing entire CFG space via
>>>>>> pruss_cfg_read/update().
>>>>>>
>>>>>>
>>>>>
>>>>> I think the intention here is to keep this APIs pruss_cfg_read() and
>>>>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>>>>> when needed.
>>>>
>>>> Where are these other drivers? If they don't exist then let's not make provision
>>>> for it now.
>>>> We can provide necessary API helpers when needed instead of letting client drivers
>>>> do what they want as they can be misused and hard to debug.
>>>>
>>>
>>> The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
>>> the series [1]. The ethernet driver series is dependent on this series. In
>>> series [1] we are using pruss_cfg_update() in icssg_config.c file,
>>> icssg_config() API.
> 
> You can instead add a new API on what exactly you want it to do rather than exposing
> entire CFG space.
> 

Sure.

In icssg_config.c, a call to pruss_cfg_update() is made to enable XFR shift for
PRU and RTU,

	/* enable XFR shift for PRU and RTU */
	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);

I will add the below API as part of Patch 4 of the series. We'll call this API
and entire CFG space will not be exposed.

/**
 * pruss_cfg_xfr_pru_rtu_enable() - Enable/disable XFR shift for PRU and RTU
 * @pruss: the pruss instance
 * @enable: enable/disable
 *
 * Return: 0 on success, or an error code otherwise
 */
static inline int pruss_cfg_xfr_pru_rtu_enable(struct pruss *pruss, bool enable)
{
	u32 mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
	u32 set = enable ? mask : 0;

	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
}

To make pruss_cfg_update() and pruss_cfg_read() API internal to pruss.c, I will
add the below change to pruss.h file and pruss.c file. Let me know if this
change looks okay to you.

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c

index 537a3910ffd8..9f01c8809deb 100644

--- a/drivers/soc/ti/pruss.c

+++ b/drivers/soc/ti/pruss.c

@@ -182,7 +182,6 @@ int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
unsigned int *val)



        return regmap_read(pruss->cfg_regmap, reg, val);

 }

-EXPORT_SYMBOL_GPL(pruss_cfg_read);



 /**

  * pruss_cfg_update() - configure a PRUSS CFG sub-module register

@@ -203,7 +202,6 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,



        return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);

 }

-EXPORT_SYMBOL_GPL(pruss_cfg_update);



 static void pruss_of_free_clk_provider(void *data)

 {

diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h

index d41bec448f06..12ef10b9fe9a 100644

--- a/include/linux/remoteproc/pruss.h

+++ b/include/linux/remoteproc/pruss.h

@@ -165,9 +165,6 @@ int pruss_request_mem_region(struct pruss *pruss, enum
pruss_mem mem_id,

                             struct pruss_mem_region *region);

 int pruss_release_mem_region(struct pruss *pruss,

                             struct pruss_mem_region *region);

-int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);

-int pruss_cfg_update(struct pruss *pruss, unsigned int reg,

-                    unsigned int mask, unsigned int val);



 #else



@@ -191,18 +188,6 @@ static inline int pruss_release_mem_region(struct pruss
*pruss,

        return -EOPNOTSUPP;

 }



-static inline int pruss_cfg_read(struct pruss *pruss, unsigned int reg,

-                                unsigned int *val)

-{

-       return -EOPNOTSUPP;

-}

-

-static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,

-                                  unsigned int mask, unsigned int val)

-{

-       return -EOPNOTSUPP;

-}

-

 #endif /* CONFIG_TI_PRUSS */



 #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)


Please have a look and let me know if above API and code changes looks OK to you.

>>>
>>> So for this, the API pruss_cfg_update() needs to be public.
>>>
>>> [1] https://lore.kernel.org/all/20230210114957.2667963-3-danishanwar@ti.com/
>>>
>>
>> I will keep this patch as it is as pruss_cfg_update() needs to be public for
>> ICSSG Ethernet driver and pruss_cfg_read() is kind of a complementary function
>> to update. I will do required changes in other patches and send next revision
>> if that's OK with you. Please let me know.
>>
>>>>>
>>>>> The later patches (4-6) add APIs to do specific thing, but those APIs also
>>>>> eventually call pruss_cfg_read/update().
>>>>
>>>> They can still call them but they need to be private to pruss.c
>>>>
>>>>>
>>>>>>> drivers without having them to include and parse the CFG syscon node
>>>>>>> within their respective device nodes. Various useful registers and
>>>>>>> macros for certain register bit-fields and their values have also
>>>>>>> been added.
>>>>>>>
>>>>>>> It is the responsibility of the client drivers to reconfigure or
>>>>>>> reset a particular register upon any failures.
>>>>>>>
>>>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>>>>>> ---
>>>>>>>  drivers/soc/ti/pruss.c           |  41 +++++++++++++
>>>>>>>  include/linux/remoteproc/pruss.h | 102 +++++++++++++++++++++++++++++++
>>>>>>>  2 files changed, 143 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>>>>> index c8053c0d735f..537a3910ffd8 100644
>>>>>>> --- a/drivers/soc/ti/pruss.c
>>>>>>> +++ b/drivers/soc/ti/pruss.c
>>>>>>> @@ -164,6 +164,47 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>>>>>
> 
> cheers,
> -roger

-- 
Thanks and Regards,
Danish.
