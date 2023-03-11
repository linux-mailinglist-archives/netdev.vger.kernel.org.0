Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB36B5B73
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 13:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCKMHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 07:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCKMHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 07:07:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751A411F631;
        Sat, 11 Mar 2023 04:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45C45B8253D;
        Sat, 11 Mar 2023 12:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BDEC433D2;
        Sat, 11 Mar 2023 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678536414;
        bh=2M+sg4TU2SXNAZOw21xnHl7W71SdvtY6IWxfePY4G4c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mWnRud+y6Xx+7VXOUE0VSvOWleJ52YqCdyFoNPMnlEbzKPyWh3ZNebH0uIQvhIClQ
         NNPl7o1KAy4FPoNeuQuyio5eEP2MEnwT3xZIgoYxvGx2a/6hwOT89zdBvjcHyyzs64
         qv6sYz42vaPkmT/9UKACcgkfQ5f4JgtJmvkvJ5koSHZTy5ZPN+S39Qmojjx1dDO/fG
         fCEIbjExIGjh41wbXHolYQUUqCLxOpDhJ6f+pr8+VV2PXFmr3fhWKsifVfT06AAWG7
         jN5XsRr5rjF/kNp6KdGpnxs1UHwtRgD+SHhualNesP8ObIw/tUCRuSu2uyaiUzxD67
         J1mMRwEvBwrNQ==
Message-ID: <ba703ed6-e91d-5128-f1a4-1667125c531e@kernel.org>
Date:   Sat, 11 Mar 2023 14:06:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v3 3/6] soc:
 ti: pruss: Add pruss_cfg_read()/update() API
Content-Language: en-US
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
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <1c1e67fd-1eaa-30f5-8b2a-41a7e3ff664a@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Danish,

On 10/03/2023 17:36, Md Danish Anwar wrote:
> Hi Roger,
> 
> On 10/03/23 18:53, Roger Quadros wrote:
>> Hi Danish,
>>
>> On 10/03/2023 13:53, Md Danish Anwar wrote:
>>> Hi Roger,
>>>
>>> On 09/03/23 17:00, Md Danish Anwar wrote:
>>>> Hi Roger,
>>>>
>>>> On 08/03/23 17:12, Roger Quadros wrote:
>>>>>
>>>>>
>>>>> On 08/03/2023 13:36, Md Danish Anwar wrote:
>>>>>> Hi Roger,
>>>>>>
>>>>>> On 08/03/23 13:57, Roger Quadros wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 06/03/2023 13:09, MD Danish Anwar wrote:
>>>>>>>> From: Suman Anna <s-anna@ti.com>
>>>>>>>>
>>>>>>>> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
>>>>>>>> the PRUSS platform driver to allow other drivers to read and program
>>>>>>>> respectively a register within the PRUSS CFG sub-module represented
>>>>>>>> by a syscon driver. This interface provides a simple way for client
>>>>>>>
>>>>>>> Do you really need these 2 functions to be public?
>>>>>>> I see that later patches (4-6) add APIs for doing specific things
>>>>>>> and that should be sufficient than exposing entire CFG space via
>>>>>>> pruss_cfg_read/update().
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> I think the intention here is to keep this APIs pruss_cfg_read() and
>>>>>> pruss_cfg_update() public so that other drivers can read / modify PRUSS config
>>>>>> when needed.
>>>>>
>>>>> Where are these other drivers? If they don't exist then let's not make provision
>>>>> for it now.
>>>>> We can provide necessary API helpers when needed instead of letting client drivers
>>>>> do what they want as they can be misused and hard to debug.
>>>>>
>>>>
>>>> The ICSSG Ethernet driver uses pruss_cfg_update() API. It is posted upstream in
>>>> the series [1]. The ethernet driver series is dependent on this series. In
>>>> series [1] we are using pruss_cfg_update() in icssg_config.c file,
>>>> icssg_config() API.
>>
>> You can instead add a new API on what exactly you want it to do rather than exposing
>> entire CFG space.
>>
> 
> Sure.
> 
> In icssg_config.c, a call to pruss_cfg_update() is made to enable XFR shift for
> PRU and RTU,
> 
> 	/* enable XFR shift for PRU and RTU */
> 	mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
> 	pruss_cfg_update(prueth->pruss, PRUSS_CFG_SPP, mask, mask);
> 
> I will add the below API as part of Patch 4 of the series. We'll call this API
> and entire CFG space will not be exposed.
> 
> /**
>  * pruss_cfg_xfr_pru_rtu_enable() - Enable/disable XFR shift for PRU and RTU
>  * @pruss: the pruss instance
>  * @enable: enable/disable
>  *
>  * Return: 0 on success, or an error code otherwise
>  */
> static inline int pruss_cfg_xfr_pru_rtu_enable(struct pruss *pruss, bool enable)
> {
> 	u32 mask = PRUSS_SPP_XFER_SHIFT_EN | PRUSS_SPP_RTU_XFR_SHIFT_EN;
> 	u32 set = enable ? mask : 0;
> 
> 	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
> }

I would suggest to make separate APIs for PRU XFR vs RTU XFR.

> 
> To make pruss_cfg_update() and pruss_cfg_read() API internal to pruss.c, I will
> add the below change to pruss.h file and pruss.c file. Let me know if this
> change looks okay to you.
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> 
> index 537a3910ffd8..9f01c8809deb 100644
> 
> --- a/drivers/soc/ti/pruss.c
> 
> +++ b/drivers/soc/ti/pruss.c
> 
> @@ -182,7 +182,6 @@ int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
> unsigned int *val)

Need to declare this as 'static'.

> 
> 
> 
>         return regmap_read(pruss->cfg_regmap, reg, val);
> 
>  }
> 
> -EXPORT_SYMBOL_GPL(pruss_cfg_read);
> 
> 
> 
>  /**
> 
>   * pruss_cfg_update() - configure a PRUSS CFG sub-module register
> 
> @@ -203,7 +202,6 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,

this as well.

> 
> 
> 
>         return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
> 
>  }
> 
> -EXPORT_SYMBOL_GPL(pruss_cfg_update);
> 
> 
> 
>  static void pruss_of_free_clk_provider(void *data)
> 
>  {
> 
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> 
> index d41bec448f06..12ef10b9fe9a 100644
> 
> --- a/include/linux/remoteproc/pruss.h
> 
> +++ b/include/linux/remoteproc/pruss.h
> 
> @@ -165,9 +165,6 @@ int pruss_request_mem_region(struct pruss *pruss, enum
> pruss_mem mem_id,
> 
>                              struct pruss_mem_region *region);
> 
>  int pruss_release_mem_region(struct pruss *pruss,
> 
>                              struct pruss_mem_region *region);
> 
> -int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);
> 
> -int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> 
> -                    unsigned int mask, unsigned int val);
> 
> 
> 
>  #else
> 
> 
> 
> @@ -191,18 +188,6 @@ static inline int pruss_release_mem_region(struct pruss
> *pruss,
> 
>         return -EOPNOTSUPP;
> 
>  }
> 
> 
> 
> -static inline int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
> 
> -                                unsigned int *val)
> 
> -{
> 
> -       return -EOPNOTSUPP;
> 
> -}
> 
> -
> 
> -static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> 
> -                                  unsigned int mask, unsigned int val)
> 
> -{
> 
> -       return -EOPNOTSUPP;
> 
> -}
> 
> -
> 
>  #endif /* CONFIG_TI_PRUSS */
> 
> 
> 
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> 
> 
> Please have a look and let me know if above API and code changes looks OK to you.
> 

Rest looks OK.

cheers,
-roger
