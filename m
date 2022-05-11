Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9E2523F4A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 23:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348029AbiEKVLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 17:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240438AbiEKVLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 17:11:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945AF1BADEF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 14:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC32DCE26F7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 21:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38EC340EE;
        Wed, 11 May 2022 21:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652303495;
        bh=NMev4gtgxuIWkqEUjCXkdZRWv4ChOQDHulGi+stkGD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scdIKp7FdFHsuHkdXlmXEDWQFiTpomby4K8eUTrs30TmNBkcgcmkvXvRarJcr0ssv
         ZM4V2Nztm0H3n3GQGX1ZmOqxsjqekfbE9LrRiLnJXFGrmin36QFiEiTJlUQwnihgVY
         P2sX2syoM+RrriLNOvh6BgXr5Fq5lgwdBE8yKS1flj4871mGmBEg4HHvIur78+hAQV
         qgCle7Nq5y95wh4HxSvcvb4LU1OfLBj7mPm5HhcbWIH0GNecIzDnGypBANb2w15mtP
         BsAFyKeSIDGggrIe4SsLC95vxX/YbaFZPtLKhdPdQiq2GIR4TyupX/TUvqXbRfxL1w
         U9BP5hM0Afb0g==
Date:   Wed, 11 May 2022 14:11:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes@sipsolutions.net, pablo@netfilter.org,
        laforge@gnumonks.org, Jason@zx2c4.com, jgg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [RFC net-next] net: add ndo_alloc_and_init and ndo_release to
 replace priv_destructor
Message-ID: <20220511141133.142f2a45@kernel.org>
In-Reply-To: <20220511191218.1402380-1-kuba@kernel.org>
References: <20220511191218.1402380-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 12:12:18 -0700 Jakub Kicinski wrote:
> That's best I can come up. Using .ndo_free as a name may seem
> like a better option but that may make people think it's called
> from free_netdev().

Maybe ndo_destroy is better =F0=9F=A4=94
