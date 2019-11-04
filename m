Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CE1EF123
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 00:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfKDXUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 18:20:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56895 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729428AbfKDXUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 18:20:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FB4522008;
        Mon,  4 Nov 2019 18:20:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 04 Nov 2019 18:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QawIQ9
        A2Q3tw0KSoYUGQuYTJqVczTcBLJNGmhMEuqUA=; b=k56l6FANSdLSu5Nc/NvEwY
        VKQgbggGdXRkNHO4gYrq6qdpPNzhEUG/JYhpMaJI15fr/lY5JL2WQsHrsq9Xq/1Q
        KgOQ1l6XSkhrJNTUA3eHydzZTUSDhcgAZVhDTHOiyGgA9DyzZEkv/z4OEVGRZpgf
        qdG+M5BGT+vpSuI6QXdDOtkHppzyia4m3c5GKHuxTWo+OJ8bcSMp8EG+poJoqdXx
        IcrFRTEVYlw61BG4Kd+DwVE2Wge6x4IKOxxw0AHEFV9v6ejxqAs7q/7O7UzBMsN6
        KFodajI45T+6AHx77OL2UufZNcyp5OlwEdLxsAh2YvkB+4T/DHaaKeE0BU5LNbEg
        ==
X-ME-Sender: <xms:UbLAXdE3QFIlw6cKmuvDHKBHVFlo47ZEZl4wH8LVoTKB_s2qFp8Rjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeejje
    drudefkedrvdegledrvddtleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:UbLAXbsbao6NNn5EB-sSnnLFQi3TWnXHFizQzgnYp5SgW4Ca9DvOEg>
    <xmx:UbLAXYRPnsGis4M-EXEtE8l6fyW7nVcsOkhdyWGNsO1fOMT2KIXDvw>
    <xmx:UbLAXWGhZazqCndY9n5tOh9p0o49ZtiPBkLqOBljTbcrPz-YR-2L6Q>
    <xmx:UbLAXZgqGZOwRLUrBie4NbHh9D2Fi288DKdN_us7LGRbqp-s91OCzw>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90FEF80059;
        Mon,  4 Nov 2019 18:20:48 -0500 (EST)
Date:   Tue, 5 Nov 2019 01:20:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191104232036.GA12725@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
 <20191104123954.538d4574@cakuba.netronome.com>
 <20191104210450.GA10713@splinter>
 <20191104144419.46e304a9@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104144419.46e304a9@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 02:44:19PM -0800, Jakub Kicinski wrote:
> On Mon, 4 Nov 2019 23:04:50 +0200, Ido Schimmel wrote:
> > On Mon, Nov 04, 2019 at 12:39:54PM -0800, Jakub Kicinski wrote:
> > > On Sun,  3 Nov 2019 10:35:48 +0200, Ido Schimmel wrote:  
> > > > From: Ido Schimmel <idosch@mellanox.com>
> > > > 
> > > > Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> > > > the driver and device's firmware. They are used to pass various
> > > > configurations to the device, but also to get events (e.g., port up)
> > > > from it. After the Ethernet header, these packets are built in a TLV
> > > > format.
> > > > 
> > > > Up until now, whenever the driver issued an erroneous register access it
> > > > only got an error code indicating a bad parameter was used. This patch
> > > > set from Shalom adds a new TLV (string TLV) that can be used by the
> > > > firmware to encode a 128 character string describing the error. The new
> > > > TLV is allocated by the driver and set to zeros. In case of error, the
> > > > driver will check the length of the string in the response and print it
> > > > to the kernel log.
> > > > 
> > > > Example output:
> > > > 
> > > > mlxsw_spectrum 0000:03:00.0: EMAD reg access failed (tid=a9719f9700001306,reg_id=8018(rauhtd),type=query,status=7(bad parameter))
> > > > mlxsw_spectrum 0000:03:00.0: Firmware error (tid=a9719f9700001306,emad_err_string=inside er_rauhtd_write_query(), num_rec=32 is over the maximum number of records supported)  
> > > 
> > > Personally I'm not a big fan of passing unstructured data between user
> > > and firmware. Not having access to the errors makes it harder to create
> > > common interfaces by inspecting driver code.  
> > 
> > I don't understand the problem. If we get an error from firmware today,
> > we have no clue what the actual problem is. With this we can actually
> > understand what went wrong. How is it different from kernel passing a
> > string ("unstructured data") to user space in response to an erroneous
> > netlink request? Obviously it's much better than an "-EINVAL".
> 
> The difference is obviously that I can look at the code in the kernel
> and understand it. FW code is a black box. Kernel should abstract its
> black boxiness away.

But FW code is still code and it needs to be able to report errors in a
way that will aid us in debugging when problems occur. I want meaningful
errors from applications regardless if I can read their code or not.

> 
> > Also, in case it was not clear, this is a read-only interface and only
> > from firmware to kernel. No hidden knobs or something fishy like that.
> 
> I'm not saying it's fishy, I'm saying it's way harder to refactor code
> if some of the user-visible outputs are not accessible (i.e. hidden in
> a binary blob).

Not sure I understand which code you're referring to? The error print
statement?

>
> > > Is there any precedent in the tree for printing FW errors into the logs
> > > like this?  
> > 
> > The mlx5 driver prints a unique number for each firmware error. We tried
> > to do the same in switch firmware, but it lacked the infrastructure so
> > we decided on this solution instead. It achieves the same goal, but in a
> > different way.
> 
> FWIW nfp FW also passes error numbers to the driver and based on that
> driver makes decisions and prints errors of its own choosing. The big
> difference being you can see all the relevant errors by looking at
> driver code.

This is done by mlxsw as well. See:
$ vi drivers/net/ethernet/mellanox/mlxsw/emad.h +50

But by far the most common error is "bad parameter" in which case we
would like to know exactly what is "bad" and why.

Anyway, it's already tomorrow here, so I'll be back in a few hours (IOW:
expect some delay).
