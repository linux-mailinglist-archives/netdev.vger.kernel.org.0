Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA254FF426
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiDMJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiDMJxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:53:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3FC4A923;
        Wed, 13 Apr 2022 02:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E57DB82161;
        Wed, 13 Apr 2022 09:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B24BC385A4;
        Wed, 13 Apr 2022 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649843489;
        bh=Ll9cmKCnCIZMAyLi98CvN9YvaSxa78kAFH25Ir3N/Lc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o6cyqtjJAqcuHsZDL2GJ5Cu/uyLkMKtP3ZoNzSEoKuskM8DDXIVYGdMXzmGCPXbXX
         x4+G8jBkp9naUQB8RDykGzSr4Uf9ETzn3t5sjtw5yoE0tECMyIzypgAgUI6jwkBzt4
         DXEo0gmLuFZfQxyo6VdEhFItq+RBriomD/d2wYLp4CetEegmGqyO/8fpM/htsIND6b
         fXKedbvQqLWrM/zIYjQZFTSm5uXd5Ch95Kmo/o+1DFwAn//qBv1XvZq8Y8rqLqw43j
         qx1yTCTy4nTERKmkisOoL38D5CsT7gl/HpJolBwP0RbWJCGaoqmSutgA6vjYElozLT
         tj0MUV1IdtH4Q==
Date:   Wed, 13 Apr 2022 12:51:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [net-next PATCH v5 1/7] octeon_ep: Add driver framework and
 device initialization
Message-ID: <YladGTmon1x3dfxI@unreal>
References: <20220413033503.3962-1-vburru@marvell.com>
 <20220413033503.3962-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413033503.3962-2-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 08:34:57PM -0700, Veerasenareddy Burru wrote:
> Add driver framework and device setup and initialization for Octeon
> PCI Endpoint NIC.
> 
> Add implementation to load module, initilaize, register network device,
> cleanup and unload module.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>

<...>

> +static struct workqueue_struct *octep_wq;
> +
> +/* Supported Devices */
> +static const struct pci_device_id octep_pci_id_tbl[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CN93_PF)},
> +	{0, },
> +};
> +MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
> +
> +MODULE_AUTHOR("Veerasenareddy Burru <vburru@marvell.com>");
> +MODULE_DESCRIPTION(OCTEP_DRV_STRING);
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(OCTEP_DRV_VERSION_STR);

No module and/or driver versions in new code.

Thanks
