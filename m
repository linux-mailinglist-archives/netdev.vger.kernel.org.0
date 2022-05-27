Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1921553661A
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 18:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbiE0Qoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 12:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238676AbiE0Qon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 12:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8E3EAD1D
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 09:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD0B61DF6
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 16:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9627AC385B8;
        Fri, 27 May 2022 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653669882;
        bh=4TDRmopppv3+yFUZX9BljdSuGR1hFRNAsK/kBdSdXQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tinJccVszwuYh2tlztIJq4pUnb8fPl49njA5dwS0ylEj/aDkjB+E+rsljbdoE809I
         gI010z8oZVxQuhWqsrVQEgMcVisOKy9QJVUb7ai76zJs6jDGwoI8APb7qVFhIZQhIQ
         Ew4u5MsGrrYk4UeFmrmVIZC54rLWXl2gP5jZbp92sPkmAkGkq/8szvYlSgt0nQHh3M
         mAWqtoos35vTnmQCgcaGvNbVH1A4p3X5D+vAWM9W6WuueRdDqrmcOXEWmYdeDtF7Zj
         p/VAqyy5TRc8lIJBQJDmA0w7yY6ab++5KFeoFsfVzEKUvlmmAxEnXeJztOE3U2FSRQ
         BKVX78PMgfnyg==
Date:   Fri, 27 May 2022 19:44:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: txgbe: Add build support for txgbe
Message-ID: <YpD/9dqThFZZgs2K@unreal>
References: <20220527063157.486686-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527063157.486686-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 02:31:57PM +0800, Jiawen Wu wrote:
> Add doc build infrastructure for txgbe driver.
> Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  .../device_drivers/ethernet/index.rst         |   1 +
>  .../device_drivers/ethernet/wangxun/txgbe.rst |  20 ++
>  MAINTAINERS                                   |   7 +
>  drivers/net/ethernet/Kconfig                  |   1 +
>  drivers/net/ethernet/Makefile                 |   1 +
>  drivers/net/ethernet/wangxun/Kconfig          |  32 +++
>  drivers/net/ethernet/wangxun/Makefile         |   6 +
>  drivers/net/ethernet/wangxun/txgbe/Makefile   |   9 +
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  27 ++
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 241 ++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  65 +++++
>  11 files changed, 410 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
>  create mode 100644 drivers/net/ethernet/wangxun/Kconfig
>  create mode 100644 drivers/net/ethernet/wangxun/Makefile
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
>  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h

<...>

> +/**
> + * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
> + * @adapter: board private structure to initialize
> + *
> + * txgbe_sw_init initializes the Adapter private data structure.
> + * Fields are initialized based on PCI device information and
> + * OS network device settings (MTU size).
> + **/
> +static int txgbe_sw_init(struct txgbe_adapter *adapter)
> +{
> +	struct txgbe_hw *hw = &adapter->hw;
> +	struct pci_dev *pdev = adapter->pdev;
> +
> +	/* PCI config space info */
> +	hw->vendor_id = pdev->vendor;
> +	hw->device_id = pdev->device;
> +	hw->revision_id = pdev->revision;
> +	hw->subsystem_vendor_id = pdev->subsystem_vendor;
> +	hw->subsystem_device_id = pdev->subsystem_device;
> +
> +	return 0;
> +}

You are setting this data, but not using it. I'm not sure that to cache
this data is even correct thing to do in a first place.

> +

<...>

> +	pci_set_master(pdev);
> +	/* errata 16 */
> +	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> +					   PCI_EXP_DEVCTL_READRQ,
> +					   0x1000);

Why do you need this in probe function and not as PCI quirk?

Thanks
