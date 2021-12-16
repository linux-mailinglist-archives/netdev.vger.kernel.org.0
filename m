Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B26477783
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbhLPQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:13:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45428 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239144AbhLPQNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:13:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E5CB824BA;
        Thu, 16 Dec 2021 16:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8349C36AE0;
        Thu, 16 Dec 2021 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639671212;
        bh=TTDTW3nku84v+Dzh3bFaAwq5x/FUchEFotqJpJFNAi8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VTemadZPZkFYcBvbsPbmnlmfQW8xMWH4nMv39VbG77N54Bm3+AmYFXKy8gXG3Glwi
         711B7pj5zmMPC1RnTUIZWSeZWDvWubRFNQo+WTNsCeyq4bKlk/zgm/5loyzLoKHntc
         qAqRvPwDLkKKOGzM595+x2pObPDVwnWDFTS9+reIFhUHeIXPGk7nq5Jnb1ynxwMB/Z
         ft+AaqA1j3xhxFfZx1lRMKn6Fwk1zgTtURxsQAXLQ2gDF+MRtJxjYU0ZiQ85VGGAbA
         GbVBPR4nBUFqHvr9oLMeUEL0bw1s1esy5j81CSK9x4Hq4vWIh1BNpjAxhqNKwgSslv
         8b6vQt6vyTRjw==
Date:   Thu, 16 Dec 2021 08:13:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Prevent smc_release() from long blocking
Message-ID: <20211216081331.4983d048@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2c8f208f-9b14-1c79-ae6a-0ef64010b70a@linux.ibm.com>
References: <1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com>
        <2c8f208f-9b14-1c79-ae6a-0ef64010b70a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 11:08:13 +0100 Karsten Graul wrote:
> On 15/12/2021 13:29, D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > In nginx/wrk benchmark, there's a hung problem with high probability
> > on case likes that: (client will last several minutes to exit)
> > 
> > server: smc_run nginx
> > 
> > client: smc_run wrk -c 10000 -t 1 http://server
> > 
> > Client hangs with the following backtrace:  

In the future please make sure to leave the commit title in the Fixes
tag exactly as is (you seem to have removed a "net/" prefix).

> Good finding, thank you!
> 
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>

Applied, thanks.
