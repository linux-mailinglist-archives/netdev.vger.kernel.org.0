Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359846B6EA3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 06:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCMFBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 01:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCMFB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 01:01:29 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979CF43935;
        Sun, 12 Mar 2023 22:01:26 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32D51A6G041004;
        Mon, 13 Mar 2023 00:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678683670;
        bh=7YNQsJHAcjBomy56+HsztQEPct9ELDRVhRmdwFoUaVA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=IVfaqIEuFqKm6F9UDDYv4RqGBoAZhBuEiKoTsoHv/BmDUpJWzsdVNgSMEVzVeA0Wb
         qoBoiYI1T5nGZaHDwPv5nG3Jqzxm6xCg2+pFT0ssXO80Au3nWGhNjGIxVy+ePcEO44
         T5a0e+6ovmyvwQf/ph9ua+CK0ZhTz1DWIEN9/fLg=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32D51A0h032628
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Mar 2023 00:01:10 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 13
 Mar 2023 00:01:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 13 Mar 2023 00:01:09 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32D514Sm113061;
        Mon, 13 Mar 2023 00:01:05 -0500
Message-ID: <ab595625-d2ad-3f14-737e-748b233d7fe5@ti.com>
Date:   Mon, 13 Mar 2023 10:31:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re:
 [PATCH v3 3/6] soc: ti: pruss: Add pruss_cfg_read()/update() API
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
 <1c1e67fd-1eaa-30f5-8b2a-41a7e3ff664a@ti.com>
 <ba703ed6-e91d-5128-f1a4-1667125c531e@kernel.org>
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <ba703ed6-e91d-5128-f1a4-1667125c531e@kernel.org>
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

Hi Roger

On 11/03/23 17:36, Roger Quadros wrote:
> Hi Danish,
> 
> On 10/03/2023 17:36, Md Danish Anwar wrote:
>> Hi Roger,
>>
>> On 10/03/23 18:53, Roger Quadros wrote:
>>> Hi Danish,
>>>
>>> On 10/03/2023 13:53, Md Danish Anwar wrote:
>>>> Hi Roger,
>>>>
>>>> On 09/03/23 17:00, Md Danish Anwar wrote:
>>>>> Hi Roger,
>>>>>
>>>>> On 08/03/23 17:12, Roger Quadros wrote:
>>>>>>
>>>>>>
>>>>>> On 08/03/2023 13:36, Md Danish Anwar wrote:
>>>>>>> Hi Roger,
>>>>>>>
>>>>>>> On 08/03/23 13:57, Roger Quadros wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>>>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>>>>>
>>>>>>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>>>>>>> the PRUSS platform driver to allow other drivers to read and program
>>>>>>>>> respectively a register within the PRUSS CFG sub-module represented
>>>>>>>>> by a syscon driver. This interface provides a simple way for client
>>>>>>>>
>>>>>>>> Do you really need these 2 functions to be public?
>>>>>>>> I see that later patches (4-6) add APIs for doing specific things
>>>>>>>> and that should be sufficient than exposing entire CFG space via
>>>>>>>> pruss_cfg_read/update().
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> I think the intention here is to keep this APIs pruss_cfg_read() and
>>>>>>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>>>>>>> when needed.
>>>>>>
>>>>>> Where are these other drivers? If they don't exist then let's not make provision
>>>>>> for it now.
>>>>>> We can provide necessary API helpers when needed instead of letting client drivers
>>>>>> do what they want as they can be misused and hard to debug.
>>>>>>
>>>>>
>>>>> The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
>>>>> the series [1]. The ethernet driver series is dependent on this series. In
>>>>> series [1] we are using pruss_cfg_update() in icssg_config.c file,
>>>>> icssg_config() API.
>>>
>>> You can instead add a new API on what exactly you want it to do rather than exposing
>>> entire CFG space.
>>>
>>
>> Sure.
>>
>> In icssg_config.c, a call to pruss_cfg_update() is made to enable XFR shift for
>> PRU and RTU,
>>
>> 	/* enable XFR shift for PRU and RTU */
>> 	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
>> 	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
>>
>> I will add the below API as part of Patch 4 of the series. We'll call this API
>> and entire CFG space will not be exposed.
>>
>> /**
>>  * pruss_cfg_xfr_pru_rtu_enable() - Enable/disable XFR shift for PRU and RTU
>>  * @pruss: the pruss instance
>>  * @enable: enable/disable
>>  *
>>  * Return: 0 on success, or an error code otherwise
>>  */
>> static inline int pruss_cfg_xfr_pru_rtu_enable(struct pruss *pruss, bool enable)
>> {
>> 	u32 mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
>> 	u32 set = enable ? mask : 0;
>>
>> 	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
>> }
> 
> I would suggest to make separate APIs for PRU XFR vs RTU XFR.
> 

How about making only one API for XFR shift and passing PRU or RTU as argument
to the API. The API along with struct pruss and bool enable will take another
argument u32 mask.

mask = PRUSS_SPP_XFER_SHIFT_EN for PRU
mask = PRUSS_SPP_RTU_XFR_SHIFT_EN for RTU
mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN for PRU and RTU

So one API will be able to do all three jobs.

How does this seem?

>>
>> To make pruss_cfg_update() and pruss_cfg_read() API internal to pruss.c, I will
>> add the below change to pruss.h file and pruss.c file. Let me know if this
>> change looks okay to you.
>>
>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>
>> index 537a3910ffd8..9f01c8809deb 100644
>>
>> --- a/drivers/soc/ti/pruss.c
>>
>> +++ b/drivers/soc/ti/pruss.c
>>
>> @@ -182,7 +182,6 @@ int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
>> unsigned int *val)
> 
> Need to declare this as 'static'.
> 
>>
>>
>>
>>         return regmap_read(pruss->cfg_regmap, reg, val);
>>
>>  }
>>
>> -EXPORT_SYMBOL_GPL(pruss_cfg_read);
>>
>>
>>
>>  /**
>>
>>   * pruss_cfg_update() - configure a PRUSS CFG sub-module register
>>
>> @@ -203,7 +202,6 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> 
> this as well.
> 
>>
>>
>>
>>         return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>>
>>  }
>>
>> -EXPORT_SYMBOL_GPL(pruss_cfg_update);
>>
>>
>>
>>  static void pruss_of_free_clk_provider(void *data)
>>
>>  {
>>
>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>>
>> index d41bec448f06..12ef10b9fe9a 100644
>>
>> --- a/include/linux/remoteproc/pruss.h
>>
>> +++ b/include/linux/remoteproc/pruss.h
>>
>> @@ -165,9 +165,6 @@ int pruss_request_mem_region(struct pruss *pruss, enum
>> pruss_mem mem_id,
>>
>>                              struct pruss_mem_region *region);
>>
>>  int pruss_release_mem_region(struct pruss *pruss,
>>
>>                              struct pruss_mem_region *region);
>>
>> -int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);
>>
>> -int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>
>> -                    unsigned int mask, unsigned int val);
>>
>>
>>
>>  #else
>>
>>
>>
>> @@ -191,18 +188,6 @@ static inline int pruss_release_mem_region(struct pruss
>> *pruss,
>>
>>         return -EOPNOTSUPP;
>>
>>  }
>>
>>
>>
>> -static inline int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
>>
>> -                                unsigned int *val)
>>
>> -{
>>
>> -       return -EOPNOTSUPP;
>>
>> -}
>>
>> -
>>
>> -static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>>
>> -                                  unsigned int mask, unsigned int val)
>>
>> -{
>>
>> -       return -EOPNOTSUPP;
>>
>> -}
>>
>> -
>>
>>  #endif /* CONFIG_TI_PRUSS */
>>
>>
>>
>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>>
>>
>> Please have a look and let me know if above API and code changes looks OK to you.
>>
> 
> Rest looks OK.
> 
> cheers,
> -roger

-- 
Thanks and Regards,
Danish.
