Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786E85B4003
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiIITmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiIITlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:41:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C1D14A52D;
        Fri,  9 Sep 2022 12:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 491B7B82607;
        Fri,  9 Sep 2022 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8206C433D6;
        Fri,  9 Sep 2022 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662752331;
        bh=FfmmzxqN9ZwNiKXNw6xZkYm5SglV5tc8WW01IPrgjjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GBl8qdIiDq7a6c2Lbkg2rb7uclYEGiTF7VTz6I1qIVqGwnpo4N4s827gGekGOdia3
         w6cYxtJewhn1XW4bND8xj+uTgYKx5SHf9XW3kYFPWHL6czBduNxZI2SoyCiUEHnYQD
         oPP4vW5prswPdAVBAqQEyJzJIBCdITuSW1sTNJC0qVTHXO16w9ofTZPqXsnKVdr2Pl
         VS/p4JPb2iqcBqQV/4oZvuApMWceC34WCbS+V+FMhdpwmzzhf4GU/sXgzsSlieALzh
         VOcbmZwEk0lx1BiZvlfC8/4c1DTfLg4p5nkrAmw3ZQQ64N+QNXLEXqehiOwJ9cxd5R
         6z+yPL8ou8W2g==
Date:   Fri, 9 Sep 2022 14:38:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Easwar Hariharan <eahariha@linux.microsoft.com>
Cc:     vkuznets@redhat.com, Deepak Rawat <drawat.floss@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Helge Deller <deller@gmx.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Easwar Hariharan <easwar.hariharan@microsoft.com>,
        Colin Ian King <colin.i.king@googlemail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "open list:DRM DRIVER FOR HYPERV SYNTHETIC VIDEO DEVICE" 
        <linux-hyperv@vger.kernel.org>,
        "open list:DRM DRIVER FOR HYPERV SYNTHETIC VIDEO DEVICE" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] pci_ids: Add the various Microsoft PCI device IDs
Message-ID: <20220909193849.GA309868@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662749425-3037-3-git-send-email-eahariha@linux.microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please follow the PCI subject line conventions.  Discover it with
"git log --oneline include/linux/pci_ids.h".

On Fri, Sep 09, 2022 at 11:50:25AM -0700, Easwar Hariharan wrote:
> From: Easwar Hariharan <easwar.hariharan@microsoft.com>
> 

Needs a commit log, even if it is nothing more than the subject line.

Also read the top of include/linux/pci_ids.h, because it looks like
some of these are only used in one driver and hence do not need to be
in pci_ids.h.

> Signed-off-by: Easwar Hariharan <easwar.hariharan@microsoft.com>
> ---
>  drivers/gpu/drm/hyperv/hyperv_drm_drv.c         | 2 +-
>  drivers/net/ethernet/microsoft/mana/gdma.h      | 3 ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 +++---
>  drivers/video/fbdev/hyperv_fb.c                 | 4 ++--
>  include/linux/pci_ids.h                         | 4 +++-
>  5 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
> index f84d397..24c2def 100644
> --- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
> +++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
> @@ -51,7 +51,7 @@ static void hyperv_pci_remove(struct pci_dev *pdev)
>  static const struct pci_device_id hyperv_pci_tbl[] = {
>  	{
>  		.vendor = PCI_VENDOR_ID_MICROSOFT,
> -		.device = PCI_DEVICE_ID_HYPERV_VIDEO,
> +		.device = PCI_DEVICE_ID_MICROSOFT_HYPERV_VIDEO,
>  	},
>  	{ /* end of list */ }
>  };
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
> index 4a6efe6..9d3a9f7 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma.h
> +++ b/drivers/net/ethernet/microsoft/mana/gdma.h
> @@ -476,9 +476,6 @@ struct gdma_eqe {
>  
>  #define GDMA_SRIOV_REG_CFG_BASE_OFF	0x108
>  
> -#define MANA_PF_DEVICE_ID 0x00B9
> -#define MANA_VF_DEVICE_ID 0x00BA
> -
>  struct gdma_posted_wqe_info {
>  	u32 wqe_size_in_bu;
>  };
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 00d8198..18cf168 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1333,7 +1333,7 @@ static void mana_gd_cleanup(struct pci_dev *pdev)
>  
>  static bool mana_is_pf(unsigned short dev_id)
>  {
> -	return dev_id == MANA_PF_DEVICE_ID;
> +	return dev_id == PCI_DEVICE_ID_MICROSOFT_MANA_PF;
>  }
>  
>  static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> @@ -1466,8 +1466,8 @@ static void mana_gd_shutdown(struct pci_dev *pdev)
>  }
>  
>  static const struct pci_device_id mana_id_table[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_PF_DEVICE_ID) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, MANA_VF_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, PCI_DEVICE_ID_MICROSOFT_MANA_PF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_MICROSOFT, PCI_DEVICE_ID_MICROSOFT_MANA_VF) },
>  	{ }
>  };
>  
> diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
> index b58b445..118e244 100644
> --- a/drivers/video/fbdev/hyperv_fb.c
> +++ b/drivers/video/fbdev/hyperv_fb.c
> @@ -997,7 +997,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
>  
>  	if (!gen2vm) {
>  		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
> -			PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
> +			PCI_DEVICE_ID_MICROSOFT_HYPERV_VIDEO, NULL);
>  		if (!pdev) {
>  			pr_err("Unable to find PCI Hyper-V video\n");
>  			return -ENODEV;
> @@ -1311,7 +1311,7 @@ static int hvfb_resume(struct hv_device *hdev)
>  static const struct pci_device_id pci_stub_id_table[] = {
>  	{
>  		.vendor      = PCI_VENDOR_ID_MICROSOFT,
> -		.device      = PCI_DEVICE_ID_HYPERV_VIDEO,
> +		.device      = PCI_DEVICE_ID_MICROSOFT_HYPERV_VIDEO,
>  	},
>  	{ /* end of list */ }
>  };
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 15b49e6..fe3517f 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2080,7 +2080,9 @@
>  #define PCI_DEVICE_ID_VT1724		0x1724
>  
>  #define PCI_VENDOR_ID_MICROSOFT		0x1414
> -#define PCI_DEVICE_ID_HYPERV_VIDEO	0x5353
> +#define PCI_DEVICE_ID_MICROSOFT_HYPERV_VIDEO	0x5353
> +#define PCI_DEVICE_ID_MICROSOFT_MANA_PF  	0x00B9
> +#define PCI_DEVICE_ID_MICROSOFT_MANA_VF  	0x00BA
>  
>  #define PCI_VENDOR_ID_OXSEMI		0x1415
>  #define PCI_DEVICE_ID_OXSEMI_12PCI840	0x8403
> -- 
> 1.8.3.1
> 
