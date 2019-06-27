Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAF758E35
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfF0XAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 19:00:03 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:40720 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfF0XAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 19:00:03 -0400
Received: by mail-lf1-f54.google.com with SMTP id a9so2680469lff.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 16:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hlkWLIAXD/X1/Rol3Kp/jDc7fHX/O8gfTPi+EszwxMk=;
        b=cywHBuyGo6Bo8Pe0YgCNqDTgGJXYeW2qfryVIdoqHLuFB6yVVqj4P4FcYcesoQD+m5
         TH+oD3vLkdsTZjS7ipHAHxbrFPfsWa/I0k3IFc0KXP9sFx57JS1JKyJZOhCjqg5cfHiB
         Q+KdkYr3u9lzZAKNwJ6Yx/l3qrJiwLxSJZJ13O61YI+bR/IzNi1EO1hJd8FI2St30Gju
         84q4N6104fdJmZ0apSLhS7IkHbW3xo3/iZdts4nWc6wgla3KR7MQBxoDL6I4DP67jooz
         pzsfcKWnggz7Gx/7O1BGpZPyThLAoMi+Exa2uxy0zBpn18UwNlFwKEQ8PW/AODf4F122
         af5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hlkWLIAXD/X1/Rol3Kp/jDc7fHX/O8gfTPi+EszwxMk=;
        b=tfc7U8JH78W/Y0n7WQ7Xr+6lvlEfpUPaemupiEYTyJXy8hTjjiqmJBuIaH0KzKIowl
         gZbNzBr743x5E8DKrMno8+Z4wpMq/UzFIaKg10Y/gdsaj9ZYGJ33CEHA/3WQANN9scpC
         bg7M7Mte6TZlVa1SFWr/sxKyjUmxIoYK38djj6eYhxw29L01Axx5QTfkI5xFJ4RoBvND
         bjq7Kjg0BP7XWtsO55GE+ulB1rgacSvS8skDbWF6oJrJCVleztH9saL0pwsiVajwk8Cd
         2t2WXD76lTaWfsJTZkfG/UQ8ec/ubaoE50cHmba90LRwHQzpRxxoQR68B756nQ+zveR6
         zeEw==
X-Gm-Message-State: APjAAAVqwJA2fnJRVmBHvGZqmwJit5ecVl2vwRv1SOuXJd/03EZsaaZZ
        J5ZSVFcWzfD0k+H/RWhpdCaCYupuF7zWFhTwG5dg8w==
X-Google-Smtp-Source: APXvYqwDjhyAm/JnXPDZNdNiwHLoYgZLNOeH0iN1jwqCMcd99dUJxH9I59IhGTbrF+XNbuezHXXX+OBkXWphnKAhluQ=
X-Received: by 2002:ac2:518d:: with SMTP id u13mr3366240lfi.40.1561676401476;
 Thu, 27 Jun 2019 16:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190627140929.74ae7da6@canb.auug.org.au>
In-Reply-To: <20190627140929.74ae7da6@canb.auug.org.au>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 27 Jun 2019 15:59:50 -0700
Message-ID: <CALzJLG9pmK-OPK1+iVkKWkKPvPUf0icFKZuUojJej7WR1BtV3w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 9:09 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the mlx5-next tree got a conflict in:
>
>   drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>
> between commits:
>
>   955858009708 ("net/mlx5e: Fix number of vports for ingress ACL configuration")
>   d4a18e16c570 ("net/mlx5e: Enable setting multiple match criteria for flow group")
>
> from the net-next tree and commits:
>
>   7445cfb1169c ("net/mlx5: E-Switch, Tag packet with vport number in VF vports and uplink ingress ACLs")
>   c01cfd0f1115 ("net/mlx5: E-Switch, Add match on vport metadata for rule in fast path")
>
> from the mlx5-next tree.
>
> I fixed it up (I basically used the latter versions) and can carry the
> fix as necessary. This is now fixed as far as linux-next is concerned,
> but any non trivial conflicts should be mentioned to your upstream
> maintainer when your tree is submitted for merging.  You may also want
> to consider cooperating with the maintainer of the conflicting tree to
> minimise any particularly complex conflicts.
>

Thanks Stephen, this will be handled in my next pull request to net-next.


> --
> Cheers,
> Stephen Rothwell
