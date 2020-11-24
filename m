Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED8F2C2040
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgKXIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:41:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59783 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730763AbgKXIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:41:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 155B25C0170;
        Tue, 24 Nov 2020 03:41:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 24 Nov 2020 03:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kyemIi
        meImHmKPTUBx3grJAj/NN1XAUrTI9ze8i9sQI=; b=Cy5SBZQCaq6aurEuWfrOza
        Xqt16qsA98x0bQK0UC3cmkFoPuR0G+DcFYKzXDgVFPeORWxENejLq8mcr0HKDjBC
        Jlrvsomyaumy/3wyAn0Ru77XLHwLMw5FwKMDJ+ZoRBBdhfZw8xE/eLADQn2SBXHG
        mv0RJxQ2NfV3BRvpzon/O+uGljJt1HTmN6JxC6xXghcCP4up2XUf/p86WK2RoQDz
        Zba7VydTSnCysf5lmdlFYjH8dnMCMphYMR9qpqwILH0lGDHWh9xajrCKXiWzJWtC
        iK8F6Sbkp2gWg2AexrPmJoe6CSSoYg2m8t59L/TqLzzpRD4WAMHNG2BcYhC0VfKQ
        ==
X-ME-Sender: <xms:Use8X0p5nh5WugXTXUNeNqxDlBNkVDEQwMO7odDJ7zhVz2VFpaJm2w>
    <xme:Use8X6o8oK6XKcOywMDw5HCSLJAXxAoc3rYCaI6yOtbt2LwI8l1EnSjsiwVSgoF_6
    2iw-uUiuOtdgPk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegjedgudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleeh
    keeunecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeegrddvvdelrdduhe
    egrddugeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Use8X5Po0qCOxOKFW_z4AapuwZE9C32Q6c9wJCo4-vq_sheEY3sDfg>
    <xmx:Use8X76EKB1ypZ-fKhhZcDZC_V9_bod8cOyWpUoK9sJ7SIjeg119LQ>
    <xmx:Use8Xz797jBZeE35vHK8ifffn0bUM_gZfUsoP_VjQxIdSHYA6EsVyA>
    <xmx:Vce8XzE02ZacgHoUgyZ0NKrHBoSKK3zZ22cTltpUAMNA3aghzwUjvw>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80E3D3064AB0;
        Tue, 24 Nov 2020 03:41:54 -0500 (EST)
Date:   Tue, 24 Nov 2020 10:41:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201124084151.GA722671@shredder.lan>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
 <20201124001431.GA2031446@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124001431.GA2031446@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:14:31AM +0100, Andrew Lunn wrote:
> On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:
> > Add debugfs support to SFP so that the internal state of the SFP state
> > machines and hardware signal state can be viewed from userspace, rather
> > than having to compile a debug kernel to view state state transitions
> > in the kernel log.  The 'state' output looks like:
> > 
> > Module state: empty
> > Module probe attempts: 0 0
> > Device state: up
> > Main state: down
> > Fault recovery remaining retries: 5
> > PHY probe remaining retries: 12
> > moddef0: 0
> > rx_los: 1
> > tx_fault: 1
> > tx_disable: 1
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Hi Russell
> 
> This looks useful. I always seem to end up recompiling the kernel,
> which as you said, this should avoid.

FWIW, another option is to use drgn [1]. Especially when the state is
queried from the kernel and not hardware. We are using that in mlxsw
[2][3].

[1] https://github.com/osandov/drgn
[2] https://github.com/Mellanox/mlxsw/blob/master/Debugging/hdroom_dump.txt
[3] https://github.com/Mellanox/mlxsw/blob/master/Debugging/hdroom_dump.py
