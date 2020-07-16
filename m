Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43405221CA5
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgGPGds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:33:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39252 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgGPGds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 02:33:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BB275200A7;
        Thu, 16 Jul 2020 08:33:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XQqA6EdDHMjd; Thu, 16 Jul 2020 08:33:46 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 58F5220536;
        Thu, 16 Jul 2020 08:33:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 16 Jul 2020 08:33:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 16 Jul
 2020 08:33:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A01DD3180222; Thu, 16 Jul 2020 08:33:45 +0200 (CEST)
Date:   Thu, 16 Jul 2020 08:33:45 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     syzbot <syzbot+ea9832f8ae588deb0205@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, kuznet <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        yoshfuji <yoshfuji@linux-ipv6.org>
Subject: Re: KASAN: slab-out-of-bounds Read in __xfrm6_tunnel_spi_lookup
Message-ID: <20200716063345.GX20687@gauss3.secunet.de>
References: <0000000000003011fb05aa59df1e@google.com>
 <20200714093718.GQ20687@gauss3.secunet.de>
 <CADvbK_c3AGXDUr5_h5-JzcMowUJ4SZ5euyneAebssHjaKVx50A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADvbK_c3AGXDUr5_h5-JzcMowUJ4SZ5euyneAebssHjaKVx50A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 05:18:36PM +0800, Xin Long wrote:
> Hi, Steffen,
> 
> I've confirmed the patchset I posted yesterday would fix this:
> 
> [PATCH ipsec-next 0/3] xfrm: not register one xfrm(6)_tunnel object twice

Thanks for the confirmation! That patchset is now applied
to ipsec-next.
