Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0408B627608
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 07:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiKNGnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 01:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbiKNGnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 01:43:41 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235CA55A9;
        Sun, 13 Nov 2022 22:43:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E7ED220322;
        Mon, 14 Nov 2022 07:43:33 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4ZqAWFh9eFFD; Mon, 14 Nov 2022 07:43:33 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7901C201AE;
        Mon, 14 Nov 2022 07:43:33 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7149B80004A;
        Mon, 14 Nov 2022 07:43:33 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 07:43:33 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 14 Nov
 2022 07:43:33 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B526D31829C0; Mon, 14 Nov 2022 07:43:32 +0100 (CET)
Date:   Mon, 14 Nov 2022 07:43:32 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <zhang.songyi@zte.com.cn>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jiang.xuexin@zte.com.cn>, <xue.zhihong@zte.com.cn>
Subject: Re: [PATCH linux-next] net: af_key: remove redundant ret variable
Message-ID: <20221114064332.GL665047@gauss3.secunet.de>
References: <202211022146335400497@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202211022146335400497@zte.com.cn>
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

On Wed, Nov 02, 2022 at 09:46:33PM +0800, zhang.songyi@zte.com.cn wrote:
> >From a09ddf4bd144610fd17bdbf07f0c27700d805e6f Mon Sep 17 00:00:00 2001
> From: zhang songyi <zhang.songyi@zte.com.cn>
> Date: Wed, 2 Nov 2022 21:05:39 +0800
> Subject: [PATCH linux-next] net: af_key: remove redundant ret variable
> 
> Return value from pfkey_net_init() directly instead of taking this in
> another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>

pfkey is deprecated and should not be used anymore.
Please do changes to pfkey just if there is a real
bug to fix.

Thanks!
