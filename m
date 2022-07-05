Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0756767E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiGESbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGESbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:31:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E256594;
        Tue,  5 Jul 2022 11:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B284619A6;
        Tue,  5 Jul 2022 18:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A7C341C7;
        Tue,  5 Jul 2022 18:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657045863;
        bh=/npDUasULjXiZbzc/ZSFtmS962gEGg7Ox9mBxn1ssd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S7E0B4oLU0Yd2cjVV0On7+ymT0KPQDkHgquM+5qJz3xMEgVBxjrdK9EPzZTm0BWd8
         t/im2KyMJqguMVWGtRzRMMcIKxj70NiAnOkP/40ZK21wpek1eI1aKnT/QiY4Zfu1V2
         Ok1UBZMnvspkco8k/lK51jWjnGIwi+bWWYcrShZTbI9jZMOLNkpjS38ATxw/LfQcFf
         Qw0JgsZke7vKDp4I/4LNqKow1nt9ZD7lYkhmmYsHRgrVIvc8Z/e60ATd1Kc15jYVMl
         9MlHnm2WQROzx8aYqpDrVE+RqtTA6rzlVSluKNLScBdo/j3lP3IFmqiWULhdFmyvZE
         EFZ9uxTtArM5w==
Date:   Tue, 5 Jul 2022 11:31:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Taehee Yoo <ap420073@gmail.com>, linux-crypto@vger.kernel.org,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: tls: Add ARIA-GCM algorithm
Message-ID: <20220705113102.1862660a@kernel.org>
In-Reply-To: <YsO+DmGe7LdGUmUE@gondor.apana.org.au>
References: <20220704094250.4265-1-ap420073@gmail.com>
        <20220704094250.4265-4-ap420073@gmail.com>
        <20220704201009.34fb8aa8@kernel.org>
        <YsO+DmGe7LdGUmUE@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 12:29:02 +0800 Herbert Xu wrote:
> I need to know that you guys will take the network part of the
> patch in order to accept the crypto part.  We don't add algorithms
> with no in-kernel users.

GTK, I thought maybe using crypto sockets is enough of a reason.

> As long as you are happy to take the TLS part later, we can add
> the crypto parts right now.

Yup, can confirm. I haven't heard of this algo before but the IETF
RFC looks legit so we'll take the TLS part.
