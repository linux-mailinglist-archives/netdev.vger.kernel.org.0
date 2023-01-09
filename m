Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5270E662AD3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjAIQIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjAIQIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:08:00 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372B93AAAC;
        Mon,  9 Jan 2023 08:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673280479; x=1704816479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U2wZo7YImjw8iGThsIb1GjeZZAAZ6xxiPbQ0GHK+dAU=;
  b=YcExn20Iyxo/5H0V5inRlzjAlHIS4P38Lp0uD8vCTMtkXb0ZzTOmzM9e
   wTvKdoGSSuOc++LD5ku/5WRCmSi5n/VRErNxq+/vdkVsTUhbAutJZoQ/M
   h2US8flTumEYu6iwa8VFoRGtO0sN17GyCrOSCLWdBBzITtAK2XHYs4sfA
   REom55OUTVwbS2+SAnVTFkcD8n6CB34FTKLeMbZvzmKVdGw3ph1N9GqQe
   pvBcmkU1oFh4h7TPDFy9vbb1TJSRocVqWjqRnETIVm/f0uLfgPl5bLZ++
   fG32POzJSKavFO1u/sK2qpGd/locMNv1NxpdcRCj+2w18qee/sllrLfnD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="306424950"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306424950"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 08:07:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="658646531"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="658646531"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.194.243]) ([10.215.194.243])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 08:07:33 -0800
Message-ID: <c7bd8511-7d4f-526a-28b9-215edc6e7c7f@linux.intel.com>
Date:   Mon, 9 Jan 2023 21:37:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 5/5] net: wwan: t7xx: Devlink documentation
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-doc@vger.kernel.org,
        jiri@nvidia.com, corbet@lwn.net
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
 <Y7uOcBRN0Awn5xAb@debian.me>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <Y7uOcBRN0Awn5xAb@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bagas,
Thank you for the feedback.

On 1/9/2023 9:18 AM, Bagas Sanjaya wrote:
> On Fri, Jan 06, 2023 at 09:58:06PM +0530, m.chetan.kumar@linux.intel.com wrote:
>> Refer to t7xx.rst file for details.
> 
> Above line is unnecessary.

Ok. Will drop it.

> 
>> +The wwan device is put into fastboot mode via devlink reload command, by
>> +passing "driver_reinit" action.
>> +
>> +$ devlink dev reload pci/0000:$bdf action driver_reinit
>> +
>> +Upon completion of fw flashing or coredump collection the wwan device is
>> +reset to normal mode using devlink reload command, by passing "fw_activate"
>> +action.
>> +
>> +$ devlink dev reload pci/0000:$bdf action fw_activate
> 
> Personally I prefer to put command-line explanations below the actual
> command:

Sure. Will keep explanation under the command.

> 
> ---- >8 ----
> 
> diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
> index de220878ad7649..24f9e0ee69bffb 100644
> --- a/Documentation/networking/devlink/t7xx.rst
> +++ b/Documentation/networking/devlink/t7xx.rst
> @@ -74,17 +74,21 @@ The supported list of firmware image types is described below.
>   procedure, fastboot command & response are exchanged between driver and wwan
>   device.
>   
> +::
> +
> +  $ devlink dev reload pci/0000:$bdf action driver_reinit
> +
>   The wwan device is put into fastboot mode via devlink reload command, by
>   passing "driver_reinit" action.
>   
> -$ devlink dev reload pci/0000:$bdf action driver_reinit
> +::
> +
> +  $ devlink dev reload pci/0000:$bdf action fw_activate
>   
>   Upon completion of fw flashing or coredump collection the wwan device is
>   reset to normal mode using devlink reload command, by passing "fw_activate"
>   action.
>   
> -$ devlink dev reload pci/0000:$bdf action fw_activate
> -
>   Flash Commands:
>   ===============
>   
> 
> However, I find it's odd to jump from firmware image type list directly to
> devlink usage. Perhaps the latter should be put into the following section
> below?

Ok. Will move image type list under Flash Commands.

> 
> I also find that there is minor inconsistency of keyword formatting, so I
> have to inline-code the uninlined remainings:

Ok. Will correct it.

> 
> ---- >8 ----
> 
> diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
> index 24f9e0ee69bffb..d8feefe116c978 100644
> --- a/Documentation/networking/devlink/t7xx.rst
> +++ b/Documentation/networking/devlink/t7xx.rst
> @@ -29,7 +29,7 @@ Flash Update
>   The ``t7xx`` driver implements the flash update using the ``devlink-flash``
>   interface.
>   
> -The driver uses DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT to identify the type of
> +The driver uses ``DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT`` to identify the type of
>   firmware image that need to be programmed upon the request by user space application.
>   
>   The supported list of firmware image types is described below.
> @@ -79,14 +79,14 @@ device.
>     $ devlink dev reload pci/0000:$bdf action driver_reinit
>   
>   The wwan device is put into fastboot mode via devlink reload command, by
> -passing "driver_reinit" action.
> +passing ``driver_reinit`` action.
>   
>   ::
>   
>     $ devlink dev reload pci/0000:$bdf action fw_activate
>   
>   Upon completion of fw flashing or coredump collection the wwan device is
> -reset to normal mode using devlink reload command, by passing "fw_activate"
> +reset to normal mode using devlink reload command, by passing ``fw_activate``
>   action.
>   
>   Flash Commands:
>   
>> +
>> +Flash Commands:
>> +===============
> 
> Trim the unneeded trailing colon on the section title.

Ok. will drop it.

> 
>> +
>> +$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
>> +
>> +$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
>> +
>> +$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
>> +
>> +$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
>> +
>> +$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
>> +
>> +$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
>> +
>> +$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
>> +
>> +$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
>> +
>> +$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
>> +
>> +$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
>> +
>> <snipped>...
>> +Region commands
>> +===============
>> +
>> +$ devlink region show
>> +
>> +
>> +$ devlink region new mr_dump
>> +
>> +$ devlink region read mr_dump snapshot 0 address 0 length $len
>> +
>> +$ devlink region del mr_dump snapshot 0
>> +
>> +$ devlink region new lk_dump
>> +
>> +$ devlink region read lk_dump snapshot 0 address 0 length $len
>> +
>> +$ devlink region del lk_dump snapshot 0
>> +
>> +Note: $len is actual len to be dumped.
> 
> Please briefly describe these devlink commands.

Ok. Will add some explanations.

> 
> Also, wrap them in literal code blocks:
> 
> ---- >8 ----
> 
> diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
> index d8feefe116c978..1ba3ba4680e721 100644
> --- a/Documentation/networking/devlink/t7xx.rst
> +++ b/Documentation/networking/devlink/t7xx.rst
> @@ -92,35 +92,65 @@ action.
>   Flash Commands:
>   ===============
>   
> -$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
> +  $ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
>   
> -$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
> +  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
>   
> -$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
> +  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
>   
> -$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
> +  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
>   
> -$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
> +  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
>   
> -$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
> +  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
>   
> -$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
> +::
>   
> -$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
> +  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
>   
> -$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
>   
>   Note: Component selects the partition type to be programmed.
>   
> @@ -147,19 +177,31 @@ Following regions are accessed for device internal data.
>   Region commands
>   ===============
>   
> -$ devlink region show
> +::
> +  $ devlink region show
>   
> +::
>   
> -$ devlink region new mr_dump
> +  $ devlink region new mr_dump
>   
> -$ devlink region read mr_dump snapshot 0 address 0 length $len
> +::
>   
> -$ devlink region del mr_dump snapshot 0
> +  $ devlink region read mr_dump snapshot 0 address 0 length $len
>   
> -$ devlink region new lk_dump
> +::
>   
> -$ devlink region read lk_dump snapshot 0 address 0 length $len
> +  $ devlink region del mr_dump snapshot 0
>   
> -$ devlink region del lk_dump snapshot 0
> +::
> +
> +  $ devlink region new lk_dump
> +
> +::
> +
> +  $ devlink region read lk_dump snapshot 0 address 0 length $len
> +
> +::
> +
> +  $ devlink region del lk_dump snapshot 0
>   
>   Note: $len is actual len to be dumped.
> 
> Thanks.
> 

Thanks for the inline-code. Will follow the suggested format for 
documentation.

-- 
Chetan
