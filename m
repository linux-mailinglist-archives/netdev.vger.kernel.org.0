Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036104D0CF4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbiCHAsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiCHAsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:48:02 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AC82C677;
        Mon,  7 Mar 2022 16:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646700426; x=1678236426;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kLn6O9vNC1OEB9AI01OFGZINoxo7G/urtRjFfDyBTmQ=;
  b=C6H9KlJZfCW2DkiPNy1ZGmksqkpe8inNPXowa8spnbXTL5V83kxD37V9
   ljijcpzrnmCwOw2ztKoN6LI0XftnydZQkpXH2+qLp4PjFgdBz2KqHlar5
   Ig8oK8OlYTcx7sEg9A6CFVe7moTYYlBSuTbTc01pUCYcg0WzhDwcI6TmC
   Ghlr0cGOXxusLL8FGKtuoOkh8W/H4ABf//QEosd9adt+FOB26NY/MnjMB
   tpGuBeUlZvoVVVRNS5nvg6v4xFzbekEnkm3MuwsXzJODAieDXSFZFLFpW
   qd11zJr3M16/Fkby+6Pp7KAaQ1yH94TcJle94GEh6Y4VSx0JdFRMWzTRE
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254738761"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254738761"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:47:06 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="512899685"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.10.64]) ([10.251.10.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:47:05 -0800
Message-ID: <ab04cf86-9e4d-6282-61b8-02681c18b92f@linux.intel.com>
Date:   Mon, 7 Mar 2022 16:47:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 03/13] net: wwan: t7xx: Add core components
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-4-ricardo.martinez@linux.intel.com>
 <d5e3d2c-998b-58aa-9e71-43210f33e6f@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <d5e3d2c-998b-58aa-9e71-43210f33e6f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/25/2022 3:10 AM, Ilpo Järvinen wrote:
> On Wed, 23 Feb 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Registers the t7xx device driver with the kernel. Setup all the core
>> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
>> modem control operations, modem state machine, and build
>> infrastructure.
>>
>> * PCIe layer code implements driver probe and removal.
>> * MHCCIF provides interrupt channels to communicate events
>>    such as handshake, PM and port enumeration.
>> * Modem control implements the entry point for modem init,
>>    reset and exit.
>> * The modem status monitor is a state machine used by modem control
>>    to complete initialization and stop. It is used also to propagate
>>    exception events reported by other components.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>
>> >From a WWAN framework perspective:
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>> ---
>> +	/* IPs enable interrupts when ready */
>> +	for (i = 0; i < EXT_INT_NUM; i++)
>> +		t7xx_pcie_mac_clear_int(t7xx_dev, i);
> In v4, PCIE_MAC_MSIX_MSK_SET() wrote to IMASK_HOST_MSIX_SET_GRP0_0.
> In v5, t7xx_pcie_mac_clear_int() writes to IMASK_HOST_MSIX_CLR_GRP0_0.
>
> t7xx_pcie_mac_set_int() would write to IMASK_HOST_MSIX_SET_GRP0_0
> matching to what v4 did. So you probably want to call
> t7xx_pcie_mac_set_int() instead of t7xx_pcie_mac_clear_int()?
Yes, this should call t7xx_pcie_mac_set_int().
>
