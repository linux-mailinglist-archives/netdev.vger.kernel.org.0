Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496C83FF03B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbhIBPbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhIBPbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 11:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8771D61074;
        Thu,  2 Sep 2021 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630596612;
        bh=gwToKVwGPbgoL1VEL+NV08Lci9ZseBJcrvbTsqYJhw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Xq32jcW9GOsKtyfLuCDB27LvHHF3QGMhL4pKeck9J51PaFPFfeDOtoo8rL9z0wV0k
         VtCM/48Dh2X3k4mib9We0eBU7Gg69g48PL4mvbfDsDb9GQKl8lkuuR6S8j4mvI0/xp
         i2FPamwxv3Qm2FnF0PSpU4t4TaLMomOgkTojVXBZDRthqbyebCsBgwdwB01pwxXJFk
         aRSI7+P0bZGY80J+0QIOAAxnOTfh4yGTnEgTKI9DKp2OxMGLNruxodwjeXM/wbLHj2
         yBApeWlxYPC3PFDDo0j1fF5yvHgknIpPDFl87WUEg9b6xoX9zhTr72KWKBwjd/KCeT
         83rmBYRBr2AGg==
Date:   Thu, 2 Sep 2021 10:30:11 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] PCI/VPD: Final extensions and cleanups
Message-ID: <20210902153011.GA333751@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fa6578d-1515-20d3-be5f-9e7dc7db4424@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 08:52:32PM +0200, Heiner Kallweit wrote:
> This series finalizes the VPD extensions and cleanups.
> It should be applied via the PCI tree.
> 
> Heiner Kallweit (7):
>   PCI/VPD: Stop exporting pci_vpd_find_tag()
>   PCI/VPD: Stop exporting pci_vpd_find_info_keyword()
>   PCI/VPD: Include post-processing in pci_vpd_find_tag()
>   PCI/VPD: Add pci_vpd_find_id_string()
>   cxgb4: Use pci_vpd_find_id_string() to find VPD id string
>   PCI/VPD: Clean up public VPD defines and inline functions
>   PCI/VPD: Use unaligned access helpers
> 
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 13 ++-
>  drivers/pci/vpd.c                          | 71 +++++++++++-----
>  include/linux/pci.h                        | 95 ++--------------------
>  3 files changed, 61 insertions(+), 118 deletions(-)

Applied to pci/vpd for v5.15, thanks!
