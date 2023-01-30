Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD27680AD0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjA3Kbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjA3Kba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:31:30 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA722DE47
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:31:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 04FDB2035C;
        Mon, 30 Jan 2023 11:31:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0D7XANxt5MUA; Mon, 30 Jan 2023 11:31:27 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8F115201A1;
        Mon, 30 Jan 2023 11:31:27 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7FE4480004A;
        Mon, 30 Jan 2023 11:31:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 30 Jan 2023 11:31:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 30 Jan
 2023 11:31:27 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 928223182945; Mon, 30 Jan 2023 11:31:26 +0100 (CET)
Date:   Mon, 30 Jan 2023 11:31:26 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>
Subject: Re: [PATCH net 0/2] xfrm: two fixes around use_time
Message-ID: <20230130103126.GJ438791@gauss3.secunet.de>
References: <20230126112130.2341075-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230126112130.2341075-1-edumazet@google.com>
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

On Thu, Jan 26, 2023 at 11:21:28AM +0000, Eric Dumazet wrote:
> First patch fixes a long/time64_t mismatch,
> found while addressing a syzbot report.
> 
> Second patch adds annotations to reads and
> writes of (struct xfrm_lifetime_cur)->use_time field.
> 
> Eric Dumazet (2):
>   xfrm: consistently use time64_t in xfrm_timer_handler()
>   xfrm: annotate data-race around use_time

Both applied, thanks a lot Eric!
