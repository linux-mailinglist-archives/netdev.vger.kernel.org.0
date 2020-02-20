Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF33C165DC2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 13:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBTMo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 07:44:56 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50216 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgBTMo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 07:44:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8520720491;
        Thu, 20 Feb 2020 13:44:54 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iOePJampMJ7u; Thu, 20 Feb 2020 13:44:53 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2FFAB2027C;
        Thu, 20 Feb 2020 13:44:53 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 13:44:52 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CF65E318028C;
 Thu, 20 Feb 2020 13:44:52 +0100 (CET)
Date:   Thu, 20 Feb 2020 13:44:52 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xue.zhihong@zte.com.cn>,
        <wang.liang82@zte.com.cn>, Huang Zijiang <huang.zijiang@zte.com.cn>
Subject: Re: [PATCH] xfrm: Use kmem_cache_zalloc() instead of
 kmem_cache_alloc() with flag GFP_ZERO.
Message-ID: <20200220124452.GX8274@gauss3.secunet.de>
References: <1581501276-5636-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1581501276-5636-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 05:54:36PM +0800, Yi Wang wrote:
> From: Huang Zijiang <huang.zijiang@zte.com.cn>
> 
> Use kmem_cache_zalloc instead of manually setting kmem_cache_alloc
> with flag GFP_ZERO since kzalloc sets allocated memory
> to zero.
> 
> Change in v2:
>      add indation
> 
> Signed-off-by: Huang Zijiang <huang.zijiang@zte.com.cn>
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>

Applied to ipsec-next, thanks!
