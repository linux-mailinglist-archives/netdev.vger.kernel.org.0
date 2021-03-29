Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6C434C2F7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 07:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhC2FRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 01:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhC2FRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 01:17:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A812061574;
        Mon, 29 Mar 2021 05:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616995030;
        bh=xs2zQQdJZtFj0Mb1oKtGsqD7vXLzWUoN5+2XWFSYZBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjDHnmrUYuWim5sz/hYiyJLGcfOYB/yR+G3B/Fp0pK+nsKaykXmibCGYcRSqnirW9
         02JH4KxLUUpBtxKpUlDTY79wgY/MLBt3+W5IPN86IgqmNYdm4vZGHZsFECbXhsdb1s
         YbVvZacfHi51Si9InSe6wGayGo1I8kjpzWukOwcesKIFfhhvS41S5yfEfJO5O64z2y
         DsAR0VEQaEnF8BqEh/lwX6/7+8LUs14Np7crJh9sLb7hikuPFdAbFgMdCkFF5ZKm02
         1qzLMSGV96BieiMAebRbYBQy0qN7OXeGvEo98aPmfjo1TgjvCDn5hyhzRzSW1JkoOw
         uXUp/QoZCvw2Q==
Date:   Mon, 29 Mar 2021 08:17:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <YGFi0uIfavNsXhfs@unreal>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 02:26:21PM +0200, Greg Kroah-Hartman wrote:
> There does not seem to be any developers willing to maintain the
> net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> from the kernel tree entirely in a few kernel releases if no one steps
> up to maintain it.
> 
> Reported-by: Matthew Wilcox <willy@infradead.org>
> Cc: Du Cheng <ducheng2@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Greg,

Why don't you simply delete it like other code that is not maintained?

Thanks
