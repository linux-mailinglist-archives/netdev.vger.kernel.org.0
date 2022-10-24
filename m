Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4388360BDEA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiJXWyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiJXWxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:53:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3D6C0696;
        Mon, 24 Oct 2022 14:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AE5B615BE;
        Mon, 24 Oct 2022 21:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B54AC433C1;
        Mon, 24 Oct 2022 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666646105;
        bh=8kPFzMeilpB3CpJczn/2vDvOmL51eZM51dkWbxD7eDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nwh+FRYM3fMx9UauhbI3LzJk2TEQjjJUpBaqYFpF6iBXhN9k8hWrtd2qkg78tNErh
         /tiBryN/sTulkFAPDKN+Azf8V+jDJ/ciZ7TNAu2YjbrZrb6cl06CFTZRJD2eNKdQTn
         9ohgZUoIfGnBNSRMmcGwo6FXm1odDZAef87ECvrhOk8W87omv7kI2xHdgrIdnxdS59
         S+mnbhZ1aMyD2sIAnTJPdUxbY+Z65/nT4Hn975//1wkigKeD4iz1PRoJheG9VCz9la
         FiKmT6yqSTttEKeCTWk4uINLZ1DBxnVY5r0A9Zr9kzJoPFLuhXNEEiPpsz0b+tZgbh
         gIHIml5PzbKCw==
Date:   Mon, 24 Oct 2022 14:15:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        pabeni@redhat.com, davem@davemloft.net, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, metze@samba.org
Subject: Re: [PATCH for-6.1 0/3] fail io_uring zc with sockets not
 supporting it
Message-ID: <20221024141503.22b4e251@kernel.org>
In-Reply-To: <166664403814.23938.17239840347120158867.git-patchwork-notify@kernel.org>
References: <cover.1666346426.git.asml.silence@gmail.com>
        <166664403814.23938.17239840347120158867.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 20:40:38 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Here is the summary with links:
>   - [for-6.1,1/3] net: flag sockets supporting msghdr originated zerocopy
>     https://git.kernel.org/netdev/net/c/e993ffe3da4b
>   - [for-6.1,2/3] io_uring/net: fail zc send when unsupported by socket
>     https://git.kernel.org/netdev/net/c/edf81438799c
>   - [for-6.1,3/3] io_uring/net: fail zc sendmsg when unsupported by socket
>     https://git.kernel.org/netdev/net/c/cc767e7c6913

Ugh, ignore, looks like we forgot to drop this series from our PW 
and bot thought we've applied it when we forwarded the tree.
