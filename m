Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7823FF33C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347001AbhIBS3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:29:36 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:54724 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346971AbhIBS3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:29:34 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 363AC72C8F8;
        Thu,  2 Sep 2021 21:28:33 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 274F87CF76A; Thu,  2 Sep 2021 21:28:33 +0300 (MSK)
Date:   Thu, 2 Sep 2021 21:28:33 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
Message-ID: <20210902182832.GB21258@altlinux.org>
References: <20210901153407.GA20446@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901153407.GA20446@asgard.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 05:34:07PM +0200, Eugene Syromiatnikov wrote:
> Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
> if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
> enum item.  Fix it by placing XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT
> to the end of the enum, right before __XFRM_MSG_MAX.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>


-- 
ldv
