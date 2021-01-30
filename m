Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E715A30964E
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhA3PlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:41:00 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56555 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232160AbhA3PiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 10:38:02 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B68961290;
        Sat, 30 Jan 2021 10:36:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 30 Jan 2021 10:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aZ8MU9
        Dz8Im+VeJzpTopYS+G2PObraHK3x03ZH0V+Vc=; b=or45A2hElzMlTmEdiH19Nw
        9A587SgpDeOErFC4Q/Nr5bQ2ScFSVD8APJd+n+q1pS+haQoxHfTcdKXkuAWmd+L+
        fHFxTNYgrAUv9T+zH4E6XQ1EmOYupTFIoBvXB+WxgIds+T3lxEnHYE+Yd3G3s/GV
        FTjR/zWVwJXmNY/D2DzWVp/fqAb80hnOhwqC9jgcJp+WGzJL+M6pUlc5yDS118rR
        NhEwDG1cLhFv+nbAyL9b7sIh0yNiemJgrsSKrZZC4V13kKYunVl8x9ghGGiKsXhh
        cL95l59dElMBqQ080uVh4sgYZtPPhGDA/ml+xuWqTfqjPJwewzxNNDaIxAFhFxRg
        ==
X-ME-Sender: <xms:F30VYJ5J4UIqswjQ35A30nV0Zd0ql2N3RbLlPbLhhFvKoCi0tZU2gA>
    <xme:F30VYBdaojF7FoQ7vbMWRk87pEM-a3P-ts4GQFV3ym4S8vouMuI9UWoh0Ib0HJ-lk
    e0jiuukokzbBKM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:F30VYNATZddvBj9ziGJZq1I7EuyHOPk4vxCpwC1Qpi9QMREvcjnQRg>
    <xmx:F30VYE-F19ZVI8N24f22sgRlaG0PSHmyp3h4lxza91tZRdZZKoUCwQ>
    <xmx:F30VYIIK89DJVLxQknN5vNjLhOE7dw-Rnu4DAi5batKVMx0xc69OQg>
    <xmx:F30VYPjCTbMpr-Qz_YuNvDQ5yiGTYxbbM3b1gv2pfduMnhvZrGAiJg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9878F1080066;
        Sat, 30 Jan 2021 10:36:54 -0500 (EST)
Date:   Sat, 30 Jan 2021 17:36:51 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, amcohen@nvidia.com, roopa@nvidia.com,
        sharpd@nvidia.com, bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Message-ID: <20210130153651.GC3330615@shredder.lan>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
 <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
 <20210128201545.07e95057@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128201545.07e95057@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 08:15:45PM -0800, Jakub Kicinski wrote:
> My impression from working on this problem in TC is that the definition
> of "all" becomes problematic especially if one takes into account
> drivers getting reloaded. But I think routing offload has stronger
> semantics than TC, so no objections.

During the teardown phase of the reload, all the routes using the
driver's netdevs (or their uppers) will be deleted by the kernel because
the netdevs will disappear. During the init phase of the reload, the
driver will re-register its FIB notifier and ask for a dump of all the
existing routes (usually only host routes). With this patchset, user
space will receive a notification that these routes are now in hardware.

# ip monitor route
broadcast 127.255.255.255 dev lo table local proto kernel scope link src 127.0.0.1 
local 127.0.0.1 dev lo table local proto kernel scope host src 127.0.0.1 
local 127.0.0.0/8 dev lo table local proto kernel scope host src 127.0.0.1 
broadcast 127.0.0.0 dev lo table local proto kernel scope link src 127.0.0.1 
broadcast 10.209.1.255 dev eth0 table local proto kernel scope link src 10.209.0.191 
local 10.209.0.191 dev eth0 table local proto kernel scope host src 10.209.0.191 
broadcast 10.209.0.0 dev eth0 table local proto kernel scope link src 10.209.0.191 
10.209.0.1 dev eth0 proto dhcp scope link src 10.209.0.191 metric 1024 
10.209.0.0/23 dev eth0 proto kernel scope link src 10.209.0.191 
default via 10.209.0.1 dev eth0 proto dhcp src 10.209.0.191 metric 1024 
<< init phase starts here >>
default via 10.209.0.1 dev eth0 proto dhcp src 10.209.0.191 metric 1024 rt_trap 
10.209.0.0/23 dev eth0 proto kernel scope link src 10.209.0.191 rt_trap 
10.209.0.1 dev eth0 proto dhcp scope link src 10.209.0.191 metric 1024 rt_trap 
broadcast 10.209.0.0 dev eth0 table local proto kernel scope link src 10.209.0.191 rt_trap 
local 10.209.0.191 dev eth0 table local proto kernel scope host src 10.209.0.191 rt_trap 
broadcast 10.209.1.255 dev eth0 table local proto kernel scope link src 10.209.0.191 rt_trap 
broadcast 127.0.0.0 dev lo table local proto kernel scope link src 127.0.0.1 rt_trap 
local 127.0.0.0/8 dev lo table local proto kernel scope host src 127.0.0.1 rt_trap 
local 127.0.0.1 dev lo table local proto kernel scope host src 127.0.0.1 rt_trap 
broadcast 127.255.255.255 dev lo table local proto kernel scope link src 127.0.0.1 rt_trap 
