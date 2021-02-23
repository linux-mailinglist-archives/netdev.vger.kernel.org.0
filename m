Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEFF322EDB
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhBWQgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232864AbhBWQgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B201B64E3F;
        Tue, 23 Feb 2021 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614098125;
        bh=L9HuqK32zS9KekX638gNmP4V/5rB4ZvBkb0UiHMMkDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H9C1l68q5dCd5Tsj6mrYMGMI5me0GcuyoMBok6Ak78RV8py72EBKbYARgBA6xXJmm
         iGleudx95lu9XQy8IBRLQE4yygeWfWVHaGIK1pAjnVn40Bi3gQaU3dN4Hlt1EAvcZZ
         n3ZLpIYyPkVcEUyCD/vZOEMeGxT4q+35y4pkDWTT+FobmQu7a22DJYnoqA6dQE/8Ea
         AnZyz5YPMgtJYo7y7737BOZkt8JMuVA+uN89UHcOSSSbmlEtKGvHhjM/i4dcCyerb7
         pk5z5BJRIbAqU5oVd3b7npovculgPDDuHQPKUF8VWf1a7v24LKuNhFSQ/Zo12uHi7S
         nU1aJDcjTY1Kw==
Date:   Tue, 23 Feb 2021 08:35:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netdevsim: fib: remove unneeded semicolon
Message-ID: <20210223083522.6d7156f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614047326-16478-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1614047326-16478-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 10:28:46 +0800 Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:564:2-3: Unneeded semicolon.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 
and therefore net-next is closed for new drivers, features, 
code refactoring and optimizations. We are currently accepting 
bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
