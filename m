Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D83DD022
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 07:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhHBFvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 01:51:33 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:60090 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhHBFvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 01:51:32 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9734E800051;
        Mon,  2 Aug 2021 07:51:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 07:51:21 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 2 Aug 2021
 07:51:21 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0730A31804EF; Mon,  2 Aug 2021 07:51:20 +0200 (CEST)
Date:   Mon, 2 Aug 2021 07:51:20 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>
Subject: Re: [PATCH next] net: xfrm: fix shift-out-of-bounce
Message-ID: <20210802055120.GT893739@gauss3.secunet.de>
References: <20210728163818.10744-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210728163818.10744-1-paskripkin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 07:38:18PM +0300, Pavel Skripkin wrote:
> We need to check up->dirmask to avoid shift-out-of-bounce bug,
> since up->dirmask comes from userspace.
> 
> Also, added XFRM_USERPOLICY_DIRMASK_MAX constant to uapi to inform
> user-space that up->dirmask has maximum possible value
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Reported-and-tested-by: syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Applied, thanks a lot!
