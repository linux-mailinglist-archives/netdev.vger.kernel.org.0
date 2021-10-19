Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28482432DEA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhJSGNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:13:51 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:45511 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234146AbhJSGNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:13:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C1C163200E60;
        Tue, 19 Oct 2021 02:11:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 19 Oct 2021 02:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HoZ6at
        z2Oa/aQfhWSNg2q5J/x7wU9ypaF0/CVPTUtZ4=; b=bicBBDvJs4cZTUfrXYTwvt
        2bB8qSnmCweew2fjU+43X8hHVexGGYIAqKk1wS+f5q7yAm649cXebFA8mbJMvou2
        lqL5drkFUofwc5nUl/1WmLX5B5JsmPYJNKQnpqYTLTEhqMiI1ffalfml0qvO8E36
        CK3fqy//QvTByqoIceWUYOARKHdYLQQ/K4vyOeAFF10ZorPj+DX+qkBxXBTVJR2m
        bkO5HPheA6VKyewlC9wo1nOHcaO0nx9O5PH5yoEgwiDpKRIEhbkTjGbswbR1EAfe
        Ie9KUXobo5x4Qh8TLq735CTNxueKHRHK7r23HrIRa5UWu5zxLFRft8Lnpcyw2ajA
        ==
X-ME-Sender: <xms:mWFuYV5pA0vi8Ut-qEQl9tL9oVFV85rBKKfUU1sceCVD-4oogkQAeQ>
    <xme:mWFuYS5tvO9eptmxfBMQ4EmzhmfNTbHi59_jrSvqWSegl1fx8z7ZCSIaHMBgtkTxI
    88xQehoaUiVmw4>
X-ME-Received: <xmr:mWFuYccoGt_Guw0viS4tjMt8n-wUWVW4KW82HmdUPMxKFR6WTFBMB2VT47rqi7iibClqySchTqbXHLudwUkAk6RK9-s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mWFuYeKSHe3LWtBcKJZYoOylrUunHY-tWDKiAr_MZr5pOJ-Hkj17iA>
    <xmx:mWFuYZJaKih_prwx9BtgoJGdC4-e3HGZihzPSCkdXAnzfkMtpBP57g>
    <xmx:mWFuYXxY5sKDYgDZhBKBjSTrk05VpjLwABgtfP2vn3RQvFwJ05SCiQ>
    <xmx:mWFuYWHtrUDxHxwq7H9432_-ednDMnpxO4j_RqNMUQSCXvAI3KhKOg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 02:11:34 -0400 (EDT)
Date:   Tue, 19 Oct 2021 09:11:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, olteanv@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com, snelson@pensando.io
Subject: Re: [PATCH net-next 1/6] ethernet: add a helper for assigning port
 addresses
Message-ID: <YW5hkKVPiV20Ky+7@shredder>
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018211007.1185777-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:10:02PM -0700, Jakub Kicinski wrote:
> We have 5 drivers which offset base MAC addr by port id.
> Create a helper for them.
> 
> This helper takes care of overflows, which some drivers
> did not do, please complain if that's going to break
> anything!
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

> --
>  - eth_hw_addr_set_port() -> eth_hw_addr_gen()
>  - id u8 -> unsigned int

Thanks!
