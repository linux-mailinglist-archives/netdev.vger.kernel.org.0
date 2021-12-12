Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94843471939
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 09:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhLLIJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 03:09:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50485 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229641AbhLLIJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 03:09:26 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C1CFD5C0125;
        Sun, 12 Dec 2021 03:09:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 12 Dec 2021 03:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hXQuDG
        lzjy/3xUxrf64ysd1cj+5C6g7s7wwybJFOTOQ=; b=cG03nb9AYQKJ+gVeiKjbwo
        v1SZfEDkI/SQVeZhGQOV9U+8Y8i3gT+hisASpF1JuKks+ZkP3Ue7XdY7BoX81JOD
        OVQrjeMJ6BCHFWblm6qG9h4rs8XNI7i9BnG1/s/Kwuhqrox5uMFz4hCii79Ifb/C
        1FfmTfyPvTbJHFa9QPSQ1SVdwoeEZSyGpVDHY4q9tHmvyU6of+fyKjQpeJ4Df+8t
        Tuft9ied8EqNzuYHeCInzYt1S5CzPCel2dYbMpMhMNnHWKTn+6mnzppnqwvOuBxY
        bSttQsb+zyvgqvqusaPtlfgtyG2bdxq2h2R1lIXAhaMJVB0auKoMNbH/g/HPN4BA
        ==
X-ME-Sender: <xms:Na61YT1WFM2Ocx2DOKnBK1qFGvJIpW2SYB5u9Dd3YHRKH7URSey-Ig>
    <xme:Na61YSGiVUXaNyQ2RWFvcoDrJiTruwb9TGNVEeoLUKqE1jnISbicEk3k9kJljh0hg
    JsnkNTYKSKX4xM>
X-ME-Received: <xmr:Na61YT4G7ID_yek9tJIyCtAiQycNoWHTSdry8TPkGjHNh2bcjbleIoxZ7j9i>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeehgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffhfehveefleejlefflefhleehhffggeejjeegtdejhfdthfegueeghfduvedv
    geenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhshiiisghothdrmhgupdhnohhtrd
    hnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Na61YY3IJbzB_60jkQSQ0UHb5EphkgzlhyWOHjqeRuaEc_0icmbmNw>
    <xmx:Na61YWHWhHIJleDhoF0bPYbhrOo7604DWV4VjjVNAerLt79Q5C4MPQ>
    <xmx:Na61YZ8JfVtbUWmx8Gdl7D8oXKnkBAdsp_2lxSphkqT4w6qhqEtJiw>
    <xmx:Na61YbTuFTx7D3Hk4jouQw9hyhVWNMZ0eceLrASWH5GksHldSOMP3A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Dec 2021 03:09:24 -0500 (EST)
Date:   Sun, 12 Dec 2021 10:09:22 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH net] ipv4: Check attribute length for RTA_GATEWAY
Message-ID: <YbWuMj3moQ9uShMc@shredder>
References: <20211211162148.74404-1-dsahern@kernel.org>
 <YbT4ZJ+bSc/qeT5A@shredder>
 <73de092c-e6d0-72d6-3547-b4217076f6f9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73de092c-e6d0-72d6-3547-b4217076f6f9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 03:13:02PM -0700, David Ahern wrote:
> On 12/11/21 12:13 PM, Ido Schimmel wrote:
> > On Sat, Dec 11, 2021 at 09:21:48AM -0700, David Ahern wrote:
> >> syzbot reported uninit-value:
> >> ============================================================
> >>   BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
> >>   net/ipv4/fib_semantics.c:708
> >>    fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
> >>    fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
> >>    fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
> >>    inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886
> >>
> >> Add length checking before using the attribute.
> >>
> >> Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
> >> Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
> >> Signed-off-by: David Ahern <dsahern@kernel.org>
> >> Cc: Thomas Graf <tgraf@suug.ch>
> >> ---
> >> I do not have KMSAN setup, so this is based on a code analysis. Before
> > 
> > Was using this in the past:
> > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs
> 
> thanks for the pointer. I am a bit hardware challenged at the moment for
> out of tree features.
> 
> > 
> >> 4e902c57417c fib_get_attr32 was checking the attribute length; the
> >> switch to nla_get_u32 does not.
> >>
> >>  net/ipv4/fib_semantics.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> >> index 3cad543dc747..930843ba3b17 100644
> >> --- a/net/ipv4/fib_semantics.c
> >> +++ b/net/ipv4/fib_semantics.c
> >> @@ -704,6 +704,10 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
> >>  				return -EINVAL;
> >>  			}
> >>  			if (nla) {
> >> +				if (nla_len(nla) < sizeof(__be32)) {
> >> +					NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
> >> +					return -EINVAL;
> >> +				}
> > 
> > Isn't the problem more general than that? It seems that there is no
> > minimum length validation to any of the attributes inside RTA_MULTIPATH.
> > Except maybe RTA_VIA
> > 
> 
> A follow up commit is needed for RTA_FLOW.

The same problem seems to exists in the delete path and IPv6. See
fib_nh_match() and ip6_route_multipath_add(), for example.
