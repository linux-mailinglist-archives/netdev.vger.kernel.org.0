Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F03C455
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403819AbfFKGfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:35:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51437 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390485AbfFKGfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:35:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 068B62220D;
        Tue, 11 Jun 2019 02:35:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 02:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iO5RKL
        gPJeU8X2BCAEweMziTPO0ad8sb6WVM6BcaVUY=; b=Zjno7hnC1LwA8CAvjAuBIS
        9vmUwgpbQvFBDwKGUp5bxoQ0nrlwdSt1yD1p8MXFadoW2vCAqqdcFrTLfoIP2ngt
        N9TuBx0g/qDJ0x5BCrcLr1pOthe07IBVJbu81NXLfdIi28WYLQ/b4t2eDo1wf5jB
        2t1zcVRhc/5iCkyNBpPk5DfHRyYs9pZfoAwKs3upsYpyWe3Pdb5p2SDgKBlexxfc
        0+p2mNGA61opO75USkNSYIWc+M6yU7KdLA/KeboSTp5wjw197t5bt2t2pMENkDsg
        mHZ1G+Gyo8xbzjBsFLaYgAkIu4ncZjgpDi1lBiNYafx9V5VJR46tA5RW6cNraWiw
        ==
X-ME-Sender: <xms:sEv_XJy2NZA9_gRwL3YLqC1AfWEWcf6hlz5mAvVGNeVJy7XRLTeKZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:sEv_XC6bUySuckrk3zzyLM8zj4fFqONCQ0mWdqvHvYwU_TLkAH4PwA>
    <xmx:sEv_XDVePjmKZQlSMNDketpFjaF77q_9E0unah_QMrEv0DOQxBqR3w>
    <xmx:sEv_XO3Ci2tInAARoitt9TC1eL8z0946wmAKJS3Lt8BDJrGwmcJ-Ww>
    <xmx:s0v_XPAkrxmO5cgoL37gGCgbfxFLkO5rM9PzvOr_mKwM4d1N9G56Pg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D96D380087;
        Tue, 11 Jun 2019 02:35:28 -0400 (EDT)
Date:   Tue, 11 Jun 2019 09:35:26 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190611063526.GA6167@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
 <20190610134820.GG8247@lunn.ch>
 <20190610135848.GB19495@splinter>
 <20190610140633.GI8247@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610140633.GI8247@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 04:06:33PM +0200, Andrew Lunn wrote:
> On Mon, Jun 10, 2019 at 04:58:48PM +0300, Ido Schimmel wrote:
> > On Mon, Jun 10, 2019 at 03:48:20PM +0200, Andrew Lunn wrote:
> > > > +		# Skip 56G because this speed isn't supported with autoneg off.
> > > > +		if [[ $speed == 56000 ]]; then
> > > > +			continue
> > > > +		fi
> > > 
> > > Interesting. How is 56000 represented in ethtool? Listed in both
> > > "Supported link modes" and "Advertised link modes"?
> > 
> > Hi Andrew,
> > 
> > Yes. We recently sent a patch to error out if autoneg is off: Commit
> > 275e928f1911 ("mlxsw: spectrum: Prevent force of 56G").
> 
> I never get access to high speed links like this. Do you have a
> reference to why 56G needs auto-neg? What makes it different to every
> other link mode?

Hi Andrew,

I verified with PHY engineers and this limitation is specific to our
hardware, so no external reference I can provide.
