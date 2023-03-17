Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09D76BE06B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCQFC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCQFC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:02:58 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610257D19;
        Thu, 16 Mar 2023 22:02:56 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32H52eVZ118036;
        Fri, 17 Mar 2023 00:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679029360;
        bh=O3wqgAjd5Kq/xmlrss1YwHCRDPVlxQ49A5FvgeboGmc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=RvpkluMDvA6JKT9Ccec86ev48N6FKa9H05fhakyQhp3ZvU5cGuW86zWNWnOAl8Jig
         +K4wGN7F0vkwJfQYu2wdpJyJqcXm+eH44ESF/L9ZZw0Y89XgRjCZh4L/JpbrNHTJl9
         GZxYzy6Yduq9o5pDZzHE8NPtQCj3dW7bMpW350V0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32H52dYo056248
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 17 Mar 2023 00:02:39 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 17
 Mar 2023 00:02:39 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 17 Mar 2023 00:02:39 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32H52Yk9102104;
        Fri, 17 Mar 2023 00:02:35 -0500
Message-ID: <22b8860c-12bd-384d-41af-93f1dde9a0fd@ti.com>
Date:   Fri, 17 Mar 2023 10:32:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 4/5] soc: ti: pruss: Add
 helper functions to set GPI mode, MII_RT_event and XFR
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
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <455440f4-7f2b-366e-53ec-700c3bb98534@kernel.org>
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



On 16/03/23 19:34, Roger Quadros wrote:
> 
> Hi,
> 
> On 16/03/2023 15:11, Md Danish Anwar wrote:
>>
>>
>> On 16/03/23 17:49, Roger Quadros wrote:
>>>
>>>
>>> On 16/03/2023 13:44, Md Danish Anwar wrote:
>>>>
>>>> On 16/03/23 17:06, Roger Quadros wrote:
>>>>> Hi,
>>>>>
>>>>> On 16/03/2023 13:05, Md Danish Anwar wrote:
>>>>>> Hi Roger,
>>>>>>
>>>>>> On 15/03/23 17:52, Roger Quadros wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 13/03/2023 13:11, MD Danish Anwar wrote:
>>>>>>>> From: Suman Anna <s-anna@ti.com>
>

[..]

>> Sure, then I will use the existing enum pru_type.
>>
>> The enum pru_type is currently in drivers/remoteproc/pruss.c I will move this
>> enum definition from there to include/linux/remoteproc/pruss.h
> 
> There are 2 public pruss.h files.
> 	include/linux/remoteproc/pruss.h
> and
> 	include/linux/pruss_driver.h
> 
> Why is that and when to use what?
> 

The include/linux/remoteproc/pruss.h file was introduced in series [1] as a
public header file for PRU_RPROC driver (drivers/remoteproc/pru_rproc.c)

The second header file include/linux/pruss_driver.h was introduced much earlier
as part of [2] , "soc: ti: pruss: Add a platform driver for PRUSS in TI SoCs".

As far as I can see, seems like pruss_driver.h was added as a public header
file for PRUSS platform driver (drivers/soc/ti/pruss.c)

[1] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/
[2] https://lore.kernel.org/all/1542886753-17625-7-git-send-email-rogerq@ti.com/


> cheers,
> -roger

-- 
Thanks and Regards,
Danish.
