Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC4655E0F2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiF0LG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiF0LGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:06:25 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5409646A;
        Mon, 27 Jun 2022 04:06:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9E2982057B;
        Mon, 27 Jun 2022 13:06:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KPTQuNyaiw8o; Mon, 27 Jun 2022 13:06:20 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1D1C820270;
        Mon, 27 Jun 2022 13:06:20 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 116ED80004A;
        Mon, 27 Jun 2022 13:06:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 27 Jun 2022 13:06:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 27 Jun
 2022 13:06:19 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6C7593182CC2; Mon, 27 Jun 2022 13:06:19 +0200 (CEST)
Date:   Mon, 27 Jun 2022 13:06:19 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH ipsec-next] xfrm: change the type of xfrm_register_km and
 xfrm_unregister_km
Message-ID: <20220627110619.GC2950045@gauss3.secunet.de>
References: <20220615015519.96975-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220615015519.96975-1-shaozhengchao@huawei.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 09:55:19AM +0800, Zhengchao Shao wrote:
> Functions xfrm_register_km and xfrm_unregister_km do always return 0,
> change the type of functions to void.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Applied, thanks Zhengchao!
