Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B065F0610
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiI3Hxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiI3HxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:53:20 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1CC15ED1E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:52:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EEA3B204A4;
        Fri, 30 Sep 2022 09:52:53 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B5EwWm2dFiLI; Fri, 30 Sep 2022 09:52:53 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8556F2008D;
        Fri, 30 Sep 2022 09:52:53 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 76F6480004A;
        Fri, 30 Sep 2022 09:52:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 09:52:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 09:52:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C1BB23182A37; Fri, 30 Sep 2022 09:52:52 +0200 (CEST)
Date:   Fri, 30 Sep 2022 09:52:52 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/6] xfrm: add netlink extack to all the
 ->init_state
Message-ID: <20220930075252.GA2950045@gauss3.secunet.de>
References: <cover.1664287440.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1664287440.git.sd@queasysnail.net>
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

On Tue, Sep 27, 2022 at 05:45:28PM +0200, Sabrina Dubroca wrote:
> This series completes extack support for state creation.
> 
> Sabrina Dubroca (6):
>   xfrm: pass extack down to xfrm_type ->init_state
>   xfrm: ah: add extack to ah_init_state, ah6_init_state
>   xfrm: esp: add extack to esp_init_state, esp6_init_state
>   xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
>   xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
>   xfrm: mip6: add extack to mip6_destopt_init_state,
>     mip6_rthdr_init_state

Series applied, thanks Sabrina!
