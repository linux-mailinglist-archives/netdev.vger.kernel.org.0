Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCCB67AFBD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjAYKds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjAYKdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:33:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B638A51;
        Wed, 25 Jan 2023 02:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674642826; x=1706178826;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XjZbxMCnwLhWhkcGBYEG6dFfUEEWu5K6GKW0b8SxAtE=;
  b=RMc+l1v/cPcNK4AP03TDoLg9QhsKDfUdT0LN/xw/S/ZDRrTItiobH6bx
   p2XvJuGYg+/ppfB8zSxVikM1vzNn8U2nDjG4rNa2XtS+JR0BK0RogJqn9
   1JuOgIL2fEXZMqDh6o5dz3txnpRMEifb726H0Sc4I8oMHvmMD4qZZavaW
   DybqycVxGNgjksS4PcAreUrWoDpig33qXgzxFzXF1Vo8/oSkG6+wD0DwT
   4SoNghSfSRHwOFMBGEJeKAoj0YMdTU2vACQCJOmb8YKZBK/TiHbUQ6KH2
   Og7yxGLbC945U2J7ySqoD1LexeTOTZlf1pH5L0Fbe069vl+05HvGLNw3m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="324223075"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="324223075"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:33:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="662454579"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="662454579"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.86.11]) ([10.213.86.11])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:33:39 -0800
Message-ID: <c9f0eca7-99e8-62a5-9790-1230c43e1817@linux.intel.com>
Date:   Wed, 25 Jan 2023 16:03:37 +0530
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
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20230124205142.772ac24c@kernel.org>
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

On 1/25/2023 10:21 AM, Jakub Kicinski wrote:
> On Sat, 21 Jan 2023 19:03:58 +0530 m.chetan.kumar@linux.intel.com wrote:
>> +In fastboot mode the userspace application uses these commands for obtaining the
>> +current snapshot of second stage bootloader.
> 
> I don't know what fastboot is, and reading this doc I see it used in
> three forms:
>   - fastboot protocol
>   - fastboot mode
>   - fastboot command & response

The fastboot is sort of a tool. It implements the protocol for 
programming the device flash or getting device information. The device 
implements the fastboot commands and host issue those commands for 
programming the firmware to device flash or to obtain device 
information. Inorder to execute those commands, first the device needs 
to be put into fastboot mode.

More details on fastboot can be found in links [1].

> In the end - I have no idea what the devlink param you're adding does.

"fastboot" devlink param is used to put the device into fastboot mode
to program firmware to device flash or to obtain device information.


[1]
https://en.wikipedia.org/wiki/Fastboot
https://android.googlesource.com/platform/system/core/+/refs/heads/master/fastboot/README.md

-- 
Chetan
