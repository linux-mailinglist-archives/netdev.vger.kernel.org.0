Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620EE44076F
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ3EaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJ3EaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D94F60F0F;
        Sat, 30 Oct 2021 04:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635568051;
        bh=mctwEpWBT3hUOu+z3oxGQh40Sxraz8nJUL+eAEKiiAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mF836OxH2JYklfqm9/UucYRi9HhprZlMvFa3CnCXLejK7FIwLmzX6mYA6s7xJrcV6
         9Osyvj5QrqPpnurNccXJ8qkd0zGCC30ELby714lAbiIcf4JO6pkCIgl2r/hPFViAm0
         f3Ah9vUERLhk6DbzilUMnlxOUMSYlprhjRYSSLgmldQ0U7OGFbVybFmi2zzKI8/CPk
         W9skx1/syje2IKhWUlc2DcQlgaZVq+oniJuSZWo90tdcWYstUxopXmYJiX1V7EU0f7
         CBUoHD15f5kjyaFTbsOFa4ggeSZTiOBaU42H4peQI5tMma+5WRIa4Gqg2osYekp4Yc
         dQOSyTxk4TTzQ==
Date:   Fri, 29 Oct 2021 21:27:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
Message-ID: <20211029212730.4742445b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211029200742.19605-4-gerhard@engleder-embedded.com>
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
        <20211029200742.19605-4-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 22:07:42 +0200 Gerhard Engleder wrote:
> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
> 
> It is integrated as Ethernet controller with ethtool and PTP support.
> For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Looks like there is a lot of sparse warnings about endian.
Please make sure it builds cleanly with W=1 C=1 and repost.
