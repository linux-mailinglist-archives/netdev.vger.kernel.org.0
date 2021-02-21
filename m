Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62D320906
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 08:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhBUHAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 02:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhBUHAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 02:00:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AD064E5C;
        Sun, 21 Feb 2021 06:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613890762;
        bh=DdlbG/BSpVZo5h0GvsNU+dYWOsmflWmL/oFizWNBOc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdvC4nd3lOK03Gk2RW6xLtLcy1Ub6w3Y0zsjc6ROPLCyZeqoO9tNS+HH5TSubL7r9
         EzLXIFMavxF8ywhvgH15zG6MyhsKxgL8hkwxRcL+FhWRcYzsvaUS7KyMLH1MbB/gkq
         JHF+GVhYnHPqM7HZP4jhqabx6GTTF8CSHEJBknPRU7MWQS69p1AxP1ywPwifibx576
         I3Ddpsm+58hVxoRwTmy+rrJK9eqG1+lSrCQHIJbzX3GiPQC+7VwxD5Z/Zh2Lshek0o
         v+pCmdrnE9K2l5m/C/7H0UJA3sxldUfoI/BaCZwBW8nf2CN9NeiGBfUOp18iTOySIh
         2Zs2bODpDRJAg==
Date:   Sun, 21 Feb 2021 08:59:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YDIExpismOnU3c4k@unreal>
References: <YC90wkwk/CdgcYY6@kroah.com>
 <20210220190600.GA1260870@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220190600.GA1260870@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
> On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
>
> > Ok, can you step back and try to explain what problem you are trying to
> > solve first, before getting bogged down in odd details?  I find it
> > highly unlikely that this is something "unique", but I could be wrong as
> > I do not understand what you are wanting to do here at all.
>
> We want to add two new sysfs files:
>
>   sriov_vf_total_msix, for PF devices
>   sriov_vf_msix_count, for VF devices associated with the PF
>
> AFAICT it is *acceptable* if they are both present always.  But it
> would be *ideal* if they were only present when a driver that
> implements the ->sriov_get_vf_total_msix() callback is bound to the
> PF.

BTW, we already have all possible combinations: static, static with
folder, with and without "sriov_" prefix, dynamic with and without
folders on VFs.

I need to know on which version I'll get Acked-by and that version I
will resubmit.

Thanks
