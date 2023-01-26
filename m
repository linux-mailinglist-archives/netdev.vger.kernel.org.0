Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23867C941
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbjAZKzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbjAZKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:55:45 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA7C6ACBE;
        Thu, 26 Jan 2023 02:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674730543; x=1706266543;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u69v3S/g7l8w7wR1kGbqMcI8pLDCGnhHV65PcCEa6YU=;
  b=agx+Y5LPKzC6DFxvFsBLd+X3yBgfHOyJUoDF4YvH6mESjmreAQRsllQU
   bs3MLI04fiiuqlqw/una+FZYyu63dm2sJHXnXo5Eb9cAZFjwAksmaIOW7
   Rl0WuqqxlOeSTbitAG1lWO6IOq/l44Jpc8wdqbJ2C/KL3SyrmjaeS40b6
   IgjhBs49I8Ru2+PHopcPTZ04Tsd6QNp9luzQtEJ9kV5EnIv1ImzyPP9aV
   ZiA9P5SU97CHB13eigqVauAX6/EkhuVbG+NoE39FCU919dGJBvmMh2w1c
   MW957T5j0b1g2wjpyrU/7ZtvnTpNWbb/Mcg/y84Ss8lODO8XuvF5cyx8C
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="389123082"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="389123082"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 02:55:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="786777308"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="786777308"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.115.96]) ([10.215.115.96])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 02:55:37 -0800
Message-ID: <e8316533-53cc-1533-a8f2-fb8860a31a9d@linux.intel.com>
Date:   Thu, 26 Jan 2023 16:25:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, ilpo.jarvinen@linux.intel.com,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jiri@nvidia.com
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
 <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
 <20230124205142.772ac24c@kernel.org>
 <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
 <20230125100812.026c0a1e@kernel.org>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20230125100812.026c0a1e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/2023 11:38 PM, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 16:03:37 +0530 Kumar, M Chetan wrote:
>>> I don't know what fastboot is, and reading this doc I see it used in
>>> three forms:
>>>    - fastboot protocol
>>>    - fastboot mode
>>>    - fastboot command & response
>>
>> The fastboot is sort of a tool. It implements the protocol for
>> programming the device flash or getting device information. The device
>> implements the fastboot commands and host issue those commands for
>> programming the firmware to device flash or to obtain device
>> information. Inorder to execute those commands, first the device needs
>> to be put into fastboot mode.
>>
>> More details on fastboot can be found in links [1].
>>
>>> In the end - I have no idea what the devlink param you're adding does.
>>
>> "fastboot" devlink param is used to put the device into fastboot mode
>> to program firmware to device flash or to obtain device information.
>>
>>
>> [1]
>> https://en.wikipedia.org/wiki/Fastboot
>> https://android.googlesource.com/platform/system/core/+/refs/heads/master/fastboot/README.md
> 
> As Ilpo mentions, please add this info into the doc, including
> the links.

Sure. In the next patch, I will detail out the fastboot and include 
those links for reference.

> 
> The most confusing part is that "fastboot" sounds like it's going
> to boot fast, while IIUC the behavior is the opposite - it's not going
> to boot at all and just expose an interface to load the FW, is that
> right?

On device side, the fastboot protocol is implemented in bootloader. When 
the host request the device to enter fastboot mode, the device is reset. 
Post reset, the host will be able to communicate with device bootloader 
using fastboot protocol.

Fastboot protocol implements a set of commands for various operations. 
The "flash" is one such command used for programming firmware.

> 
> Please also clarify what the normal operation for the device is.

It means fully functional mode.
In this mode wwan functionalities like AT, MBIM, modem trace collection 
& data path are operational.

> In what scenarios does the fastboot mode get used?

It is used in 2 scenarios.
1> Firmware update, when user/app wants to update firmware.
2> Core dump collection, when device encounters an exception.

> 
> And just to double confirm - that the FW loaded in fastboot mode is
> persistently stored on the device, and will be used after power cycle.
> Rather than it being an upload into RAM.

That's correct.
The firmware is permanently stored on the device & it will be used after 
power cycle.

-- 
Chetan
