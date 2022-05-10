Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5366A522529
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiEJUDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiEJUDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:03:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173FF1DEC54
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B20B6B81F70
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266ACC385C8;
        Tue, 10 May 2022 20:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652212996;
        bh=eeiFWnEQ7LigAM9BUUpxaX/GwMFUxfrRqy92JryNU9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CjNnzt1Hudl2J6RxiziMmCsNPotJ/qZore8sgLz5+uneHYVr6rrkIiaR4B+nQ543s
         qpqAXZGIZ2+1JgVPznw7G2ZVAf1qiRbnFtKtlo8lMCAJNEBRGFEebhQjiFj3VQDyBB
         Qw0m3L6cSK4yDY9Li2UntPloaRFb+AmKy0lNVljWa1BUznp7/TAU9b8NRvlB+fz3SM
         gHfYD9lrb1c4NLEAWgKpzm7tLOt3942A/5r6DxIHMiA1a4dn2/+CAoutPQPJqwZj2m
         BYuzBua3hb1xGzcR8r/0IHMubKxrJIJwF9AybrdkiRSID/kiqXC5H+OqNh94R1V5sz
         +DbbSqH+NJJIQ==
Date:   Tue, 10 May 2022 13:03:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH V3] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Message-ID: <20220510130314.15a5e4fa@kernel.org>
In-Reply-To: <SJ0PR18MB5216F9A48501F795382D41BDDBC99@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220506054519.323295-1-sumang@marvell.com>
        <20220509174145.629b04df@kernel.org>
        <20220509174234.4a31ff92@kernel.org>
        <SJ0PR18MB5216F9A48501F795382D41BDDBC99@SJ0PR18MB5216.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 04:18:39 +0000 Suman Ghosh wrote:
> Hi Jakub,
> 
> Yes, this is tested code.

Alright, rebase, retest, repost then please.

As I said the current version does not apply:

$ git checkout net-next/master 
HEAD is now at ecd17a87eb78 x25: remove redundant pointer dev
$ git pw series apply 638987
Applying: octeontx2-pf: Add support for adaptive interrupt coalescing
error: sha1 information is lacking or useless (drivers/net/ethernet/marvell/octeontx2/Kconfig).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 octeontx2-pf: Add support for adaptive interrupt coalescing
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
