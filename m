Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B60FC216
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNJHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:07:40 -0500
Received: from ozlabs.org ([203.11.71.1]:48977 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfKNJHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 04:07:39 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 47DFxN5pWqz9sP6; Thu, 14 Nov 2019 20:07:36 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 93a1544ad4ec4bd9147992e57b4f834ceb2cc159
In-Reply-To: <20190612071901.21736-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>, <linux@armlinux.org.uk>,
        <fw@strlen.de>, <steffen.klassert@secunet.com>,
        <davem@davemloft.net>, <ralf@linux-mips.org>,
        <paul.burton@mips.com>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     linux-s390@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-sh@vger.kernel.org, netdev@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next] defconfigs: remove obsolete CONFIG_INET_XFRM_MODE_* and CONFIG_INET6_XFRM_MODE_*
Message-Id: <47DFxN5pWqz9sP6@ozlabs.org>
Date:   Thu, 14 Nov 2019 20:07:36 +1100 (AEDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-12 at 07:19:01 UTC, YueHaibing wrote:
> These Kconfig options has been removed in
> commit 4c145dce2601 ("xfrm: make xfrm modes builtin")
> So there is no point to keep it in defconfigs any longer.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/93a1544ad4ec4bd9147992e57b4f834ceb2cc159

cheers
