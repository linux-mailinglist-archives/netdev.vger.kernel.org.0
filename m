Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BA13FD909
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243892AbhIALyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 07:54:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48385 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243737AbhIALyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 07:54:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 60EF15C0136;
        Wed,  1 Sep 2021 07:53:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 Sep 2021 07:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z4qIXy
        LcujV2U5CyH1bzUJqLI8i07tbLSNrRKX1gOog=; b=v9wQbBaWV9uoucX3bZfEk1
        pOezAv9s2miXludOgBWk0nsHf2ktrBq9HRX7vWbjeOYkQav2eY56TzxbdkH7eqiy
        8UFH2kmVuCJgpKKkiMf2CK1G2V1sZWQIWU2Z3xp7ZbN8Het4xftTJIkPb9o4nlWO
        jSkhhvtC2UTsloa/qf6o+fL4qd1b7Ftq72xHrUHCMPYtcWwvqnbLaRZHoFqup5oD
        3JG+5v/HCgnUAqSu56L9EJX0AuDyYNE/Sf+F/qIPQh9ishOb1jJlZtMn8NTPfnlT
        dpc8N+swoYUTW1WUqvevSoZpoMXEgOe1p8lEDgUrQkN3XYcoEU0W13dh9dS/OUEg
        ==
X-ME-Sender: <xms:vWkvYYbSp86gKDQ2DPLdYIoB_tYNSnqbQu9JJA5XsXl5Hzz_T8WbuA>
    <xme:vWkvYTYjF1QJiX2CIUWAm46S4JjNoQl-sIv8w19aMU0e3s-pXCzNLHFABT_cOt27Z
    zzvJzC6Nvna7xw>
X-ME-Received: <xmr:vWkvYS_apNhSzs2g8RyYkRKZhE8TUCNfAnj6N1UYb8kOt6W6loHYsMJz4OiWvXp1HzeJa3ZNLE7gbfajcmsd7e1CL9vmXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vWkvYSqMboSQ_X-0GZddopgn0a9nUgEF3bMnNxCHCVQ-aq8GW6JAfg>
    <xmx:vWkvYTou-5PLlYzw4ls2mp92HqPXxe8VaZPDQ6po2cx_dBZr0bxZog>
    <xmx:vWkvYQRn2RcI6AGnS47CUlwE_tdVjuu82_LqgBK-MhME9OGY9cljdg>
    <xmx:vmkvYfLmB68LkzfD77nHyiV_hss1GtIlMQewrOz56S2qjP6ZratKPA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 07:53:32 -0400 (EDT)
Date:   Wed, 1 Sep 2021 14:53:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
Message-ID: <YS9puVgl/exGgrr3@shredder>
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
 <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 09:41:14AM -0400, Willem de Bruijn wrote:
> On Sat, Aug 21, 2021 at 3:14 AM Shreyansh Chouhan
> <chouhan.shreyansh630@gmail.com> wrote:
> >
> > Validate csum_start in gre_handle_offloads before we call _gre_xmit so
> > that we do not crash later when the csum_start value is used in the
> > lco_csum function call.
> >
> > This patch deals with ipv4 code.
> >
> > Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> > Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
> > Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Hi Shreyansh, Willem,

I bisected packet drops with a GRE tunnel to this patch. With the
following debug patch [1], I'm getting this output [2].

Tested with IPv4 underlay only, but I assume problem exists with ip6gre
as well.

Thanks

[1]
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 177d26d8fb9c..cf4e13db030b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-       if (csum && skb_checksum_start(skb) < skb->data)
+       if (csum && skb_checksum_start(skb) < skb->data) {
+               if (net_ratelimit())
+                       skb_dump(KERN_WARNING, skb, false);
                return -EINVAL;
+       }
        return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }

[2]
skb len=84 headroom=78 headlen=84 tailroom=15902
mac=(78,0) net=(78,20) trans=98
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=32
dev name=g1a feat=0x0x00000006401d5869
skb linear:   00000000: 45 00 00 54 be 12 40 00 3f 01 f9 82 c0 00 02 01
skb linear:   00000010: c0 00 02 12 08 00 fe ad 8c 39 00 01 7c 65 2f 61
skb linear:   00000020: 00 00 00 00 f8 7d 0a 00 00 00 00 00 10 11 12 13
skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
skb linear:   00000050: 34 35 36 37
