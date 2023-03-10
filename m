Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2249E6B3E73
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCJLyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCJLyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:54:03 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7450AC2237;
        Fri, 10 Mar 2023 03:54:00 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32ABro76127449;
        Fri, 10 Mar 2023 05:53:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678449230;
        bh=QSIrK2hf0RVPY4b/FgB+Q97RERaUbLYuYjYCaB2CdYQ=;
        h=Date:Subject:From:To:CC:References:In-Reply-To;
        b=USybG5S2djIhE2wGOt/XlHuHsO3yvv7Mxug4un46WUoMCM+2BK8kU+nJm28KePPeR
         0QYi884r64b+bJo6keFHmWj6YHAcQvcr7aCB9tzjNQnyKZNp3aq6a+l8nxiQebyHr6
         H3XE4NII6n3IBMG9S7N3C3sFtD5GnOB57F4Se5Eo=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32ABronN096866
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Mar 2023 05:53:50 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 10
 Mar 2023 05:53:50 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 10 Mar 2023 05:53:50 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32ABrj67017278;
        Fri, 10 Mar 2023 05:53:45 -0600
Message-ID: <367f6b50-e4cc-c3eb-e8e9-dabd4e044530@ti.com>
Date:   Fri, 10 Mar 2023 17:23:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v3 3/6] soc: ti: pruss: Add
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
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-4-danishanwar@ti.com>
 <7076208d-7dca-6980-5399-498e55648740@kernel.org>
 <afd6cd8a-8ba7-24b2-d7fc-c25a9c5f3c42@ti.com>
 <a74e5079-d89d-2420-b6af-d630c4f04380@kernel.org>
 <a4395259-9b83-1101-7c4c-d8a36c3600eb@ti.com>
Organization: Texas Instruments
In-Reply-To: <a4395259-9b83-1101-7c4c-d8a36c3600eb@ti.com>
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

On 09/03/23 17:00, Md Danish Anwar wrote:
> Hi Roger,
> 
> On 08/03/23 17:12, Roger Quadros wrote:
>>
>>
>> On 08/03/2023 13:36, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 08/03/23 13:57, Roger Quadros wrote:
>>>> Hi,
>>>>
>>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>
>>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>>> the PRUSS platform driver to allow other drivers to read and program
>>>>> respectively a register within the PRUSS CFG sub-module represented
>>>>> by a syscon driver. This interface provides a simple way for client
>>>>
>>>> Do you really need these 2 functions to be public?
>>>> I see that later patches (4-6) add APIs for doing specific things
>>>> and that should be sufficient than exposing entire CFG space via
>>>> pruss_cfg_read/update().
>>>>
>>>>
>>>
>>> I think the intention here is to keep this APIs pruss_cfg_read() and
>>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>>> when needed.
>>
>> Where are these other drivers? If they don't exist then let's not make provision
>> for it now.
>> We can provide necessary API helpers when needed instead of letting client drivers
>> do what they want as they can be misused and hard to debug.
>>
> 
> The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
> the series [1]. The ethernet driver series is dependent on this series. In
> series [1] we are using pruss_cfg_update() in icssg_config.c file,
> icssg_config() API.
> 
> So for this, the API pruss_cfg_update() needs to be public.
> 
> [1] https://lore.kernel.org/all/20230210114957.2667963-3-danishanwar@ti.com/
> 

I will keep this patch as it is as pruss_cfg_update() needs to be public for
ICSSG Ethernet driver and pruss_cfg_read() is kind of a complementary function
to update. I will do required changes in other patches and send next revision
if that's OK with you. Please let me know.

>>>
>>> The later patches (4-6) add APIs to do specific thing, but those APIs also
>>> eventually call pruss_cfg_read/update().
>>
>> They can still call them but they need to be private to pruss.c
>>
>>>
>>>>> drivers without having them to include and parse the CFG syscon node
>>>>> within their respective device nodes. Various useful registers and
>>>>> macros for certain register bit-fields and their values have also
>>>>> been added.
>>>>>
>>>>> It is the responsibility of the client drivers to reconfigure or
>>>>> reset a particular register upon any failures.
>>>>>
>>>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>>>> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
>>>>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>>>>> ---
>>>>>  drivers/soc/ti/pruss.c           |  41 +++++++++++++
>>>>>  include/linux/remoteproc/pruss.h | 102 +++++++++++++++++++++++++++++++
>>>>>  2 files changed, 143 insertions(+)
>>>>>
>>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>>> index c8053c0d735f..537a3910ffd8 100644
>>>>> --- a/drivers/soc/ti/pruss.c
>>>>> +++ b/drivers/soc/ti/pruss.c
>>>>> @@ -164,6 +164,47 @@ int pruss_release_mem_region(struct pruss *pruss,
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(pruss_release_mem_region);
>>>>
>>>> cheers,
>>>> -roger
>>>
> 

-- 
Thanks and Regards,
Danish.
