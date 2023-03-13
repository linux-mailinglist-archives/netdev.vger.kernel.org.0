Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB96B7202
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCMJFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjCMJFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:05:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDAACC2B;
        Mon, 13 Mar 2023 02:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678698122; x=1710234122;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=pI4nUmeEVLC3M5pHVpsWX+NZs0JcgtOBrvHpvPUR7eg=;
  b=EkhYi4RdBGdu3QgJdPFU/U+D88BS49AMSYSHC2XBho2cfDU3Ge44RBDq
   QsvK/lFQGNXk0lXJHa0+l7qHjRz4W9NbT3ADJZTP/kja/Pe0u7wZeYGG4
   ekunyiW/i1B4j7atJrvxy2m8MSC/fB3kjnU9XUX3UzeDMpbqopuNbvkPE
   1exz+sX50KN8HzhdVAeK4b6PQ9p302dvKp6je0oWhkLI0zeqc9Lw8rhPt
   ysCAiWn1R0GTIyowZbjGC4Gzz/DocdOPTlkPge8TgrxHtiD8+xgKJ6c+w
   wAvqOW0FMZ0DeiYOQpa2YQWW9Bh1y9yLKaYddXeNcuNmBkWImSaWV+MHr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="339468051"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="339468051"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 02:01:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628552130"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="628552130"
Received: from etsykuno-mobl2.ccr.corp.intel.com ([10.252.47.211])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 02:01:52 -0700
Date:   Mon, 13 Mar 2023 11:01:47 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, alok.a.tiwari@oracle.com,
        hdanton@sina.com, leon@kernel.org, Netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v8 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
In-Reply-To: <20230310181921.1437890-4-neeraj.sanjaykale@nxp.com>
Message-ID: <52e8d148-8b0-c0f7-5f27-716ec2d247e0@linux.intel.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com> <20230310181921.1437890-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1117770723-1678698117=:2573"
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

--8323329-1117770723-1678698117=:2573
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 10 Mar 2023, Neeraj Sanjay Kale wrote:

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

> v8: Move bootloader signature handling to a separate function. Add
> select CRC32 to Kconfig file. (Ilpo Järvinen)

> +config BT_NXPUART
> +	tristate "NXP protocol support"
> +	depends on SERIAL_DEV_BUS
> +	help
> +	  NXP is serial driver required for NXP Bluetooth
> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module (btnxpuart).
> +
> +

The select change in not there.


-- 
 i.

--8323329-1117770723-1678698117=:2573--
