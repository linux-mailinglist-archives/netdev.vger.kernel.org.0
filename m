Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B277315F1A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 06:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBJFgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 00:36:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhBJFgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 00:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC02F64E42;
        Wed, 10 Feb 2021 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612935320;
        bh=8Mi5y1XOlSSQCO9GXAo8Oz2sqZlraSnWYiHajcVGWH4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mBG2b7POiXfE0sAvGXn6d/kvr3MupVpsSrHMA01ggetODnMw5+DrbmvDRLTeD940f
         DDNKA9tHW8ABADIeVgojIp/LUearOaxGOUNNE/eWbsfieKvkSgDixJxdsU4d/KJHWR
         oQ2xdhJ4/M2zTu8XYtu8K9mEVP8y/o1b+VbYy7PXPrA2QE9vry9SvKSXPnV6lXDRQL
         d648YsaCO8DP61nh/15rhdMMXDfWME1G3tZO76CKbpCxFDx1UHQop6u12GS73yAl9l
         pwvGmdzl1+0TwpHzMv+ieNWSTW85L1/SYMqjwGcJxcWUve3oRxyZ/yhYxV8Wo87r4b
         3SubHKy0XeQQw==
Message-ID: <aa015811327cb7f358287546be926afcddf8d17d.camel@kernel.org>
Subject: Re: [next] [s390 ] net: mlx5: tc_tun.h:24:29: error: field
 'match_level' has incomplete type
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, eli@mellanox.com,
        Paul Blakey <paulb@mellanox.com>, huyn@mellanox.com
Date:   Tue, 09 Feb 2021 21:35:18 -0800
In-Reply-To: <CA+G9fYsOHVObZyK0mFTLN452q43N3hkYp5Tmf7HQaB=1ZbVJxw@mail.gmail.com>
References: <CA+G9fYsOHVObZyK0mFTLN452q43N3hkYp5Tmf7HQaB=1ZbVJxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 10:50 +0530, Naresh Kamboju wrote:
> While building Linux next tag 20210209 s390 (defconfig) with gcc-9
> make modules failed.
> 
...

> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 

Thanks for the report a patch was already posted earlier today
https://patchwork.kernel.org/project/netdevbpf/patch/20210209203722.12387-1-saeed@kernel.org/
> 


