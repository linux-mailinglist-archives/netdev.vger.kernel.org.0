Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5915741804D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 10:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhIYI1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 04:27:35 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53568 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230162AbhIYI1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 04:27:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2E2E2200BC;
        Sat, 25 Sep 2021 10:06:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t4gy4JVMN4x0; Sat, 25 Sep 2021 10:06:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A7778200BB;
        Sat, 25 Sep 2021 10:06:16 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 9BA5C80004A;
        Sat, 25 Sep 2021 10:06:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Sat, 25 Sep 2021 10:06:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Sat, 25 Sep
 2021 10:06:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D5BAA3183C35; Sat, 25 Sep 2021 10:06:15 +0200 (CEST)
Date:   Sat, 25 Sep 2021 10:06:15 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: fix rcu lock in xfrm_notify_userpolicy()
Message-ID: <20210925080615.GA3027429@gauss3.secunet.de>
References: <0000000000003533d205cc8a624b@google.com>
 <20210922085006.13570-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210922085006.13570-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:50:06AM +0200, Nicolas Dichtel wrote:
> As stated in the comment above xfrm_nlmsg_multicast(), rcu read lock must
> be held before calling this function.
> 
> Reported-by: syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
> Fixes: 703b94b93c19 ("xfrm: notify default policy on update")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks Nicolas!
