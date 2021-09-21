Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2749413C6D
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhIUV3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235380AbhIUV3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 17:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2327260E05;
        Tue, 21 Sep 2021 21:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632259685;
        bh=+VctEhIjE1yGqzGUb7S3FGrzQau03G7kRtjnF9SGwPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=glv8fdhh2skNx/G8krXtlnZapQD0ItUgLjYctG+d1f8L976TpklQOetEWtc1ibgks
         a2zYz9CyVopH33I4a2hiZETMEClke3wb7IwA4h7vMQnZUy3FAZqmWlwkCbuFCGbFPY
         WjlrP97l5cFWN+J4tFzmhgFNvbsrG++p83xIc/TrisbsqUz32tAqodOdrI2n4K2ov3
         BAo7TEhCWhjXkEDulykysCgHIQLGs13NXPjL0Y/WwBe3nbC8kqAHIsYlAoFfqPQdcR
         LLeD9cRr/xcpHGLZGFlXRh9CRufuRTFSYXJnUtfKUx5ehsAZhvXsUae5EIwwF2urlO
         84ql/m2Cixq2A==
Date:   Tue, 21 Sep 2021 14:28:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
Message-ID: <20210921142803.125d4c6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMuHMdX1ZjLFjE5oH7usz5mGPKPBy+qvvt4fN=wUw-BHOBiVqA@mail.gmail.com>
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
        <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com>
        <20210920121523.7da6f53d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANP3RGd5Hiwvx1W=UOCY166MUpLP38u5V6=zJR9c=FPAR52ubg@mail.gmail.com>
        <CAMuHMdX1ZjLFjE5oH7usz5mGPKPBy+qvvt4fN=wUw-BHOBiVqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 09:30:34 +0200 Geert Uytterhoeven wrote:
> > The problem is CDCETHER (ECM) tries to be a generic driver that just
> > works for USB standards compliant generic hardware...
> > (similarly the EEM/NCM drivers)
> >
> > There shouldn't be a 'subdriver'  
> 
> If it does not make any sense to disable USB_RTL8153_ECM if CDCETHER
> is enabled, perhaps the option should just be removed?

And when we say "removed" we can just hide it from what's prompted 
to the user (whatever such internal options are called)? I believe 
this way we don't bring back Marek's complaint.
