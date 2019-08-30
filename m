Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2BA3450
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfH3Jn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:43:26 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55973 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbfH3Jn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 05:43:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A136332A9;
        Fri, 30 Aug 2019 05:43:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 30 Aug 2019 05:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xSMmHk
        8zElgw/P9GO/Rx4Txs5yQjETOuxsESTLh73Xk=; b=HozWlQepDEdOiqmHdN+iB4
        XDIiLG/bT+Mrp7NRjEn9tL2IvMjbKIXzKOU9xH5nTsG9mkl2MC/KNvkEWWg7232J
        5oXQcNjFETuzzJalltAuOV5hMQ2wqqkw/l8ZIymJcUNDPKV75Oa8AYAsOt0qrEyY
        Jz7BcoGWz6P3ymgFFX5EZ3aQNqHYvFVkckbZK1dNEdQ2PsUIh7rN+M0AvZcXgdeW
        /u+PmmNDzRvE5qI9NRfXgmwi4OM1IvLKN1s9j47TGqS/6t+rtiCZLAoloYji1fks
        025RIe1yvC7NsMHgPP2jyHlQruFw9GgVHm5rhX3rlW89ocw06+8x+AeP6feCbYVg
        ==
X-ME-Sender: <xms:uu9oXXxSWQ7nPhQRWgka53m4hrKouBXV0yFHfAOdQJ69-OzHUqIHlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedutd
    elrdeijedriedurddvvdegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:uu9oXTh8mI8-iGGVM7AOVy7GfkMzxE_oFY8ZmHsia6epPGyCdiR7lg>
    <xmx:uu9oXcUg0vib1F477xVc084he61Mbv6dWl3Sm2Ygv8HrVMu38Nm2nQ>
    <xmx:uu9oXV37g9VeJ9h5SxrUST_yaeBYJ3EpBSUb0g7UOhzZh_hBX4zKjg>
    <xmx:vO9oXe44d5mvUPOCOC2Ytc0JFh8YhX16FJkO2XrmKTiQ-IS-krwgPg>
Received: from localhost (bzq-109-67-61-224.red.bezeqint.net [109.67.61.224])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D7F88005A;
        Fri, 30 Aug 2019 05:43:21 -0400 (EDT)
Date:   Fri, 30 Aug 2019 12:43:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, jiri@resnulli.us, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190830094319.GA31789@splinter>
References: <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
 <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829.151201.940681219080864052.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 03:12:01PM -0700, David Miller wrote:
> From: Ido Schimmel <idosch@idosch.org>
> Date: Thu, 29 Aug 2019 22:36:13 +0300
> 
> > I fully agree that we should make it easy for users to capture offloaded
> > traffic, which is why I suggested patching libpcap. Add a flag to
> > capable netdevs that tells libpcap that in order to capture all the
> > traffic from this interface it needs to add a tc filter with a trap
> > action. That way zero familiarity with tc is required from users.
> 
> Why not just make setting promisc mode on the device do this rather than
> require all of this tc indirection nonsense?
> 
> That's the whole point of this conversation I thought?

As I understand it, the goal of this series is to be able to capture
offloaded traffic.

Currently, the only indication that drivers get when someone is running
tcpdump/tshark/whatever over an interface is that it's is put in promisc
mode. So this patches use it as an indication to trap all the traffic to
the CPU and special case the bridge in order to prevent the driver from
trapping packets when its ports are bridged. The same will have to be
done for OVS and in any other (current or future) cases where promisc
mode is needed to disable Rx filtering.

If there was another indication that these applications are running over
an interface, would we be bothering with this new interpretation of
promisc mode and special casing? I don't think so.

We can instead teach libpcap that in order to capture offloaded traffic
it should use this "tc indirection nonsense". Or turn on a new knob.
This avoids the need to change each driver with this new special case
logic.

Also, what happens when I'm running these application without putting
the interface in promisc mode? On an offloaded interface I would not be
able to even capture packets addressed to my interface's MAC address.
What happens when the interface is already in promisc mode (because of
the bridge) and I'm again running tcpdump with '-p'? I will not be able
to capture offloaded traffic despite the fact that the interface is
already configured in promisc mode.
