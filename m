Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0775B7E1D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 03:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiINBLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 21:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINBLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 21:11:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FF311C0F;
        Tue, 13 Sep 2022 18:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663117861; x=1694653861;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4hhTqP0/V+vCzPJZLXM7LRMMWx5tpU/aTziqBSnlTo8=;
  b=nBxSzZc3/JklAAX6kYsVStTdm2YqA47f0CzheQgl0ooAppKAFLAbSekT
   P+vrc4c/ugE16ZhwpLqhHYEyyb3K+G2sCpgQKKav4ts4ADRH8Xm3ihjDp
   Xtmdzpro+xd7w9+7xciKc5J/Cmiy3Yt2gPNhOLGs8MBtCNZrS0h5/T7fE
   rGzNXYtpjZWBH0yUtHI8X1DIWlsQ7fw/9eEwFoMeNf2zxaOOJl8jgdncq
   wW7DdCwMlIG7kCWS2CXZoLNeRusM1funVBZX8R26l+lkBSX7H/d6N2pBX
   OyZfY0R11i+MvTE923pWwu6XThUrvi5a/8EkvXimOxSXO6/T615zJs/Ch
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="299656716"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="299656716"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 18:11:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="567809005"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.29.56]) ([10.255.29.56])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 18:10:59 -0700
Message-ID: <5346c9f6-1b7e-3c65-80a7-b06408bd95f3@linux.intel.com>
Date:   Wed, 14 Sep 2022 09:10:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
Content-Language: en-US
To:     Sam Mendoza-Jonas <sam@mendozajonas.com>,
        Paul Fertser <fercerpav@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
 <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
 <Yxrun9LRcFv2QntR@home.paul.comp>
 <36c12486-57d4-c11d-474f-f26a7de8e59a@linux.intel.com>
 <F7F5AD32-901B-440A-8B1D-30C4283F18CD@mendozajonas.com>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <F7F5AD32-901B-440A-8B1D-30C4283F18CD@mendozajonas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-09-13 21:35, Sam Mendoza-Jonas wrote:
> On September 13, 2022 3:12:06 AM GMT+01:00, Jiaqing Zhao <jiaqing.zhao@linux.intel.com> wrote:
>>
>>
>> On 2022-09-09 15:43, Paul Fertser wrote:
>>> Hello,
>>>
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
> If so, that would be a bug :)

Yes but I haven't found the root cause so far, it only panics with some specific
NICs I remember.

>>
>> Why I prefer the kernel option is that it applies the config to all ncsi
>> devices by default when setting up them. This reduces the effort and keeps
>> compatibility. Lots of things in current ncsi kernel driver can be done via
>> commands from userspace, but I think it is not a good idea to have a driver
>> resides on both kernel and userspace.
> 
> BMCs are of course in their own world and there's already some examples of the config option, but how would a system owner be able to disable this without reflashing the BMC?

Given that ncsi driver is a driver binding to the PHY driver, it seems to be unable
to make it a module and have some module options. So far build option seems to be
the only way. Maybe in future sysfs entries can be added to make it configurable at
runtime.
