Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291F356CBB0
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGIWcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 18:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGIWcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 18:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF379165A2;
        Sat,  9 Jul 2022 15:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE99C60FEE;
        Sat,  9 Jul 2022 22:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE02C3411C;
        Sat,  9 Jul 2022 22:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657405942;
        bh=XTvpDJdsCOf2yxDpcCtMoGoPgImqx4kvThMmmT3dQXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IgBaPg8Xg1tutA0UjR1AiTf9wWhuE6iwIc39Xuekgth1F34VifB6ybmGcXrX257v/
         gMuRbyv/W9iAhzTGxlmaLh0SnJyT7R2J3QCBsBRuvuitdzMy7NiZpPQpw1KCFXZkjN
         W7D1T91sirNqHc4lJfmLssVUTD4jt5uloS23oLtOZTtfKpr+2QBGo2wuRoJUrr9XWk
         nRzJdBnlqrcRlvQH+m/JXJDayfhM0bucHpta2IqK9xZkV35tzH0N2p1c5jVtSmYH3v
         c/EW0trOk0SwMryhoy7odG1BO95zUvOusrT3xwSt2dGVK981xvj9xyj/BeGQfwpGWx
         gZOEjbacyo/BA==
Date:   Sat, 9 Jul 2022 15:32:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto: Introduce ARIA symmetric cipher algorithm
Message-ID: <YsoB9LBXOLEdV/2e@sol.localdomain>
References: <20220704094250.4265-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704094250.4265-1-ap420073@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 09:42:47AM +0000, Taehee Yoo wrote:
> This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.
> 
> Like SEED, the ARIA is a standard cipher algorithm in South Korea.
> Especially Government and Banking industry have been using this algorithm.
> So the implementation of ARIA will be useful for them and network vendors.
> 
> Usecases of this algorithm are TLS[1], and IPSec.

Is this actually going to be used in the real world, or is this just a PhD
thesis sort of thing?  There are already way too many random crypto algorithms
that are supported in the kernel, and many have been removed due to lack of
users -- implying that they should never have been accepted in the first place.

- Eric
