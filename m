Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92F9578B14
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiGRTie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236271AbiGRTiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:38:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011AF31393;
        Mon, 18 Jul 2022 12:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC478B81705;
        Mon, 18 Jul 2022 19:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4242C341C0;
        Mon, 18 Jul 2022 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658173095;
        bh=vpqAL0CO/3a8visbxpQjy5FG9dzSYgZJjhqVkMHPZ9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJwT0BIEYiy2IydNB5664j5+dSwoB1bzgZCPvsxIEy+6GAl6EsyKLpNq3e7u0lEu2
         qD+Gl+Le97pLChGOVBt7IP8fdfIj8bXoB0R0fGImT/O51gn3IJ10B4TmSKI5nNFwhT
         Ca5OXWip3qIhshOufJ2u5z/hDTjvW48Frl9viIwaNS9X6XUAmd4o+WH5Ere/eJXC7r
         d+f9U8axJLckNX6l4SIuz7Debc0m64ckc84iDn3ZoM6WMNH6+HohWC7417ubUXQCxj
         zD7CLVkyX7mNjRPZ4hxrMd37yGljypLrSyYEicoAucTKOVCWn7ZYtGDPnwmPnUrWn2
         kFGEwZAyyIquw==
Date:   Mon, 18 Jul 2022 12:38:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     edumazet@google.com, aelior@marvell.com, skalluru@marvell.com,
        manishc@marvell.com, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Fix comment typo
Message-ID: <20220718123810.220fae3f@kernel.org>
In-Reply-To: <20220715045630.22682-1-wangborong@cdjrlc.com>
References: <20220715045630.22682-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 12:56:30 +0800 Jason Wang wrote:
> Subject: [PATCH] bnx2x: Fix comment typo
> Date: Fri, 15 Jul 2022 12:56:30 +0800

The date on your submissions is broken, please fix and repost.
I got those patches on Monday my time and they are supposedly 
sent on Thursday my time :(
