Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17173AC4F9
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFRH2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:28:33 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:50070 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhFRH2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:28:31 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 54847800050;
        Fri, 18 Jun 2021 09:26:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:26:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 18 Jun
 2021 09:26:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C1CD63180428; Fri, 18 Jun 2021 09:26:19 +0200 (CEST)
Date:   Fri, 18 Jun 2021 09:26:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: avoid compiler warning when ipv6 is
 disabled
Message-ID: <20210618072619.GT40979@gauss3.secunet.de>
References: <20210615142720.2749-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210615142720.2749-1-fw@strlen.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 04:27:20PM +0200, Florian Westphal wrote:
> with CONFIG_IPV6=n:
> xfrm_output.c:140:12: warning: 'xfrm6_hdr_offset' defined but not used
> 
> Fixes: 9acf4d3b9ec1 ("xfrm: ipv6: add xfrm6_hdr_offset helper")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks!
