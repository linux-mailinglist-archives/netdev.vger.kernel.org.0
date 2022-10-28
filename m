Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D306108CA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiJ1Dfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiJ1Dfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:35:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F8772FEC;
        Thu, 27 Oct 2022 20:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFE3624B7;
        Fri, 28 Oct 2022 03:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8ACC433B5;
        Fri, 28 Oct 2022 03:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666928138;
        bh=uNtkxXN3o2zhketgLUlLwqdehARTFX/2B0v98yM7x7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAjiJzajxQ73fA0Td+mWZ5NxlT8LJ7xEbQP1H+aM1nt9tE6fcYtWZcFb71GitwNCq
         rQk/DguU20lGo12FXeq9X53rdy1xE1TDGCiQejykum4yfOhYBcp3P2UklM3/lfdPe1
         RjMU8hbzFOEb5y1/DIrCqP3v72ujCf+kfMz8JZd29TB8QOU4RAeq6dc3hbnFJGc3y/
         M3fxMY/6mzd6N0sMk4qNjg7LaXF1ECqIbajLtT1eats25M/kbUeTUc76z5jn7qAlXU
         ji/UwbjT8cGwaiPDThbaZj6RuW0Bb4YKRUJDwDMCRGxXYzDhrer9qcsR9GFBAJo3ry
         70D/rvP8Eia6Q==
Date:   Thu, 27 Oct 2022 20:35:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 04/10] netfilter: nft_payload: access GRE
 payload via inner offset
Message-ID: <20221027203536.2daef2b2@kernel.org>
In-Reply-To: <20221026132227.3287-5-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
        <20221026132227.3287-5-pablo@netfilter.org>
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

On Wed, 26 Oct 2022 15:22:21 +0200 Pablo Neira Ayuso wrote:
> Parse GRE v0 packets to properly set up inner offset, this allow for
> matching on inner headers.

net/netfilter/nft_payload.c:112:25: warning: incorrect type in assignment (different base types)
net/netfilter/nft_payload.c:112:25:    expected unsigned int [usertype] version
net/netfilter/nft_payload.c:112:25:    got restricted __be16
net/netfilter/nft_payload.c:114:22: warning: restricted __be16 degrades to integer
