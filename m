Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0845654FC27
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383243AbiFQRVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383242AbiFQRVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:21:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF6734BAC
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655486502; x=1687022502;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=980dsgNiSwvDbuUCAihU3mK04rAdGEfJWYVURJDFlto=;
  b=KDO0+fNI979dYjHX+DSVReDFjGd37WlVMDZ9HxfqLRFmVZEQbr/8YW54
   1BEPGDmCNNwviLKzSLgVkvMvpSdxTfT7uNsgCqtvGg5kzOcsH2mky2T0U
   GS8Yp9f07B0TVeqFH/8IeuxJ02p/6yRClRDluBFOJnnlw7wqz/ZiomYqL
   uN0NW5lKKCqo759SHVehfJOvbwTTxC/AxXmHhR6qQeyFc8mLubrKa8WQQ
   gH62VWjRVKGIPYwlXe0pDVqDDyX/LbV7VNVI+xIYdlqio8Os5Jtvi//L9
   oApErEyZORzCapsW8PjStTgI2poZKCP4dOfeOcqujjuQziDFw1v+vaa9R
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="262575827"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="262575827"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 09:59:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="642092765"
Received: from igoulart-mobl1.amr.corp.intel.com (HELO [10.209.93.112]) ([10.209.93.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 09:59:50 -0700
Message-ID: <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
Date:   Fri, 17 Jun 2022 09:59:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/16/22 10:29, Loic Poulain wrote:
> Hi Moises,
>
> On Tue, 14 Jun 2022 at 22:58, Moises Veleta
> <moises.veleta@linux.intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>> ---
> [...]
>>   static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>          {
>> +               .tx_ch = PORT_CH_AP_GNSS_TX,
>> +               .rx_ch = PORT_CH_AP_GNSS_RX,
>> +               .txq_index = Q_IDX_CTRL,
>> +               .rxq_index = Q_IDX_CTRL,
>> +               .path_id = CLDMA_ID_AP,
>> +               .ops = &wwan_sub_port_ops,
>> +               .name = "t7xx_ap_gnss",
>> +               .port_type = WWAN_PORT_AT,
> Is it really AT protocol here? wouldn't it be possible to expose it
> via the existing GNSS susbsystem?
>
> Regards,
> Looic

The protocol is AT.
It is not possible to using the GNSS subsystem as it is meant for 
stand-alone GNSS receivers without a control path. In this case, GNSS 
can used for different use cases, such as Assisted GNSS, Cell ID 
positioning, Geofence, etc. Hence, this requires the use of the AT 
channel on the WWAN subsystem.

Regards,
Moises

