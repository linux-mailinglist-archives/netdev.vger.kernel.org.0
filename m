Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB3966E4AA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjAQRRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbjAQRRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:17:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DF34B18A;
        Tue, 17 Jan 2023 09:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B873E614E6;
        Tue, 17 Jan 2023 17:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9382AC433F0;
        Tue, 17 Jan 2023 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673975778;
        bh=DVGijHnp1c/j29pDnvdtsSA2nL5EheoEfju49RCRxn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y63FebPLuKEebwS2QIVFml7h1ypSZ/01Sccjr0ESYxAWOeb55OiiWcVRjNYje9M94
         FAS9HNQWqUPqvyGF3toW4GForqtoEKM9Bsj6MajqkMHUJET+R8ZJz6qXeAurwbvkkg
         0EV4BgDOOkT9WsZxUXscRSXmbncYTA6r+GDtSqa2hY+/rpLV90tNzQYRz9ClegxmgZ
         vm8ZRd5Yyy2DSJi9fHTScLkoJC7XEzh1GorxLOEK02EQbD9xQQKc68yLR54Sk3ZAuK
         gpkX6FJVErzfLhwoYhTZYXUpkHMjz05qJBYWIQt4af7GSAyq/4ZWVGl3JuCrGbWX2j
         JtJUyffHLLmdw==
Date:   Tue, 17 Jan 2023 09:16:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Subject: Re: [PATCHv3 net-next] selftests/net: mv bpf/nat6to4.c to net
 folder
Message-ID: <20230117091616.19d8eb76@kernel.org>
In-Reply-To: <Y8URDVVQs9pRrNdU@Laptop-X1>
References: <20221218082448.1829811-1-liuhangbin@gmail.com>
        <Y8URDVVQs9pRrNdU@Laptop-X1>
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

On Mon, 16 Jan 2023 16:55:41 +0800 Hangbin Liu wrote:
> May I ask what's the status of this patch? I saw it's deferred[1] but I don't
> know what I should do.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20221218082448.1829811-1-liuhangbin@gmail.com/

Judging by the date it may have been posted during the merge window.
Just repost as is.
