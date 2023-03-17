Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAB16BE471
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjCQIzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCQIzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:55:38 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2E26A1CC;
        Fri, 17 Mar 2023 01:55:29 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32H8tKHF084921;
        Fri, 17 Mar 2023 03:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679043320;
        bh=iNOyU8jAlyYbzlqmmNzxj5imjqg2Dawl0ITO6Jw3VBE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=AJjkqJGh1Y/2MZawzjBmnsIgQmcnw8F1UwY5GzR2sWPOziCIba/MCrteVk6tGcvdg
         2i/ys17INWggxOiy2BRiOAdm1WzHVdtmGwIiRBW9VxYkqjTOiEZgFGLEILd1iN+siE
         fHuVKZG338ZjJqwbnLkVUveFccAuNMaCjogQcAEU=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32H8tKm9043688
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Mar 2023 03:55:20 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 17
 Mar 2023 03:55:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 17 Mar 2023 03:55:20 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32H8tE1a042709;
        Fri, 17 Mar 2023 03:55:15 -0500
Message-ID: <4f4dd491-e7f6-a963-c185-68521b262b22@ti.com>
Date:   Fri, 17 Mar 2023 14:25:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 4/5] soc:
 ti: pruss: Add helper functions to set GPI mode, MII_RT_event and XFR
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
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-5-danishanwar@ti.com>
 <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
 <b1409f34-86b5-14e8-f352-5032aa57ca46@ti.com>
 <60e73395-f670-6eaa-0eb7-389553320a71@kernel.org>
 <20718115-7606-a77b-7e4d-511ca9c1d798@ti.com>
 <e49b9a78-5e35-209e-7ecc-2333478b98b0@kernel.org>
 <468f85ad-e4b0-54e1-a5b9-4692ae8a1445@ti.com>
 <455440f4-7f2b-366e-53ec-700c3bb98534@kernel.org>
 <22b8860c-12bd-384d-41af-93f1dde9a0fd@ti.com>
 <d8776be3-75a2-02fd-3702-79169675e4f6@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <d8776be3-75a2-02fd-3702-79169675e4f6@kernel.org>
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



On 17/03/23 14:01, Roger Quadros wrote:
> 
> 
> On 17/03/2023 07:02, Md Danish Anwar wrote:
>>
>>
>> On 16/03/23 19:34, Roger Quadros wrote:
>>>
>>> Hi,
>>>
>>> On 16/03/2023 15:11, Md Danish Anwar wrote:
>>>>
>>>>
>>>> On 16/03/23 17:49, Roger Quadros wrote:
>>>>>
>>>>>
>>>>> On 16/03/2023 13:44, Md Danish Anwar wrote:
>>>>>>
>>>>>> On 16/03/23 17:06, Roger Quadros wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 16/03/2023 13:05, Md Danish Anwar wrote:
>>>>>>>> Hi Roger,
>>>>>>>>
>>>>>>>> On 15/03/23 17:52, Roger Quadros wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>>>>>>>>> From: Suman Anna <s-anna@ti.com>
>>>
>>
>> [..]
>>
>>>> Sure, then I will use the existing enum pru_type.
>>>>
>>>> The enum pru_type is currently in drivers/remoteproc/pruss.c I will move this
>>>> enum definition from there to include/linux/remoteproc/pruss.h
>>>
>>> There are 2 public pruss.h files.
>>> 	include/linux/remoteproc/pruss.h
>>> and
>>> 	include/linux/pruss_driver.h
>>>
>>> Why is that and when to use what?
>>>
>>
>> The include/linux/remoteproc/pruss.h file was introduced in series [1] as a
>> public header file for PRU_RPROC driver (drivers/remoteproc/pru_rproc.c)
>>
>> The second header file include/linux/pruss_driver.h was introduced much earlier
>> as part of [2] , "soc: ti: pruss: Add a platform driver for PRUSS in TI SoCs".
>>
>> As far as I can see, seems like pruss_driver.h was added as a public header
>> file for PRUSS platform driver (drivers/soc/ti/pruss.c)
>>
>> [1] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/
>> [2] https://lore.kernel.org/all/1542886753-17625-7-git-send-email-rogerq@ti.com/
> 
> Thanks. "include/linux/remoteproc/pruss.h" seems appropriate for enum pru_type.
> 
> cheers,
> -roger

Yes, enum pru_type is located in pru_rproc.c, I will move enum pru_type to
include/linux/remoteproc/pruss.h and then include
include/linux/remoteproc/pruss.h" in pru_rproc.c and any other file that needs
this enum.

-- 
Thanks and Regards,
Danish.
