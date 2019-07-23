Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB06571FDE
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391694AbfGWTEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 15:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbfGWTEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 15:04:23 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A90218F0;
        Tue, 23 Jul 2019 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563908662;
        bh=qBdiWSKWIjCsHen6DnbxUXpe6f7Z76IfupBI004rDYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C556rVfU9yA8awMISWDNFXvi69SukXOZ/51Z7wszIOrAmvkAKrA6vrLUlfGyp809s
         noXnBRk//Ep/8rZoqEB2ATyLRt3aaVNL75nn/VSwqcDovIuiR9SxsQLOmbEseMqEXO
         3ajYdU82gtgjVyI1emhn/2TfPOUBI7IS1RfkUgUw=
Date:   Tue, 23 Jul 2019 22:04:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     dledford@redhat.com, jgg@mellanox.com, edwards@mellanox.com,
        linux-rdma@vger.kernel.org, yishaih@mellanox.com,
        saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Message-ID: <20190723190414.GU5125@mtr-leonro.mtl.com>
References: <20190723071255.6588-1-leon@kernel.org>
 <20190723.112850.610952032088764951.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723.112850.610952032088764951.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 11:28:50AM -0700, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Tue, 23 Jul 2019 10:12:55 +0300
>
> > From: Edward Srouji <edwards@mellanox.com>
> >
> > Fix modify_cq_in alignment to match the device specification.
> > After this fix the 'cq_umem_valid' field will be in the right offset.
> >
> > Cc: <stable@vger.kernel.org> # 4.19
> > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> > Signed-off-by: Edward Srouji <edwards@mellanox.com>
> > Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> Very confusing submission on many levels.
>
> Coming from a Mellanox developer using a kernel.org email address.

It works for us and was proven internally as the best way to have
setup which always works.

>
> Targetting the mlx5-next tree, yet CC:'ing stable.

This patch was found by RDMA team, needed by RDMA but changes are located
in code accessible by mlx5_core part. This is why mlx5-next.

>
> A networking change, for which stable submissions are handled by me by
> hand and not via CC:'ing stable.

The intention was to have this patch in shared mlx5 branch, which is
picked by RDMA too. This "Cc: stable@..." together with merge through
RDMA will ensure that such patch will be part of stable automatically.

I can remove "Cc: ..." line if you think that it is inappropriate to
have such line in patch in mlx5-next.

Thanks
