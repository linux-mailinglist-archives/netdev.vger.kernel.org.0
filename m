Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7204C6644AD
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbjAJP1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbjAJP0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:26:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4BC8B536;
        Tue, 10 Jan 2023 07:26:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0910D6178E;
        Tue, 10 Jan 2023 15:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282FDC433D2;
        Tue, 10 Jan 2023 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673364368;
        bh=i8m6nnObUjQAxVsR4ErMApSFIjYm0i6e8LmsHTc+RzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=aN1C5tuhxBq0HXkvxafm6eDrBiqlZObX9jGntIfkU2YFvTz31cTWAzfBQdkMxNvhu
         RugL5b0ZhmQqd87cotoEzdTTZhnI8efCiGumaEjdht+GBaSLL7BZzsaZqE/ZGF0IHC
         9VczJ/WT+PyDjYOoDfYM7DhwOnmcNgV8ei0atpHfANoKCU+RlMwfcg9KfgkMu7AxQB
         A3qIt+vw3iC+/W+D1yzz6cm7hL2a++O8lStMtk4R+aKazbPR6Pz+ND6/VYfzaF1UPr
         IfMG1O1ndu2S4XQ9YaZpDB2b+ItQMCpvYholdLIQSqoM9nzG3z0n3Vwcr4rrMLFaW5
         bEKiSZmHVwvZg==
Date:   Tue, 10 Jan 2023 09:26:06 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 2/7] PCI: Remove PCI IDs used by the Sun Cassini
 driver
Message-ID: <20230110152606.GA1504608@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106220020.1820147-3-anirudh.venkataramanan@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 02:00:15PM -0800, Anirudh Venkataramanan wrote:
> The previous patch removed the Cassini driver (drivers/net/ethernet/sun).
> With this, PCI_DEVICE_ID_NS_SATURN and PCI_DEVICE_ID_SUN_CASSINI are
> unused. Remove them.
> 
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  include/linux/pci_ids.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index b362d90..eca2340 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -433,7 +433,6 @@
>  #define PCI_DEVICE_ID_NS_CS5535_AUDIO	0x002e
>  #define PCI_DEVICE_ID_NS_CS5535_USB	0x002f
>  #define PCI_DEVICE_ID_NS_GX_VIDEO	0x0030
> -#define PCI_DEVICE_ID_NS_SATURN		0x0035
>  #define PCI_DEVICE_ID_NS_SCx200_BRIDGE	0x0500
>  #define PCI_DEVICE_ID_NS_SCx200_SMI	0x0501
>  #define PCI_DEVICE_ID_NS_SCx200_IDE	0x0502
> @@ -1047,7 +1046,6 @@
>  #define PCI_DEVICE_ID_SUN_SABRE		0xa000
>  #define PCI_DEVICE_ID_SUN_HUMMINGBIRD	0xa001
>  #define PCI_DEVICE_ID_SUN_TOMATILLO	0xa801
> -#define PCI_DEVICE_ID_SUN_CASSINI	0xabba

I don't think there's value in removing these definitions.  I would
just leave them alone.
