Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5053269EC3
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgIOGpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 02:45:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37569 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726033AbgIOGp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 02:45:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 699F95C00C1;
        Tue, 15 Sep 2020 02:45:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 02:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GldgJ7
        RQPmzPgW3JiwuzicyOz0XVLdYlzL3wC9ojd4w=; b=hcTuqWy7erNiktGtVzF8uP
        2YL10NlcSzn5r+EdNUIaZwz5Hs7LNwOdowplGemJ5xX8IAN/vjFE0/7/DlAW4H9z
        goSBFgm9C3AWQtwdv+cqF244avZaYMTD8MGtEaz2tYGCL4rjSp1jd8tHa5a13zr8
        0AQu1QE76f0aAgnc/fcTSJv7kZHPuX2xL2zD3CTTRJ5BFS89eFUHnFMGJM9P96lI
        ioTD7SspJBys6y5AHo2ZjZNn9+VYkQHjKYHOlRAs6CMeZQL1F9Hr5QhouZxC0qAs
        V4SbCnyjJGtyuSzm7p+3T0M6wQy4rU2LLV7VQh+DRloaCXXhKXhd+sIWPxUuhJiw
        ==
X-ME-Sender: <xms:AmNgX5llK84vGMHy9c138Jc9sgLDMqe5zDFx3yAlapZqisWsShWRQw>
    <xme:AmNgX03Uw2RyGQ74z_g0pmNFncCmYu18PMDSwQfImWnxJTicDtV1iZyeOJ-MnCUy0
    yfT9oy9hz7WafI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleeh
    keeunecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeegrddvvdelrdefie
    drkedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:AmNgX_rqekxLfVML6ASgBdlgSgz1KJUdaxhrOWQED1KSqZG-xe2sqw>
    <xmx:AmNgX5kUzq63WmKn_uPXA0ipJYjhUzfeafzmZQEZ6PQNJjrmbkErSA>
    <xmx:AmNgX33_j3t9B9SMi52cOTHtqbs8Zcza13gQmGb0Clac_6-rWm0nqw>
    <xmx:BWNgX4y-NqVEersN1ujQk41a3r85269b5qzFklwY_6-mZcrDft5BUQ>
Received: from localhost (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB9FF306467D;
        Tue, 15 Sep 2020 02:45:21 -0400 (EDT)
Date:   Tue, 15 Sep 2020 09:45:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats
 to dev get
Message-ID: <20200915064519.GA5390@shredder>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-5-git-send-email-moshe@mellanox.com>
 <20200914134500.GH2236@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914134500.GH2236@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 03:45:00PM +0200, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:51AM CEST, moshe@mellanox.com wrote:
> >Expose devlink reload actions stats to the user through devlink dev
> >get command.
> >
> >Examples:
> >$ devlink dev show
> >pci/0000:82:00.0:
> >  reload_action_stats:
> >    driver_reinit 2
> >    fw_activate 1
> >    driver_reinit_no_reset 0
> >    fw_activate_no_reset 0
> >pci/0000:82:00.1:
> >  reload_action_stats:
> >    driver_reinit 1
> >    fw_activate 1
> >    driver_reinit_no_reset 0
> >    fw_activate_no_reset 0
> 
> I would rather have something like:
>    stats:
>      reload_action:
>        driver_reinit 1
>        fw_activate 1
>        driver_reinit_no_reset 0
>        fw_activate_no_reset 0
> 
> Then we can easily extend and add other stats in the tree.
> 
> 
> Also, I wonder if these stats could be somehow merged with Ido's metrics
> work:
> https://github.com/idosch/linux/commits/submit/devlink_metric_rfc_v1
> 
> Ido, would it make sense?

I guess. My original idea for devlink-metric was to expose
design-specific metrics to user space where the entity registering the
metrics is the device driver. In this case the entity would be devlink
itself and it would be auto-registered for each device.

> 
> 
> >
> >$ devlink dev show -jp
> >{
> >    "dev": {
> >        "pci/0000:82:00.0": {
> >            "reload_action_stats": [ {
> >                    "driver_reinit": 2
> >                },{
> >                    "fw_activate": 1
> >                },{
> >                    "driver_reinit_no_reset": 0
> >                },{
> >                    "fw_activate_no_reset": 0
> >                } ]
> >        },
> >        "pci/0000:82:00.1": {
> >            "reload_action_stats": [ {
> >                    "driver_reinit": 1
> >                },{
> >                    "fw_activate": 1
> >                },{
> >                    "driver_reinit_no_reset": 0
> >                },{
> >                    "fw_activate_no_reset": 0
> >                } ]
> >        }
> >    }
> >}
> >
> 
> [..]
