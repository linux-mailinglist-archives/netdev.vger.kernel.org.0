Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32B05BC3F6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiISIGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiISIGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:06:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846ADDEB6;
        Mon, 19 Sep 2022 01:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663574774; x=1695110774;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xCWOlIVedeUSMrJDrVauyFgN/2kkkiDl5exTSJm4CdI=;
  b=a7mfaJu8b30R6wO/VLmqLphQl+FfRmFpixEcuCKfvSZrJOlOi0m107qA
   J6RGjHzdBc2zlhRsO46FI+M1Rci+z6rHlrb3iP/8BHl7jytH4v8/Zz6Zw
   nSaCA9kCZLRfwoYkUjbIBBGrhuZHOYBtti4F2Ex4t3Sux9DAW1/PuGa5R
   gY0xPnPo62Va7OCGOOP7QhmAGdzk9OIGR6iV4JuYjUmmEHRTbnM9gH4Y5
   ubelKCsnJCaQ5ZlLtFXnXDCGe8h2SBCArwle6vHyirA9MwCfk9xZlnXzO
   2pitxsfk64wsTv0Tl0BuLJs4OTFfKJ7vuOOnRBZd056kBe0wbso8lDcNN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="279066021"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="279066021"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 01:06:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="707473135"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.30.38]) ([10.255.30.38])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 01:06:12 -0700
Message-ID: <dbf54143-b514-5155-ac2a-9f934e9dd8bc@linux.intel.com>
Date:   Mon, 19 Sep 2022 16:06:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
Content-Language: en-US
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
 <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
 <Yxrun9LRcFv2QntR@home.paul.comp>
 <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
 <YyNIPjNX9MCI3zkK@home.paul.comp>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <YyNIPjNX9MCI3zkK@home.paul.comp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-15 23:43, Paul Fertser wrote:
> Hello,
> 
> On Tue, Sep 13, 2022 at 10:12:06AM +0800, Jiaqing Zhao wrote:
>> On 2022-09-09 15:43, Paul Fertser wrote:
>>> On Fri, Sep 09, 2022 at 03:34:53PM +0800, Jiaqing Zhao wrote:
>>>>> Can you please outline some particular use cases for this feature?
>>>>>
>>>> It enables access between host and BMC when BMC shares the network connection
>>>> with host using NCSI, like accessing BMC via HTTP or SSH from host. 
>>>
>>> Why having a compile time kernel option here more appropriate than
>>> just running something like "/usr/bin/ncsi-netlink --package 0
>>> --channel 0 --index 3 --oem-payload 00000157200001" (this example uses
>>> another OEM command) on BMC userspace startup?
>>>
>>
>> Using ncsi-netlink is one way, but the package and channel id is undetermined
>> as it is selected at runtime. Calling the netlink command on a nonexistent
>> package/channel may lead to kernel panic.
> 
> That sounds like a bug all right. If you can reproduce, it's likely
> the fix is reasonably easy, please consider doing it.

It cannot be reproduced stably and varies on NICs, I'm still investigating it,
it might be some NIC firmware issue. 

>> Why I prefer the kernel option is that it applies the config to all ncsi
>> devices by default when setting up them. This reduces the effort and keeps
>> compatibility. Lots of things in current ncsi kernel driver can be done via
>> commands from userspace, but I think it is not a good idea to have a driver
>> resides on both kernel and userspace.
> 
> How should the developer decide whether to enable this compile-time
> option for a platform or not? If it's always nice to have why not
> add the code unconditionally? And if not, are you sure kernel compile
> time is the right decision point? So far I get an impression a sysfs
> runtime knob would be more useful.

Disabling Host-BMC traffic ensures the isolation between Host network and BMC's
management network, some developers/vendors may prefer disable it for security
concerns. Though having a runtime knob in sysfs would be useful, setting the
default behavior in kernel config is also useful from my point.
