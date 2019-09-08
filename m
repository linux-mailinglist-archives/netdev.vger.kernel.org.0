Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E115ACC06
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfIHKU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 06:20:58 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:35635 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbfIHKU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 06:20:57 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Sep 2019 06:20:57 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 22B67486;
        Sun,  8 Sep 2019 06:15:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 08 Sep 2019 06:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tnq5F9
        dmfBg3vZC/wKlqDrhdDjTehPEGdyvDq45CR5w=; b=kwQeDugJi32VUoPZ3rZYc2
        TfN5CH5OcggguFQOq44Hxm3MNRG7imZqEwvDDbWDqbSchb8p142Cx2CAh0jl0u1e
        eI16AubAU/PSJQpCcq6f2gN+ESAZQb5TCXZ6A+uPQd5opsK3vvca0ZfkmB6TI5Pf
        3zzpi/Z938XY1blnakqvUF4rPJnmSns3pjYHH6nJjr+sPhk2JrKEQZBbnuec2ZUx
        SxaaIL0YesEdl+oBlqhSLqfaGgdIcVazjptBO9sJOewZQOqbTx4HIU7cIbmGjXRe
        fBEIuo1PAe+tsQ3f+MR/oWJNv5uW4/P13jyJqk1fOUFzIVf+COSp5Om5Z60fshJw
        ==
X-ME-Sender: <xms:wdR0XWgTv3sTCuEJcbypVDwhfFtXUTv1NfnYNP-Xfkm3ndkT8nhB3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wdR0XRhbZhoKNgfEqdBDQTVDuSn_vJWRP79LFlCHaIQng8YEcEXnqg>
    <xmx:wdR0XbD2sUM1tX8Poi3GjJzTqo2AuUKAJOQEk4pVbPLbVT3FlVy3gA>
    <xmx:wdR0XR_wFNw4ajXo3qIzr2y5W-0T1lTj0zHJTZppxrkWk-JE9FrQCQ>
    <xmx:w9R0XWvidP1mR0ticmuVxjwmazfUch98liAB6BYn1-w6mAXqcFqGy3UyJi4>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14732D6005A;
        Sun,  8 Sep 2019 06:15:28 -0400 (EDT)
Date:   Sun, 8 Sep 2019 13:15:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190908101527.GA20499@splinter>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
 <20190903061324.GA6149@splinter>
 <20190903081410.zpcdm2dzqrxyg43c@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903081410.zpcdm2dzqrxyg43c@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 10:14:12AM +0200, Allan W. Nielsen wrote:
> The 09/03/2019 09:13, Ido Schimmel wrote:
> > On Mon, Sep 02, 2019 at 07:42:31PM +0200, Allan W. Nielsen wrote:
> > With these patches applied I assume I will see the following traffic
> > when running tcpdump on one of the netdevs exposed by the ocelot driver:
> > 
> > - Ingress: All
> > - Egress: Only locally generated traffic and traffic forwarded by the
> >   kernel from interfaces not belonging to the ocelot driver
> > 
> > The above means I will not see any offloaded traffic transmitted by the
> > port. Is that correct?
> Correct - but maybe we should change this.
> 
> In Ocelot and in LANxxxx (the part we are working on now), we can come pretty
> close. We can get the offloaded TX traffic to the CPU, but it will not be
> re-written (it will look like the ingress frame, which is not always the same as
> the egress frame, vlan tags an others may be re-written).

Yes, this is the same with mlxsw. You can trap the egress frames, but
they will reach the CPU unmodified via the ingress port.

> In some of our chips we can actually do this (not Ocelot, and not the LANxxxx
> part we are working on now) after the frame as been re-written.

Cool.

> > I see that the driver is setting 'offload_fwd_mark' for any traffic trapped
> > from bridged ports, which means the bridge will drop it before it traverses
> > the packet taps on egress.
> Correct.
> 
> > Large parts of the discussion revolve around the fact that switch ports
> > are not any different than other ports. Dave wrote "Please stop
> > portraying switches as special in this regard" and Andrew wrote "[The
> > user] just wants tcpdump to work like on their desktop."
> And we are trying to get as close to this as practical possible, knowing that it
> may not be exactly the same.
> 
> > But if anything, this discussion proves that switch ports are special in
> > this regard and that tcpdump will not work like on the desktop.
> I think it can come really close. Some drivers may be able to fix the TX issue
> you point out, others may not.
> 
> > Beside the fact that I don't agree (but gave up) with the new
> > interpretation of promisc mode, I wonder if we're not asking for trouble
> > with this patchset. Users will see all offloaded traffic on ingress, but
> > none of it on egress. This is in contrast to the sever/desktop, where
> > Linux is much more dominant in comparison to switches (let alone hw
> > accelerated ones) and where all the traffic is visible through tcpdump.
> > I can already see myself having to explain this over and over again to
> > confused users.
> > 
> > Now, I understand that showing egress traffic is inherently difficult.
> > It means one of two things:
> > 
> > 1. We allow packets to be forwarded by both the software and the
> > hardware
> > 2. We trap all ingressing traffic from all the ports
> If the HW cannot copy the egress traffic to the CPU (which our HW cannot), then
> you need to do both. All ingress traffic needs to go to the CPU, you need to
> make all the forwarding decisions in the CPU, to figure out what traffic happens
> to go to the port you want to monitor.
> 
> I really doubt this will work in real life. Too much traffic, and HW may make
> different forwarding decision that the SW (tc rules in HW but not in SW), which
> means that it will not be good for debugging anyway.

I agree.

> 
> > Both options can have devastating effects on the network and therefore
> > should not be triggered by a supposedly innocent invocation of tcpdump.
> Agree.
> 
> > I again wonder if it would not be wiser to solve this by introducing two
> > new flags to tcpdump for ingress/egress (similar to -Q in/out) capturing
> > of offloaded traffic. The capturing of egress offloaded traffic can be
> > documented with the appropriate warnings.
> Not sure I agree, but I will try to spend some more time considering it.
> 
> In the mean while, what TC action was it that Jiri suggestion we should use? The
> trap action is no good, and it prevents the forwarding in silicon, and I'm not
> aware of a "COPY-TO-CPU" action.

I agree. We would either need a new or just extend the existing one with
a new attribute.

> > Anyway, I don't want to hold you up, I merely want to make sure that the
> > above (assuming it's correct) is considered before the patches are
> > applied.
> Sounds good, and thanks for all the time spend on reviewing and asking the
> critical questions.

Thanks for bringing up these issues. I will be happy to review future
patches.
