Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7163E2AFFE1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgKLGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:52:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:33850 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgKLGwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 01:52:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7FCCB20265;
        Thu, 12 Nov 2020 07:52:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ooKxlV0UZRKt; Thu, 12 Nov 2020 07:52:01 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F0069200BB;
        Thu, 12 Nov 2020 07:52:01 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 07:52:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 12 Nov
 2020 07:52:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4ECF53181489; Thu, 12 Nov 2020 07:52:01 +0100 (CET)
Date:   Thu, 12 Nov 2020 07:52:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yu Kuai <yukuai3@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <0x7f454c46@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <zhangxiaoxu5@huawei.com>
Subject: Re: [PATCH] net: xfrm: fix memory leak in xfrm_user_policy()
Message-ID: <20201112065201.GE15658@gauss3.secunet.de>
References: <20201110011443.2482437-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201110011443.2482437-1-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 09:14:43AM +0800, Yu Kuai wrote:
> if xfrm_get_translator() failed, xfrm_user_policy() return without
> freeing 'data', which is allocated in memdup_sockptr().
> 
> Fixes: 96392ee5a13b ("xfrm/compat: Translate 32-bit user_policy from sockptr")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Patch applied, thanks!
