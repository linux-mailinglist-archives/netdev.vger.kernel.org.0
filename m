Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9461ADBF1
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgDQLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 07:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730091AbgDQLMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 07:12:10 -0400
Received: from linux-8ccs (p3EE2C7AC.dip0.t-ipconnect.de [62.226.199.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BAA521D95;
        Fri, 17 Apr 2020 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587121930;
        bh=MUG7MxQRnqIRzgMzXlRZSVXLEa67kjsJeT81XFUo30o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SUa4yjiEi9BYuvlcnAC7Gmqq3Di56eau2EtUMk6sMt15x+bnOZ5RAKdtwc0+dtdJa
         0nNw0ZIhbVznDqnz1Nlf0wyUxWc2foeJKKk+/bxLR8bv8IWIUrkpl0BfSUezTw+lmJ
         SVW1c9WRKw7QiB92K81e8jgYGXrvKgfKzz81ZISI=
Date:   Fri, 17 Apr 2020 13:12:05 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] kernel/module: Hide vermagic header file
 from general use
Message-ID: <20200417111205.GB2582@linux-8ccs>
References: <20200415133648.1306956-1-leon@kernel.org>
 <20200415133648.1306956-5-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200415133648.1306956-5-leon@kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Leon Romanovsky [15/04/20 16:36 +0300]:
>From: Leon Romanovsky <leonro@mellanox.com>
>
>VERMAGIC* definitions are not supposed to be used by the drivers,
>see this [1] bug report, so simply move this header file to be visible
>to kernel/* and scripts files only.
>
>In-tree module build:
>➜  kernel git:(vermagic) ✗ make clean
>➜  kernel git:(vermagic) ✗ make M=drivers/infiniband/hw/mlx5
>➜  kernel git:(vermagic) ✗ modinfo drivers/infiniband/hw/mlx5/mlx5_ib.ko
>filename:	/images/leonro/src/kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
><...>
>vermagic:       5.6.0+ SMP mod_unload modversions
>
>Out-of-tree module build:
>➜  mlx5 make -C /images/leonro/src/kernel clean M=/tmp/mlx5
>➜  mlx5 make -C /images/leonro/src/kernel M=/tmp/mlx5
>➜  mlx5 modinfo /tmp/mlx5/mlx5_ib.ko
>filename:       /tmp/mlx5/mlx5_ib.ko
><...>
>vermagic:       5.6.0+ SMP mod_unload modversions
>
>[1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
>Reported-by: Borislav Petkov <bp@suse.de>
>Acked-by: Borislav Petkov <bp@suse.de>
>Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Acked-by: Jessica Yu <jeyu@kernel.org>
