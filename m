Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084DA3EACD4
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhHLWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhHLWAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 18:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A8716108C;
        Thu, 12 Aug 2021 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628805592;
        bh=32FuaZIJIUtaOGXlZhQ7pZnzf1aI/WCGKnrNHC1P9g8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qBynKEjwEn8ejtYw5LuYlWFmAMNPX+WKDPzYCECw5btj8UL9EikQpBV19qLWkk2FZ
         9EDxn252Cri4Zs+ikkUQbpEQdpAadvttApNeSJY4Pf5LXvljHjYxc5TlrdQ29vCPwi
         LJO4kWkxZTZsU8wonbtWB61lkIHIlDkEgKC3q+MeAgJvpfXpGAuG/25vEZG/RTRA5q
         sb4AIKVqNjfIj9OVWTdVA91ZUrWI21RP85DFwOzBokHPLh18f8GAN/0AhB/D7SRpBY
         KOrCFRfxw5l05Zkzrjxyr8vyeEHk8QMdUR+EdvZlF5qHurXBJfuknTPay3BJfczizl
         Myj936pXAC7Mw==
Date:   Thu, 12 Aug 2021 14:59:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 2/3] ptp: ocp: Fix error path for
 pci_ocp_device_init()
Message-ID: <20210812145951.6e5c62f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811183133.186721-3-jonathan.lemon@gmail.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
        <20210811183133.186721-3-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 11:31:32 -0700 Jonathan Lemon wrote:
> If ptp_ocp_device_init() fails, pci_disable_device() is skipped.
> Fix the error handling so this case is covered.  Update ptp_ocp_remove()
> so the normal exit path is identical.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Fixes tag would be useful on this and previous patch to make it clear
the problems are only present in net-next.
