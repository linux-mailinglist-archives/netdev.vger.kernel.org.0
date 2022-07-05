Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A0566FDC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiGENuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiGENtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354BD1F2C4;
        Tue,  5 Jul 2022 06:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC54C61445;
        Tue,  5 Jul 2022 13:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026C5C341C7;
        Tue,  5 Jul 2022 13:21:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="exJSyJP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657027297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bTCbFyvLD181ceTl81n4Rvx4O+hydwDMRZXrAGsIYRE=;
        b=exJSyJP4ISXCOZvWNpBvhPPTL/CtxyD27N/3kS4hzlC0JATuugA2oZNG/y4KZSMGL5rwRz
        odfuFRwk8d8WD9c5ca/stYOc5TsaM0lhwPHX1YskNNE8ii11z+6exHtXdj3bbNxqsI7S+d
        EzIs6hn3WmyDOa3ft4qCIs3Vh1IKfL4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75734888 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 13:21:37 +0000 (UTC)
Date:   Tue, 5 Jul 2022 15:21:33 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Vlad Dronov <vdronov@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireguard: Kconfig: select CRYPTO_CHACHA_S390
Message-ID: <YsQ63c3mkxKRC4v0@zx2c4.com>
References: <20220704191535.76006-1-vdronov@redhat.com>
 <YsOKj/GE2Mb2UsYa@zx2c4.com>
 <YsOY/eWq7gRjXJK1@zx2c4.com>
 <CAMusb+RLB6-oz10yp9Cdigt0TeJ_85M30bH8snZaeM2CyvUiYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMusb+RLB6-oz10yp9Cdigt0TeJ_85M30bH8snZaeM2CyvUiYA@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Tue, Jul 05, 2022 at 02:07:40PM +0200, Vlad Dronov wrote:
> Whoa, that's... funny. Honestly, I was always wondering why CRYPTO_CHACHA_S390
> and friends live in drivers/crypto/Kconfig. Now I know why.

Well... now you know that somebody else thought it was strange too. But
not quite why. At least I don't know why, other than assuming it was
a simple human mistake. But maybe the s390 developers will have an
interesting explanation or something. Herbert CC'd them into that
thread, so I look forward to seeing their response (if any).

Jason
