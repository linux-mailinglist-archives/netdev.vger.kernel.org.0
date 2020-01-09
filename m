Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906E3135444
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgAII0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:26:50 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47429 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728347AbgAII0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 03:26:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C6F7F21CDA;
        Thu,  9 Jan 2020 03:26:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 09 Jan 2020 03:26:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8xSNRZ
        KbiFnlwHQpyfLhNCmhDc50M+zIr3Dzt6d7M34=; b=K4P4KVoOqqooVDCabWeQAd
        IVUHo+sDgvT9C/zVDsAM23kNqzFI6io59woSYIaLdKFO4EdHjIXkgXA+et3efYOG
        LjyMK4u7WOlx0OmK1i2bGcVl6qOwUGhrhJ8ZmGZ1dNOZHs8FNuUuGBmb9H4NkxOe
        NDudRRRHI4wf85+Du2pSXUxSuWAy4qavGIo5XPtXn+atZDzOXhwY1nZj4ePVNsvV
        eBtAR0YvKYAvOw1jZiEPEU7qIgUjzK9gqmY0Lhbc3b6u9htx/OxmK4wYWhUfpfuw
        /pU2H+RlSb8CRUlcIpz8vBDFcgievY4kTOyqJEFmG1fBUqIhMf7x/ztExwlCVcaQ
        ==
X-ME-Sender: <xms:yOMWXkADII_uEguCHahBWpvUeARnkMqCO24fEqQXduJeVSKHx1SPgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehledgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:yOMWXlQAb7uNVNmMdCYMdgy3vgv5RvsA-dN6p7ycsKEtxDoKkOxWtA>
    <xmx:yOMWXnIkXLPXeEMOrkQet5TsCJfEAOFpidrwK8p6cLOVACF8shxHKg>
    <xmx:yOMWXlE2ST1nCl1Uu_Fgyo6378dNt3MOCrC8iDnbY_EP0l5Pcvqo1w>
    <xmx:yOMWXkPThX8LyL1RZHwpYvZmNPRX5rqLyc_EgBAs8MEbAhpoNmyqmg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19E5280059;
        Thu,  9 Jan 2020 03:26:47 -0500 (EST)
Date:   Thu, 9 Jan 2020 10:26:46 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 02/10] ipv4: Encapsulate function arguments in a
 struct
Message-ID: <20200109082646.GA273688@splinter>
References: <20200107154517.239665-1-idosch@idosch.org>
 <20200107154517.239665-3-idosch@idosch.org>
 <c35c97d7-d1dc-d0d6-6ea8-deaf33441c7c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c35c97d7-d1dc-d0d6-6ea8-deaf33441c7c@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 11:37:28AM -0700, David Ahern wrote:
> On 1/7/20 8:45 AM, Ido Schimmel wrote:
> > diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
> > index a68b5e21ec51..b34594a9965f 100644
> > --- a/net/ipv4/fib_lookup.h
> > +++ b/net/ipv4/fib_lookup.h
> > @@ -21,6 +21,15 @@ struct fib_alias {
> >  
> >  #define FA_S_ACCESSED	0x01
> >  
> > +struct fib_rt_info {
> > +	struct fib_info		*fi;
> > +	u32			tb_id;
> > +	__be32			dst;
> > +	int			dst_len;
> > +	u8			tos;
> > +	u8			type;
> > +};
> > +
> >  /* Dont write on fa_state unless needed, to keep it shared on all cpus */
> >  static inline void fib_alias_accessed(struct fib_alias *fa)
> >  {
> > @@ -35,9 +44,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
> >  int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
> >  		 struct netlink_ext_ack *extack);
> >  bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
> > -int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event, u32 tb_id,
> > -		  u8 type, __be32 dst, int dst_len, u8 tos, struct fib_info *fi,
> > -		  unsigned int);
> > +int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
> > +		  struct fib_rt_info *fri, unsigned int);
> 
> since you are modifying this, can you add a name for that last argument?

Yes, will add in v2

> 
> 
> Otherwise, nice cleanup.
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks!
