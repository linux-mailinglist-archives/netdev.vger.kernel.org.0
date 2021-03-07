Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973A13300D7
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 13:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhCGM3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 07:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhCGM2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 07:28:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CBF965092;
        Sun,  7 Mar 2021 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615120125;
        bh=sY1HN2BTEJut9YpU7t00t6v+TXQSn/Gf4U69FgfKcdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POrEybZ4F4prA4n+UYe5izD5Imvnkvyrvg84/Wm2SjlPL/UtSYD2BQw7BAgTN2XJ0
         BsaM2lMocTWp50+LIdiD6vC8JSHyhGEQZlFogbRSj8lLUIGIJullcNSmUmQoy2IIbH
         NrobhxecgRpV4PN/mLlhSXElykQrjTkA5nktYU2R73k35eeIjrDqHfJcukhlewCVNN
         Thpak2cAvfNisOG3xxWDTLGQjh8WuTBhM62r7HAMP/CgqeUW5i9bpPI2wnUGnA/Riu
         2VRTewB1gXn91YhQmf2aBaAWtQmo89BIv5GUSmtmJarZLXr3hGIJ638q3HeFwdj1kD
         Xkqs62JEf9U0A==
Date:   Sun, 7 Mar 2021 14:28:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: ath6kl: fix error return code of
 ath6kl_htc_rx_bundle()
Message-ID: <YETG+HrMTXs688MN@unreal>
References: <20210307090757.22617-1-baijiaju1990@gmail.com>
 <YESaSwoGRxGvrggv@unreal>
 <a55172ad-bf40-0110-8ef3-326001ecd13e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55172ad-bf40-0110-8ef3-326001ecd13e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 05:31:01PM +0800, Jia-Ju Bai wrote:
> Hi Leon,
>
> I am quite sorry for my incorrect patches...
> My static analysis tool reports some possible bugs about error handling
> code, and thus I write some patches for the bugs that seem to be true in my
> opinion.
> Because I am not familiar with many device drivers, some of my reported bugs
> can be false positives...

It will be much helpful if instead of writing new static analysis tool,
you will invest time and improve existing well known tools, like smatch
and sparse.

Right now, you didn't report bugs, but sent bunch of patches that most
of the time are incorrect. So it is not "some of my reported bugs can
be false positives...", but "some of my patches can fix real bugs by
chance".

Thanks
