Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3582EB739
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbhAFA6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:58:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57858 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbhAFA6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:58:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D5A794CBCE1FD;
        Tue,  5 Jan 2021 16:57:32 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:57:32 -0800 (PST)
Message-Id: <20210105.165732.1163341792000656368.davem@davemloft.net>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, pantelis.antoniou@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, andrew@lunn.ch
Subject: Re: [PATCH v2] net: ethernet: fs_enet: Add missing MODULE_LICENSE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105091515.87509-1-mpe@ellerman.id.au>
References: <20210105091515.87509-1-mpe@ellerman.id.au>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:57:33 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>
Date: Tue,  5 Jan 2021 20:15:15 +1100

> Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
> into error") the ppc32_allmodconfig build fails with:
> 
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o
> 
> Add the missing MODULE_LICENSEs to fix the build. Both files include a
> copyright header indicating they are GPL v2.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied.
