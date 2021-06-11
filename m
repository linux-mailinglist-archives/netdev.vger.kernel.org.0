Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77013A3B71
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 07:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFKFol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 01:44:41 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:38990 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFKFoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 01:44:39 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id E3921800050;
        Fri, 11 Jun 2021 07:42:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 07:42:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 07:42:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2376A3180609; Fri, 11 Jun 2021 07:42:40 +0200 (CEST)
Date:   Fri, 11 Jun 2021 07:42:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>
Subject: Re: [PATCH ipsec-next] xfrm: remove description from xfrm_type struct
Message-ID: <20210611054240.GG1081744@gauss3.secunet.de>
References: <20210605105443.17667-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210605105443.17667-1-fw@strlen.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 12:54:43PM +0200, Florian Westphal wrote:
> Its set but never read. Reduces size of xfrm_type to 64 bytes on 64bit.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian!
