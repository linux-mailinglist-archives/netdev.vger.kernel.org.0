Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D62C085
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 09:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfE1HpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 03:45:17 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:40850 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbfE1HpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 03:45:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4002820083;
        Tue, 28 May 2019 09:45:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2OwcLXemXGHM; Tue, 28 May 2019 09:45:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0C70A200BA;
        Tue, 28 May 2019 09:45:13 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 28 May 2019
 09:45:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 87F6C31804FB;
 Tue, 28 May 2019 09:45:12 +0200 (CEST)
Date:   Tue, 28 May 2019 09:45:12 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jeremy Sowden <jeremy@azazel.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2] af_key: fix leaks in key_pol_get_resp and dump_sp.
Message-ID: <20190528074512.GE14601@gauss3.secunet.de>
References: <20190525180204.6936-1-jeremy@azazel.net>
 <20190525180935.7919-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190525180935.7919-1-jeremy@azazel.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 07:09:35PM +0100, Jeremy Sowden wrote:
> In both functions, if pfkey_xfrm_policy2msg failed we leaked the newly
> allocated sk_buff.  Free it on error.
> 
> Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
> Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Applied, thanks Jeremy!
