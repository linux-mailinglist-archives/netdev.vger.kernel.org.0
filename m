Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0847C316384
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBJKQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:16:46 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56723 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229970AbhBJKOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:14:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D48B858011C;
        Wed, 10 Feb 2021 05:13:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Feb 2021 05:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wXYUm5
        sqPqEmEMkn7WH/JtpvQmsaYI2cjrart5PSwqI=; b=AMefiAdY+GroMjfPiYxXzS
        TAUtIPzaM5CiXWePeYtd0vK2JCl9YVzCJ3h0t1XndvC1GOHB0CWjjNgMla7aD0J2
        v+Qx0nVTDlZEjOAGzFLSimljOht1MGVGC1UEGM6mIoG8ya+gj1jreMeZGu9xjOOn
        oP71xyDwP6N/Kpt20CPl+pMOWdk4N3phhDZebdC5zLWQoxZzaeIISboAXCDPVD3F
        wBH4x0UNNtL5ftSWE55HIMkeaPSgOOGPK0riRgW0VY6bfm35sN5cc8pHGGDbPgRk
        BFsjIevyaLl9Yzy6zxIAc8Lg2x/JP6kaKVwlCgc/AvkeXQBfAcf2yZscFXmPA3jw
        ==
X-ME-Sender: <xms:rbEjYPi-HYjd3iUoj71UkfibwsySmfsYLEqcvsvYOh8aJVP5VeS_tg>
    <xme:rbEjYMA70xJij1GeZMeiBctctBBVbKEOjOkMSeixDZNFYzNI6Oe91H6fV17cNCO8_
    11bLctvMroLtPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheejgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rbEjYPFI_1edpq2dCFbuv25QE_iAp0XHJjDGZUReg8hkdWwObi4M-w>
    <xmx:rbEjYMQASlSBXTlYP4Tg5F86T3k6b5h_23IfO4kjNj0PajVuv_qTTA>
    <xmx:rbEjYMwvJkme3sjKkQQ9Ez-Xu4OndwgXc1naMMBO1cPHTH0GkGvstw>
    <xmx:rrEjYAlgG2lEGgN2To2OCc9DP_n3ismsVIiI1ZEOIUwwzWmgyr9aRQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6CFC1080059;
        Wed, 10 Feb 2021 05:13:00 -0500 (EST)
Date:   Wed, 10 Feb 2021 12:12:57 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 07/11] net: prep switchdev drivers for
 concurrent SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
Message-ID: <20210210101257.GA287766@shredder.lan>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210091445.741269-8-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 11:14:41AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Because the bridge will start offloading SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
> while not serialized by any lock such as the br->lock spinlock, existing
> drivers that treat that attribute and cache the brport flags might no
> longer work correctly.

Can you explain the race? This notification is sent from sysfs/netlink
call path, both of which take rtnl.
