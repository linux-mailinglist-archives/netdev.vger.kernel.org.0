Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2813A92A0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFPGcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:32:25 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:46356 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhFPGbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:31:51 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 882EA800050
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 08:29:43 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 08:29:43 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 08:29:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9E08C3180248; Wed, 16 Jun 2021 08:29:42 +0200 (CEST)
Date:   Wed, 16 Jun 2021 08:29:42 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: Fix error reporting in xfrm_state_construct.
Message-ID: <20210616062942.GG40979@gauss3.secunet.de>
References: <20210607132149.GM40979@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210607132149.GM40979@gauss3.secunet.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 03:21:49PM +0200, Steffen Klassert wrote:
> When memory allocation for XFRMA_ENCAP or XFRMA_COADDR fails,
> the error will not be reported because the -ENOMEM assignment
> to the err variable is overwritten before. Fix this by moving
> these two in front of the function so that memory allocation
> failures will be reported.
> 
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---

Now applied to the ipsec tree.
