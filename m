Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F0536582C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDTL52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:57:28 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:46664 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhDTL51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:57:27 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0A72180004A;
        Tue, 20 Apr 2021 13:56:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 13:56:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Apr
 2021 13:56:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3F02531803A8; Tue, 20 Apr 2021 13:56:54 +0200 (CEST)
Date:   Tue, 20 Apr 2021 13:56:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next 0/3] xfrm: minor cleanup and synchronize_rcu
 removal
Message-ID: <20210420115654.GE62598@gauss3.secunet.de>
References: <20210414161253.27586-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210414161253.27586-1-fw@strlen.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 06:12:50PM +0200, Florian Westphal wrote:
> First patch gets rid of SPI key from flowi struct.
> xfrm_policy populates this but there are no consumers.
> 
> This is part of a different patch (not part of this) to replace
> xfrm_decode_session internals with the flow dissector.
> 
> Second patch removes a synchronize_rcu/initialisation in the init path.
> Third patch avoids a synchronize_rcu during netns destruction.
> 
> Florian Westphal (3):
>   flow: remove spi key from flowi struct
>   xfrm: remove stray synchronize_rcu from xfrm_init
>   xfrm: avoid synchronize_rcu during netns destruction

Applied, thanks a lot Florian!
