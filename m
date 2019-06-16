Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7157047457
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 13:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfFPLSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 07:18:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38387 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfFPLSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 07:18:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so6251343wmj.3
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7FbJuY8/5Yrt1z9ceKgv7A+9Qlc1C1UZ61mJOrVO+3g=;
        b=mv9oZaLlNsz3s7uPuWNBUJ+xJeZ/CIGZkKZwptOgeCW4BXDjHVMx90uOJEA6y24zUn
         ykiqFWw0aTjybz/BV+F+XeOf2rixwPqoCm0L0vkNJNDsDDs1uIWPgXc3LfzzniZuc91F
         9w3wYRDNuSODoZrgnXYFVTbp82SbNRtB0kiCy5WpTPMTJW84tDbG+kXWIQuZ5f5gYvYA
         bMDWEPzeRZkGkxusZPiJ8mWInv3CltdUdVu4NweR2qcyzDotQcsqXgtsRJHwE/aIIOpq
         zhOnCnuE6xpmNx/jTCJ1Dy2pmEBmEmRoiZHVWAxKClvEOEg/ktqjccsOBBz0a9ScpuKO
         BLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7FbJuY8/5Yrt1z9ceKgv7A+9Qlc1C1UZ61mJOrVO+3g=;
        b=aurKLVM66txTbwu8txQpadfY5c3I5UicJrHHp4B1ZpmHzt6QH05EPW+Xt9PNeXRvV4
         xTc9r/yaHxZe8f4kUyjWzwuvBoRR8OdQB4r60k9l2MXcUTUdLRUx+2B/UJYwVHabqLGc
         K5Opie2n26cEafCd6M0aZJXsWYUzUzNIeyR0rxtn/MrnrRKR7FArcUUvHgeeS1FZzIT3
         rtoldLVK/5v3s6xRYfMDr/+ZQhZIvzh30sb50XWSlxdA03bsub+xZsqMWtslnMWhBSHX
         JsFXjXNJUNjJ0qSLFCZJ8HAUbN4EoBx0DFxH7+EfW4hYnLuhs/EJzShC2jNWcDkRnpYd
         ftIA==
X-Gm-Message-State: APjAAAXjBuvxULQuVesXW7rnymbhe1orRCnecVTqhjJH8PWiRCmfnAjM
        kVZ8pY9WVSrdQ8xQSb4e3PZ2Ng==
X-Google-Smtp-Source: APXvYqyeh4qMx/WXJnfIFFvbFBfSqtV05JI2SOKdwFdtjmj8UG5sVCxKE+QS+cfdTQlguVjB2+SVBQ==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr15541132wmi.78.1560683923763;
        Sun, 16 Jun 2019 04:18:43 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id x17sm9802659wrq.64.2019.06.16.04.18.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 04:18:43 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:18:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Parav Pandit <parav@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Message-ID: <20190616111842.GD2511@nanopsycho>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
 <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190613055954.GV6369@mtr-leonro.mtl.com>
 <20190616100707.GB2511@nanopsycho>
 <20190616101507.GF4694@mtr-leonro.mtl.com>
 <20190616103939.GC2511@nanopsycho>
 <20190616105327.GG4694@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616105327.GG4694@mtr-leonro.mtl.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jun 16, 2019 at 12:53:27PM CEST, leon@kernel.org wrote:
>On Sun, Jun 16, 2019 at 12:39:40PM +0200, Jiri Pirko wrote:
>> Sun, Jun 16, 2019 at 12:15:07PM CEST, leon@kernel.org wrote:
>> >On Sun, Jun 16, 2019 at 12:07:07PM +0200, Jiri Pirko wrote:
>> >> Thu, Jun 13, 2019 at 07:59:54AM CEST, leon@kernel.org wrote:
>> >> >On Thu, Jun 13, 2019 at 04:32:25AM +0000, Parav Pandit wrote:
>> >> >>
>> >> >>
>> >> >> > -----Original Message-----
>> >> >> > From: Leon Romanovsky <leon@kernel.org>
>> >> >> > Sent: Wednesday, June 12, 2019 5:50 PM
>> >> >> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> >> >> > <jgg@mellanox.com>
>> >> >> > Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>> >> >> > rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
>> >> >> > <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
>> >> >> > <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
>> >> >> > netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
>> >> >> > Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
>> >> >> > encap mode
>> >> >> >
>> >> >> > From: Leon Romanovsky <leonro@mellanox.com>
>> >> >> >
>> >> >> > Devlink has UAPI declaration for encap mode, so there is no need to be
>> >> >> > loose on the data get/set by drivers.
>> >> >> >
>> >> >> > Update call sites to use enum devlink_eswitch_encap_mode instead of plain
>> >> >> > u8.
>> >> >> >
>> >> >> > Suggested-by: Parav Pandit <parav@mellanox.com>
>> >> >> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> >> >> > ---
>> >> >> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 +++++---
>> >> >> >  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 ++++--
>> >> >> >  include/net/devlink.h                                     | 6 ++++--
>> >> >> >  net/core/devlink.c                                        | 6 ++++--
>> >> >> >  4 files changed, 17 insertions(+), 9 deletions(-)
>> >> >> >
>> >> >> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> >> >> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> >> >> > index ed3fad689ec9..e264dfc64a6e 100644
>> >> >> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> >> >> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> >> >> > @@ -175,7 +175,7 @@ struct mlx5_esw_offload {
>> >> >> >  	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
>> >> >> >  	u8 inline_mode;
>> >> >> >  	u64 num_flows;
>> >> >> > -	u8 encap;
>> >> >> > +	enum devlink_eswitch_encap_mode encap;
>> >> >> >  };
>> >> >> >
>> >> >> >  /* E-Switch MC FDB table hash node */
>> >> >> > @@ -356,9 +356,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct
>> >> >> > devlink *devlink, u8 mode,
>> >> >> >  					 struct netlink_ext_ack *extack);
>> >> >> >  int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8
>> >> >> > *mode);  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int
>> >> >> > nvfs, u8 *mode); -int mlx5_devlink_eswitch_encap_mode_set(struct devlink
>> >> >> > *devlink, u8 encap,
>> >> >> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
>> >> >> > +					enum devlink_eswitch_encap_mode
>> >> >> > encap,
>> >> >> >  					struct netlink_ext_ack *extack);
>> >> >> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
>> >> >> > *encap);
>> >> >> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
>> >> >> > +					enum devlink_eswitch_encap_mode
>> >> >> > *encap);
>> >> >> >  void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8
>> >> >> > rep_type);
>> >> >> >
>> >> >> >  int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw, diff --git
>> >> >> > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> >> >> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> >> >> > index e09ae27485ee..f1571163143d 100644
>> >> >> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> >> >> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> >> >> > @@ -2137,7 +2137,8 @@ int mlx5_eswitch_inline_mode_get(struct
>> >> >> > mlx5_eswitch *esw, int nvfs, u8 *mode)
>> >> >> >  	return 0;
>> >> >> >  }
>> >> >> >
>> >> >> > -int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8
>> >> >> > encap,
>> >> >> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
>> >> >> > +					enum devlink_eswitch_encap_mode
>> >> >> > encap,
>> >> >> >  					struct netlink_ext_ack *extack)
>> >> >> >  {
>> >> >> >  	struct mlx5_core_dev *dev = devlink_priv(devlink); @@ -2186,7
>> >> >> > +2187,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink
>> >> >> > *devlink, u8 encap,
>> >> >> >  	return err;
>> >> >> >  }
>> >> >> >
>> >> >> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
>> >> >> > *encap)
>> >> >> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
>> >> >> > +					enum devlink_eswitch_encap_mode
>> >> >> > *encap)
>> >> >> >  {
>> >> >> >  	struct mlx5_core_dev *dev = devlink_priv(devlink);
>> >> >> >  	struct mlx5_eswitch *esw = dev->priv.eswitch; diff --git
>> >> >> > a/include/net/devlink.h b/include/net/devlink.h index
>> >> >> > 1c4adfb4195a..7a34fc586def 100644
>> >> >> > --- a/include/net/devlink.h
>> >> >> > +++ b/include/net/devlink.h
>> >> >> > @@ -530,8 +530,10 @@ struct devlink_ops {
>> >> >> >  	int (*eswitch_inline_mode_get)(struct devlink *devlink, u8
>> >> >> > *p_inline_mode);
>> >> >> >  	int (*eswitch_inline_mode_set)(struct devlink *devlink, u8
>> >> >> > inline_mode,
>> >> >> >  				       struct netlink_ext_ack *extack);
>> >> >> > -	int (*eswitch_encap_mode_get)(struct devlink *devlink, u8
>> >> >> > *p_encap_mode);
>> >> >> > -	int (*eswitch_encap_mode_set)(struct devlink *devlink, u8
>> >> >> > encap_mode,
>> >> >> > +	int (*eswitch_encap_mode_get)(struct devlink *devlink,
>> >> >> > +				      enum devlink_eswitch_encap_mode
>> >> >> > *p_encap_mode);
>> >> >> > +	int (*eswitch_encap_mode_set)(struct devlink *devlink,
>> >> >> > +				      enum devlink_eswitch_encap_mode
>> >> >> > encap_mode,
>> >> >> >  				      struct netlink_ext_ack *extack);
>> >> >> >  	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
>> >> >> >  			struct netlink_ext_ack *extack);
>> >> >> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
>> >> >> > d43bc52b8840..47ae69363b07 100644
>> >> >> > --- a/net/core/devlink.c
>> >> >> > +++ b/net/core/devlink.c
>> >> >> > @@ -1552,7 +1552,8 @@ static int devlink_nl_eswitch_fill(struct sk_buff
>> >> >> > *msg, struct devlink *devlink,
>> >> >> >  				   u32 seq, int flags)
>> >> >> >  {
>> >> >> >  	const struct devlink_ops *ops = devlink->ops;
>> >> >> > -	u8 inline_mode, encap_mode;
>> >> >> > +	enum devlink_eswitch_encap_mode encap_mode;
>> >> >> > +	u8 inline_mode;
>> >> >> >  	void *hdr;
>> >> >> >  	int err = 0;
>> >> >> >  	u16 mode;
>> >> >> > @@ -1628,7 +1629,8 @@ static int devlink_nl_cmd_eswitch_set_doit(struct
>> >> >> > sk_buff *skb,  {
>> >> >> >  	struct devlink *devlink = info->user_ptr[0];
>> >> >> >  	const struct devlink_ops *ops = devlink->ops;
>> >> >> > -	u8 inline_mode, encap_mode;
>> >> >> > +	enum devlink_eswitch_encap_mode encap_mode;
>> >> >> > +	u8 inline_mode;
>> >> >> >  	int err = 0;
>> >> >> >  	u16 mode;
>> >> >> >
>> >> >> > --
>> >> >> > 2.20.1
>> >> >>
>> >> >> Netdev follows reverse Christmas tree, but otherwise,
>> >> >
>> >> >It was before this patch, if Jiri is ok with that, I'll change this
>> >> >"const struct devlink_ops *ops = devlink->ops;" line while I'll apply
>> >> >this patchset to mlx5-net. If not, I'll leave it as is.
>> >>
>> >> Change to what? I don't follow. The patch looks completely fine to me as
>> >> it is.
>> >
>> >Thanks Jiri,
>> >
>> >Parav mentioned that two lines above my change were already not in Christmas
>> >tree format.
>> >
>> >   struct devlink *devlink = info->user_ptr[0];
>> >   const struct devlink_ops *ops = devlink->ops;
>>
>> As there is a dependency between those 2 lines, I don't see how you can
>> fix this.
>
>I don't want to do it, but this is possible solution:
>
>	const struct devlink_ops *ops:
>	struct devlink *devlink;
>	..... extra declarations ....
>
>	devlink = info->user_ptr[0];
>	ops = devlink->ops;
>	... rest of the code ...

Please don't.


>>
>>
>> >
>> >Thanks
>> >
>> >>
>> >> Acked-by: Jiri Pirko <jiri@mellanox.com>
>> >>
>> >>
>> >>
>> >> >
>> >> >> Reviewed-by: Parav Pandit <parav@mellanox.com>
>> >> >
>> >> >Thanks
>> >> >
>> >> >>
