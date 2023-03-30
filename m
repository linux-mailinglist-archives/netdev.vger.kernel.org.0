Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F061F6CFFA4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjC3JRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3JRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:17:23 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ACC65AC;
        Thu, 30 Mar 2023 02:17:21 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32U9HAcS090110;
        Thu, 30 Mar 2023 04:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680167830;
        bh=q503s1OmwI5NFX01PWn7YHe2HcdAMGPDRTIYG6DOStM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=LNmnZr6OUKoNWx0LDhLOhbIDjHTVWpqR+OG3TZN8pwUelwBv0p/KIIrlNFznX97Zp
         Len2sFFggMYQemzd5yr3pRkBVnFha9Y8Akl/KwqaZAqbVioNwygFh83cIp5NdWPHvo
         ZjVD4nbdjghksubb3Wt7DMroZ+Z4PW9lccM0GhTY=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32U9HAMP119164
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Mar 2023 04:17:10 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 30
 Mar 2023 04:17:10 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 30 Mar 2023 04:17:10 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32U9GxX3074655;
        Thu, 30 Mar 2023 04:17:05 -0500
Message-ID: <73422f05-1452-9223-7a54-f4c03394dd05@ti.com>
Date:   Thu, 30 Mar 2023 14:46:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/5] soc: ti: pruss: Add
 pruss_get()/put() API
Content-Language: en-US
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
CC:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <srk@ti.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230323062451.2925996-1-danishanwar@ti.com>
 <20230323062451.2925996-2-danishanwar@ti.com> <20230327205841.GA3158115@p14s>
 <9d4c7762-615b-0fbd-76d2-87156e691928@ti.com>
 <CANLsYkx6Nkrc_qSVWe53bhm9GjTDzXydiaxCB=_nL2R7ppu-qw@mail.gmail.com>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <CANLsYkx6Nkrc_qSVWe53bhm9GjTDzXydiaxCB=_nL2R7ppu-qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/03/23 23:29, Mathieu Poirier wrote:
> On Mon, 27 Mar 2023 at 23:42, Md Danish Anwar <a0501179@ti.com> wrote:
>>
>> Hi Mathieu,
>>
>> On 28/03/23 02:28, Mathieu Poirier wrote:
>>> Hi Danish
>>>
>>> On Thu, Mar 23, 2023 at 11:54:47AM +0530, MD Danish Anwar wrote:
>>>> From: Tero Kristo <t-kristo@ti.com>
>>>>
>>>> Add two new get and put API, pruss_get() and pruss_put() to the
>>>> PRUSS platform driver to allow client drivers to request a handle
>>>> to a PRUSS device. This handle will be used by client drivers to
>>>> request various operations of the PRUSS platform driver through
>>>> additional API that will be added in the following patches.
>>>>
>>>> The pruss_get() function returns the pruss handle corresponding
>>>> to a PRUSS device referenced by a PRU remoteproc instance. The
>>>> pruss_put() is the complimentary function to pruss_get().
>>>>
>>>> Co-developed-by: Suman Anna <s-anna@ti.com>
>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>>> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
>>>> Reviewed-by: Roger Quadros <rogerq@kernel.org>
>>>> ---
>>>>  drivers/remoteproc/pru_rproc.c                |  2 +-
>>>>  drivers/soc/ti/pruss.c                        | 60 ++++++++++++++++++-
>>>>  .../{pruss_driver.h => pruss_internal.h}      |  7 ++-
>>>>  include/linux/remoteproc/pruss.h              | 19 ++++++
>>>>  4 files changed, 83 insertions(+), 5 deletions(-)
>>>>  rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)
>>>>
>>>> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
>>>> index b76db7fa693d..4ddd5854d56e 100644
>>>> --- a/drivers/remoteproc/pru_rproc.c
>>>> +++ b/drivers/remoteproc/pru_rproc.c
>>>> @@ -19,7 +19,7 @@
>>>>  #include <linux/of_device.h>
>>>>  #include <linux/of_irq.h>
>>>>  #include <linux/remoteproc/pruss.h>
>>>> -#include <linux/pruss_driver.h>
>>>> +#include <linux/pruss_internal.h>
>>>>  #include <linux/remoteproc.h>
>>>>
>>>>  #include "remoteproc_internal.h"
>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>> index 6882c86b3ce5..6c2bb02a521d 100644
>>>> --- a/drivers/soc/ti/pruss.c
>>>> +++ b/drivers/soc/ti/pruss.c
>>>> @@ -6,6 +6,7 @@
>>>>   * Author(s):
>>>>   *  Suman Anna <s-anna@ti.com>
>>>>   *  Andrew F. Davis <afd@ti.com>
>>>> + *  Tero Kristo <t-kristo@ti.com>
>>>>   */
>>>>
>>>>  #include <linux/clk-provider.h>
>>>> @@ -16,8 +17,9 @@
>>>>  #include <linux/of_address.h>
>>>>  #include <linux/of_device.h>
>>>>  #include <linux/pm_runtime.h>
>>>> -#include <linux/pruss_driver.h>
>>>> +#include <linux/pruss_internal.h>
>>>>  #include <linux/regmap.h>
>>>> +#include <linux/remoteproc.h>
>>>>  #include <linux/slab.h>
>>>>
>>>>  /**
>>>> @@ -30,6 +32,62 @@ struct pruss_private_data {
>>>>      bool has_core_mux_clock;
>>>>  };
>>>>
>>>> +/**
>>>> + * pruss_get() - get the pruss for a given PRU remoteproc
>>>> + * @rproc: remoteproc handle of a PRU instance
>>>> + *
>>>> + * Finds the parent pruss device for a PRU given the @rproc handle of the
>>>> + * PRU remote processor. This function increments the pruss device's refcount,
>>>> + * so always use pruss_put() to decrement it back once pruss isn't needed
>>>> + * anymore.
>>>> + *
>>>> + * Return: pruss handle on success, and an ERR_PTR on failure using one
>>>> + * of the following error values
>>>> + *    -EINVAL if invalid parameter
>>>> + *    -ENODEV if PRU device or PRUSS device is not found
>>>> + */
>>>> +struct pruss *pruss_get(struct rproc *rproc)
>>>> +{
>>>> +    struct pruss *pruss;
>>>> +    struct device *dev;
>>>> +    struct platform_device *ppdev;
>>>> +
>>>> +    if (IS_ERR_OR_NULL(rproc))
>>>> +            return ERR_PTR(-EINVAL);
>>>> +
>>>
>>> There is no guarantee that @rproc is valid without calling rproc_get_by_handle()
>>> or pru_rproc_get().
>>>
>>
>> Here in this API, we are checking if rproc is NULL or not. Also we are checking
>> is_pru_rproc() to make sure this rproc is pru-rproc only and not some other rproc.
>>
>> This API will be called from driver (icssg_prueth.c) which I'll post once this
>> series is merged.
>>
>> In the driver we are doing,
>>
>>         prueth->pru[slice] = pru_rproc_get(np, pru, &pruss_id);
>>
>>         pruss = pruss_get(prueth->pru[slice]);
>>
>> So, before calling pruss_get() we are in fact calling pru_rproc_get() to make
>> sure it's a valid rproc.
>>
> 
> You are doing the right thing but because pruss_get() is exported
> globally, other people eventually using the interface may not be so
> rigorous.  Add a comment to the pruss_get() function documentation
> clearly mentioning it is expected the caller will have done a
> pru_rproc_get() on @rproc.
> 

Sure, Mathieu. I will add the required comment in pruss_get() documentation.

>> I think in this API, these two checks (NULL check and is_pru_rproc) should be
>> OK as the driver is already calling pru_rproc_get() before this API.
>>
>> The only way to get a "pru-rproc" is by calling pru_rproc_get(), now the check
>> is_pru_rproc() will only be true if it is a "pru-rproc" implying
>> pru_rproc_get() was called before calling this API.
>>
>> Please let me know if this is OK or if any change is required.
>>
>>>> +    dev = &rproc->dev;
>>>> +
>>>> +    /* make sure it is PRU rproc */
>>>> +    if (!dev->parent || !is_pru_rproc(dev->parent))
>>>> +            return ERR_PTR(-ENODEV);
>>>> +
>>>> +    ppdev = to_platform_device(dev->parent->parent);
>>>> +    pruss = platform_get_drvdata(ppdev);
>>>> +    if (!pruss)
>>>> +            return ERR_PTR(-ENODEV);
>>>> +
>>>> +    get_device(pruss->dev);
>>>> +
>>>> +    return pruss;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(pruss_get);
>>>> +
>>>> +/**
>>>> + * pruss_put() - decrement pruss device's usecount
>>>> + * @pruss: pruss handle
>>>> + *
>>>> + * Complimentary function for pruss_get(). Needs to be called
>>>> + * after the PRUSS is used, and only if the pruss_get() succeeds.
>>>> + */
>>>> +void pruss_put(struct pruss *pruss)
>>>> +{
>>>> +    if (IS_ERR_OR_NULL(pruss))
>>>> +            return;
>>>> +
>>>> +    put_device(pruss->dev);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(pruss_put);
>>>> +
>>>>  static void pruss_of_free_clk_provider(void *data)
>>>>  {
>>>>      struct device_node *clk_mux_np = data;
>>>> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_internal.h
>>>> similarity index 90%
>>>> rename from include/linux/pruss_driver.h
>>>> rename to include/linux/pruss_internal.h
>>>> index ecfded30ed05..8f91cb164054 100644
>>>> --- a/include/linux/pruss_driver.h
>>>> +++ b/include/linux/pruss_internal.h
>>>> @@ -6,9 +6,10 @@
>>>>   *  Suman Anna <s-anna@ti.com>
>>>>   */
>>>>
>>>> -#ifndef _PRUSS_DRIVER_H_
>>>> -#define _PRUSS_DRIVER_H_
>>>> +#ifndef _PRUSS_INTERNAL_H_
>>>> +#define _PRUSS_INTERNAL_H_
>>>>
>>>> +#include <linux/remoteproc/pruss.h>
>>>>  #include <linux/types.h>
>>>>
>>>>  /*
>>>> @@ -51,4 +52,4 @@ struct pruss {
>>>>      struct clk *iep_clk_mux;
>>>>  };
>>>>
>>>> -#endif      /* _PRUSS_DRIVER_H_ */
>>>> +#endif      /* _PRUSS_INTERNAL_H_ */
>>>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>>>> index 039b50d58df2..93a98cac7829 100644
>>>> --- a/include/linux/remoteproc/pruss.h
>>>> +++ b/include/linux/remoteproc/pruss.h
>>>> @@ -4,12 +4,14 @@
>>>>   *
>>>>   * Copyright (C) 2015-2022 Texas Instruments Incorporated - http://www.ti.com
>>>>   *  Suman Anna <s-anna@ti.com>
>>>> + *  Tero Kristo <t-kristo@ti.com>
>>>>   */
>>>>
>>>>  #ifndef __LINUX_PRUSS_H
>>>>  #define __LINUX_PRUSS_H
>>>>
>>>>  #include <linux/device.h>
>>>> +#include <linux/err.h>
>>>>  #include <linux/types.h>
>>>>
>>>>  #define PRU_RPROC_DRVNAME "pru-rproc"
>>>> @@ -44,6 +46,23 @@ enum pru_ctable_idx {
>>>>
>>>>  struct device_node;
>>>>  struct rproc;
>>>> +struct pruss;
>>>> +
>>>> +#if IS_ENABLED(CONFIG_TI_PRUSS)
>>>> +
>>>> +struct pruss *pruss_get(struct rproc *rproc);
>>>> +void pruss_put(struct pruss *pruss);
>>>> +
>>>> +#else
>>>> +
>>>> +static inline struct pruss *pruss_get(struct rproc *rproc)
>>>> +{
>>>> +    return ERR_PTR(-EOPNOTSUPP);
>>>> +}
>>>> +
>>>> +static inline void pruss_put(struct pruss *pruss) { }
>>>> +
>>>> +#endif /* CONFIG_TI_PRUSS */
>>>>
>>>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
>>>>
>>>> --
>>>> 2.25.1
>>>>
>>
>> --
>> Thanks and Regards,
>> Danish.

-- 
Thanks and Regards,
Danish.
