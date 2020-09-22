Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388EE274985
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVTxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVTxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 15:53:03 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD60220888;
        Tue, 22 Sep 2020 19:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804383;
        bh=KTKxnoveergkTChE6viM1YPJ7yfsKyu4FKqg2/mwRas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xYoFUJmql1F/LccYOgW18yJFLLKW9WNZ5U24FVwaIwKrWeYkNjaMIkWdO9QYJcp0c
         N3YKjdxq/6KXYXiChHvx+3kFWiHOCi/0WTCEWoHRVkiWn9/6NDYmyrbuzYpJbpF0Mp
         vaMPIianyZB31LTfGe6HbwRCnJfdLqY0hfrkQECs=
Message-ID: <d6a509a9340c3840f4cfc9db2883e02bb7a60e9f.camel@kernel.org>
Subject: Re: [PATCH -next] net/mlx5: simplify the return expression of
 mlx5_ec_init()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Sep 2020 12:53:01 -0700
In-Reply-To: <20200922080426.164e5af1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200921131044.92430-1-miaoqinglang@huawei.com>
         <ae06288c3c4d5d8ad59202ff7967d479af1152a5.camel@kernel.org>
         <20200922080426.164e5af1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-22 at 08:04 -0700, Jakub Kicinski wrote:
> On Mon, 21 Sep 2020 22:52:30 -0700 Saeed Mahameed wrote:
> > On Mon, 2020-09-21 at 21:10 +0800, Qinglang Miao wrote:
> > > Simplify the return expression.
> > > 
> > > Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/ecpf.c | 6 +-----
> > >  1 file changed, 1 insertion(+), 5 deletions(-)
> > > 
> > >   
> > 
> > Applied to net-next-mlx5.
> 
> Beware:
> 
> drivers/net/ethernet/mellanox/mlx5/core/ecpf.c: In function
> ‘mlx5_ec_init’:
> drivers/net/ethernet/mellanox/mlx5/core/ecpf.c:46:6: warning: unused
> variable ‘err’ [-Wunused-variable]
>   46 |  int err = 0;
>      |      ^~~

Thanks Jakub

Yes, Saw this in my CI as well, 
will resolve this one myself.
and for next time I will wait for the CI result before replying ;)

