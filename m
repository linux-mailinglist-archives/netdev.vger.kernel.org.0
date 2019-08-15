Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC548E4E6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 08:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfHOG1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 02:27:51 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:59215 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729796AbfHOG1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 02:27:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 10FC63718;
        Thu, 15 Aug 2019 02:27:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 15 Aug 2019 02:27:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5oocgb
        On3iCaI+ipewfyoDU3IkkWOZRHTKssoosqJK0=; b=wWg2QRsQkqUhfezSQxIJ4l
        w/Xeb7xntKGI07xAuhYJda58iQl5g79MC5uY1OR8ncqCZy6ewsg1a94SGyeULEB0
        MTc+QAxmPVLrx0unAS6idNKOuGuHzI+7w5yMySwIpbwrbPMFWSNASApllagjOmqe
        WgFthhwrPetahr21E+d4BcXZrbviaXHcOu/Y1RV2Tlqfi9Wdtv1ynLAsl71LLRVb
        lOZKIaO9qQ1aSvECXFDqcQUQpvg7aimfjhOZjXMD0HA4kY6LBpoMW/KDJCuJwJeC
        eMYABXzt0HZwXQrbqx7EnRTHxSm4fTxIfErF+ZEua4GO8DmmDQn30E5qNuUXEKsA
        ==
X-ME-Sender: <xms:Y_tUXZF8NjvpzRzau7DjjtlI_LHSwqiDa1B4TrxqszhWs8SYgepLRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeftddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Y_tUXbsn5xlJHKm6K5xMbOV_Ieq71mjjlNK9GyX28TTPIMgtsPFSqg>
    <xmx:Y_tUXSdkhFgQ7eoAARu5B_NC1TEtyuv67Tl639iVolais0IBUcA5Fw>
    <xmx:Y_tUXZkXDlyiTSC0kvSyp3DsZduBRcd6_q86ZRbWiIFxPUlk7ghWgw>
    <xmx:ZvtUXVydE9cprn6AaDGsZCpHZ49Oo8FRqOJZX-pBNuVTe-G0weTMZQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E649380076;
        Thu, 15 Aug 2019 02:27:47 -0400 (EDT)
Date:   Thu, 15 Aug 2019 09:27:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, toke@redhat.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 11/14] netdevsim: Add devlink-trap support
Message-ID: <20190815062745.GA12222@splinter>
References: <20190813075400.11841-1-idosch@idosch.org>
 <20190813075400.11841-12-idosch@idosch.org>
 <20190814165957.0e626f57@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165957.0e626f57@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 04:59:57PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Aug 2019 10:53:57 +0300, Ido Schimmel wrote:
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index 08ca59fc189b..2758d95c8d18 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -17,11 +17,21 @@
> >  
> >  #include <linux/debugfs.h>
> >  #include <linux/device.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/inet.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/kernel.h>
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> >  #include <linux/random.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/random.h>
> >  #include <linux/rtnetlink.h>
> >  #include <net/devlink.h>
> > +#include <net/ip.h>
> > +#include <uapi/linux/devlink.h>
> > +#include <uapi/linux/ip.h>
> > +#include <uapi/linux/udp.h>
> 
> Please keep includes ordered alphabetically. You're adding
> linux/random.h second time.

Will fix.

> 
> >  #include "netdevsim.h"
> 
> > +static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
> > +{
> > +	struct nsim_dev *nsim_dev = nsim_dev_port->ns->nsim_dev;
> > +	struct nsim_trap_data *nsim_trap_data = nsim_dev->trap_data;
> > +	struct devlink *devlink = priv_to_devlink(nsim_dev);
> > +	int i;
> 
> reverse christmas tree, please

Likewise.

Thanks!
