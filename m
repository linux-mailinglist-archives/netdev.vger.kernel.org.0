Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6A399C55
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCITP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:19:15 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:60370 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFCITP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:19:15 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0C594800057;
        Thu,  3 Jun 2021 10:17:30 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 10:17:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 10:17:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 62F9431801F6; Thu,  3 Jun 2021 10:17:29 +0200 (CEST)
Date:   Thu, 3 Jun 2021 10:17:29 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] xfrm: Remove the repeated declaration
Message-ID: <20210603081729.GX40979@gauss3.secunet.de>
References: <1622274722-9945-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1622274722-9945-1-git-send-email-zhangshaokun@hisilicon.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 29, 2021 at 03:52:02PM +0800, Shaokun Zhang wrote:
> Function 'xfrm_parse_spi' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net> 
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Applied, thanks!
