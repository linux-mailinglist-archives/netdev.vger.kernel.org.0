Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E482EFD29
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAIClf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:41:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbhAIClf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 21:41:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB311239EB;
        Sat,  9 Jan 2021 02:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610160055;
        bh=cHcFvxtzAFOh5n8TN+hpeR6fYCB03Y/pklIAQantVYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dWytxbSP78Js3bIdomR0+J3dwQZc1ZgqvgjQdCm7I8jvdRJr+AMHv9p0ZXEKM+9IB
         Ggiu6BnORyUfgyyx0HKLLOwr+Ost7CDrXKFYknEx+g77Qsp7rRj2CJec2QYtQdvH6G
         E/taCVWj56UT3/E/4lUjko/ZY0WBd52z7mAFU1/4u71iGjmB5FQZcqKeJ/WXrxRKaO
         BChqIqNzywfsC4/82bpuLQH/JGcoHZqgdy4O22/pEu1wFpAiv2Z2i3h+6g++TvI2Rr
         IZJd3fRPX8H2LYZrtDE9DKOBUuQgOxn/xzzsiO7w++WyAtUSvl2wlK6jIve6MaxXwN
         QSTLSjpOPPNIA==
Date:   Fri, 8 Jan 2021 18:40:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Update register/bit definitions in the
 EtherAVB driver
Message-ID: <20210108184054.6d748229@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
References: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 23:30:42 +0300 Sergey Shtylyov wrote:
> Here are 2 patches against DaveM's 'net-next' repo. I'm updating the driver to match
> the recent R-Car gen2/3 manuals...

Applied, thanks, but I dropped the Fixes tag from patch 1.
Patch which makes no functional changes can't be fixing things.
