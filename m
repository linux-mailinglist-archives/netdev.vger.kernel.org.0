Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68235BF0FA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiITXTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITXTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:19:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B3772B75
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BF6CB82D7E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCACC433C1;
        Tue, 20 Sep 2022 23:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663715960;
        bh=E4AYg5M1NW0J4oTxx5tU7YkDca0FZLdECenrdwIFOd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lkK5cGa3jGpJovkBO9UZbl46aWgWW8ji52AnrGKwb1cA7RYtrf4LwBcqR7FqltaE7
         SHtO7n+dBaJGxPPrhk2PTMz5CpBND4fXqlLS4u+VmlEeR69GJgqKk5u25UcQgipAn0
         KrroRedhNkkg9OIX8N+cB0aRXyQA6/LDgMBl3300GFq9+F8aDuA98Ykl6MUr+s3fZ4
         srNAcPnEjEAdSqgtkFvptcReR3/Gs/K+n6vG+YP+HD8QLTSbwpUT9H6b0UUXp0du/E
         6KhH9Za9bd6Psg/qMYt1GhVG+1OWHNbaKMqnes33IX3xjNS2xsYxk9Lmd0p2vL3VW0
         gQSXjN1Ishfzg==
Date:   Tue, 20 Sep 2022 16:19:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, pablo@netfilter.org
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
Message-ID: <20220920161918.6c40f2a6@kernel.org>
In-Reply-To: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Sep 2022 11:03:55 +0300 Martin Zaharinov wrote:
> xt_NAT(O)

What's this? Can you repro on a vanilla kernel?
