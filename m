Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E003D2116
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhGVJBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:01:35 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:50032 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhGVJBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 05:01:34 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 0777380005B;
        Thu, 22 Jul 2021 11:42:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 11:42:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 22 Jul
 2021 11:42:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 62FE53180B27; Thu, 22 Jul 2021 11:42:08 +0200 (CEST)
Date:   Thu, 22 Jul 2021 11:42:08 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <minyard@acm.org>
CC:     <netdev@vger.kernel.org>, Corey Minyard <cminyard@mvista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ipsec: Remove unneeded extra variable in esp4
 esp_ssg_unref()
Message-ID: <20210722094208.GB893739@gauss3.secunet.de>
References: <20210716202846.257656-1-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210716202846.257656-1-minyard@acm.org>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 03:28:46PM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> It's assigned twice, but only used to calculate the size of the
> structure it points to.  Just remove it and take a sizeof the
> actual structure.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

Applied to ipsec-next, thanks!
