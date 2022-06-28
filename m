Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC5755F050
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiF1V1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 17:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiF1V1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 17:27:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2F93AA57
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656451624; x=1687987624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KFw1Jf1CGCi6tvKBAkg6fX1RZBJfp5GQwXtTCsGuW14=;
  b=f9VbrkRZDwR4oJAi8Uvf+LffjVyB7bvVD9NejU6FJR0saVKAKZKrohHj
   gFaJvPzZUSJdpaL2G8tTd7Y+AEG+1HbR+g22nqvMvlEhfXXiY21o/sXNP
   UoVQzdaobM2QzLkLIhDaP6vg2tRRRYK+Tciib5j+A4wTMpkNtM0LXF72b
   NAGZBERsF1Aas7EhErllUjAxtiZmqQLGAu29xtwG+OS8GXTtJSvzSkpgE
   6OGX8Iz2C8pqM9iK3tv3nlGDfmO8PwkJFja6HUPz+yX082c4Q26mTMuYD
   U+YTVKdAaF8QCwv/xjhL7CtnXTtOtEBBFQGENGsqfiQSX4pVTanBgr5xm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368165706"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="368165706"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:27:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="647086093"
Received: from tuckermc-mobl.amr.corp.intel.com (HELO [10.212.191.153]) ([10.212.191.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 14:27:03 -0700
Message-ID: <395cbc90-da43-c505-7bf0-18f8ac8e78cc@linux.intel.com>
Date:   Tue, 28 Jun 2022 14:26:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
 <YrtonRQTeLZeYm8T@smile.fi.intel.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <YrtonRQTeLZeYm8T@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/28/22 13:46, Andy Shevchenko wrote:
> On Tue, Jun 28, 2022 at 09:50:24AM -0700, Moises Veleta wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
>>
>> GNSS AT control port allows Modem Manager to control GPS for:
>> - Start/Stop GNSS sessions,
>> - Configuration commands to support Assisted GNSS positioning
>> - Crash & reboot (notifications when resetting device (AP) & host)
>> - Settings to Enable/Disable GNSS solution
>> - Geofencing
>>
>> Rename small Application Processor (sAP) to AP.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Missed cutter '---' line here. Effectively invalidates your tag block and may
> not be applied (as no SoB present _as a tag_).
Thanks for catching that! Next time I will add '---' between the 
Signed-offs and the vX change log.
>> Change log in v2:
>> - Add to commit message renaming sAP to AP
>> - Add to commit message GNSS AT port info
>> - Lowercase X in constant prefix
>> - Add GNSS AT comment in static port file
>> ---
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 17 +++--
>>   drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  2 +-
>>   drivers/net/wwan/t7xx/t7xx_mhccif.h        |  1 +
>>   drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 85 ++++++++++++++++++----
>>   drivers/net/wwan/t7xx/t7xx_modem_ops.h     |  3 +
>>   drivers/net/wwan/t7xx/t7xx_port.h          | 10 ++-
>>   drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |  8 +-
>>   drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 24 ++++++
>>   drivers/net/wwan/t7xx/t7xx_reg.h           |  2 +-
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.c | 13 +++-
>>   drivers/net/wwan/t7xx/t7xx_state_monitor.h |  2 +


Regards,

Moises

