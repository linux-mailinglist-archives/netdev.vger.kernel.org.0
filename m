Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4F2ABFE8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgKIPfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:35:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36881 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbgKIPfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:35:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F37C05C03D2;
        Mon,  9 Nov 2020 10:35:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 09 Nov 2020 10:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GOSBQ0
        Tt3iIgzm1Ap8+/GyZNXBFPRXdZktjV4NW0/44=; b=TGewrfP9BFyJOO05Dd2t8b
        6h6JYDldlEKSjfmn23x6hXEg5NN3c06wI8sJvxsEkyL97Bqv7BkwJ0cqe6S7P+0K
        +CcW5vknCbWcBt4gBejqAlOmn7i0ShzfU1TMYjtP3388GaOg2A/NnZt9yR4tiR1x
        0eB0vNDtNZXWIKLK+3vMzdUyggNA1m98MMRSOV2ufSIwK74rbTL/iPVUyRRqyc0H
        R9lOiJN3j3mOHxxJFdkI54yq4eHlbAMMidbDW8D+a16sGoueLpveJVY09F4dg3kb
        Ijcu1Kso11D+/w1noivPi1hPJo+Dhs1drrpkkZF3ToE3t6uRd3RrlJdwTyNhO7fQ
        ==
X-ME-Sender: <xms:2GGpX9oQdU2IYxfP3MNRqdfMmvLMNyL-LKum9njZiMGZNagoyHVlzg>
    <xme:2GGpX_ok6gSSYtiLAoYTAMoySrwtYvu_a47bgSmUvfHYiVE45vhLTBmWk0aE6tBbB
    OMAv3-xL3Cs-hY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2GGpX6Oywk4rOlVdR9OjiK4eWDojjH8YLY2AUZU2NYtpw3M5Dx-E0A>
    <xmx:2GGpX47ti8JiLWdNgLd3iHSQccwBpzFOgVXrlXOn6RPY1w1xoNjgpA>
    <xmx:2GGpX859LezlVCnMXTOs5gqA1_-ZePO5DMrby2BRo-Tr0zdLy_d5_g>
    <xmx:2GGpX6m_8Ovb92c2sPjRdKi7h9CuvROyUIjTTeUF4PYHDzI9zKmORg>
Received: from localhost (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71933328005E;
        Mon,  9 Nov 2020 10:35:52 -0500 (EST)
Date:   Mon, 9 Nov 2020 17:35:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/18] rtnetlink: Add RTNH_F_TRAP flag
Message-ID: <20201109153550.GA1796533@shredder>
References: <20201104133040.1125369-1-idosch@idosch.org>
 <20201104133040.1125369-6-idosch@idosch.org>
 <20201106111221.06e16716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106111221.06e16716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 11:12:21AM -0800, Jakub Kicinski wrote:
> On Wed,  4 Nov 2020 15:30:27 +0200 Ido Schimmel wrote:
> >  	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
> >  	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
> >  		*flags |= RTNH_F_OFFLOAD;
> > +	if (nhc->nhc_flags & RTNH_F_TRAP)
> > +		*flags |= RTNH_F_TRAP;
> 
> Out of curiosity - why use this if construct like OFFLOAD rather than
> the more concise mask like ONLINK does?

Good question :)

> In fact looks like the mask could just be extended there instead?

Yes, good suggestion. Will do that.
