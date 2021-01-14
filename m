Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887052F67FE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbhANRnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbhANRnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:43:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AE723B40;
        Thu, 14 Jan 2021 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610646152;
        bh=qyCgoMQS1q3Gbl/YPa4tVX/MZkl9Rw9Fb3rWjKlYnKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QexCp9ikjfo2fgUELpThJrlfN3qRvRKKeFFKetHH9Si0gW1yJEMGoiXCpxvLbmxbB
         3Ae5QD/LvXlo1x9wn06oBAE3GtNsag8mY19NoMaipaikTaBdeRJiOAX8KT7Y24qwun
         +5+J0UzdCjkLdVF0zAi9QYZkwJQVL85W44zvRrBRQAno4Ysro6DrHcI02VuTeLiDlD
         IwhVNAg4Obct5NgzXcUnnzzY1eNk63NUR3DTFVCj44u5TJZWMn7aselENLT+x/de5h
         JHnzupfTOmALgG+4p81htYVH+YzIl34rUS0ZNs0ekhEjOqlCvzPliX1E4Nui5Kej9Q
         iL3izsHBVTCrw==
Date:   Thu, 14 Jan 2021 09:42:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Message-ID: <20210114094230.67e8bef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113192730.280656-3-saeed@kernel.org>
References: <20210113192730.280656-1-saeed@kernel.org>
        <20210113192730.280656-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 11:27:18 -0800 Saeed Mahameed wrote:
>  /**
>   * struct devlink_port_attrs - devlink port object
>   * @flavour: flavour of the port
> @@ -114,6 +126,7 @@ struct devlink_port_attrs {
>  		struct devlink_port_phys_attrs phys;
>  		struct devlink_port_pci_pf_attrs pci_pf;
>  		struct devlink_port_pci_vf_attrs pci_vf;
> +		struct devlink_port_pci_sf_attrs pci_sf;
>  	};
>  };

include/net/devlink.h:131: warning: Function parameter or member 'pci_sf' not described in 'devlink_port_attrs'
