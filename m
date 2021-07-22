Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27E63D2130
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhGVJII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:08:08 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:50074 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhGVJIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 05:08:07 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 0890080005A;
        Thu, 22 Jul 2021 11:48:41 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 11:48:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 22 Jul
 2021 11:48:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3C7333180B27; Thu, 22 Jul 2021 11:48:40 +0200 (CEST)
Date:   Thu, 22 Jul 2021 11:48:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Safonov <dima@arista.com>
CC:     <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <stable@kernel.org>, "Shuah Khan" <shuah@kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 0/2] xfrm/compat: Fix xfrm_spdattr_type_t copying
Message-ID: <20210722094840.GD893739@gauss3.secunet.de>
References: <20210717150222.416329-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210717150222.416329-1-dima@arista.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 04:02:20PM +0100, Dmitry Safonov wrote:
> Here is the fix for both 32=>64 and 64=>32 bit translators and a
> selftest that reproduced the issue.
> 
> Big thanks to YueHaibing for fuzzing and reporting the issue,
> I really appreciate it!
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: netdev@vger.kernel.org
> 
> Dmitry Safonov (2):
>   net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
>   selftests/net/ipsec: Add test for xfrm_spdattr_type_t
> 
>  net/xfrm/xfrm_compat.c              |  49 ++++++++-
>  tools/testing/selftests/net/ipsec.c | 165 +++++++++++++++++++++++++++-
>  2 files changed, 207 insertions(+), 7 deletions(-)

Series applied, thanks Dmitry!
