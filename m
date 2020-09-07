Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFD925F9C3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgIGLoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:44:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38180 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbgIGLYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 07:24:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 01FBD2019C;
        Mon,  7 Sep 2020 13:24:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CLT690AUOpRN; Mon,  7 Sep 2020 13:24:12 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8AE202008D;
        Mon,  7 Sep 2020 13:24:12 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Sep 2020 13:24:12 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Sep 2020
 13:24:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E2400318450A; Mon,  7 Sep 2020 13:24:11 +0200 (CEST)
Date:   Mon, 7 Sep 2020 13:24:11 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Safonov <dima@arista.com>
CC:     <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] xfrm/compat: Add 64=>32-bit messages translator
Message-ID: <20200907112411.GK20687@gauss3.secunet.de>
References: <20200826014949.644441-1-dima@arista.com>
 <20200826014949.644441-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200826014949.644441-2-dima@arista.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 02:49:44AM +0100, Dmitry Safonov wrote:
> XFRM is disabled for compatible users because of the UABI difference.
> The difference is in structures paddings and in the result the size
> of netlink messages differ.
> 
> Possibility for compatible application to manage xfrm tunnels was
> disabled by: the commmit 19d7df69fdb2 ("xfrm: Refuse to insert 32 bit
> userspace socket policies on 64 bit systems") and the commit 74005991b78a
> ("xfrm: Do not parse 32bits compiled xfrm netlink msg on 64bits host").
> 
> This is my second attempt to resolve the xfrm/compat problem by adding
> the 64=>32 and 32=>64 bit translators those non-visibly to a user
> provide translation between compatible user and kernel.
> Previous attempt was to interrupt the message ABI according to a syscall
> by xfrm_user, which resulted in over-complicated code [1].
> 
> Florian Westphal provided the idea of translator and some draft patches
> in the discussion. In these patches, his idea is reused and some of his
> initial code is also present.

One comment on this. Looks like the above is the same in all
commit messages. Please provide that generic information
with the patch 0/n and remove it from the other patches.


