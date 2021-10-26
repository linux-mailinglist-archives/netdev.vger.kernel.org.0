Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6D43A987
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhJZBDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhJZBD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 21:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD76160E73;
        Tue, 26 Oct 2021 01:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635210067;
        bh=caoRHXu5bzhUCS6y0UBJ4+gz8fPPHwkLatuwG55nQ6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PD8vC5LGoH5OiE/3gTPH5Oo1C8ZMefGllU5k+YVS4v5D0AI6SoT71eAXuwcDIsXaQ
         rhFV2MdX3DdG4YkvEA+8pFEY6u8HkyiUo+CNw2wsGwWzVmIT9Xty5j4KSX1ONfmVeA
         xcGxaKuE4nj6HyJrMgW/ZaU1LmhrFxotbD2rYCqV8sQbJpxlTbcwD1/3iGGqkcCz8u
         XtviDRIwlYQkTCIdSYW6FDISNXO0q9F4DuYkz2G+fHL4XAAIxIe95u1tf1KZeRuTIx
         sH3QdvV2luybwyGGFyuJ7JpTPBqCIRKSUOhIuJQF4lUJpXEv17LGGPxn8RHGEN0l2L
         fJ94FjJp/zzRg==
Date:   Mon, 25 Oct 2021 18:01:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Janghyub Seo <jhyub06@gmail.com>
Cc:     nic_swsd@realtek.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Add device 10ec:8162 to driver r8169
Message-ID: <20211025180105.703121f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1635173498973.1185636578.3510859947@gmail.com>
References: <1635173498973.1185636578.3510859947@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 14:55:43 +0000 Janghyub Seo wrote:
> This patch makes the driver r8169 pick up device Realtek Semiconductor Co.
> , Ltd. Device [10ec:8162].
> 
> Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
> Suggested-by: Rushab Shah <rushabshah32@gmail.com>

I'm not 100% clear why but this patch does not apply to neither of the
networking trees. Can you please rebase on top of this tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

And add a '---' after the lspci output, maybe?
