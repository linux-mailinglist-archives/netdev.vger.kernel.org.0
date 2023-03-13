Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7D6B7A38
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCMOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjCMOTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:19:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B25855BD;
        Mon, 13 Mar 2023 07:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678717176; x=1710253176;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=UvXWWjYWFyByb3yselhOpraN5TwzIc41HmQ1z3Y7kNU=;
  b=VlPZQ5gj+HuMNV5pXKMNnJce7PhC8chkfyo7uosvnG4HhnD7bYeG5DK6
   esBDAip7HAb9gf0E+/VIQcPp7ZkMo+dOnrkBcLDy+Zg/0FE3KD5Y0bNIU
   GfT94v9rXgtdIqrDG5o7iulSx/Qr6i1CRJ60ZRKFcPfWGFdLJ0YCGigf2
   sgFaspkmgMBfkQGnxukAl643A5gICUtcwuikW1H+3sKRZTR2kGEhXtzBo
   wkYhvhkrMJkWjzdcK97lwp6au0G1s6w5BCq1DUJL1TGPamqjw5Bz2o1u5
   kKD04koIk8wufwlxzQxqTpGfp2Q6UoY9RzsSLuGAAV7SpcuN6HnR3hkN6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="335855779"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="335855779"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:19:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="628650322"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="628650322"
Received: from etsykuno-mobl2.ccr.corp.intel.com ([10.252.47.211])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:19:15 -0700
Date:   Mon, 13 Mar 2023 16:19:13 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, alok.a.tiwari@oracle.com,
        hdanton@sina.com, leon@kernel.org, simon.horman@corigine.com,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v9 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <20230313140924.3104691-4-neeraj.sanjaykale@nxp.com>
Message-ID: <b28d1e39-f036-c260-4452-ac1332efca0@linux.intel.com>
References: <20230313140924.3104691-1-neeraj.sanjaykale@nxp.com> <20230313140924.3104691-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-949427343-1678716921=:2573"
Content-ID: <d0d0d083-5eee-bc4e-247e-ae68d1b8294@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-949427343-1678716921=:2573
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <e726a4dc-97d5-5826-9ea5-ba8b2d5bbdfe@linux.intel.com>

On Mon, 13 Mar 2023, Neeraj Sanjay Kale wrote:

> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any
> activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending the vendor
> specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the chip
> by waiting for the bootloader signature, and downloads device specific FW
> file into the chip over UART if bootloader signature is received..
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based
> on compatibility devices mentioned in DT bindings. Handled potential
> memory leaks and null pointer dereference issues, simplified FW download
> feature, handled byte-order and few cosmetic changes. (Ilpo Järvinen,
> Alok Tiwari, Hillf Danton)
> v3: Added conf file support necessary to support different vendor modules,
> moved .h file contents to .c, cosmetic changes. (Luiz Augusto von Dentz,
> Rob Herring, Leon Romanovsky)
> v4: Removed conf file support, optimized driver data, add logic to select
> FW name based on chip signature (Greg KH, Ilpo Järvinen, Sherry Sun)
> v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
> parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto von Dentz)
> v6: Add support for fw-init-baudrate parameter from device tree,
> modified logic to detect FW download is needed or FW is running. (Greg
> KH, Sherry Sun)
> v7: Renamed variables, improved FW download functions, include ps_data
> into btnxpuart_dev. (Ilpo Järvinen)
> v8: Move bootloader signature handling to a separate function. Add
> select CRC32 to Kconfig file. (Ilpo Järvinen)
> v9: Change datatype of FW download command CRC to __be32. (Ilpo Järvinen)

Thanks, looks okay to me except this one I just noticed while preparing 
this email:

> +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");

I don't think version numbers belong to the module description.


Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.
--8323329-949427343-1678716921=:2573--
