Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5688554330
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 09:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiFVGlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 02:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiFVGlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 02:41:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE133EA6
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 23:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655880075; x=1687416075;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VkYmF4Ki5TmofkaVi9Iv/1bkRp4vKlaIjjFrtYDQnCU=;
  b=CLuZoHlfSObURX1rp78RyAqIu9CIJzPmxEMJbQN1ZSfg3HxoYgmjeRhA
   Wu4HyxJduB9On9ZR2POBYAjEv56/e61vPZTUsulttQHkd5XMLSZylbdjV
   OcaRaEr3WCiqBKvzDnpRlFBKP4IagLGKqO0PbcY8Ez/ktcIkPc4fECn+u
   xdPZPwSx6h8sp219hLJCWD4Cl+MtLxCaDvYoVohunUxlPVaqNdESjkX2a
   1Ix+rZ4fg8uUcwYpAnxNgChTY6LoXWlxb/Ajk21iezg01mwU9EoJ4boY0
   Ig0ga0zMvGYkuzGo4e7EUhG1du9xoWcG5B1VbKe1nvhTwJBqk8LG9wsL6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="277878410"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="277878410"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 23:41:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="730182569"
Received: from jwise-mobl.amr.corp.intel.com (HELO [10.252.139.173]) ([10.252.139.173])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 23:40:59 -0700
Message-ID: <cb473297-f64d-7346-d649-58413f3e033e@linux.intel.com>
Date:   Tue, 21 Jun 2022 23:40:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
 <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
 <CAHNKnsRaOS54c6K_s5JmmgDP2KEV38XpGWY5eAmQJ-EUnQt4Ww@mail.gmail.com>
 <45113752-c6a6-a578-3a5a-575d2348d856@linux.intel.com>
 <CAHNKnsTpxKF2bQMEyGfL=73YvtGWZmra_eL4n_qF+smtwSvmhA@mail.gmail.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <CAHNKnsTpxKF2bQMEyGfL=73YvtGWZmra_eL4n_qF+smtwSvmhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/21/22 16:45, Sergey Ryazanov wrote:
> On Tue, Jun 21, 2022 at 7:45 PM moises.veleta
> <moises.veleta@linux.intel.com> wrote:
>> On 6/18/22 04:55, Sergey Ryazanov wrote:
>>> On Fri, Jun 17, 2022 at 8:28 PM moises.veleta
>>> <moises.veleta@linux.intel.com> wrote:
>>>> On 6/16/22 10:29, Loic Poulain wrote:
>>>>> On Tue, 14 Jun 2022 at 22:58, Moises Veleta
>>>>> <moises.veleta@linux.intel.com> wrote:
>>>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>>>> communicate with AP and Modem processors respectively. So far only
>>>>>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>>>>>> port which requires such channel.
>>>>>>
>>>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>>>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>>>>>> ---
>>>>> [...]
>>>>>>     static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>>>>>            {
>>>>>> +               .tx_ch = PORT_CH_AP_GNSS_TX,
>>>>>> +               .rx_ch = PORT_CH_AP_GNSS_RX,
>>>>>> +               .txq_index = Q_IDX_CTRL,
>>>>>> +               .rxq_index = Q_IDX_CTRL,
>>>>>> +               .path_id = CLDMA_ID_AP,
>>>>>> +               .ops = &wwan_sub_port_ops,
>>>>>> +               .name = "t7xx_ap_gnss",
>>>>>> +               .port_type = WWAN_PORT_AT,
>>>>> Is it really AT protocol here? wouldn't it be possible to expose it
>>>>> via the existing GNSS susbsystem?
>>>> The protocol is AT.
>>>> It is not possible to using the GNSS subsystem as it is meant for
>>>> stand-alone GNSS receivers without a control path. In this case, GNSS
>>>> can used for different use cases, such as Assisted GNSS, Cell ID
>>>> positioning, Geofence, etc. Hence, this requires the use of the AT
>>>> channel on the WWAN subsystem.
>>> To make it clear. When you talking about a control path, did you mean
>>> that this GNSS port is not a simple NMEA port? Or did you mean that
>>> this port is NMEA, but the user is required to activate GPS
>>> functionality using the separate AT-commands port?
>>>
>>> In other words, what is the format of the data that are transmitted
>>> over the GNSS port of the modem?
>>>
>> It is an AT port where MTK GNSS AT commands can be sent and received.
>> Not a simple NMEA port, but NMEA data can be sent to Host via an AT
>> command. Control port is exposed for Modem Manager to send GNSS comands,
>> which may include disable/enable GPS functionality (enabled by default).
>>
>> These are MTK GNSS AT commands, which follow the syntax as defined by
>> 3GPP TS 27.007.  These are not standard AT commands.
> Now it is pretty clear. Thank you for your explanation. Please add
> this info somewhere near the GNSS port static configuration. This will
> help avoid similar confusion in the future.
>
> BTW, does the regular AT port of this modem support the MTK GNSS AT
> commands? Or maybe the GNSS port supports regular modem management AT
> commands (PDP, RSSI, SMS, etc.)? In other words, are these GNSS and AT
> ports interchangeable or does each have a specific purpose?
>
> If both ports are interchangeable, then it is ok to expose each as a
> WWAN AT port. But if the GNSS port only supports the MTK GNSS AT
> commands, then I am afraid we should not expose it via the WWAN
> subsystem at least as a regular AT port. This probably will confuse a
> user a lot.
>
> It is not the format of the command used, it is a matter of the
> interface nature. There will be different controlling daemons. E.g.,
> the AT port will be used by ModemManager or something similar and the
> GNSS port will be used by gpsd. And a user will have a hard time to
> figure out which WWAN AT port should be used for what purpose if we
> expose these ports simply as wwan0at0 and wwan0at1.
>
The ports are not interchangeable. Each has a specific purpose. Modem 
port is used for sending Modem commands and GNSS port for GNSS commands.

MTK architecture is defined to have Modem as part of the base-band 
processor and GNSS chip part of the Application Processor. MTK wanted to 
keep the architecture simple and common for SKU's that have GNSS 
solution or not. One example is the MTK's M70 which did not have a GNSS 
solution.

We have different architectures, some fully AT based WWAN modems, or 
fully MBIM, and composite Modems (where Modem interfaces go on MBIM and 
GNSS on AT). This falls under the third category where GPS control port 
(over AT) supports GNSS functionality. There are not standard MBIM 
commands for GNSS and thus GNSS is only supported over AT via MTK 
proprietary commands.

This has been discussed with ModemManager maintainer (Aleksander) who 
introduced MM_PORT_SERIAL_AT_FLAG_GPS_CONTROL, an AT port that is used 
purely for GPS control.  See Gerrit 
https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/753/diffs?commit_id=343f27a5e7b0226e10aec025c502703d0be9d1ac#0dbbdd1ea5ff4bb4ee5b3bd70e9bb0502e02eeea

Since the GNSS solution is part of the M.2 WWAN module, we believe that 
the GNSS port should be exposed by the WWAN subsystem and that 
ModemManager treats this AT port as a GPS control port.

Note that the GNSS port helps supports functionalities such as:
1. Start/Stop GNSS sessions
2. Configuration commands to support Assisted GNSS positioning
3. Crash & reboot (notifications when device is reset (AP) & host is reset)
4. Settings to Enable/Disable GNSS solution
5. Geofencing

Regards,
Moises

