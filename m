Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33551DDD1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443860AbiEFQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiEFQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:49:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7A52AC44;
        Fri,  6 May 2022 09:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651855554; x=1683391554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sHOpTDaVdHwXHGQJz+fHBf4Vwt0d9C/WRQnUKVhhBo4=;
  b=aQczqjAe4oYx51T5ivVE1oQQgIITqbqcgSpcvBVqdG3MSJsPbcWP3Ciu
   m9Hby0AE8jnE2XBOxdX+P1DfaXYEdokIQCM/63tOiMzPu5Sjkkj+DXBP5
   Qo4npAXTVSmG9i0obkR97DzQcnP6XuLrN9DTnaVWrKiWPbV7yoYV79mIh
   Y1xbceI+RlSasr4gYYeoAOQEEdDZNADyRqVambzWXStUbAxk/0PlN9Bjq
   wOTaF04OsQ0zUIja99zqtgxP/3tkeGDQ48xAnFmTRVfcnI877Htdx2i33
   Gts6JV2Qw/K20Ic3WGWD+phShOimdanaaPEfNWSAmcIG12qsbeRg/CXxS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="268659447"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="268659447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 09:45:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="812456991"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.255.230.121]) ([10.255.230.121])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 09:45:53 -0700
Message-ID: <b77219e1-10e5-a732-89f0-2e90d30ade8f@linux.intel.com>
Date:   Fri, 6 May 2022 09:45:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v7 00/14] net: wwan: t7xx: PCIe driver for
 MediaTek M.2 modem
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
References: <20220506011616.1774805-1-ricardo.martinez@linux.intel.com>
 <CAHNKnsTnqNrcnz9gx8uX0mMiq8V_Vt99AQPAom01Q=V50a2bFg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsTnqNrcnz9gx8uX0mMiq8V_Vt99AQPAom01Q=V50a2bFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/6/2022 6:43 AM, Sergey Ryazanov wrote:
> Hello Ricardo,
>
> On Fri, May 6, 2022 at 4:16 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> t7xx is the PCIe host device driver for Intel 5G 5000 M.2 solution which
>> is based on MediaTek's T700 modem to provide WWAN connectivity.
>> The driver uses the WWAN framework infrastructure to create the following
>> control ports and network interfaces:
>> * /dev/wwan0mbim0 - Interface conforming to the MBIM protocol.
>>    Applications like libmbim [1] or Modem Manager [2] from v1.16 onwards
>>    with [3][4] can use it to enable data communication towards WWAN.
>> * /dev/wwan0at0 - Interface that supports AT commands.
>> * wwan0 - Primary network interface for IP traffic.
>>
>> The main blocks in t7xx driver are:
>> * PCIe layer - Implements probe, removal, and power management callbacks.
>> * Port-proxy - Provides a common interface to interact with different types
>>    of ports such as WWAN ports.
>> * Modem control & status monitor - Implements the entry point for modem
>>    initialization, reset and exit, as well as exception handling.
>> * CLDMA (Control Layer DMA) - Manages the HW used by the port layer to send
>>    control messages to the modem using MediaTek's CCCI (Cross-Core
>>    Communication Interface) protocol.
>> * DPMAIF (Data Plane Modem AP Interface) - Controls the HW that provides
>>    uplink and downlink queues for the data path. The data exchange takes
>>    place using circular buffers to share data buffer addresses and metadata
>>    to describe the packets.
>> * MHCCIF (Modem Host Cross-Core Interface) - Provides interrupt channels
>>    for bidirectional event notification such as handshake, exception, PM and
>>    port enumeration.
>>
>> The compilation of the t7xx driver is enabled by the CONFIG_MTK_T7XX config
>> option which depends on CONFIG_WWAN.
>> This driver was originally developed by MediaTek. Intel adapted t7xx to
>> the WWAN framework, optimized and refactored the driver source code in close
>> collaboration with MediaTek. This will enable getting the t7xx driver on the
>> Approved Vendor List for interested OEM's and ODM's productization plans
>> with Intel 5G 5000 M.2 solution.
>>
>> List of contributors:
>> Amir Hanania <amir.hanania@intel.com>
>> Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Dinesh Sharma <dinesh.sharma@intel.com>
>> Eliot Lee <eliot.lee@intel.com>
>> Haijun Liu <haijun.liu@mediatek.com>
>> M Chetan Kumar <m.chetan.kumar@intel.com>
>> Mika Westerberg <mika.westerberg@linux.intel.com>
>> Moises Veleta <moises.veleta@intel.com>
>> Pierre-louis Bossart <pierre-louis.bossart@intel.com>
>> Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
>> Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Muralidharan Sethuraman <muralidharan.sethuraman@intel.com>
>> Soumya Prakash Mishra <Soumya.Prakash.Mishra@intel.com>
>> Sreehari Kancharla <sreehari.kancharla@intel.com>
>> Suresh Nagaraj <suresh.nagaraj@intel.com>
>>
>> [1] https://www.freedesktop.org/software/libmbim/
>> [2] https://www.freedesktop.org/software/ModemManager/
>> [3] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/582
>> [4] https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/523
> Now the driver looks really nice. Good job!

Thanks Sergey.

