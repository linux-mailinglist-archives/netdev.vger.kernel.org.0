Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69923E9A96
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhHKVxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:53:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38659 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232166AbhHKVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:53:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AD6435C00BE;
        Wed, 11 Aug 2021 17:52:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 11 Aug 2021 17:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FK7M9k
        Owfu+KZDsOKjdiQ8lyNCXWTSpz2RJWMEH8QTE=; b=myEzfllXbQ91dfcBRmK3Yi
        EIsoDkH8QYIvtmWI06mfJudcL/j9ABgMuHQZ3ULavzfvBITA5nKaqFbyb+yC7wZu
        NoEcIzQwFqIIoquw6vTg52KjbQQNXrpjLVffJ2xB9BlmaxTD9jrfP2vS2MehMPPI
        8GsnpdKafi0DoMVN56gkf/E4fYfS6K2nhhsMmXi9PgU47cIlJOiCQjW4CGT8rLIM
        fypQcoUzK6i7wIfAzLMHAzmsf4YImpn+iJU4Hd1ryS67+WD7i9cNz/DFMnhZ/b8w
        skGLGNQ2PEBwVNMBIgMUOR7zwjZKKbgVvqCHqfqu8DB7msNEPpOvSpFw/08a1qKw
        ==
X-ME-Sender: <xms:s0YUYUnGq_w357Aj6jRi8dtC1AJH12uVnu7vtD7FX1uJ8SBzjcos3g>
    <xme:s0YUYT0fi0oZZNJsDq2PhiWBd30nh_eI9vI2DpyVqHaPLqjW0DWS7CJDRZzP5b9G6
    LJpYQcVtlB9xaI>
X-ME-Received: <xmr:s0YUYSpz6WQ-iCSqCkIXM9-2Q7zT7okw6Kq6AyxZ0GUIfLdYpN5bJk5K41TSFHUB2gQaQW9enmLeXNN30jjB6khz2_-2kQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkedvgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:s0YUYQkxeZAQTq8K-r0ZKyWpsQ3XSR5dIHp-R6_U0dQKJqiZRbDfMg>
    <xmx:s0YUYS27N6QbEsSQbfH9XrGmmsHLukeSPstwge_6FvIHLcsTs0vhpw>
    <xmx:s0YUYXu8RxKwwqd9spBJenIhKgJ-TTF_EiMB4RiAQlgiobaaEAYUrg>
    <xmx:tEYUYbnynv0_56JXPddZ1sA5cfeG3RFgk5qeNMCgbHpri8iiifsUUg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Aug 2021 17:52:51 -0400 (EDT)
Date:   Thu, 12 Aug 2021 00:52:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: bridge: switchdev: allow port isolation to
 be offloaded
Message-ID: <YRRGsL60WeDGQOnv@shredder>
References: <20210811135247.1703496-1-dqfext@gmail.com>
 <YRRDcGWaWHgBkNhQ@shredder>
 <20210811214506.4pf5t3wgabs5blqj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811214506.4pf5t3wgabs5blqj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 12:45:06AM +0300, Vladimir Oltean wrote:
> On Thu, Aug 12, 2021 at 12:38:56AM +0300, Ido Schimmel wrote:
> > On Wed, Aug 11, 2021 at 09:52:46PM +0800, DENG Qingfang wrote:
> > > Add BR_ISOLATED flag to BR_PORT_FLAGS_HW_OFFLOAD, to allow switchdev
> > > drivers to offload port isolation.
> > >
> > > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > > ---
> > >  net/bridge/br_switchdev.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > > index 6bf518d78f02..898257153883 100644
> > > --- a/net/bridge/br_switchdev.c
> > > +++ b/net/bridge/br_switchdev.c
> > > @@ -71,7 +71,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> > >
> > >  /* Flags that can be offloaded to hardware */
> > >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> > > -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> > > +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> > > +				  BR_ISOLATED)
> >
> > Why add it now and not as part of a patchset that actually makes use of
> > the flag in a driver that offloads port isolation?
> 
> The way the information got transmitted is a bit unfortunate.
> 
> Making BR_ISOLATED part of BR_PORT_FLAGS_HW_OFFLOAD is a matter of
> correctness when switchdev offloads the data path. Since this feature
> will not work correctly without driver intervention, it makes sense that
> drivers should reject it currently, which is exactly what this patch
> accomplishes - it makes the code path go through the
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
> -EINVAL for everything they don't recognize.

If the purpose is correctness, then this is not the only flag that was
missed. BR_HAIRPIN_MODE is also relevant for the data path, for example.

Anyway, the commit message needs to be reworded to reflect the true
purpose of the patch.

> 
> (yes, we do still have a problem for drivers that don't catch
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS at all, switchdev will return
> -EOPNOTSUPP for those which is then ignored, but those are in the
> minority)
