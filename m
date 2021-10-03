Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42D41FFCE
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 06:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhJCEmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 00:42:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43189 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229450AbhJCEmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 00:42:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 382E55C00CA;
        Sun,  3 Oct 2021 00:40:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 03 Oct 2021 00:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=u3E0uL
        U6T5YTklmLRS6CRo5rtoudTsWZfwKzUvU5ZtU=; b=AFwOufMBZpOKSvoxtd0IYC
        +58EeK/l4XwHDWDJNtNzSHZEn/p+ZKj+mWD1b9Gg2r1s03PlWhdcw5tNF+1zeoUb
        KqQK16Ko8oylurGlSqTJ4R1feAOUbXoeBWr5GSAXzpukR3+nfDK2a+Cpzzyuo0vJ
        6C9C/bySM0MXd3VBEPN2NdpbRZPKQ0u2wl+s1xam0ZNKbC/vMYvbkEfqVrIQOj0B
        fycghnQ0xd8mY5WeOnQpgYO50d203jKicy1sd/loqoYwifVsKOd5G6M5rBuE2CyJ
        PakYEKdK2qQP1y4qXEslMGsJqNZ9A6dq9Awx4+nsN0HAzgVfsItfHSITY03ac6Wg
        ==
X-ME-Sender: <xms:WTRZYRNPZ1RmhhnBUyiAkA7ye8jBFTLJ3N12G9S-ikxLLUp7_eHkrg>
    <xme:WTRZYT_ZgWixZnqMWuiR4yZG_LLxzBcKwKH7Lgg0M1R4tACxesfU5xIKDrptHo3Ya
    I8s5Yl9j8CKqmk>
X-ME-Received: <xmr:WTRZYQRy7AdtmXfg2MjQrLGjZxrBVH86EA17LHxXtLxCIJiQhJPaZfcsFzBppPwzqCslsonnp9DgmISxR6ePVu4x79hmow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekledgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WTRZYduPr6YiPxFm8UXx3rYfwVbtllvgYi3Q46bA6HJUfC5pSL5C8w>
    <xmx:WTRZYZfGJnjr4rwOX5UQawWxXG9ktq5q6-mISYvE9K1uM1xIHYRk1g>
    <xmx:WTRZYZ3UCIWICbSpAuMavuEqvOOrZN-Nu3RW7rHuNQLkm7fDU6h0rg>
    <xmx:WTRZYZlLLP_HY7HLq1VXVCvKiDLm5CQrkfJQbdCTE34_qzU1z5ISkw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 3 Oct 2021 00:40:56 -0400 (EDT)
Date:   Sun, 3 Oct 2021 07:40:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/11] ethernet: use eth_hw_addr_set()
Message-ID: <YVk0VeaCv93ZFNtk@shredder>
References: <20211001213228.1735079-1-kuba@kernel.org>
 <20211001213228.1735079-4-kuba@kernel.org>
 <YViJtfwpSqR9wIOU@shredder>
 <20211002171255.336bbbe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211002171255.336bbbe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 02, 2021 at 05:12:55PM -0700, Jakub Kicinski wrote:
> On Sat, 2 Oct 2021 19:32:53 +0300 Ido Schimmel wrote:
> > On Fri, Oct 01, 2021 at 02:32:20PM -0700, Jakub Kicinski wrote:
> > > Convert all Ethernet drivers from memcpy(... ETH_ADDR)
> > > to eth_hw_addr_set():
> > > 
> > >   @@
> > >   expression dev, np;
> > >   @@
> > >   - memcpy(dev->dev_addr, np, ETH_ALEN)
> > >   + eth_hw_addr_set(dev, np)  
> > 
> > Some use:
> > 
> > memcpy(dev->dev_addr, np, dev->addr_len)
> > 
> > Not sure if you missed it or if it's going to be in part 2. I assume the
> > latter, but thought I would ask.
> 
> Yup, still
> 
>  417 files changed, 1239 insertions(+), 960 deletions(-)
> 
> to go. I thought I'd start upstreaming from the most obvious /
> mechanical changes.
> 
> For the memcpy(..., dev->addr_len) I'm thinking of using
> eth_hw_addr_set() in appropriate sections of the tree (drivers/ethernet,
> driver/wireless) and convert the rest to this helper:
> 
> static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
> {
> 	memcpy(dev->dev_addr, addr, dev->addr_len);
> }
> 
> dev_addr_set() everywhere would be more obviously correct, but using
> eth_hw_addr_set() seems cleaner for Ethernet drivers. Second opinion
> on this would be good if you have a preference.

Yes, I agree with using eth_hw_addr_set() for Ethernet drivers as it
will make the drivers in part 1 and part 2 consistent.
