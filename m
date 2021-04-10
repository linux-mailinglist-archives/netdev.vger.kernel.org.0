Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD64335A9DD
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 03:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhDJBPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 21:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJBPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 21:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 310AE610FB;
        Sat, 10 Apr 2021 01:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618017323;
        bh=b6VLt/Gbf2ZyxdJEMepYFsZ2my3ugXBkJRdoUTgIgKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/Ztez8UWWaSPei7EgrYWDLk2RhrsdoywEG2J5pIAnlK4wtGLEl0n3mUVfN10DLPa
         fT2fZX5r2dNFwf5HFVy6ujpkRTFmYX1etkFbvQ6PXbTT5vF1dU/meHdZRM29fwr/fZ
         LEfbSe5oYNrm498+X841zRihOX4EoHIFz1psEh5BdifFY2Iqyg3CWfPiO2qkRSPa2C
         PChduAec5F4v9BHHnQTqK/BvPTtR+1enOBxp74Cpk1emrB11dh344OpdMIhytc6Lrn
         7kzIy26ykt7r5OgSNrDauwV6+Z4TmOZ1/D4djYnVMAzLdTepjxMYGORfqO6oI40xqN
         GMA9c5VIW2FDw==
Date:   Fri, 9 Apr 2021 18:15:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull-request][net-next][rdma-next] mlx5-next 2021-04-09
Message-ID: <20210409181522.5258f89f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409200704.10886-1-saeed@kernel.org>
References: <20210409200704.10886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 13:07:04 -0700 Saeed Mahameed wrote:
> Hi Dave, Jakub, Jason,
> 
> This pr contains changes from  mlx5-next branch,
> already reviewed on netdev and rdma mailing lists, links below.
> 
> 1) From Leon, Dynamically assign MSI-X vectors count
> Already Acked by Bjorn Helgaas.
> https://patchwork.kernel.org/project/netdevbpf/cover/20210314124256.70253-1-leon@kernel.org/
> 
> 2) Cleanup series:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210311070915.321814-1-saeed@kernel.org/
> 
> From Mark, E-Switch cleanups and refactoring, and the addition 
> of single FDB mode needed HW bits.
> 
> From Mikhael, Remove unused struct field
> 
> From Saeed, Cleanup W=1 prototype warning 
> 
> From Zheng, Esw related cleanup
> 
> From Tariq, User order-0 page allocation for EQs

Pulled, thanks!
