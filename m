Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718F543910E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhJYIXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:23:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36288 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhJYIXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 04:23:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1851420265;
        Mon, 25 Oct 2021 10:20:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZAXeZe6iBZIe; Mon, 25 Oct 2021 10:20:46 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7A0862019D;
        Mon, 25 Oct 2021 10:20:46 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6B99880004A;
        Mon, 25 Oct 2021 10:20:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 25 Oct 2021 10:20:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Mon, 25 Oct
 2021 10:20:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AA2603182FA7; Mon, 25 Oct 2021 10:20:45 +0200 (CEST)
Date:   Mon, 25 Oct 2021 10:20:45 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     luo penghao <cgel.zte@gmail.com>
CC:     SimonHorman <horms@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "luo penghao" <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] xfrm: Remove redundant fields and related
 parentheses
Message-ID: <20211025082045.GC36125@gauss3.secunet.de>
References: <20211022095911.1066475-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211022095911.1066475-1-luo.penghao@zte.com.cn>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:59:11AM +0000, luo penghao wrote:
> The variable err is not necessary in such places. It should be revmoved
> for the simplicity of the code. This will cause the double parentheses
> to be redundant, and the inner parentheses should be deleted.
> 
> The clang_analyzer complains as follows:
> 
> net/xfrm/xfrm_input.c:533: warning:
> net/xfrm/xfrm_input.c:563: warning:
> 
> Although the value stored to 'err' is used in the enclosing expression,
> the value is never actually read from 'err'.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

Is this an update to your previous patch?
If so, please mark it as such with a 'v2'
and describe what changed.

Thanks!

