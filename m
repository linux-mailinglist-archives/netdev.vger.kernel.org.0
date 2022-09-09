Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DB5B37A8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 14:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiIIMWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiIIMWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 08:22:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC176B660
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662726052; x=1694262052;
  h=message-id:date:mime-version:from:subject:cc:references:
   to:in-reply-to:content-transfer-encoding;
  bh=LOOofKyG6XlG77YPdUwRLfc4Vtgxg4xNzvmukZ3T7V0=;
  b=gfEcyAczzywKMNRppZOBJypcnZVY/c+7wo6tBmEUfYXtDgkYQ0mEVvjc
   kq2nYulpLADAiTD4KH7xq0A8dgpCHt2dDK+QVgDjR/kUug80sY0DtBVQj
   NmX7G/i1bZ6KxaVnZ63zcxmGTJ7788AAw2viojxNXjlcyp+2rXMRzoRdW
   W8cHQENlEZe8wvVHzhbPx4Dk0z2GZCoyRfxmAj97O3OWBit2gUQBUJQdQ
   8GeLGalozOONglPWZNroDsyNMkFtJNvMYqjFm2xNiN8+6fodGkP1Q3b55
   Be6Vw+L7DvcbmOpyQyh86bHeehV6EdfrgYv9e+L3JnGuiNjabIeiA01iQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="295043979"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="295043979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 05:20:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="677140126"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.87.132]) ([10.213.87.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 05:20:48 -0700
Message-ID: <bb6ad043-a581-1157-8836-6277ebc69cd1@linux.intel.com>
Date:   Fri, 9 Sep 2022 17:50:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: Re: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
References: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
 <CAHNKnsTVGZXF_kUU5YgWmM64_8yAE75=2w1H2A40Wb0y=n8YMg@mail.gmail.com>
 <56a42938-c746-9937-58cb-7a065815a93f@linux.intel.com>
 <CAHNKnsT7zC4fTmc_+17Vy05aP-=vfZhwjOhbYJLOd=OZNMVD0w@mail.gmail.com>
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
In-Reply-To: <CAHNKnsT7zC4fTmc_+17Vy05aP-=vfZhwjOhbYJLOd=OZNMVD0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/2022 3:49 AM, Sergey Ryazanov wrote:
> On Fri, Sep 2, 2022 at 7:50 AM Kumar, M Chetan
> <m.chetan.kumar@linux.intel.com> wrote:
>> On 8/30/2022 7:32 AM, Sergey Ryazanov wrote:
>>> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> PCI rescan module implements "rescan work queue". In firmware flashing
>>>> or coredump collection procedure WWAN device is programmed to boot in
>>>> fastboot mode and a work item is scheduled for removal & detection.
>>>> The WWAN device is reset using APCI call as part driver removal flow.
>>>> Work queue rescans pci bus at fixed interval for device detection,
>>>> later when device is detect work queue exits.
>>>
>>> [skipped]
>>>
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>>>> new file mode 100644
>>>> index 000000000000..045777d8a843
>>>> --- /dev/null
>>>> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>>>
>>> [skipped]
>>>
>>>> +static void t7xx_remove_rescan(struct work_struct *work)
>>>> +{
>>>> +       struct pci_dev *pdev;
>>>> +       int num_retries = RESCAN_RETRIES;
>>>> +       unsigned long flags;
>>>> +
>>>> +       spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
>>>> +       g_mtk_rescan_context.rescan_done = 0;
>>>> +       pdev = g_mtk_rescan_context.dev;
>>>> +       spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
>>>> +
>>>> +       if (pdev) {
>>>> +               pci_stop_and_remove_bus_device_locked(pdev);
>>>
>>> What is the purpose of removing the device then trying to find it by
>>> rescanning the bus? Would not it be easier to save a PCI device
>>> configuration, reset the device, and then restore the configuration?
>>
>> If hotplug is disabled, the device is not removed on reset. So in this
>> case driver need to handle the device removal and rescan.
> 
> I still can not understand this part and need a clue. Why should the
> driver disable the hotplug?

This is a platform configuration, it could be set to enable/disable.
We can find this option in BIOS settings.

> And is there a more gentle way to reset the firmware without the
> device object removing?

Device reset causes WWAN device to fall off the BUS. If device had not 
fallen off the bus then we could have reused.

Without these changes, we need to manually execute device remove & 
rescan commands.

Could you please suggest how can we proceed here ?

-- 
Chetan
