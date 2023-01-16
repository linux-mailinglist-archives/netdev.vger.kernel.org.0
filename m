Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B0C66BE97
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjAPNEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjAPNDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:03:02 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01A01F932;
        Mon, 16 Jan 2023 05:01:18 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 22CE720184;
        Mon, 16 Jan 2023 14:01:16 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5CvyrAfdirKL; Mon, 16 Jan 2023 14:01:15 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A4E44200A7;
        Mon, 16 Jan 2023 14:01:15 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 9525980004A;
        Mon, 16 Jan 2023 14:01:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 14:01:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 14:01:14 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AA0933182995; Mon, 16 Jan 2023 14:01:14 +0100 (CET)
Date:   Mon, 16 Jan 2023 14:01:14 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Anastasia Belova <abelova@astralinux.ru>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] xfrm: compat: change expression for switch in
 xfrm_xlate64
Message-ID: <20230116130114.GF438791@gauss3.secunet.de>
References: <20230110091450.21696-1-abelova@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230110091450.21696-1-abelova@astralinux.ru>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 12:14:50PM +0300, Anastasia Belova wrote:
> Compare XFRM_MSG_NEWSPDINFO (value from netlink
> configuration messages enum) with nlh_src->nlmsg_type
> instead of nlh_src->nlmsg_type - XFRM_MSG_BASE.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 4e9505064f58 ("net/xfrm/compat: Copy xfrm_spdattr_type_t atributes")
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>

Applied, thanks a lot Anastasia!
