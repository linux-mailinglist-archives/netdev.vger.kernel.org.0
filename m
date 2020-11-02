Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859A72A2604
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 09:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgKBIVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 03:21:30 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:58298 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbgKBIVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 03:21:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4646F204FD;
        Mon,  2 Nov 2020 09:21:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xf-tTB2zwMVo; Mon,  2 Nov 2020 09:21:24 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B6ADA2026E;
        Mon,  2 Nov 2020 09:21:24 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 09:21:24 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 2 Nov 2020
 09:21:24 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A365531844C7; Mon,  2 Nov 2020 09:21:23 +0100 (CET)
Date:   Mon, 2 Nov 2020 09:21:23 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Safonov <dima@arista.com>
CC:     <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hillf Danton <hdanton@sina.com>, <netdev@vger.kernel.org>,
        <syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com>,
        <syzbot+c43831072e7df506a646@syzkaller.appspotmail.com>
Subject: Re: [PATCH 0/3] xfrm/compat: syzbot-found fixes
Message-ID: <20201102082123.GC8805@gauss3.secunet.de>
References: <20201030022600.724932-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201030022600.724932-1-dima@arista.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 02:25:57AM +0000, Dmitry Safonov wrote:
> WARN_ON() for XFRMA_UNSPEC translation which likely no-one except
> syzkaller uses; properly zerofy tail-padding for 64-bit attribute;
> don't use __GFP_ZERO as the memory is initialized during translation.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: netdev@vger.kernel.org
> 
> Thanks,
>          Dmitry
> 
> Dmitry Safonov (3):
>   xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
>   xfrm/compat: memset(0) 64-bit padding at right place
>   xfrm/compat: Don't allocate memory with __GFP_ZERO

Can you please add 'Fixes' tags to all the patches.

Thanks!
