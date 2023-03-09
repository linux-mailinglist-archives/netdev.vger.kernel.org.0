Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841F26B2310
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjCILbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjCILbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:31:21 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F93241FD;
        Thu,  9 Mar 2023 03:31:18 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 329BV5Fv019998;
        Thu, 9 Mar 2023 05:31:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678361465;
        bh=PVFsQ2KDP+Vkk1afSUgI+AQ9InzXNc5xwXMybxvdwSw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=MpSE924ZKyhRfViXEDZgjXmip4NIjHXb7dNtr/UAvumbyANXqfzWwiXNHn0c44PNW
         C3iDsxSq6EGcmSuHfgZlvlrROAzeALcUC/BGhQDXYzwNST2Zirq4xvMkwGml//wWr9
         o6oYACPa5ylKEz/OMwK+PLsAa7h/IqVLawnUnejw=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 329BV5Ev035566
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 05:31:05 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 05:31:04 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 05:31:04 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 329BUxNf006862;
        Thu, 9 Mar 2023 05:31:00 -0600
Message-ID: <a4395259-9b83-1101-7c4c-d8a36c3600eb@ti.com>
Date:   Thu, 9 Mar 2023 17:00:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v3 3/6] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
Content-Language: en-US
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
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <a74e5079-d89d-2420-b6af-d630c4f04380@kernel.org>
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

Hi Roger,

On 08/03/23 17:12, Roger Quadros wrote:
> 
> 
> On 08/03/2023 13:36, Md Danish Anwar wrote:
>> Hi Roger,
>>
>> On 08/03/23 13:57, Roger Quadros wrote:
>>> Hi,
>>>
>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>> From: Suman Anna <s-anna@ti.com>
>>>>
>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>> the PRUSS platform driver to allow other drivers to read and program
>>>> respectively a register within the PRUSS CFG sub-module represented
>>>> by a syscon driver. This interface provides a simple way for client
>>>
>>> Do you really need these 2 functions to be public?
>>> I see that later patches (4-6) add APIs for doing specific things
>>> and that should be sufficient than exposing entire CFG space via
>>> pruss_cfg_read/update().
>>>
>>>
>>
>> I think the intention here is to keep this APIs pruss_cfg_read() and
>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>> when needed.
> 
> Where are these other drivers? If they don't exist then let's not make provision
> for it now.
> We can provide necessary API helpers when needed instead of letting client drivers
> do what they want as they can be misused and hard to debug.
> 

The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
the series [1]. The ethernet driver series is dependent on this series. In
series [1] we are using pruss_cfg_update() in icssg_config.c file,
icssg_config() API.

So for this, the API pruss_cfg_update() needs to be public.

[1] https://lore.kernel.org/all/20230210114957.2667963-3-danishanwar@ti.com/

>>
>> The later patches (4-6) add APIs to do specific thing, but those APIs also
>> eventually call pruss_cfg_read/update().
> 
> They can still call them but they need to be private to pruss.c
> 
>>
>>>> drivers without having them to include and parse the CFG syscon node
>>>> within their respective device nodes. Various useful registers and
>>>> macros for certain register bit-fields and their values have also
>>>> been added.
>>>>
>>>> It is the responsibility of the client drivers to reconfigure or
>>>> reset a particular register upon any failures.
>>>>
>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>>> ---
>>>>  drivers/soc/ti/pruss.c           |  41 +++++++++++++
>>>>  include/linux/remoteproc/pruss.h | 102 +++++++++++++++++++++++++++++++
>>>>  2 files changed, 143 insertions(+)
>>>>
>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>> index c8053c0d735f..537a3910ffd8 100644
>>>> --- a/drivers/soc/ti/pruss.c
>>>> +++ b/drivers/soc/ti/pruss.c
>>>> @@ -164,6 +164,47 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>>
>>> cheers,
>>> -roger
>>

-- 
Thanks and Regards,
Danish.
