Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9842467E5
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgHQOBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:01:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53424 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbgHQOBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:01:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DD056205A9;
        Mon, 17 Aug 2020 16:01:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IX9izu4UJceC; Mon, 17 Aug 2020 16:01:33 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6BC5C200AA;
        Mon, 17 Aug 2020 16:01:33 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 17 Aug 2020 16:01:33 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 17 Aug
 2020 16:01:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B829231845EC;
 Mon, 17 Aug 2020 16:01:32 +0200 (CEST)
Date:   Mon, 17 Aug 2020 16:01:32 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Xiumei Mu <xmu@redhat.com>
Subject: Re: [PATCH ipsec] espintcp: restore IP CB before handing the packet
 to xfrm
Message-ID: <20200817140132.GQ13121@gauss3.secunet.de>
References: <b3c2d120af02d34c0ab6e67b897be502c5106dca.1597328612.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b3c2d120af02d34c0ab6e67b897be502c5106dca.1597328612.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 04:24:04PM +0200, Sabrina Dubroca wrote:
> Xiumei reported a bug with espintcp over IPv6 in transport mode,
> because xfrm6_transport_finish expects to find IP6CB data (struct
> inet6_skb_cb). Currently, espintcp zeroes the CB, but the relevant
> part is actually preserved by previous layers (first set up by tcp,
> then strparser only zeroes a small part of tcp_skb_tb), so we can just
> relocate it to the start of skb->cb.
> 
> Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks Sabrina!
