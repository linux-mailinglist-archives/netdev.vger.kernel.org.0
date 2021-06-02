Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B085C39809D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 07:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFBFYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 01:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhFBFYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 01:24:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BA8E61360;
        Wed,  2 Jun 2021 05:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622611369;
        bh=TLTTUMCFST1h+Pt6QF1cF1sMd5HXYkgydjNTAYfDFZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GZFlyYfkAcioeS3IFO3xH2H5dxyfBUvBgfJm5wTKiT584+47CDPEwfK9PqYXU9dop
         Rfwnb0842L7AE+v1Mu0wzxSsOTZ6BIux7GJsDjrbght+wd0TcBd1Z9zKyQzGLgBnWb
         WIzNBu+ZqDnJrHCAXQmZfTFunVF1DGo05kZyYxX2kEMxQGWqCrfnxrS2q7zIUEW/Nt
         vb6zAomRdLaWBXGK8fEypCgrl5r6MGfTl5I4e/V5cReftP3G4Zdt4vkiNviNXiUtq3
         e3o0qWx8rLWpUsTwuqEgJwiwhKepkP+gBKgYooBssZSKEp4mdHPG5WyRyYFo0zldEg
         MQSV5H9n+xfSw==
Date:   Wed, 2 Jun 2021 08:22:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, bhelgaas@google.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH] pci: Add ACS quirk for Broadcom NIC.
Message-ID: <YLcVpVXN4LHxCEWt@unreal>
References: <1621645997-16251-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621645997-16251-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 09:13:17PM -0400, Michael Chan wrote:
> From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> 
> Some Broadcom NICs such as the BCM57414 do not advertise PCI-ACS
> capability. All functions on such devices are placed under the same
> IOMMU group. Attaching a single PF to a userspace application like
> OVS-DPDK using VFIO is not possible, since not all functions in the
> IOMMU group are bound to VFIO.
> 
> Since peer-to-peer transactions are not possible between PFs on these
> devices, it is safe to treat them as fully isolated even though the ACS
> capability is not advertised. Fix this issue by adding a PCI quirk for
> this chip.
> 
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/pci/quirks.c | 2 ++
>  1 file changed, 2 insertions(+)

Small nitpick, please don't put dot in the end of git commit subject.
[PATCH] pci: Add ACS quirk for Broadcom NIC.
                                          ^^^^

Thanks
