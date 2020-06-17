Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAF91FC5E4
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 07:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgFQF6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 01:58:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36274 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgFQF6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 01:58:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8873920482;
        Wed, 17 Jun 2020 07:58:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IJzO8qhUqr4L; Wed, 17 Jun 2020 07:58:31 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6832A20185;
        Wed, 17 Jun 2020 07:58:31 +0200 (CEST)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 17 Jun 2020 07:58:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 17 Jun
 2020 07:58:30 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 87F9C31800C0; Wed, 17 Jun 2020 07:58:30 +0200 (CEST)
Date:   Wed, 17 Jun 2020 07:58:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net v4 0/3] esp, ah: improve crypto algorithm selections
Message-ID: <20200617055830.GV19286@gauss3.secunet.de>
References: <20200610161437.4290-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200610161437.4290-1-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 09:14:34AM -0700, Eric Biggers wrote:
> This series consolidates and modernizes the lists of crypto algorithms
> that are selected by the IPsec kconfig options, and adds CRYPTO_SEQIV
> since it no longer gets selected automatically by other things.
> 
> See previous discussion at
> https://lkml.kernel.org/netdev/20200604192322.22142-1-ebiggers@kernel.org/T/#u
> 
> Changed v3 => v4:
>   - Don't say that AH is "NOT RECOMMENDED" by RFC 8221.
>   - Updated commit messages (added Acked-by tags, fixed a bad Fixes tag,
>     added some more explanation to patch 3).

Series applied to the ipsec tree, thanks a lot Eric!
