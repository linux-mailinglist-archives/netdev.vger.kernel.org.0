Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175BD3FA2F0
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 03:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhH1Bgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhH1Bgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 21:36:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B01C0613D9;
        Fri, 27 Aug 2021 18:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=AxcZIHM6WRdQHLVjEv6VID2r686OxIA9JRn4iceNx/k=; b=JzMfwkMosdaUNdn/1Yel4T4CIK
        nWisCh3pB4LKYN9lmwe3kcW3y3RMi10xxn6rv9ZKQHMOEzo7YeR6slfz9vwI6zdJaT9QpwTkMDLG0
        FVlxc+oMw9bT3aYZHXCILsRugcuKgDA/pNOPr3WKN/CR/4TZWLX8LOvM8JIY8Tw7/RAXbZ5+EvLLl
        ELs2nfKhbOuHAJWozZXROlf+LlMshSqceKQyZsvz2IaQ/0W++3UqEREICbu9Lr6NKfgCs3fCgy/t0
        lY3tapkuG51RveCTItRCp2mSHKi2NHvMx/tFOfQn5IG43PTS4CpRFFlnS1B9TvB8gRsXu+E89GAV5
        n/4ThJsQ==;
Received: from [2602:306:c5a2:a380:51a9:8dca:e324:214f]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJnFP-00FBZe-Bc; Sat, 28 Aug 2021 01:35:14 +0000
Subject: Re: [PATCH] net: spider_net: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kou.ishizaki@toshiba.co.jp, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <4f3113d1-b76e-a085-df2d-fd97d4b45faf@infradead.org>
Date:   Fri, 27 Aug 2021 18:34:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On 8/27/21 12:56 PM, Christophe JAILLET wrote:
> It has *not* been compile tested because I don't have the needed
> configuration or cross-compiler.

The powerpc ppc64_defconfig has CONFIG_SPIDER_NET set. My
tdd-builder Docker image has the needed gcc-powerpc-linux-gnu
cross compiler to build ppc64_defconfig:

  https://hub.docker.com/r/glevand/tdd-builder

-Geoff
 
