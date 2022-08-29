Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B265A44A8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiH2IK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiH2IKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:10:52 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88069543DB;
        Mon, 29 Aug 2022 01:10:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B5A022059C;
        Mon, 29 Aug 2022 10:09:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eZo_ZvLRGrG9; Mon, 29 Aug 2022 10:09:44 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4364720590;
        Mon, 29 Aug 2022 10:09:44 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 33F2080004A;
        Mon, 29 Aug 2022 10:09:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 10:09:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 29 Aug
 2022 10:09:43 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5A91D3182ABC; Mon, 29 Aug 2022 10:09:43 +0200 (CEST)
Date:   Mon, 29 Aug 2022 10:09:43 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hongbin Wang <wh_bin@126.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfrm: Drop unused argument
Message-ID: <20220829080943.GN566407@gauss3.secunet.de>
References: <20220822034147.2284570-1-wh_bin@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220822034147.2284570-1-wh_bin@126.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
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

On Sun, Aug 21, 2022 at 11:41:47PM -0400, Hongbin Wang wrote:
> Drop unused argument from xfrm_policy_match,
> __xfrm_policy_eval_candidates and xfrm_policy_eval_candidates.
> No functional changes intended.
> 
> Signed-off-by: Hongbin Wang <wh_bin@126.com>

Applied to ipsec-next, thanks!
