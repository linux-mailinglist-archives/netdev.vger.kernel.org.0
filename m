Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0847158A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhLKTNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:13:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36859 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231765AbhLKTNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:13:46 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D5EF05C011B;
        Sat, 11 Dec 2021 14:13:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 11 Dec 2021 14:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0voisC
        9fR5bzOuU54KbyY7UIBuven/v2s2k4ok21ff8=; b=T3n5cadyUCu7CscTOhjvi7
        8B1w8BuWTJ8YEq/ru2DQt/coRuu4YPzOJcL3cMxP9hZ6egAcHcVgcvlOvDsB3BCJ
        ErZyejvvrAi9hXkzlG3PJZfpX+fdfNgSHLWe7rNY0sFZNVSOeJu36HnVMMyih/0L
        BLGFiOBxaPd3MU7utlFG7ofulW1wMDE5uITHMcpLnfjcyqAxcvyCrgVNvIJUirFr
        yLnP1m7tfVgLbi0IOQfxjnnQ6Mwj03Bi1Q9yhG9L+CiU5Tpg0Rv2bMtq9Auw3aF6
        rbDrDMMxgobMcr7Iqn+MU+buzO1rIYvKAKwLU1kXnrtpSC2KGe4sqTHINOHUVjXg
        ==
X-ME-Sender: <xms:aPi0YY4VWpmdFaDG-kcCnvPwznEd85tmdcX69Dj_vYof2gUFrqm5Lw>
    <xme:aPi0YZ7dloURFFnL5ABuGRAp--3svOF4hFaZ1mKdKm6MIikKXlxkFfGJycDn_ngUg
    NC8eYCJSMcZSbI>
X-ME-Received: <xmr:aPi0YXeoYLVk1584MRgdlQvjFKsYQLS88IhYPPhTBeUsdRplZ41Mx4Vj8orObyY1KeQmXmaNXXiTQlt8gH0e9tmpJBIbvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeeggdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffhfehveefleejlefflefhleehhffggeejjeegtdejhfdthfegueeghfduvedv
    geenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhshiiisghothdrmhgupdhnohhtrd
    hnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aPi0YdIQGtanL1MqcODzECqs2yvOftfuooIYHWg6S1Pxdgru0javow>
    <xmx:aPi0YcKZEW6N-jvsq2s19L9THuAvY1oKUTMShJkNoS2wJjJHfjMARQ>
    <xmx:aPi0YexfYSkjHJcMMaPZJS0_yrzM0DWqaJwBfbmC74jQ6g6vJLHu-w>
    <xmx:afi0YWikf8EyU2ymBMUewaSmUgxg4qa-1fY6RiVnCMK5iVN9w6e-Qg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 11 Dec 2021 14:13:44 -0500 (EST)
Date:   Sat, 11 Dec 2021 21:13:40 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH net] ipv4: Check attribute length for RTA_GATEWAY
Message-ID: <YbT4ZJ+bSc/qeT5A@shredder>
References: <20211211162148.74404-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211162148.74404-1-dsahern@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 09:21:48AM -0700, David Ahern wrote:
> syzbot reported uninit-value:
> ============================================================
>   BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
>   net/ipv4/fib_semantics.c:708
>    fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
>    fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
>    fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
>    inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886
> 
> Add length checking before using the attribute.
> 
> Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
> Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Thomas Graf <tgraf@suug.ch>
> ---
> I do not have KMSAN setup, so this is based on a code analysis. Before

Was using this in the past:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs

> 4e902c57417c fib_get_attr32 was checking the attribute length; the
> switch to nla_get_u32 does not.
> 
>  net/ipv4/fib_semantics.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 3cad543dc747..930843ba3b17 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -704,6 +704,10 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
>  				return -EINVAL;
>  			}
>  			if (nla) {
> +				if (nla_len(nla) < sizeof(__be32)) {
> +					NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
> +					return -EINVAL;
> +				}

Isn't the problem more general than that? It seems that there is no
minimum length validation to any of the attributes inside RTA_MULTIPATH.
Except maybe RTA_VIA

>  				fib_cfg.fc_gw4 = nla_get_in_addr(nla);
>  				if (fib_cfg.fc_gw4)
>  					fib_cfg.fc_gw_family = AF_INET;
> -- 
> 2.24.3 (Apple Git-128)
> 
