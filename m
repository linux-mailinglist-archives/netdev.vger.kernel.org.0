Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7778C32CE5F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbhCDIY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236662AbhCDIYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 03:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1540864EEC;
        Thu,  4 Mar 2021 08:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614846215;
        bh=nXUevGJiNmrhG5HY6nR5A28AY6SEM94fbFVjuik0f9E=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=UIw369TReRByqBK52h7c0Gd8D5acp9Y6//ee3aF+aU7d4BQ3odrUzgJ0txkDX9Nhz
         EunvzrbqtJry3M/JBHaqImlz6pi3n6ZFSkCR29jXK7gqNYQS+ebbxDVoY3VacBlpB2
         utCbAiOVxcHX+K2r+vOC/ONl3N5Ln+lMk5BVWuPuTFagztnO4DUEM3bXhglpmfbLqG
         LhLFwLeE7+ZwFqpKADaXn8SUtFf8E4B04rMhc7fUTvr7nfc2AcCZjkhndYvmGWNwSx
         dQVKeW9kBr5OHRmQtNNTZGsU8dcfEC9Xaz/IDTQo7reWoT1EDA/swLLvp54+qWW35b
         UESTATPkKlwqQ==
Date:   Thu, 4 Mar 2021 10:23:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net] docs: networking: drop special stable handling
Message-ID: <YECZA2pNnl9ZVvJd@unreal>
References: <20210303024643.1076846-1-kuba@kernel.org>
 <161479080763.4362.12115440673038425798.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161479080763.4362.12115440673038425798.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 05:00:07PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This patch was applied to netdev/net.git (refs/heads/master):
>
> On Tue,  2 Mar 2021 18:46:43 -0800 you wrote:
> > Leave it to Greg.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  Documentation/networking/netdev-FAQ.rst       | 72 ++-----------------
> >  Documentation/process/stable-kernel-rules.rst |  6 --
> >  Documentation/process/submitting-patches.rst  |  5 --
> >  3 files changed, 6 insertions(+), 77 deletions(-)
>
> Here is the summary with links:
>   - [net] docs: networking: drop special stable handling
>     https://git.kernel.org/netdev/net/c/dbbe7c962c3a

Excellent news, thanks
