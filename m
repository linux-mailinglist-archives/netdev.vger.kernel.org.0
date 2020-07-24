Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C30222BD72
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgGXF0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:26:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56246 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXF0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 01:26:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E14212052E;
        Fri, 24 Jul 2020 07:26:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cD4lS2IjMipk; Fri, 24 Jul 2020 07:26:19 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 329AA201A0;
        Fri, 24 Jul 2020 07:26:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 07:26:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 24 Jul
 2020 07:26:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7147331805D5; Fri, 24 Jul 2020 07:26:18 +0200 (CEST)
Date:   Fri, 24 Jul 2020 07:26:18 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Mark Salyzyn <salyzyn@android.com>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@android.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2] af_key: pfkey_dump needs parameter validation
Message-ID: <20200724052618.GS20687@gauss3.secunet.de>
References: <20200722110059.1264115-1-salyzyn@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200722110059.1264115-1-salyzyn@android.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 04:00:53AM -0700, Mark Salyzyn wrote:
> In pfkey_dump() dplen and splen can both be specified to access the
> xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
> when it calls addr_match() with the indexes.  Return EINVAL if either
> are out of range.
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Applied, thanks a lot!
