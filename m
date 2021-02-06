Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D275E311BD9
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 08:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBFHM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 02:12:58 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50326 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhBFHM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 02:12:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 741C6205DD;
        Sat,  6 Feb 2021 08:12:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hcmvKwzvX_mK; Sat,  6 Feb 2021 08:12:14 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 08883205DB;
        Sat,  6 Feb 2021 08:12:14 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 6 Feb 2021 08:12:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 6 Feb 2021
 08:12:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CCE623182C11;
 Sat,  6 Feb 2021 08:12:13 +0100 (CET)
Date:   Sat, 6 Feb 2021 08:12:13 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] xfrm: Return the correct errno code
Message-ID: <20210206071213.GT3576117@gauss3.secunet.de>
References: <20210204074254.18572-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210204074254.18572-1-zhengyongjun3@huawei.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 03:42:54PM +0800, Zheng Yongjun wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied to ipsec-next, thanks!
