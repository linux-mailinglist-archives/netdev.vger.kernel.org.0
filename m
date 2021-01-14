Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD42F6979
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbhANSXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbhANSXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 13:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AAE23B5D;
        Thu, 14 Jan 2021 18:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610648551;
        bh=I0biHUngS0/mSenJpUH7hAIaOnnOC/Usgk8HeM2y/oU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Urqu1pEbxAIwI9Q0EZctHPmrjJHY4X8L8Q38SGFpm6tTXlnb2PJO9ojwPUsJ/spwk
         0UlFuJEuz3F40jC2Crhn7mxqvQzKtU25/IwdoFLGkv/7x8YBo+XwHGqOBfX2sWCavF
         7CE+H/wYM+lNRduhXCOFWm6KWOrAFI60atd8XlIkCWSN9wWPaFnfLRyFUICBMtV7CA
         cR0ISf98FyYRriZLJ4AAXL4mGvEGxOHVf3/wMJgtNrg+yM8bFU0TNp4YnFyTiKaM/0
         C6ZVZw9jEMvXDfY/NmX5oUPakUJpUJAe6POZEeDWpwaB60Jl5hi7/GI0nXIk4A0MdZ
         Oa+Oj/OYq+Rpw==
Date:   Thu, 14 Jan 2021 10:22:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Message-ID: <20210114102229.3ac56a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43220F26F558A6CFCE013876DCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210113192730.280656-1-saeed@kernel.org>
        <20210113192730.280656-3-saeed@kernel.org>
        <20210114094230.67e8bef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220F26F558A6CFCE013876DCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 17:53:09 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, January 14, 2021 11:13 PM
> > 
> > On Wed, 13 Jan 2021 11:27:18 -0800 Saeed Mahameed wrote:  
> > >  /**
> > >   * struct devlink_port_attrs - devlink port object
> > >   * @flavour: flavour of the port
> > > @@ -114,6 +126,7 @@ struct devlink_port_attrs {
> > >  		struct devlink_port_phys_attrs phys;
> > >  		struct devlink_port_pci_pf_attrs pci_pf;
> > >  		struct devlink_port_pci_vf_attrs pci_vf;
> > > +		struct devlink_port_pci_sf_attrs pci_sf;
> > >  	};
> > >  };  
> > 
> > include/net/devlink.h:131: warning: Function parameter or member 'pci_sf'
> > not described in 'devlink_port_attrs'  
> Wasn't reported till v5.
> Can you please share, which script catches this? So that I can run next time early.

This is just scripts/kernel-doc from the tree.

All the tests are here:

https://github.com/kuba-moo/nipa/blob/master/tests/
