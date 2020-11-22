Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84EC2BC907
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 21:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgKVUCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 15:02:06 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:33993 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727297AbgKVUCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 15:02:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EB28258060F;
        Sun, 22 Nov 2020 15:02:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 22 Nov 2020 15:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7Cadpl
        UTlXRcsPfIWFGFcdBLnPqzbykXqAYEnRn0/t8=; b=lf6wBtnFP/NUxNgthH2/2r
        9twmeIQCF9C1ozoCcNcqwV80MAVgf78pL4ftBgoC/hWyvKK4SvL7q5buX57jFYiS
        n75NBxcgX2J5BRmD95UqoVc15QH4G0RGm3K4tilNoGBeIIwp0JO0wmkxeL2Tjb60
        3bkQNN1NdcppX1LPh610Be2A21fayoUDXlM84HOObOq65Tc2iHuwjt+WYOnFktr1
        DTCDhdvxM0p4g+0Z2dG9LLzejCbjmW4sfWpUlINxGPw6wFsM0Dv1Dgsw0O67ybEQ
        45lvgL1zX8qTcNub0vp14xmin4tTRgZSTh6h49YChflNuWx293lY85AXz/FUpUvA
        ==
X-ME-Sender: <xms:usO6X7-zr4qUwEwR-D6YNKI-YY5KmXLKWb-Zv-i4urcn49lI3jFiIA>
    <xme:usO6X3s-V4ZOEZXm4Sf7I27aqEc2xDvAlVmnRcTNiachzmgKmbyzVWsN1-JYw7wE6
    kYV4lCFiVDHNb0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeggedgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehgedrudegjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:usO6X5B0DNATvM4F9A0O7QAtL4vb2H4VqEEIsomSi_7d0Ha7PBIgOQ>
    <xmx:usO6X3dtql8yAYYAc1Vo0i2z6TEB5l9DMEDYAYcRmkSUtEt1uH-1rA>
    <xmx:usO6XwNK4TGTmvz_zG0mgcpksV_sWfbtc7gHh1fUf_yk3qDaH3cF3Q>
    <xmx:vMO6X_rZIfb7AMrYnwg3vMf-ClPu2NiMFMM1lQcwoAJnoYRHWTcm-g>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59AD13064AA7;
        Sun, 22 Nov 2020 15:02:02 -0500 (EST)
Date:   Sun, 22 Nov 2020 22:01:54 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message
 type definitions
Message-ID: <20201122200154.GA668367@shredder.lan>
References: <20201122082636.12451-1-ceggers@arri.de>
 <20201122082636.12451-3-ceggers@arri.de>
 <20201122143555.GA515025@shredder.lan>
 <2074851.ybSLjXPktx@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2074851.ybSLjXPktx@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 08:29:22PM +0100, Christian Eggers wrote:
> On Sunday, 22 November 2020, 15:35:55 CET, Ido Schimmel wrote:
> > On Sun, Nov 22, 2020 at 09:26:35AM +0100, Christian Eggers wrote:
> > > Use recently introduced PTP wide defines instead of a driver internal
> > > enumeration.
> > >
> > > Signed-off-by: Christian Eggers <ceggers@gmx.de>
> > > Cc: Petr Machata <petrm@mellanox.com>
> > > Cc: Jiri Pirko <jiri@nvidia.com>
> > > Cc: Ido Schimmel <idosch@nvidia.com>
> >
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> >
> > But:
> >
> > 1. Checkpatch complains about:
> > WARNING: From:/Signed-off-by: email address mismatch: 'From: Christian
> > Eggers <ceggers@arri.de>' != 'Signed-off-by: Christian Eggers
> > <ceggers@gmx.de>'
> unfortunately I changed this after running checkpatch. My intention was to
> separate my (private) weekend work from the patches I do while I'm on the job.

No problem. Just make sure that authorship and Signed-off-by agree. You
can use:

# git commit --amend --author="Christian Eggers <ceggers@gmx.de>"

> 
> > 2. This series does not build, which fails the CI [1][2] and also
> > required me to fetch the dependencies that are currently under review
> > [3]. I believe it is generally discouraged to create dependencies
> > between patch sets that are under review for exactly these reasons.
> this was also not by intention. Vladimir found some files I missed in the
> first series. As the whole first series had already been reviewed at that time,
> I wasn't sure whether I am allowed to add further patches to it. Additionally
> I didn't concern that although my local build is successful, I should wait
> until the first series is applied...

Yea, I saw that, no problem :)

> 
> > I don't know what are Jakub's preferences, but had this happened on our
> > internal patchwork instance, I would just ask the author to submit
> > another version with all the patches.
> Please let me know how I shall proceed...

Jakub has the final say, so I assume he will comment on that.

Regardless, thanks for the patches.
