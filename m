Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAD40F2E4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhIQHHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:07:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36106 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233110AbhIQHHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 03:07:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3C99A20571;
        Fri, 17 Sep 2021 09:06:12 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BPTmRxyIkuc5; Fri, 17 Sep 2021 09:06:11 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C20E120547;
        Fri, 17 Sep 2021 09:06:11 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id BC84080004A;
        Fri, 17 Sep 2021 09:06:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 09:06:11 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Fri, 17 Sep
 2021 09:06:11 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E8B8831808BD; Fri, 17 Sep 2021 09:06:10 +0200 (CEST)
Date:   Fri, 17 Sep 2021 09:06:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <antony.antony@secunet.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v3 0/2] xfrm: fix uapi for the default policy
Message-ID: <20210917070610.GB1407957@gauss3.secunet.de>
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
 <20210914144635.6850-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210914144635.6850-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 04:46:32PM +0200, Nicolas Dichtel wrote:
> This feature has just been merged after the last release, thus it's still
> time to fix the uapi.
> As stated in the thread, the uapi is based on some magic values (from the
> userland POV).
> Here is a proposal to simplify this uapi and make it clear how to use it.
> The other problem was the notification: changing the default policy may
> radically change the packets flows.
> 
> v2 -> v3: rebase on top of ipsec tree
> 
> v1 -> v2: fix warnings reported by the kernel test robot
> 
> Nicolas Dichtel (2):
>   xfrm: make user policy API complete
>   xfrm: notify default policy on update

Applied, thanks a lot Nicolas!
