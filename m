Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB326679BDA
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjAXObM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbjAXObL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:31:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788F346099;
        Tue, 24 Jan 2023 06:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674570668; x=1706106668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FS5V8JCNVFlB24cP8RHBjihhl3JxDW+KmPxc7sSHJM4=;
  b=PAqFMU5K4p7WvzJF+PsIQTCWsUZan7gwK/FNBl7wUBRhUzczFV+GT2TA
   tZwprDSru4hRkPbmfRy7TpzwdmymdFh2/dFPxCzild6Yemo1j84xrxMnP
   +b+V5Ce0/Yu5u1lSw+zd8sMV5G4/iHSTVaCxrIWZm88ouHB25xZvgTNWP
   cmZw3ZokAigMP+EySTM2PrNu9/8XYovZb3gzNLgPImCLhoDWobGFeqj0H
   pqOzvldOQ4OEeAyiQBtM4Q4pOsKss+MMONM9qkILnVF7kzTlwKDoWogye
   OBTakA5446vSnKh70xk26kbJ45xQOzEBnPaRiky8GqcBcwXSCxN5dJL7c
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="305966136"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="305966136"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 06:31:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="835980846"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="835980846"
Received: from ppathann-mobl.gar.corp.intel.com (HELO [10.213.120.197]) ([10.213.120.197])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 06:31:02 -0800
Message-ID: <29f470c1-4b93-e7d2-88ec-5cce716c128d@linux.intel.com>
Date:   Tue, 24 Jan 2023 20:00:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jiri@nvidia.com
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
 <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
 <Y8yb2AKf9mDHP0zu@debian.me>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <Y8yb2AKf9mDHP0zu@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/2023 7:43 AM, Bagas Sanjaya wrote:
> On Sat, Jan 21, 2023 at 07:03:58PM +0530, m.chetan.kumar@linux.intel.com wrote:
>> +Flash Commands
>> +--------------
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
>> +
>> +::
>> +
>> +  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
> 
> It seems like you didn't describe what ``devlink dev flash`` commands above
> are doing, as I had requested from v3 review [1].
> 
>> +Coredump Collection
>> +~~~~~~~~~~~~~~~~~~~
>> +
>> +::
>> +
>> +  $ devlink region new mr_dump
>> +
>> +::
>> +
>> +  $ devlink region read mr_dump snapshot 0 address 0 length $len
>> +
>> +::
>> +
>> +  $ devlink region del mr_dump snapshot 0
>> +
>> +Note: $len is actual len to be dumped.
>> +
>> +The userspace application uses these commands for obtaining the modem component
>> +logs when device encounters an exception.
> 
> Individual command explanation please?
> 
>> +
>> +Second Stage Bootloader dump
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +
>> +::
>> +
>> +  $ devlink region new lk_dump
>> +
>> +::
>> +
>> +  $ devlink region read lk_dump snapshot 0 address 0 length $len
>> +
>> +::
>> +
>> +  $ devlink region del lk_dump snapshot 0
>> +
>> +Note: $len is actual len to be dumped.
>> +
>> +In fastboot mode the userspace application uses these commands for obtaining the
>> +current snapshot of second stage bootloader.
> 
> Individual command explanation please?
> 
> Hint: see any manpages to get sense of how to write the explanations.
> 
> Thanks.
> 
> [1]: https://lore.kernel.org/linux-doc/Y7uOcBRN0Awn5xAb@debian.me/

I have added the explanation for each of those commands and also have 
changed the format a bit.

Could you please take a look and suggest on below changes.


--- a/Documentation/networking/devlink/t7xx.rst
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -54,65 +54,52 @@ action.
  Flash Commands
  --------------

-::
-
-  $ devlink dev flash pci/0000:$bdf file 
preloader_k6880v1_mdot2_datacard.bin component "preloader"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img 
component "loader_ext1"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component 
"spmfw"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component 
"sspm_1"
-
-::
-
-  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component 
"mcupm_1"
+.. code:: shell

-::
+    # Update device Preloader image
+    $ devlink dev flash pci/0000:$bdf file 
preloader_k6880v1_mdot2_datacard.bin component "preloader"

-  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
+    # Update device Preloader extension image
+    $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img 
component "loader_ext1"

-::
+    # Update device TEE (Trusted Execution Environment) image
+    $ devlink dev flash pci/0000:$bdf file tee-verified.img component 
"tee1"

-  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
+    # Update device Second stage bootloader image
+    $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"

-::
+    # Update device PM (Power Management) image
+    $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component 
"spmfw"

-  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
-
-::
+    # Update device Secure PM image
+    $ devlink dev flash pci/0000:$bdf file sspm-verified.img component 
"sspm_1"

-  $ devlink dev flash pci/0000:$bdf file modem-verified.img component 
"md1img"
+    # Update device CPU PM image
+    $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component 
"mcupm_1"

-::
+    # Update device DRAM PM image
+    $ devlink dev flash pci/0000:$bdf file dpm-verified.img component 
"dpm_1"

-  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component 
"md1dsp"
+    # Update Kernel image
+    $ devlink dev flash pci/0000:$bdf file boot-verified.img component 
"boot"

-::
+    # Update Root filesystem image
+    $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"

-  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
+    # Update Modem image
+    $ devlink dev flash pci/0000:$bdf file modem-verified.img component 
"md1img"

-::
+    # Update DSP image
+    $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component 
"md1dsp"

-  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
+    # Update Modem OTA image (operator specific)
+    $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"

-::
+    # Update Modem OTA image (vendor specific)
+    $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"

-  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
+    # Update Modem OTA image (vendor configurtions)
+    $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"

  Note: Component selects the partition type to be programmed.

@@ -166,12 +153,13 @@ the driver using fastboot commands.
  Region commands
  ---------------

-::
+.. code:: shell

-  $ devlink region show
+    # Show all the regions supported by driver.
+    $ devlink region show

-This command list the regions implemented by driver. These regions are 
accessed
-for device internal data. Below table describes the regions.
+Regions are used for accessing device internal data for debugging 
purpose. Below table
+describes the regions.

  .. list-table:: Regions
      :widths: 15 85
@@ -186,17 +174,16 @@ for device internal data. Below table describes 
the regions.
  Coredump Collection
  ~~~~~~~~~~~~~~~~~~~

-::
-
-  $ devlink region new mr_dump
+.. code:: shell

-::
+    # Create a modem region snapshot using:
+    $ devlink region new mr_dump

-  $ devlink region read mr_dump snapshot 0 address 0 length $len
-
-::
+    # Read a specific part of modem region snapshot using:
+    $ devlink region read mr_dump snapshot 0 address 0 length $len

-  $ devlink region del mr_dump snapshot 0
+    # Delete a modem region snapshot using:
+    $ devlink region del mr_dump snapshot 0

  Note: $len is actual len to be dumped.

@@ -206,17 +193,16 @@ logs when device encounters an exception.
  Second Stage Bootloader dump
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-::
-
-  $ devlink region new lk_dump
+.. code:: shell

-::
+    # Create a second stage bootloader snapshot using:
+    $ devlink region new lk_dump

-  $ devlink region read lk_dump snapshot 0 address 0 length $len
-
-::
+    # Read a specific part of second stage booloader snapshot using:
+    $ devlink region read lk_dump snapshot 0 address 0 length $len

-  $ devlink region del lk_dump snapshot 0
+    # Delete a second stage bootloader snapshot using:
+    $ devlink region del lk_dump snapshot 0

  Note: $len is actual len to be dumped.


-- 
Chetan
