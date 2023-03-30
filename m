Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4EB6CFFAF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjC3JTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjC3JTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:19:06 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE48F7D91;
        Thu, 30 Mar 2023 02:19:03 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32U9IsE2064180;
        Thu, 30 Mar 2023 04:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680167934;
        bh=FH1MbDTyJhw4vrH2TcRcS2PlVKs97RQ7D5LV7TM2Ies=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=IhCcqHUO7u8jy1kgxVmTnHwssFArm5lLf8PygVimjoJjPa15VNZQ+Wu8kkpkOEtlX
         B21cBsjjG0UQkQdXI5SU7Kxkk51a6EPbr96dBswKdVlHrSUQiEy2wuA5wHDbaThIX5
         JC7Nbm9bLl5u2Ns453cFuWl2mcomtVz5ysJ0K36w=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32U9IsLS024886
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Mar 2023 04:18:54 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 30
 Mar 2023 04:18:54 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 30 Mar 2023 04:18:54 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32U9ImhE048823;
        Thu, 30 Mar 2023 04:18:49 -0500
Message-ID: <87992a43-a9c3-acb5-2ca1-0174558f2420@ti.com>
Date:   Thu, 30 Mar 2023 14:48:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [EXTERNAL] Re: [PATCH v5 5/5] soc: ti: pruss: Add helper
 functions to get/set PRUSS_CFG_GPMUX
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
 <20230323062451.2925996-6-danishanwar@ti.com> <20230327210429.GD3158115@p14s>
 <08cdd2b7-5152-8dec-aea2-ce286f8b97fb@ti.com>
 <CANLsYkwO62JH0TgOLwt08n8WdM_KsNYBCvUBOEsaxikJRfut0A@mail.gmail.com>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <CANLsYkwO62JH0TgOLwt08n8WdM_KsNYBCvUBOEsaxikJRfut0A@mail.gmail.com>
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

On 29/03/23 23:34, Mathieu Poirier wrote:
> On Tue, 28 Mar 2023 at 05:28, Md Danish Anwar <a0501179@ti.com> wrote:
>>
>> On 28/03/23 02:34, Mathieu Poirier wrote:
>>> On Thu, Mar 23, 2023 at 11:54:51AM +0530, MD Danish Anwar wrote:
>>>> From: Tero Kristo <t-kristo@ti.com>
>>>>
>>>> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
>>>> to get and set the GP MUX mode for programming the PRUSS internal wrapper
>>>> mux functionality as needed by usecases.
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
>>>>  drivers/soc/ti/pruss.c           | 44 ++++++++++++++++++++++++++++++++
>>>>  include/linux/remoteproc/pruss.h | 30 ++++++++++++++++++++++
>>>>  2 files changed, 74 insertions(+)
>>>>
>>>> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
>>>> index ac415442e85b..3aa3c38c6c79 100644
>>>> --- a/drivers/soc/ti/pruss.c
>>>> +++ b/drivers/soc/ti/pruss.c
>>>> @@ -239,6 +239,50 @@ int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
>>>>
>>>> +/**
>>>> + * pruss_cfg_get_gpmux() - get the current GPMUX value for a PRU device
>>>> + * @pruss: pruss instance
>>>> + * @pru_id: PRU identifier (0-1)
>>>> + * @mux: pointer to store the current mux value into
>>>> + *
>>>> + * Return: 0 on success, or an error code otherwise
>>>> + */
>>>> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
>>>> +{
>>>> +    int ret = 0;
>>>> +    u32 val;
>>>> +
>>>> +    if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>>>> +            return -EINVAL;
>>>> +
>>>> +    ret = pruss_cfg_read(pruss, PRUSS_CFG_GPCFG(pru_id), &val);
>>>> +    if (!ret)
>>>> +            *mux = (u8)((val & PRUSS_GPCFG_PRU_MUX_SEL_MASK) >>
>>>> +                        PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
>>>
>>> What happens if @mux is NULL?
>>
>> @mux being null may result in some error here. I will add NULL check for mux
>> before storing the value in mux.
>>
> 
> It will result in a kernel panic.
> 
>> I will modify the above if condition to have NULL check for mux as well.
>> The if condition will look like below.
>>
>>         if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS || !mux)
>>                 return -EINVAL;
>>
> 
> That will be fine.>

Sure, I'll go ahead and make this change.

>> Please let me know if this looks OK.
>>
>>>
>>> Thanks,
>>> Mathieu
>>>
>>>
>>>> +    return ret;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(pruss_cfg_get_gpmux);
>>>> +
>>>> +/**
>>>> + * pruss_cfg_set_gpmux() - set the GPMUX value for a PRU device
>>>> + * @pruss: pruss instance
>>>> + * @pru_id: PRU identifier (0-1)
>>>> + * @mux: new mux value for PRU
>>>> + *
>>>> + * Return: 0 on success, or an error code otherwise
>>>> + */
>>>> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>>>> +{
>>>> +    if (mux >= PRUSS_GP_MUX_SEL_MAX ||
>>>> +        pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
>>>> +            return -EINVAL;
>>>> +
>>>> +    return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
>>>> +                            PRUSS_GPCFG_PRU_MUX_SEL_MASK,
>>>> +                            (u32)mux << PRUSS_GPCFG_PRU_MUX_SEL_SHIFT);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(pruss_cfg_set_gpmux);
>>>> +
>>>>  static void pruss_of_free_clk_provider(void *data)
>>>>  {
>>>>      struct device_node *clk_mux_np = data;
>>>> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
>>>> index bb001f712980..42f1586c62ac 100644
>>>> --- a/include/linux/remoteproc/pruss.h
>>>> +++ b/include/linux/remoteproc/pruss.h
>>>> @@ -16,6 +16,24 @@
>>>>
>>>>  #define PRU_RPROC_DRVNAME "pru-rproc"
>>>>
>>>> +/*
>>>> + * enum pruss_gp_mux_sel - PRUSS GPI/O Mux modes for the
>>>> + * PRUSS_GPCFG0/1 registers
>>>> + *
>>>> + * NOTE: The below defines are the most common values, but there
>>>> + * are some exceptions like on 66AK2G, where the RESERVED and MII2
>>>> + * values are interchanged. Also, this bit-field does not exist on
>>>> + * AM335x SoCs
>>>> + */
>>>> +enum pruss_gp_mux_sel {
>>>> +    PRUSS_GP_MUX_SEL_GP = 0,
>>>> +    PRUSS_GP_MUX_SEL_ENDAT,
>>>> +    PRUSS_GP_MUX_SEL_RESERVED,
>>>> +    PRUSS_GP_MUX_SEL_SD,
>>>> +    PRUSS_GP_MUX_SEL_MII2,
>>>> +    PRUSS_GP_MUX_SEL_MAX,
>>>> +};
>>>> +
>>>>  /*
>>>>   * enum pruss_gpi_mode - PRUSS GPI configuration modes, used
>>>>   *                   to program the PRUSS_GPCFG0/1 registers
>>>> @@ -110,6 +128,8 @@ int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
>>>>  int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
>>>>  int pruss_cfg_xfr_enable(struct pruss *pruss, enum pru_type pru_type,
>>>>                       bool enable);
>>>> +int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux);
>>>> +int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux);
>>>>
>>>>  #else
>>>>
>>>> @@ -152,6 +172,16 @@ static inline int pruss_cfg_xfr_enable(struct pruss *pruss,
>>>>      return ERR_PTR(-EOPNOTSUPP);
>>>>  }
>>>>
>>>> +static inline int pruss_cfg_get_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 *mux)
>>>> +{
>>>> +    return ERR_PTR(-EOPNOTSUPP);
>>>> +}
>>>> +
>>>> +static inline int pruss_cfg_set_gpmux(struct pruss *pruss, enum pruss_pru_id pru_id, u8 mux)
>>>> +{
>>>> +    return ERR_PTR(-EOPNOTSUPP);
>>>> +}
>>>> +
>>>>  #endif /* CONFIG_TI_PRUSS */
>>>>
>>>>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
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
