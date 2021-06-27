Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5853B52D5
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 12:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhF0Kfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 06:35:41 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35943 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhF0Kfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 06:35:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E66605805C9;
        Sun, 27 Jun 2021 06:33:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 27 Jun 2021 06:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9Q9NxT
        OMyNZY04hi81t5aW1NL/jvGVXzK0xYeWpQ/yk=; b=Cnief0dEOZagOQc0SBNZe6
        hM3dRqJl2eGWHaUqehQdBqeeWK/2b5/TbWAKV3rPGsjb+kj8FBbVNgxVGxJjdDU9
        AbGw480/VbIR3DRkzmzygt4IzOcN/ZTkkpUnd40ln6fU5FKX14vCMkrQwHxKx6u9
        4/QMHS+bMEjW94czVrQK+yywcRjKMDQ4LWf8PZBjnaX2J9GGwm1fRXqPMX++bOV8
        zJNMPsfe3RCH5fhyV/zsMbNDl6HICtvj2qGu7+EAoITdhY+/JmAADm3RLnOZH4Lo
        JcIF5zLRBxMdmlQV2ZfqCKVkvn/Zob4rOe84pBIqQPLfW1oxoPKNtHJJLX3C2AXw
        ==
X-ME-Sender: <xms:7FPYYDPuKDbOrBIDAVOik4mJLDe497Fx7Ka2shUEXkYgnyTotjmbHw>
    <xme:7FPYYN9Zae5skxfMwID7_J59Kvwzh62aBU9BJk4lWwBZXlId3T9fMIFEtOHXJKBWc
    YMwFXeNZolJsDs>
X-ME-Received: <xmr:7FPYYCT2jVwvCAvV3lrNprXMvg9A9VTutMpb8QJc-ItLYezrSJK8GXVvYqgv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7FPYYHuRqVnrzaT1jdBk5Jrj8Elya0C0alsyQKnzQGxlCCAvl4xWoQ>
    <xmx:7FPYYLc3j4kc5IDo-ptm-gXGnI4k8BELA7eGDzBYKb99Aasew4AF9g>
    <xmx:7FPYYD2_o80eTrmcva4tdPiRFts5kv5TFKJUJ9eY3pyGDMDySeYExA>
    <xmx:7FPYYKyv9tt3pCwwmdu4C-k4ugAq0Cm9Rf2nDazh5URORnv54j5g9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 06:33:15 -0400 (EDT)
Date:   Sun, 27 Jun 2021 13:33:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNhT6aAFUwOF8qrL@shredder>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNTqofVlJTgsvDqH@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 10:27:13PM +0200, Andrew Lunn wrote:
> > I fail to understand this logic. I would understand pushing
> > functionality into the kernel in order to create an abstraction for user
> > space over different hardware interfaces from different vendors. This is
> > not the case here. Nothing is vendor specific. Not to the host vendor
> > nor to the module vendor.
> 
> Hi Ido

Hi Andrew,

> 
> My worry is, we are opening up an ideal vector for user space drivers
> for SFPs. And worse still, closed source user space drivers. We have
> had great success with switchdev, over a hundred supported switches,
> partially because we have always pushed back against kAPIs which allow
> user space driver, closed binary blobs etc.

I don't think it's a correct comparison. Switch ASICs don't have a
standardized interface towards the host. It is therefore essential that
the kernel will abstract these differences to user space.

> 
> We have the choice here. We can add a write method to the kAPI, add
> open source code to Ethtool using that API, and just accept people are
> going to abuse the API for all sorts of horrible things in user space.
> Or we can add more restrictive kAPIs, put more code in the kernel, and
> probably limit user space doing horrible things. Maybe as a side
> effect, SFP vendors contribute some open source code, rather than
> binary blobs?

I didn't see any code or binary blobs from SFP vendors and I'm not sure
how they can provide these either. Their goal is - I believe - to sell
as much modules as possible to what the standard calls "systems
manufactures" / "system integrators". Therefore, they cannot make any
assumptions about the I2C connectivity (whether to the ASIC or the CPU),
the operating system running on the host and the user interface (ioctl /
netlink etc).

Given all these moving parts, I don't see how they can provide any
tooling. It is in their best interest to simply follow the standard and
make the tooling a problem of the "systems manufactures" / "system
integrators". In fact, the user who requested this functionality claims:
"the cable vendors don't develop the tools to burn the FW since the
vendors claim that the CMIS is supported". The user also confirmed that
another provider "is able to burn the FW for the cables from different
vendors".

> 
> I tend to disagree about adding kAPIs which allow write. But i would
> like to hear other peoples opinions on this.
> 
>      Andrew
> 
