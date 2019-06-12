Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18D2422BB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438020AbfFLKkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:40:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34162 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437023AbfFLKkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 06:40:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 677EA201F9;
        Wed, 12 Jun 2019 12:40:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4DVGwrK9l0Gk; Wed, 12 Jun 2019 12:40:08 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 04ED7201CC;
        Wed, 12 Jun 2019 12:40:08 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Jun 2019
 12:40:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 934C731803AC;
 Wed, 12 Jun 2019 12:40:07 +0200 (CEST)
Date:   Wed, 12 Jun 2019 12:40:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Colin King <colin.king@canonical.com>
CC:     Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] xfrm: fix missing break on AF_INET6 case
Message-ID: <20190612104007.GK17989@gauss3.secunet.de>
References: <20190612103624.27246-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190612103624.27246-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:36:24AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It appears that there is a missing break statement for the AF_INET6 case
> that falls through to the default WARN_ONCE case. I don't think that is
> intentional. Fix this by adding in the missing break.
> 
> Addresses-Coverity: ("Missing break in switch")
> Fixes: 4c203b0454b5 ("xfrm: remove eth_proto value from xfrm_state_afinfo")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

I have already a patch from Florian in queue to fix this.

Thanks anyway!
