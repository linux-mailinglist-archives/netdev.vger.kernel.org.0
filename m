Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4D61AF8C3
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgDSIah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:30:37 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56259 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725905AbgDSIag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:30:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B65B4580274;
        Sun, 19 Apr 2020 04:30:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 19 Apr 2020 04:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xFsT5O
        q/6TltH8ujvN3TMeI7egC0+L5x/aExf1ACPNg=; b=XNP4eH2stJlWOiaNzQsNIe
        2QSG6RuFttzD57rY6Y8YTTdZusSs5aNwOWgic6np/PHAHV+pq614v5GYygpf8f2x
        HzoHRe6+6PkeELKHz6fesnolop1q294s9gl7LbXwOa1UdER5XiG2kazDdvJ+pTPQ
        crCZcGNin8G9cX6WOnsiHKK7KajOgDp7Efyl4JYi12YE4aOa6HyRnONmRqEjrVBd
        9gV+Zep/ik2E08iDDfYeyTt7SlYW/6HvSYK/wDRGJLF2mN0ADk0trbN+pOynCexa
        Xsmb91tCEuXXDpseOKhgAsF/BdNgm8KmD+qwA14laq0oy9eubLyaVZSTUqu/Ko5Q
        ==
X-ME-Sender: <xms:KgycXsLKU9B5a6LFRHVDcCcRD1Q-H8M52Ss6697rV_o1PAjxE95nFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgedugddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrihhnpe
    hgihhthhhusgdrtghomhenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguoh
    hstghhrdhorhhg
X-ME-Proxy: <xmx:KgycXkVdX_0LPPoewFJ6XoVS57SPIz4ZqJeyRBYHLQaZ00Dz0bwmiA>
    <xmx:KgycXimjonaCSYfw0SY1q0-v8QtgUqdGk07F5VfqaTCMs4U_eRBWAg>
    <xmx:KgycXidNdDxbYe7ra0L6AM3ypZhQVzKVRDth9EYZce-NMRifg7vKQw>
    <xmx:KwycXigU4nZp6b5MOiGDnNv9hdmG8iQvJFhPlm5r2AOR3lpmbxjgXw>
Received: from localhost (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3927F328005A;
        Sun, 19 Apr 2020 04:30:34 -0400 (EDT)
Date:   Sun, 19 Apr 2020 11:30:32 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, kuba@kernel.org
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200419083032.GA3479405@splinter>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 09:33:07AM +0200, Allan W. Nielsen wrote:
> Hi,
> 
> Sorry I did not manage to provide feedback before it was merged (I will
> need to consult some of my colleagues Monday before I can provide the
> foll feedback).
> 
> There are many good things in this patch, but it is not only good.
> 
> The problem is that these TCAMs/VCAPs are insanely complicated and it is
> really hard to make them fit nicely into the existing tc frame-work
> (being hard does not mean that we should not try).
> 
> In this patch, you try to automatic figure out who the user want the
> TCAM to be configured. It works for 1 use-case but it breaks others.
> 
> Before this patch you could do a:
>     tc filter add dev swp0 ingress protocol ipv4 \
>             flower skip_sw src_ip 10.0.0.1 action drop
>     tc filter add dev swp0 ingress \
>             flower skip_sw src_mac 96:18:82:00:04:01 action drop
> 
> But the second rule would not apply to the ICMP over IPv4 over Ethernet
> packet, it would however apply to non-IP packets.
> 
> With this patch it not possible. Your use-case is more common, but the
> other one is not unrealistic.
> 
> My concern with this, is that I do not think it is possible to automatic
> detect how these TCAMs needs to be configured by only looking at the
> rules installed by the user. Trying to do this automatic, also makes the
> TCAM logic even harder to understand for the user.
> 
> I would prefer that we by default uses some conservative default
> settings which are easy to understand, and then expose some expert
> settings in the sysfs, which can be used to achieve different
> behavioral.
> 
> Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
> understand default.
> 
> But I do seem to recall that there is a way to allow matching on both
> SMAC and SIP (your original motivation). This may be a better default
> (despite that it consumes more TCAM resources). I will follow up and
> check if this is possible.
> 
> Vladimir (and anyone else whom interested): would you be interested in
> spending some time discussion the more high-level architectures and
> use-cases on how to best integrate this TCAM architecture into the Linux
> kernel. Not sure on the outlook for the various conferences, but we
> could arrange some online session to discuss this.

Not sure I completely understand the difficulties you are facing, but it
sounds similar to a problem we had in mlxsw. You might want to look into
"chain templates" [1] in order to restrict the keys that can be used
simultaneously.

I don't mind participating in an online discussion if you think it can
help.

[1] https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates
