Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972D360B24
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfGERkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:40:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36687 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbfGERkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:40:08 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so8447668qkl.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jGeah0eS/bL4E9vHMk5zDfvT2SrEVWWmV0jkLaBaLQw=;
        b=NpN6YPTgq0+0Rm/IFAEbcN5IhQ93HkuGec0Qrj2bVz6TDJfJNevYcAW/PPcGaB/RWE
         LW4noe7jnX5/4puLnF/VmvzGlKYEe0f1DJO3OYCZN3l1A2Jp47feskOZYQ/wfv32+Hvt
         o60IeietkiTlPvEpkxB2+f6YL3K3dvJcuvOFIz1IOvc/qacMDd1kSPmnAUPzVthKiTOi
         SKz6VPcDuWxhWGlPtH4Ob98KIxL65e4id90ku6VmKFIF/L2gScSPwHVC3Bp6fpvMB6i/
         vX+tQuGZYQIJRDu9aV6xwOU7Nus1YrqkQiFEg+LRt7pKtwHB04Y7o76XBZwUHq4AgII4
         H30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jGeah0eS/bL4E9vHMk5zDfvT2SrEVWWmV0jkLaBaLQw=;
        b=tt4uF6FvJYMVTWYC+QikBrdMGWHcZpz91W9aXv+csaKzwS1ice2bn2h+C5knm2KZGz
         xWpF+yH+7ViCtomBdVjkkdqzYrBDlaAyuEcribx518ZVSVYmPO/oHVyH8VzHXjrnJ5wE
         GM9htkTVpMNpqglgbz8sby4nzGZQKBTN4Erri1ytSxpSb4Jg1OzEfJCNfERfb+E5Ngc7
         xnzoOb9HjI/S8sxc8MZPXCdUuPA4lDMrTENgevRTmgnTFO9lNSo5CS2UHlXqjSNIl3/J
         HpH3hlRH7oJxR2+/o7eBL0Lu9zXCDdSztkVnLCjOR/ilEkgnc367GOCmJ3funroEOyeA
         c0Ug==
X-Gm-Message-State: APjAAAVbtOcxQtmbhYe22sYgOfgqVAe+qYCInLarKwYbhk7EphHMRhw0
        Xi07t6LvRrMQtuTC4yywNGx0CA==
X-Google-Smtp-Source: APXvYqzvQzUJkzye7899geX5fyZrUMX5JAbkm45g+Qo1IPJFNtVQzAq2J10VngfmPgan3GCU0jE+UA==
X-Received: by 2002:a37:a343:: with SMTP id m64mr4137762qke.75.1562348408030;
        Fri, 05 Jul 2019 10:40:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id 67sm3695179qkh.108.2019.07.05.10.40.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 10:40:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hjSBr-000224-8A; Fri, 05 Jul 2019 14:40:07 -0300
Date:   Fri, 5 Jul 2019 14:40:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] DEVX VHCA tunnel support
Message-ID: <20190705174007.GA7787@ziepe.ca>
References: <20190701181402.25286-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701181402.25286-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 09:14:00PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> Those two patches introduce VHCA tunnel mechanism to DEVX interface
> needed for Bluefield SOC. See extensive commit messages for more
> information.
> 
> Thanks
> 
> Max Gurtovoy (2):
>   net/mlx5: Introduce VHCA tunnel device capability
>   IB/mlx5: Implement VHCA tunnel mechanism in DEVX
> 
>  drivers/infiniband/hw/mlx5/devx.c | 24 ++++++++++++++++++++----
>  include/linux/mlx5/mlx5_ifc.h     | 10 ++++++++--
>  2 files changed, 28 insertions(+), 6 deletions(-)

This looks Ok can you apply the mlx5-next patch please

Thanks,
Jason

