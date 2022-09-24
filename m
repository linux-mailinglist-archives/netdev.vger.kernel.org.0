Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB75E894F
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiIXHzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 03:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiIXHzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 03:55:05 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF78B5E54
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 00:55:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 397522052E;
        Sat, 24 Sep 2022 09:55:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6fNKEW5hzeOF; Sat, 24 Sep 2022 09:54:58 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9C72120460;
        Sat, 24 Sep 2022 09:54:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 82C8C80004A;
        Sat, 24 Sep 2022 09:54:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 09:54:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 09:54:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6AF083182D23; Sat, 24 Sep 2022 09:54:57 +0200 (CEST)
Date:   Sat, 24 Sep 2022 09:54:57 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/7] xfrm: add netlink extack for state
 creation
Message-ID: <20220924075457.GP2602992@gauss3.secunet.de>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
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

On Wed, Sep 14, 2022 at 07:03:59PM +0200, Sabrina Dubroca wrote:
> This is the second part of my work adding extended acks to XFRM, now
> taking care of state creation. Policies were handled in the previous
> series [1].
> To keep this series at a reasonable size, x->type->init_state will be
> handled separately.
> 
> [1] https://lkml.kernel.org/r/cover.1661162395.git.sd@queasysnail.net
> 
> Sabrina Dubroca (7):
>   xfrm: add extack support to verify_newsa_info
>   xfrm: add extack to verify_replay
>   xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
>   xfrm: add extack support to xfrm_dev_state_add
>   xfrm: add extack to attach_*
>   xfrm: add extack to __xfrm_init_state
>   xfrm: add extack support to xfrm_init_replay

Series applied, thanks Sabrina!
