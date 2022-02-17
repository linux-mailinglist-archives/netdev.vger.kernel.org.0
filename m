Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31434BA64A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbiBQQkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:40:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243374AbiBQQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:40:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A8C2B2FFE;
        Thu, 17 Feb 2022 08:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=CiWUvZ5366lvIGhETsSSEgnHPIlanXaVnZLtS1TTtsI=; b=QsoogWw/JVCdBKfTtTDfPkNwuS
        hwTOkgQ0FzqnYrFza/hSa2oOK6BUHsw8hJShqzZ6POFid6nIrZIGyMEqRpSmrVYxLgrOagTmOWvDs
        Iw+o/gznG5u+fEHDG/2ZiEFcO9tPT1rcoGWG1hUn51Pt0ytcskrKkzYir76AHEJc5kXGpa8KPjF75
        rf6rco1DHi0m+gL+7CWEj+T2U5XsW6xa3PGmehMMpAXnHOj4t02oYVlAu2r9LAKYJtStWOLI/hN9U
        rj7+kekdZ9ahS+Rjb6tOrutggtlAPJlbr9M5CJvWr2WufB9EdhP0dcEuyN6P4dF2ZOXZ7FhkTegkC
        QzMZ9g3g==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nKjoq-00Fm3P-Az; Thu, 17 Feb 2022 16:39:48 +0000
Message-ID: <a9c40409-a72d-276c-777f-c7b1863e4537@infradead.org>
Date:   Thu, 17 Feb 2022 08:39:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] net: ethernet: xilinx: cleanup comments
Content-Language: en-US
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        esben@geanix.com, arnd@arndb.de, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moyufeng@huawei.com, michael@walle.cc,
        yuehaibing@huawei.com, prabhakar.mahadev-lad.rj@bp.renesas.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20220217160518.3255003-1-trix@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220217160518.3255003-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/22 08:05, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'the'.
> Replacements:
> endiannes to endianness
> areconnected to are connected
> Mamagement to Management
> undoccumented to undocumented
> Xilink to Xilinx
> strucutre to structure
> 
> Change kernel-doc comment style to c style for
> /* Management ...
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

> ---
> v2: Change the /** to /* 
>     Add Michal's Reviewed-by: tag
> 
>  drivers/net/ethernet/xilinx/Kconfig               | 2 +-
>  drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
>  drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
> index 911b5ef9e680..0014729b8865 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  #
> -# Xilink device configuration
> +# Xilinx device configuration
>  #
>  
>  config NET_VENDOR_XILINX
> diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
> index 4a73127e10a6..c6395c406418 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac.h
> +++ b/drivers/net/ethernet/xilinx/ll_temac.h
> @@ -271,7 +271,7 @@ This option defaults to enabled (set) */
>  
>  #define XTE_TIE_OFFSET			0x000003A4 /* Interrupt enable */
>  
> -/**  MII Mamagement Control register (MGTCR) */
> +/* MII Management Control register (MGTCR) */
>  #define XTE_MGTDR_OFFSET		0x000003B0 /* MII data */
>  #define XTE_MIIMAI_OFFSET		0x000003B4 /* MII control */
>  
> @@ -283,7 +283,7 @@ This option defaults to enabled (set) */
>  
>  #define STS_CTRL_APP0_ERR         (1 << 31)
>  #define STS_CTRL_APP0_IRQONEND    (1 << 30)
> -/* undoccumented */
> +/* undocumented */
>  #define STS_CTRL_APP0_STOPONEND   (1 << 29)
>  #define STS_CTRL_APP0_CMPLT       (1 << 28)
>  #define STS_CTRL_APP0_SOP         (1 << 27)
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index b900ab5aef2a..7171b5cdec26 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1008,7 +1008,7 @@ static void ll_temac_recv(struct net_device *ndev)
>  		    (skb->len > 64)) {
>  
>  			/* Convert from device endianness (be32) to cpu
> -			 * endiannes, and if necessary swap the bytes
> +			 * endianness, and if necessary swap the bytes
>  			 * (back) for proper IP checksum byte order
>  			 * (be16).
>  			 */
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index de0a6372ae0e..6eeaab77fbe0 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -537,7 +537,7 @@ static int __axienet_device_reset(struct axienet_local *lp)
>   * This function is called to reset and initialize the Axi Ethernet core. This
>   * is typically called during initialization. It does a reset of the Axi DMA
>   * Rx/Tx channels and initializes the Axi DMA BDs. Since Axi DMA reset lines
> - * areconnected to Axi Ethernet reset lines, this in turn resets the Axi
> + * are connected to Axi Ethernet reset lines, this in turn resets the Axi
>   * Ethernet core. No separate hardware reset is done for the Axi Ethernet
>   * core.
>   * Returns 0 on success or a negative error number otherwise.
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 519599480b15..f65a638b7239 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -498,7 +498,7 @@ static void xemaclite_update_address(struct net_local *drvdata,
>   * @dev:	Pointer to the network device instance
>   * @address:	Void pointer to the sockaddr structure
>   *
> - * This function copies the HW address from the sockaddr strucutre to the
> + * This function copies the HW address from the sockaddr structure to the
>   * net_device structure and updates the address in HW.
>   *
>   * Return:	Error if the net device is busy or 0 if the addr is set

-- 
~Randy
