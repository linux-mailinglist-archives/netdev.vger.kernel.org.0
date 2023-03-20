Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB396C0CE7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjCTJO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCTJN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:13:59 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5131CA1B
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 02:13:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6D91020189;
        Mon, 20 Mar 2023 10:13:56 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CsO-ckrJwnVy; Mon, 20 Mar 2023 10:13:55 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D7CE720080;
        Mon, 20 Mar 2023 10:13:55 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id C85B280004A;
        Mon, 20 Mar 2023 10:13:55 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Mar 2023 10:13:55 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Mon, 20 Mar
 2023 10:13:55 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 159193182D28; Mon, 20 Mar 2023 10:13:55 +0100 (CET)
Date:   Mon, 20 Mar 2023 10:13:55 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next 5/9] xfrm: copy_to_user_state fetch offloaded
 SA packets/bytes statistics
Message-ID: <ZBgj07C1o39NFJW5@gauss3.secunet.de>
References: <cover.1678714336.git.leon@kernel.org>
 <d90ec74186452b1509ee94875d942cb777b7181e.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d90ec74186452b1509ee94875d942cb777b7181e.1678714336.git.leon@kernel.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:58:40AM +0200, Leon Romanovsky wrote:
> From: Raed Salem <raeds@nvidia.com>
> 
> Both in RX and TX, the traffic that performs IPsec packet offload
> transformation is accounted by HW only. Consequently, the HW should
> be queried for packets/bytes statistics when user asks for such
> transformation data.
> 
> Signed-off-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
