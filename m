Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F261016F095
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgBYUuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbgBYUuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 15:50:50 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8A6520675;
        Tue, 25 Feb 2020 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582663849;
        bh=Q3oe1jxf23yBLBrYYE0k+LTqlIPd2rBAHhHvbGkjQlo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tmyBTjgnONnSCV+zBj0HV0B4XxFIdMnoFPCfUcc6+p3zeJfkCYynmcFx5XzEJJeWx
         2d1rVmeeWj9K9LOxXYsW1QaAv+IAA0OJi9Ty4i1N04Tj1urzCMLDNqSSSDW79mAhXy
         Bb/oqu2up4Ig0LQ6MNqF38n633K3DyjjSlyYGaRk=
Date:   Tue, 25 Feb 2020 14:50:47 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 1/8] PCI: add constant PCI_STATUS_ERROR_BITS
Message-ID: <20200225205047.GA194679@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73dd692e-bbce-35f5-88e9-417fb0f7229e@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 03:03:44PM +0100, Heiner Kallweit wrote:

Run "git log --oneline drivers/pci" and make yours match.  In
particular, capitalize the first word ("Add").  Same for the other PCI
patches.  I don't know the drivers/net convention, but please find and
follow that as well.

> This constant is used (with different names) in more than one driver,
> so move it to the PCI core.

The driver constants in *this* patch at least use the same name.

> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/marvell/skge.h | 6 ------
>  drivers/net/ethernet/marvell/sky2.h | 6 ------
>  include/uapi/linux/pci_regs.h       | 7 +++++++
>  3 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
> index 6fa7b6a34..e149bdfe1 100644
> --- a/drivers/net/ethernet/marvell/skge.h
> +++ b/drivers/net/ethernet/marvell/skge.h
> @@ -15,12 +15,6 @@
>  #define  PCI_VPD_ROM_SZ	7L<<14	/* VPD ROM size 0=256, 1=512, ... */
>  #define  PCI_REV_DESC	1<<2	/* Reverse Descriptor bytes */
>  
> -#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
> -			       PCI_STATUS_SIG_SYSTEM_ERROR | \
> -			       PCI_STATUS_REC_MASTER_ABORT | \
> -			       PCI_STATUS_REC_TARGET_ABORT | \
> -			       PCI_STATUS_PARITY)
> -
>  enum csr_regs {
>  	B0_RAP	= 0x0000,
>  	B0_CTST	= 0x0004,
> diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
> index b02b65230..851d8ed34 100644
> --- a/drivers/net/ethernet/marvell/sky2.h
> +++ b/drivers/net/ethernet/marvell/sky2.h
> @@ -252,12 +252,6 @@ enum {
>  };
>  
>  
> -#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
> -			       PCI_STATUS_SIG_SYSTEM_ERROR | \
> -			       PCI_STATUS_REC_MASTER_ABORT | \
> -			       PCI_STATUS_REC_TARGET_ABORT | \
> -			       PCI_STATUS_PARITY)
> -
>  enum csr_regs {
>  	B0_RAP		= 0x0000,
>  	B0_CTST		= 0x0004,
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 543769048..9b84a1278 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -68,6 +68,13 @@
>  #define  PCI_STATUS_SIG_SYSTEM_ERROR	0x4000 /* Set when we drive SERR */
>  #define  PCI_STATUS_DETECTED_PARITY	0x8000 /* Set on parity error */
>  
> +#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
> +			       PCI_STATUS_SIG_SYSTEM_ERROR | \
> +			       PCI_STATUS_REC_MASTER_ABORT | \
> +			       PCI_STATUS_REC_TARGET_ABORT | \
> +			       PCI_STATUS_SIG_TARGET_ABORT | \
> +			       PCI_STATUS_PARITY)

This actually *adds* PCI_STATUS_SIG_TARGET_ABORT, which is not in the
driver definitions.  At the very least that should be mentioned in the
commit log.

Ideally the addition would be in its own patch so it's obvious and
bisectable, but I see the problem -- the subsequent patches
consolidate things that aren't really quite the same.  One alternative
would be to have preliminary patches that change the drivers
individually so they all use this new mask, then do the consolidation
afterwards.

There is pitifully little documentation about the use of include/uapi,
but AFAICT that is for the user API, and this isn't part of that.  I
think this #define could go in include/linux/pci.h instead.

> +
>  #define PCI_CLASS_REVISION	0x08	/* High 24 bits are class, low 8 revision */
>  #define PCI_REVISION_ID		0x08	/* Revision ID */
>  #define PCI_CLASS_PROG		0x09	/* Reg. Level Programming Interface */
> -- 
> 2.25.1
> 
> 
> 
> 
