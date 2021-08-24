Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56263F58EE
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhHXHZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:25:16 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37557 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234734AbhHXHZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:25:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3877E580582;
        Tue, 24 Aug 2021 03:24:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 24 Aug 2021 03:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=23+OLJ
        AyGOsAQ21B6Kc7ZzhH18/xeF38azdp237++QU=; b=r6iyg76fNVgj+2ix/dlYI5
        dxqn1I0PFMnMWk09SljcaWCRtBrt4l7YNE3+IaDhwKYaZbkpIVMf5yM41W6+DhQO
        QVRC6Qc/T7EfWzMXZks0J00wUf+ZE9hZx+ytejmWinKE6/1qYMzkSff4IvjiGom/
        YncRhB/H5zQwhBh0j1iOqeByRdbM6A8GfTEpSGMoN2+HnyOlVt2RdvAYS9cs+GAp
        pG+37kyZfBt2eDZGi8p8Fgp6SzG3+yQV5/zp8Ye+NdAKvsxhsqD+s9D+YSGj31fZ
        FbCnywLDGGyl4gwS35gxwmyt986Gm0wqnyqijQ/hZ0sPP9Ru4RGKP7cX0edu6RnQ
        ==
X-ME-Sender: <xms:oZ4kYUargjpQUJ7haGOagqb01eAYbCGxzyrqvpNNv412Ne06sgqZqw>
    <xme:oZ4kYfbsATAX6W5PTqwY_ma7XOMdIfggJQO9Cc7cVRKj44IOFFDnMYni98VGv6Q9e
    kgTzJ_WYgDRP9U>
X-ME-Received: <xmr:oZ4kYe9A3-mm1qOFO7VHcWEFnGwAxSRHH0m2qhcxTSmxEDNrvjGJI0RlXmk5YhSs49jH4lG6MqO3G3w5gDAIIYypnFd8hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtiedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:oZ4kYerLnIvIx1HAoYpsKSocLUA1IH70cNWNL9KEoob9qUn-0r23pQ>
    <xmx:oZ4kYfrS8nTsBR0KysYpR4GPNOulos9Mn888yDX5foeVYnN47vAAdQ>
    <xmx:oZ4kYcQMT8BeoPNLJptgpMrlciN6QBPFrrJx-L9NL1bj5zgadQ0txg>
    <xmx:op4kYY7W1x5m5JwIA8ZsqDnYVG-aOtbc2GeFKu06Xu2lMsiVw85aAA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 03:24:16 -0400 (EDT)
Date:   Tue, 24 Aug 2021 10:24:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org, petrm@nvidia.co,
        oleksandr.mazur@plvision.eu, idosch@nvidia.com, jiri@nvidia.com,
        nikolay@nvidia.com, gnault@redhat.com, simon.horman@netronome.com,
        baowen.zheng@corigine.com, danieller@nvidia.com
Subject: Re: [PATCH] selftests/net: Use kselftest skip code for skipped tests
Message-ID: <YSSemxg1JQRdqxsP@shredder>
References: <20210823085854.40216-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823085854.40216-1-po-hsu.lin@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 04:58:54PM +0800, Po-Hsu Lin wrote:
> There are several test cases in the net directory are still using
> exit 0 or exit 1 when they need to be skipped. Use kselftest
> framework skip code instead so it can help us to distinguish the
> return status.
> 
> Criterion to filter out what should be fixed in net directory:
>   grep -r "exit [01]" -B1 | grep -i skip
> 
> This change might cause some false-positives if people are running
> these test scripts directly and only checking their return codes,
> which will change from 0 to 4. However I think the impact should be
> small as most of our scripts here are already using this skip code.
> And there will be no such issue if running them with the kselftest
> framework.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
