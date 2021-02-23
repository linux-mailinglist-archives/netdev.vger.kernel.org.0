Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEBC32234A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 01:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhBWAqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 19:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhBWAqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 19:46:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94FD64E25;
        Tue, 23 Feb 2021 00:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614041122;
        bh=gs4GQhZlaip1wTjwET9+4lWhwEf6KzHGllJS6WHQghY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p+eB3XgKMjliTcZWmP3PhYLB9eOB9/zwCVsWtEtnHZpsucGH50inKrxFtPucPCijw
         NYfouZbEbfbUk39OkCHgSHk+xaE4Hf9+zFC1F+DHUFdFIySgRd6JawOnXanx1zscV1
         nAPv1TZnjC+0l7ogCPY7tW0TAHwwCNKIZkcxSlgZ74Ayg33r/jzg0BzlCSaV443dNF
         zyu2aK8zr1kNTDUx/uXDFdmqWbf2EZOrZsWZs9OLVbf7udpZ4wPRxwW1wAPbrOb2JV
         i4RGAlFK19R08P4j2FC1FiqAK70pNFfavHnISk/TsDj/8wegWAH9JyUoCi47+TXSsl
         oWP/vtZkyQyyQ==
Date:   Mon, 22 Feb 2021 16:45:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     dingsenjie@163.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: Re: [PATCH] ethernet/microchip:remove unneeded variable: "ret"
Message-ID: <20210222164519.73126611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222025818.18304-1-dingsenjie@163.com>
References: <20210222025818.18304-1-dingsenjie@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 10:58:18 +0800 dingsenjie@163.com wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> remove unneeded variable: "ret".
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
