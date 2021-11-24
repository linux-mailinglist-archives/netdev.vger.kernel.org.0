Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6975F45C1C8
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 14:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346097AbhKXNVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 08:21:46 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49473 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347696AbhKXNTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 08:19:45 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 53FC75C0095;
        Wed, 24 Nov 2021 08:16:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 24 Nov 2021 08:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WSyhMN
        v7DKJJ0zodmmUWhnighX/DRJgOPXAnXZvn+rY=; b=ZDBhN9RUlwRj6OztRe+Hqi
        1QKUQb6blE/WwcHxYiAvvAruw0GGVaK08jBa7kMOFbESP5kUV8zO57KSHJhs/hi+
        ZjGqYL+HNvJuPMR9S+XPKZt2YPgNQyqVgpQMEBDgIqm+GfmtnAyKml8z/z6XT/WQ
        o1L7v+cxtB3vOEuCrOQpsCJ27Qk/0kxeRCD9ZzXewK9+KUhwdtaI6/1IfXIn2gdi
        1kCyRqHRgxOy90/KmEhfS6JBII6+ImXi2y+m/bgBe5opjezBs13WRsJDOWYgUjXt
        t6VxPyVs4zxRtvWOZiN4GvT+sivPMN5F/NjJcToZlEtQ/DH/wpmmKBIBVsqz1aGw
        ==
X-ME-Sender: <xms:MTueYY2Mb-pt-XLkQPN3krveb4_C1Dpy_82M5HszLVPYfrUSnowtbg>
    <xme:MTueYTGitymnrLpXEMiFhKK36V6UvdS_2JTsOBJavboyDg1tpddtZMM0eF79tu6em
    zlGi6L-xgC98AA>
X-ME-Received: <xmr:MTueYQ5tdLmIz2TlFnGzgQ1RZMbXWaPom538C0kyeu20XY8uTESYtphrgcpBXn3aiT3WLSRm43f7-OSZU1zXQQr5hfE0og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeekgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MTueYR1vWIJasPxj3WAcV6ktjlWJaK6tNWse6c78l63SUFauwMAfMg>
    <xmx:MTueYbEhe8QzHMyVMYM8TsOXlaKjEPQMKm19EPD_C_n5UZO1epVXaA>
    <xmx:MTueYa_6xFY6tizq54zzeHEGhpqDK1m7WdST4gKeZIN98VduJtcRTw>
    <xmx:MjueYQ4vvaCvZw8Z7AfCPCjSyoBz9V0DA7dCnKB9fPW9p-0cz09_5Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Nov 2021 08:16:33 -0500 (EST)
Date:   Wed, 24 Nov 2021 15:16:29 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "bernard@vivo.com" <bernard@vivo.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
Message-ID: <YZ47LRq5hGw3CSCx@shredder>
References: <20211124101122.3321496-1-idosch@idosch.org>
 <03c0d0b106954d24aba1f7417a41349f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03c0d0b106954d24aba1f7417a41349f@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 12:55:33PM +0000, David Laight wrote:
> From: Ido Schimmel
> > Sent: 24 November 2021 10:11
> >
> > Cited commit converted simple_strtoul() to kstrtoul() as suggested by
> > the former's documentation. However, it also forced all the inputs to be
> > decimal resulting in user space breakage.
> > 
> > Fix by setting the base to '0' so that the base is automatically
> > detected.
> 
> Do both functions ignore leading whitespace?

With this patch (kstrtoul):

# ip link add name br0 type bridge vlan_filtering 1
# echo "    0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
bash: echo: write error: Invalid argument

With simple_strtoul:

# ip link add name br0 type bridge vlan_filtering 1
# echo "    0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
bash: echo: write error: Invalid argument
