Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9196515BC32
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgBMJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:55:42 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37136 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgBMJzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:55:41 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9DAA6200A7;
        Thu, 13 Feb 2020 10:55:39 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sN-_csWmh8oB; Thu, 13 Feb 2020 10:55:39 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 41CDF20082;
        Thu, 13 Feb 2020 10:55:39 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 10:55:38 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D612731805ED;
 Thu, 13 Feb 2020 10:55:38 +0100 (CET)
Date:   Thu, 13 Feb 2020 10:55:38 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Trent Jaeger <tjaeger@cse.psu.edu>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] xfrm: fix uctx len check in verify_sec_ctx_len
Message-ID: <20200213095538.GF3469@gauss3.secunet.de>
References: <afee25abdf818c7a7374773a6f347cf5c719038e.1581254129.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <afee25abdf818c7a7374773a6f347cf5c719038e.1581254129.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 09, 2020 at 09:15:29PM +0800, Xin Long wrote:
> It's not sufficient to do 'uctx->len != (sizeof(struct xfrm_user_sec_ctx) +
> uctx->ctx_len)' check only, as uctx->len may be greater than nla_len(rt),
> in which case it will cause slab-out-of-bounds when accessing uctx->ctx_str
> later.
> 
> This patch is to fix it by return -EINVAL when uctx->len > nla_len(rt).
> 
> Fixes: df71837d5024 ("[LSM-IPSec]: Security association restriction.")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
