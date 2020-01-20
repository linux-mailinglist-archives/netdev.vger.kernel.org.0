Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A371427B4
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgATJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:57:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43557 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgATJ5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:57:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 572EE21EB2;
        Mon, 20 Jan 2020 04:57:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 04:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Y4PRSU
        2I4mepMUl3Q7aQc2IUX+a0tD2/En87ke8o5ZM=; b=mLfq0ljZbkb4pMyaSuoZW0
        kQw97wugBxkBB7OzBabjJkk0leBli533lEnq95TUEPjxIZw6KXwX8TbYubX+v2QV
        yk/PfuHHaKiwv0y5JWXJx7WmUXLtRNVBwZocVzttPEP9Dx4hvnPCqDVaPyMH6Ch6
        oC/KX77J7XZrTFvlrTtsnQOIFIGVhu8K0SyuhndyaRjKJ7LCzdRUSnqhkWtpSVlQ
        BspHGWqsHQZ8JMnSeZghUP/gZfgOusNfxxXq0K1aKLlXrZWf1M7z8VTgWtwOEVMb
        brlbqWAkOSgdANr//pMKjegBvYEIf1kKw9PezdskIjmk1cRrTTePlej1OtWBwLxQ
        ==
X-ME-Sender: <xms:fHklXhjcorA_7ZBWFl0NMLYtwtfnb7a7x4K5OBdYEusMPIsFvO8dgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrihhnpe
    hkvghrnhgvlhdrohhrghenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:fHklXlTnMZwF0uRJq-xBJdohuy_VeWNbVHSQESOHRXAVMumIaPPbYQ>
    <xmx:fHklXtSL5a62Uvo72FZ9mnM630C9aGmb3_w51pS9neWlcDKOP69FTg>
    <xmx:fHklXhA6vg6wSg7v9IsxQaZyUeL7-4weG0bl0QZuwWC0IgtpHxiu0w>
    <xmx:fXklXsP7hAqMXTRM_-BtUD87VPIDd13sPevXtXreb4ouxu_VuGqhuw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BE133060986;
        Mon, 20 Jan 2020 04:57:16 -0500 (EST)
Date:   Mon, 20 Jan 2020 11:57:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Regression in macvlan driver in stable release 4.4.209
Message-ID: <20200120095714.GA3421303@splinter>
References: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 09:17:35AM +0000, Hans-Christian Egtvedt (hegtvedt) wrote:
> Hello,
> 
> I am seeing a regression in the macvlan kernel driver after Linux stable 
> release 4.4.209, bisecting identifies commit 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.4.y&id=8d28d7e88851b1081b05dc269a27df1c8a903f3e

Noticed it too last week (on net-next), but Eric already fixed it:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1712b2fff8c682d145c7889d2290696647d82dab

I assume the patch will find its way to 4.4.y soon now that it is in
mainline.

> 
> There seems to be a history behind this, and I do not have the full 
> overview of the intention behind the change.
> 
> What I see on my target, Aarch64 CPU, is that this patch moves the eth 
> pointer in macvlan_broadcast() function some bytes. This will cause 
> everything within the ethhdr struct to be wrong AFAICT.
> 
> An example:
> Original code "eth = eth_hdr(skb)"
>     eth = ffffffc007a1b002
> New code "eth = skb_eth_hdr(skb)"
>     eth = ffffffc007a1b010
> 
> Let me know if I can assist in any way.
> 
> -- 
> Best regards,
> Hans-Christian Noren Egtvedt
