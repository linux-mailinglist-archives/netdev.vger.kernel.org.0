Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7CF6B7055
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCMHvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCMHvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:51:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4354E28D1D;
        Mon, 13 Mar 2023 00:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D295F6112C;
        Mon, 13 Mar 2023 07:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD111C433EF;
        Mon, 13 Mar 2023 07:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678693879;
        bh=W0+XBjv+nrljobq/UfvhL1/USkBrUmYTR01ih/dZaiE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GtNR/gp4Et7JQ19cG1OhxKrtAbSQh4wVdLE9n7Xadw8FH1g9mO+kMMzuFRJaeYCT2
         5UysR6IgAtEBJxhLtn4bk6RFwddPR1wBmdUO2r8znxGPDIRm1FderayEKHCtnYQzMN
         L1+4Lig/toHD9LkYi/NndLSv/NvehyIFe4ehjXrDw06VWreF63O7HNx2FH74hMOUyV
         vxjycwnkGa1hIxmZ2s1oxXFcsNYXi6cuuGU99ypf84PUVugwUETrf/gWC3Bx1QKza8
         wcvWXnchebS6JWMlQTjTCaaBGhie8NWGQ0ihfPGuO2rxF8QfsrVThxxVTvZ+c4AbER
         oH/AFe507pZzw==
Message-ID: <df628a96-1355-2623-d262-187d930794d9@kernel.org>
Date:   Mon, 13 Mar 2023 09:51:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re:
 [PATCH v3 3/6] soc: ti: pruss: Add pruss_cfg_read()/update() API
To:     Md Danish Anwar <a0501179@ti.com>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
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
 <ab595625-d2ad-3f14-737e-748b233d7fe5@ti.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <ab595625-d2ad-3f14-737e-748b233d7fe5@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/03/2023 07:01, Md Danish Anwar wrote:
> Hi Roger
> 
> On 11/03/23 17:36, Roger Quadros wrote:
>> Hi Danish,
>>
>> On 10/03/2023 17:36, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 10/03/23 18:53, Roger Quadros wrote:
>>>> Hi Danish,
>>>>
>>>> On 10/03/2023 13:53, Md Danish Anwar wrote:
>>>>> Hi Roger,
>>>>>
>>>>> On 09/03/23 17:00, Md Danish Anwar wrote:
>>>>>> Hi Roger,
>>>>>>
>>>>>> On 08/03/23 17:12, Roger Quadros wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 08/03/2023 13:36, Md Danish Anwar wrote:
>>>>>>>> Hi Roger,
>>>>>>>>
>>>>>>>> On 08/03/23 13:57, Roger Quadros wrote:
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>>>>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>>>>>>
>>>>>>>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>>>>>>>> the PRUSS platform driver to allow other drivers to read and program
>>>>>>>>>> respectively a register within the PRUSS CFG sub-module represented
>>>>>>>>>> by a syscon driver. This interface provides a simple way for client
>>>>>>>>>
>>>>>>>>> Do you really need these 2 functions to be public?
>>>>>>>>> I see that later patches (4-6) add APIs for doing specific things
>>>>>>>>> and that should be sufficient than exposing entire CFG space via
>>>>>>>>> pruss_cfg_read/update().
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> I think the intention here is to keep this APIs pruss_cfg_read() and
>>>>>>>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>>>>>>>> when needed.
>>>>>>>
>>>>>>> Where are these other drivers? If they don't exist then let's not make provision
>>>>>>> for it now.
>>>>>>> We can provide necessary API helpers when needed instead of letting client drivers
>>>>>>> do what they want as they can be misused and hard to debug.
>>>>>>>
>>>>>>
>>>>>> The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
>>>>>> the series [1]. The ethernet driver series is dependent on this series. In
>>>>>> series [1] we are using pruss_cfg_update() in icssg_config.c file,
>>>>>> icssg_config() API.
>>>>
>>>> You can instead add a new API on what exactly you want it to do rather than exposing
>>>> entire CFG space.
>>>>
>>>
>>> Sure.
>>>
>>> In icssg_config.c, a call to pruss_cfg_update() is made to enable XFR shift for
>>> PRU and RTU,
>>>
>>> 	/* enable XFR shift for PRU and RTU */
>>> 	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
>>> 	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
>>>
>>> I will add the below API as part of Patch 4 of the series. We'll call this API
>>> and entire CFG space will not be exposed.
>>>
>>> /**
>>>  * pruss_cfg_xfr_pru_rtu_enable() - Enable/disable XFR shift for PRU and RTU
>>>  * @pruss: the pruss instance
>>>  * @enable: enable/disable
>>>  *
>>>  * Return: 0 on success, or an error code otherwise
>>>  */
>>> static inline int pruss_cfg_xfr_pru_rtu_enable(struct pruss *pruss, bool enable)
>>> {
>>> 	u32 mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
>>> 	u32 set = enable ? mask : 0;
>>>
>>> 	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
>>> }
>>
>> I would suggest to make separate APIs for PRU XFR vs RTU XFR.
>>
> 
> How about making only one API for XFR shift and passing PRU or RTU as argument
> to the API. The API along with struct pruss and bool enable will take another
> argument u32 mask.
> 
> mask = PRUSS_SPP_XFER_SHIFT_EN for PRU
> mask = PRUSS_SPP_RTU_XFR_SHIFT_EN for RTU
> mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN for PRU and RTU
> 
> So one API will be able to do all three jobs.
> 
> How does this seem?

Yes, that is also fine.

cheers,
-roger
