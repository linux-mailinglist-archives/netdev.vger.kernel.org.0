Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582F5651B7
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 08:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfGKGJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 02:09:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36923 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbfGKGJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 02:09:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so4399890wme.2;
        Wed, 10 Jul 2019 23:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DxU4NDGj7+LedYgqXtgps+S6xA8I2Zxp+hJPjIb5+Zg=;
        b=UKVvEwgFYOj+lH7N/zeP46wV1RgqVIi/vvhU/8owpDy6XNP21uzoC214VqgueVgQUs
         KZHg0yUnvxBAwU5azFmxlyvQ/tW/OXJr/rqwEqtqc0Ig1I24GfVq6hSGtfCUj+/LQDyY
         CmORPvIVodqgaYUKFyX3XmSO3FVpxH0Cc8CIsoQFsas3+4MOcOqjOU36gM9iZ9c6Ft1B
         5lK9RuF9ckmVxYb4CqoNkwKKt2jH8Kh6pRavTiKIeMs6sqYOvVfKphHhIhSdOl9HdiFr
         yaJLNsXvzfI+XFX5cNuD6JBiWZ60kiT4+p25QFbBK0ElEdvyu6JX6HwHwDILkEni4KOU
         bY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DxU4NDGj7+LedYgqXtgps+S6xA8I2Zxp+hJPjIb5+Zg=;
        b=R9RLmS69/CUTV6erHnLNpGVs453Eblvym00PF8sWHlKV+4wiCNhGcG3xLNtmKf8zG9
         eQ2XpdAVyqLVxzgSSg3KAyFHbCjKAIN0ZgjlOq1/oDzPw8hHsHYhh9uemWsGIe6hcANR
         YpHZiZAGfqux8cHv3rSejzYn6awW6MAv4tx95v/bPxtsdB9gJWHcr2WPB3NWSWAz+leW
         jX2COA/mRstapyIkwGssvWga8cc/iN4zCVC2MBJHyNPR9uEzZXwX+hI1LmCA6N8fAlLN
         y//U/PkS4p8roLerguiGwvtM0qYPy1e6QhklRQZRp/xNfPSnGZQUXmXCuq/qBiXE+XO7
         mfRg==
X-Gm-Message-State: APjAAAWNn512tYmDUnLVFeTIG5rGmviL6xM1c4EvpnmvKdPP5ANAO1m5
        X4wTXNvWNG4rNXIjL3BYxQs=
X-Google-Smtp-Source: APXvYqyf27KFztCU1OEa/3veH1hwu7VtYutQ0u3AzJWujweE+gQJQMZe7zSO2dr8HjtJv3FlTcb3Yw==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr1887413wmi.88.1562825349529;
        Wed, 10 Jul 2019 23:09:09 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id o185sm3828748wmo.45.2019.07.10.23.09.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 23:09:08 -0700 (PDT)
Date:   Wed, 10 Jul 2019 23:09:07 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net/mlx5e: Move priv variable into case statement in
 mlx5e_setup_tc
Message-ID: <20190711060907.GA103505@archlinux-threadripper>
References: <20190710190502.104010-1-natechancellor@gmail.com>
 <CALzJLG9Aw=sVPDiewHr+4Jiuaod_1q=10vzMzCUVg-rCCXD6cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzJLG9Aw=sVPDiewHr+4Jiuaod_1q=10vzMzCUVg-rCCXD6cQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:02:00PM -0700, Saeed Mahameed wrote:
> On Wed, Jul 10, 2019 at 12:05 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > There is an unused variable warning on arm64 defconfig when
> > CONFIG_MLX5_ESWITCH is unset:
> >
> > drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3467:21: warning:
> > unused variable 'priv' [-Wunused-variable]
> >         struct mlx5e_priv *priv = netdev_priv(dev);
> >                            ^
> > 1 warning generated.
> >
> > Move it down into the case statement where it is used.
> >
> > Fixes: 4e95bc268b91 ("net: flow_offload: add flow_block_cb_setup_simple()")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/597
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 6d0ae87c8ded..651eb714eb5b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -3464,15 +3464,16 @@ static LIST_HEAD(mlx5e_block_cb_list);
> >  static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> >                           void *type_data)
> >  {
> > -       struct mlx5e_priv *priv = netdev_priv(dev);
> > -
> >         switch (type) {
> >  #ifdef CONFIG_MLX5_ESWITCH
> > -       case TC_SETUP_BLOCK:
> > +       case TC_SETUP_BLOCK: {
> > +               struct mlx5e_priv *priv = netdev_priv(dev);
> > +
> >                 return flow_block_cb_setup_simple(type_data,
> >                                                   &mlx5e_block_cb_list,
> >                                                   mlx5e_setup_tc_block_cb,
> >                                                   priv, priv, true);
> > +       }
> 
> Hi Nathan,
> 
> We have another patch internally that fixes this, and it is already
> queued up in my queue.
> it works differently as we want to pass priv instead of netdev to
> mlx5e_setup_tc_mqprio below,
> which will also solve warning ..
> 
> So i would like to submit that patch if it is ok with you ?

Hi Saeed,

Whatever works best for you, I just care that the warning gets fixed,
not how it is done :) I wouldn't mind being put on CC so I can pick it
up for my local tests.

Thanks for the follow up!
Nathan
