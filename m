Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F641BEC0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbhI2Fhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243585AbhI2Fht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 01:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9563F6139D;
        Wed, 29 Sep 2021 05:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632893769;
        bh=HNoy9qanSJ3QRcRtLnzXnmhSPhiex8bOEab38acWxKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JpTs89dfggjmXhgh6UK0HiI9LTyrDZ4U+1Ecet29CE+0UJf9xFPRyW0iJ0+nQ/JtM
         sggoxrMtoT9bENwwEOSEox95FOuMHPZDPFmb3MFuCEwZmj53sATaHvz299R6Apn7PF
         BBYQ45imGnmw3mfz43sW+CetUCB1YenPWZ/QP1JLHkOaro4g4gVyp+GfXOx5iX6cQ9
         +oGVZC6tKTvMspDuuQGmfVhrEoRprdMCZq0bgJgYGGXcBL62aGDVCn6m262VSTEmL9
         MVp7uYav7E204Tg2do3DGIa2PQbHVhgBiEsQGPt4tITB/NeDLP2Paqnu2eYHRtg9w9
         YaE5QxP+ovipA==
Date:   Wed, 29 Sep 2021 08:36:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 6/7] mlx5_vfio_pci: Expose migration commands
 over mlx5 device
Message-ID: <YVP7RU/LYTi5+Ha7@unreal>
References: <cover.1632305919.git.leonro@nvidia.com>
 <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
 <20210928142230.20b0153a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928142230.20b0153a.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:22:30PM -0600, Alex Williamson wrote:
> On Wed, 22 Sep 2021 13:38:55 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Yishai Hadas <yishaih@nvidia.com>
> > 
> > Expose migration commands over the device, it includes: suspend, resume,
> > get vhca id, query/save/load state.
> > 
> > As part of this adds the APIs and data structure that are needed to
> > manage the migration data.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/mlx5_vfio_pci_cmd.c | 358 +++++++++++++++++++++++++++
> >  drivers/vfio/pci/mlx5_vfio_pci_cmd.h |  43 ++++
> >  2 files changed, 401 insertions(+)
> >  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.c
> >  create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.h
> 
> Should we set the precedent of a vendor sub-directory like we have
> elsewhere?  Either way I'd like to see a MAINTAINERS file update for the
> new driver.  Thanks,

I would like to see subfolders, because all these vendor_xxxx.c filenames
look awful to me.

Thanks

> 
> Alex
> 
