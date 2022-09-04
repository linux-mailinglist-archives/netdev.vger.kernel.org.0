Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92735AC476
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiIDNTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiIDNTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 09:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963D16423
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 06:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 495ABB80D79
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 13:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79527C433C1;
        Sun,  4 Sep 2022 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297571;
        bh=AFXfjPYSYDGUh/qLPFbyG+GkgHaFJzuGPjllrS9L3tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fZay3pMPaxGu6z19MayMCAskXdIwtnIBzpBGzRL6P4WkugKYqFZgGzBc9lcWTLcLq
         YUn/2ts+zyut1CO1+gV3oGrWa/2oXvS5PlLxS+fI+VrDMsQH2v9C8/qCReWzjcL4EB
         Egh9TEXqy4xWiFUiQF8Jj1RFMC8jRLcCVUlgpTGAIlnXPjklRUOJSf9bDxiGVzU6YA
         CEeUnyIMyuuYczUeksZd7kEpWkwG9u8XxJpDJ20wpiEcy/HMEqMvqZOOcEcLTK6zpV
         htv4G3vGCRAJEjJ0J0rPneGlDKa1LYM4AjRiCPeX7ZyXn9NXHY5ihs/YUgaAyLxsqb
         amYssMyTnupEw==
Date:   Sun, 4 Sep 2022 16:19:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <YxSl3hetfdSAoBoi@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1662295929.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 04, 2022 at 04:15:34PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v4:
>  * Changed title from "PATCH" to "PATCH RFC" per-request.
>  * Added two new patches: one to update hard/soft limits and another
>    initial take on documentation.
>  * Added more info about lifetime/rekeying flow to cover letter, see
>    relevant section.
>  * perf traces for crypto mode will come later.

<...>

The series is v4 and not as written in subject title.

Thanks

> -- 
> 2.37.2
> 
