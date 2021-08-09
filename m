Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19BC3E487A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhHIPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:16:52 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:53429 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233058AbhHIPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 11:16:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0BD8E580E2C;
        Mon,  9 Aug 2021 11:16:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Aug 2021 11:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1pYqGa
        x3qSXnNTucika/IABBjCeQ22ESG6fuRy15h2s=; b=S0HfUGCCFMNYaWu6zatInR
        6cI4qb55LV3zeq/ewdvnVH056olR0BWLNBPwfe7UJwTpogsD3fD2/cQL/wEAp3cl
        nxKthDD4fyRdv+2IV6Qoo7dhdBFzgeh2gqTKAso7T1Evb9SnOsFh2B4zYhOUprJP
        EO5VljpUmoAzyggHCkHjUDOSMr5LbQw2X+cN5RdswfF6B30UnI03EJSQI+SwijQ/
        0x2Iryu5RFRJmkRZnyY1vFtTJg0yVcmKoPeCwCPPe+pHtKqp6dDUMdTjCaqRnZWY
        FW/KwPpuZZm17f/6Rg3yrjlX9ksK1UhH8mdDL05f+6cvCMZOoEtuLDu5lYq9d2gw
        ==
X-ME-Sender: <xms:zEYRYbQGIB9xEo6RjeSyH3E8NY09nJwCspeVGW5W-yMjMHQNMgDsSA>
    <xme:zEYRYcyujpQS1ixEjvubTlM3VtCQcUugk9praYbP03PyyYdFPe_jkz2UKaT4fre7x
    Pc-hTDz3fOUwQY>
X-ME-Received: <xmr:zEYRYQ0NPHWoCFj6XeaojIAkTME5G5A7eJHf_TENk2L322TP61EGCMHTJrfWShVJbxspvI5I1k7GnMJfPT1yRqc_qAqD2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfejvefhvdegiedukeetudevgeeujeefffeffeetkeekueeuheejudeltdejuedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zEYRYbCoKnFM3-wbngpBiRANyAE74_M6BRFtxmZn0MeoSG0Seer_6w>
    <xmx:zEYRYUi3O-H3V-73BR0dBJ5TWNLcDT8xw6fD72Fr6bfl100ClsZkHQ>
    <xmx:zEYRYfpVXnT9M1cEBDkJR9UmWcWow8uAEW-0lVAaA4aelNcO50dZfQ>
    <xmx:zkYRYZtwN-jWS7CS3-M_vUcqkyT-ZsNniU37JzRiF6CtsFtdEXqIaQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 11:16:27 -0400 (EDT)
Date:   Mon, 9 Aug 2021 18:16:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Message-ID: <YRFGxxkNyJDxoGWu@shredder>
References: <20210809131152.509092-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809131152.509092-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:11:52PM +0300, Vladimir Oltean wrote:
> The blamed commit a new field to struct switchdev_notifier_fdb_info, but
> did not make sure that all call paths set it to something valid. For
> example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
> notifier, and since the 'is_local' flag is not set, it contains junk
> from the stack, so the bridge might interpret those notifications as
> being for local FDB entries when that was not intended.
> 
> To avoid that now and in the future, zero-initialize all
> switchdev_notifier_fdb_info structures created by drivers such that all
> newly added fields to not need to touch drivers again.
> 
> Fixes: 2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB notifications")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
