Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E015BEEE8
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiITVDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiITVDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065AB45F7E;
        Tue, 20 Sep 2022 14:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1BE62679;
        Tue, 20 Sep 2022 21:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7661C433D6;
        Tue, 20 Sep 2022 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663707809;
        bh=o7S1h7jTsysuNYnR5ZE6hpSrFWBQ+QPB2QoDEmdRnlk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ookGtPWY1t+ynqmFW/SsJ8tAriZBY2bSZd7tSGW9OAuovMimPWZ4A90Yctqe9qIpa
         L7PaQRVeWiP9xMMQnzdJIXmDqFgyEc9NBs4yiM+3OUlIPoXtWTg4ApAEGfJjwZ8TTs
         LMQWXzZtvLvNWVwy+6Yaw9PciyZu0xRGWmtBNKdIfKGx0NWyw7t18Jvjjf+evl2XoF
         qdh2EpzvU7kVrLmXLJPLpElm4MUVyYnDiJ2iDSH6vrRz4Ys5O3mGz1258Ph6NDOd+X
         VRhNaB1011ZM/l6JEVsRZBr9/+Flr6u4u6XuZx7gmMo+6z0dtdIk2dhdm/j+sr69I/
         x2mvvNuwEu/gQ==
Date:   Tue, 20 Sep 2022 14:03:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: pull request: bluetooth 2022-09-09
Message-ID: <20220920140327.5eda455d@kernel.org>
In-Reply-To: <CABBYNZLhMRbvhhb-9Ho-qVarC+KLiFyxiaypHWW=NPqHXYTU0w@mail.gmail.com>
References: <20220909201642.3810565-1-luiz.dentz@gmail.com>
        <CABBYNZKHUbqYyevHRZ=6rLA0GAE20mLRHAj9JnFNuRn7VHrEeA@mail.gmail.com>
        <20220919180419.0caa435a@kernel.org>
        <CABBYNZLhMRbvhhb-9Ho-qVarC+KLiFyxiaypHWW=NPqHXYTU0w@mail.gmail.com>
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

On Tue, 20 Sep 2022 13:56:45 -0700 Luiz Augusto von Dentz wrote:
> > > Looks like this still hasn't been applied, is there any problem that
> > > needs to be fixed?  
> >
> > Sorry about the delay, we were all traveling to Linux Plumbers.
> > Pulling now.
> >
> > Any reason why struct hci_dev_info is not under include/uapi ?  
> 
> None of Bluetooth APIs are there, at some point I was discussing with
> Marcel that we should probably fix that so we can properly expose
> headers to userspace as right now this depends on bluez library which
> is something we want to deprecate.

It'd be great if for no other reason just to make it very clear 
that the structures are uAPI during review.
