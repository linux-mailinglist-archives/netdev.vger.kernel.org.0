Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6964D5BD907
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiITBEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiITBEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F684D175;
        Mon, 19 Sep 2022 18:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CD5BB80688;
        Tue, 20 Sep 2022 01:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B609EC433C1;
        Tue, 20 Sep 2022 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635860;
        bh=YbrG0hzTV2LscuzIOXmDkkz4qntnvSBburuiMoqon0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SYQ9/q3mQEp1CfaSu8njNVbpkC9TqIFrDXQuDdx9iOzYkFERdsbFwFTiI0CvI16N4
         OermtCCN0ubKs7VIcpwxRcT6DGdpTPKjcXvuOAu5Upbf3p08lBD2oEubPglr2d+xVp
         0lpjNjAJfq3n5L/o3qzLDh6GWvGrbruJGv3YHzMgial3JM1cVKWO4/NrBSMj3bvfOE
         aM4rdgweoG8W743q5g60ujmCit17keN5sz63VV5WpK1J6SJsqmNuePWvcXQAPBOn2H
         QMZWq370ibowbohk4GNpKKbq/sfs/XQ5tFaSnh8wlLoj0EKOSTSnoxRyGjs/Ru7Emw
         yuprbg1Qs+Xow==
Date:   Mon, 19 Sep 2022 18:04:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2022-09-09
Message-ID: <20220919180419.0caa435a@kernel.org>
In-Reply-To: <CABBYNZKHUbqYyevHRZ=6rLA0GAE20mLRHAj9JnFNuRn7VHrEeA@mail.gmail.com>
References: <20220909201642.3810565-1-luiz.dentz@gmail.com>
        <CABBYNZKHUbqYyevHRZ=6rLA0GAE20mLRHAj9JnFNuRn7VHrEeA@mail.gmail.com>
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

On Tue, 13 Sep 2022 16:35:01 -0700 Luiz Augusto von Dentz wrote:
> On Fri, Sep 9, 2022 at 1:16 PM Luiz Augusto von Dentz wrote:
> >
> > The following changes since commit 64ae13ed478428135cddc2f1113dff162d8112d4:
> >
> >   net: core: fix flow symmetric hash (2022-09-09 12:48:00 +0100)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-09
> >
> > for you to fetch changes up to 35e60f1aadf6c02d77fdf42180fbf205aec7e8fc:
> >
> >   Bluetooth: Fix HCIGETDEVINFO regression (2022-09-09 12:25:18 -0700)
> >
> > ----------------------------------------------------------------
> > bluetooth pull request for net:
> >
> >  -Fix HCIGETDEVINFO regression
> 
> Looks like this still hasn't been applied, is there any problem that
> needs to be fixed?

Sorry about the delay, we were all traveling to Linux Plumbers.
Pulling now.

Any reason why struct hci_dev_info is not under include/uapi ?
