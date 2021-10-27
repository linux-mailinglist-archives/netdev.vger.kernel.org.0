Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0170643C46B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbhJ0H4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:56:42 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42755 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239074AbhJ0H4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:56:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 14B255803DF;
        Wed, 27 Oct 2021 03:54:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Oct 2021 03:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+B4yri
        aR2DbbL2Gg5nDQDVPp+o+z4xOZKJ1vAQ99MHA=; b=FfaZjuDYlneHbi3Gvt7klr
        4ymRCQyHeQwA9Sk808mlGadPtm1s/PEoiFivLRE3ZkCyoFDV6w5KdVfSq8oKfQHz
        Lo51RxFPEPkuGK8QoNqR9TWGPS3Jif/zwcY3B5sRJzVuCiWFOiiewdR7qiHeBKLs
        WHshN9dvae076LQWED9iomyasvYkYww+Jwr54LSajSlYbxoYl8X86Y9894MHQrei
        8RvWlc+z053euEjGarhtDwNy9JuCniibG8ZCgoxVqXyXmWtWWc/bYNSdK588jfzK
        O8PPmzW8u08KKEKXqfoE9TEomU99l4SugmJtCKWewF5UjT+FbElm4fhQwheefN3w
        ==
X-ME-Sender: <xms:pwV5YXwHQZwuyPwFBWcJmMHTxb5Yhmxaup-W02OZQxEvEHJ7DD2Lpw>
    <xme:pwV5YfSzr6qrNwTFtB5mQX8qaUubGiou1WKX4Zp8d4knSdAq1lmG1CA5eDGr10PfY
    M3LdC4ma2aJd-I>
X-ME-Received: <xmr:pwV5YRUvzfweSPNjhkPNBhRE5bZtG6wC7RK788tprYSHRTcKbNBOXwGuFg2anSQqoof3YISR7lJizHoYA9JdYMNQCXAu2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pwV5YRhW6d3ufpnhrD7tA-O8lKhZOLjvc6IVU38FtBk9ELZJ_rS8fA>
    <xmx:pwV5YZD8FoqxG-xGmcNpNnvWk2p-NnzioIkQtWTA3tXfBGVed21mhA>
    <xmx:pwV5YaKFWajmMu8SUgnDBRi8t1nR_x-oAQdnM5YeU5Z0l4_A8p8MKQ>
    <xmx:qAV5Ydss4EqTe_zswPksJgosedCVKVZ4Ol_Qwnvfw9CrYEOo01V23g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:54:15 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:54:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 4/8] net: bridge: rename br_fdb_insert to
 br_fdb_add_local
Message-ID: <YXkFoyPUM0Zx3VD2@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-5-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:39PM +0300, Vladimir Oltean wrote:
> br_fdb_insert() is a wrapper over fdb_insert() that also takes the
> bridge hash_lock.
> 
> With fdb_insert() being renamed to fdb_add_local(), rename
> br_fdb_insert() to br_fdb_add_local().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
