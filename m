Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB5D47419
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfFPKHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 06:07:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34589 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfFPKHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 06:07:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so6794710wrl.1
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 03:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/tZ1VPM4wCco1y5GKuvC+dv7ijWO0+hICFigJua7iFI=;
        b=xKYet2Rz1EPmw1/tY7Nj8zOsmoke+43H1w1kXbvlpqcy2ocdPYfpyDCjqFdP5tZLNt
         zUqSBph+cI5p/9psPgBjF9IizLDy+TRJDMro5ArosOePqT/WkN1AiOt29za7a+S4fGYP
         0UWPX8gHgoedWQZBWvQLGzs/30ZwONbQuC+vF7w/2JpHhMYVYy7YzL5U4rHOqEAvL9QR
         rfghguvGUdM7ioRXYcRqXMQYBPBParwvS7k5RC40iZdNsLh9EnQp+gnlP1qrrHYN/GDJ
         D/tUAnP26d5wWLmpyBRi+xVii8psuP2BHFLuUXdt0VokQ7e+jnaaW5PZLzSQDi7ynKaM
         na4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/tZ1VPM4wCco1y5GKuvC+dv7ijWO0+hICFigJua7iFI=;
        b=leqejv2g5ctyThSB6YMENpPPrjbjHPMzuIEcwSfhYKO9bLJVO3mZ79y9f5P5DDY22r
         Q0OYQi4wY9ti7cvYJ+8osBjJqLmaT4obFYmiNl7LJoziQWt1lohRL6s9zdm74a63VX2I
         g/SVhV+WKGVsT7sjiGR/ncmY36DBnTcYD45TWtSnPSCim6/D3fFcJDHuotjsmHkf7Cyb
         BWTZc6rrycA1bTwgQLZNPrqDlw95DO/a+E+De9L4mNRcD306EPU7F+pMO+HMh96IYFaj
         ABb3PXunTzSO3m5c2YgmSc8nB3aQeiTE8FwAZlrWqZ0u3MK9oQL0cvLAR1UC8AjR2Ban
         wM+g==
X-Gm-Message-State: APjAAAUN4AC6LDzvTf5+PhjBes/n/on7sdErqTDGMw2HCLaQb3LG4DXj
        /3yA+v+kVU75aHeXinMvVW1dXQ==
X-Google-Smtp-Source: APXvYqzB64i4cpyCK2sYMwVAeTXyqcOws/eZFJCQi2BxCjOE/rrbGzFRPvRUtRC8CJ7IiXhvLP6fwQ==
X-Received: by 2002:adf:afde:: with SMTP id y30mr10526370wrd.197.1560679628814;
        Sun, 16 Jun 2019 03:07:08 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id j18sm6902190wre.23.2019.06.16.03.07.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 03:07:08 -0700 (PDT)
Date:   Sun, 16 Jun 2019 12:07:07 +0200
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
Message-ID: <20190616100707.GB2511@nanopsycho>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
 <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190613055954.GV6369@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613055954.GV6369@mtr-leonro.mtl.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 07:59:54AM CEST, leon@kernel.org wrote:
>On Thu, Jun 13, 2019 at 04:32:25AM +0000, Parav Pandit wrote:
>>
>>
>> > -----Original Message-----
>> > From: Leon Romanovsky <leon@kernel.org>
>> > Sent: Wednesday, June 12, 2019 5:50 PM
>> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
>> > <jgg@mellanox.com>
>> > Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
>> > rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
>> > <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
>> > <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
>> > netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
>> > Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
>> > encap mode
>> >
>> > From: Leon Romanovsky <leonro@mellanox.com>
>> >
>> > Devlink has UAPI declaration for encap mode, so there is no need to be
>> > loose on the data get/set by drivers.
>> >
>> > Update call sites to use enum devlink_eswitch_encap_mode instead of plain
>> > u8.
>> >
>> > Suggested-by: Parav Pandit <parav@mellanox.com>
>> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>> > ---
>> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 +++++---
>> >  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 ++++--
>> >  include/net/devlink.h                                     | 6 ++++--
>> >  net/core/devlink.c                                        | 6 ++++--
>> >  4 files changed, 17 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> > index ed3fad689ec9..e264dfc64a6e 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
>> > @@ -175,7 +175,7 @@ struct mlx5_esw_offload {
>> >  	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
>> >  	u8 inline_mode;
>> >  	u64 num_flows;
>> > -	u8 encap;
>> > +	enum devlink_eswitch_encap_mode encap;
>> >  };
>> >
>> >  /* E-Switch MC FDB table hash node */
>> > @@ -356,9 +356,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct
>> > devlink *devlink, u8 mode,
>> >  					 struct netlink_ext_ack *extack);
>> >  int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8
>> > *mode);  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int
>> > nvfs, u8 *mode); -int mlx5_devlink_eswitch_encap_mode_set(struct devlink
>> > *devlink, u8 encap,
>> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
>> > +					enum devlink_eswitch_encap_mode
>> > encap,
>> >  					struct netlink_ext_ack *extack);
>> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
>> > *encap);
>> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
>> > +					enum devlink_eswitch_encap_mode
>> > *encap);
>> >  void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8
>> > rep_type);
>> >
>> >  int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw, diff --git
>> > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> > index e09ae27485ee..f1571163143d 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> > @@ -2137,7 +2137,8 @@ int mlx5_eswitch_inline_mode_get(struct
>> > mlx5_eswitch *esw, int nvfs, u8 *mode)
>> >  	return 0;
>> >  }
>> >
>> > -int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8
>> > encap,
>> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
>> > +					enum devlink_eswitch_encap_mode
>> > encap,
>> >  					struct netlink_ext_ack *extack)
>> >  {
>> >  	struct mlx5_core_dev *dev = devlink_priv(devlink); @@ -2186,7
>> > +2187,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink
>> > *devlink, u8 encap,
>> >  	return err;
>> >  }
>> >
>> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
>> > *encap)
>> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
>> > +					enum devlink_eswitch_encap_mode
>> > *encap)
>> >  {
>> >  	struct mlx5_core_dev *dev = devlink_priv(devlink);
>> >  	struct mlx5_eswitch *esw = dev->priv.eswitch; diff --git
>> > a/include/net/devlink.h b/include/net/devlink.h index
>> > 1c4adfb4195a..7a34fc586def 100644
>> > --- a/include/net/devlink.h
>> > +++ b/include/net/devlink.h
>> > @@ -530,8 +530,10 @@ struct devlink_ops {
>> >  	int (*eswitch_inline_mode_get)(struct devlink *devlink, u8
>> > *p_inline_mode);
>> >  	int (*eswitch_inline_mode_set)(struct devlink *devlink, u8
>> > inline_mode,
>> >  				       struct netlink_ext_ack *extack);
>> > -	int (*eswitch_encap_mode_get)(struct devlink *devlink, u8
>> > *p_encap_mode);
>> > -	int (*eswitch_encap_mode_set)(struct devlink *devlink, u8
>> > encap_mode,
>> > +	int (*eswitch_encap_mode_get)(struct devlink *devlink,
>> > +				      enum devlink_eswitch_encap_mode
>> > *p_encap_mode);
>> > +	int (*eswitch_encap_mode_set)(struct devlink *devlink,
>> > +				      enum devlink_eswitch_encap_mode
>> > encap_mode,
>> >  				      struct netlink_ext_ack *extack);
>> >  	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
>> >  			struct netlink_ext_ack *extack);
>> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
>> > d43bc52b8840..47ae69363b07 100644
>> > --- a/net/core/devlink.c
>> > +++ b/net/core/devlink.c
>> > @@ -1552,7 +1552,8 @@ static int devlink_nl_eswitch_fill(struct sk_buff
>> > *msg, struct devlink *devlink,
>> >  				   u32 seq, int flags)
>> >  {
>> >  	const struct devlink_ops *ops = devlink->ops;
>> > -	u8 inline_mode, encap_mode;
>> > +	enum devlink_eswitch_encap_mode encap_mode;
>> > +	u8 inline_mode;
>> >  	void *hdr;
>> >  	int err = 0;
>> >  	u16 mode;
>> > @@ -1628,7 +1629,8 @@ static int devlink_nl_cmd_eswitch_set_doit(struct
>> > sk_buff *skb,  {
>> >  	struct devlink *devlink = info->user_ptr[0];
>> >  	const struct devlink_ops *ops = devlink->ops;
>> > -	u8 inline_mode, encap_mode;
>> > +	enum devlink_eswitch_encap_mode encap_mode;
>> > +	u8 inline_mode;
>> >  	int err = 0;
>> >  	u16 mode;
>> >
>> > --
>> > 2.20.1
>>
>> Netdev follows reverse Christmas tree, but otherwise,
>
>It was before this patch, if Jiri is ok with that, I'll change this
>"const struct devlink_ops *ops = devlink->ops;" line while I'll apply
>this patchset to mlx5-net. If not, I'll leave it as is.

Change to what? I don't follow. The patch looks completely fine to me as
it is.

Acked-by: Jiri Pirko <jiri@mellanox.com>



>
>> Reviewed-by: Parav Pandit <parav@mellanox.com>
>
>Thanks
>
>>
