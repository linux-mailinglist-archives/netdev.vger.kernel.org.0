Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64C92DC744
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388827AbgLPTed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbgLPTed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:34:33 -0500
Date:   Wed, 16 Dec 2020 11:33:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608147232;
        bh=5Lzz8tRYfQwB4rVb32akD3yWxvXIMSF5hiYECebvzzQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xj3m0EvYHP3WTxGNjE1kcthhiLAqrtDZ8jMrjIkkonRb+22znbn2T0yX4TboReY9W
         OvgcVUVzU9SafXjA19yszQjqbAj9LI8ntbKjv5Z8GyHPuKu4+4kQ8LR6bWjD7Tnsei
         f3uNevBcdMZMLsjX/O+vO6AnZ3HKqVVGKb3oufNAgzj/oyQodM3cr6eNwV0pvuLuIL
         yDpYuSFCHWqDlVsn9KchwBN6Kw1NFoKCKB9wTKldh60Ja2kXRhe+WMhSoLa+OXddxr
         a6cTv6cDvPfL9isz6iCmjco2K2AaVOI6nW3xHNr7DiSabxyUmE14Lpzhra2g9pm9Zt
         WNLRdrnFexQKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, andriin@fb.com,
        jiri@mellanox.com, edumazet@google.com, ap420073@gmail.com,
        bjorn.topel@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: fix msleep() is not accurate
Message-ID: <20201216113350.50c3bb67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1607997865-3437-1-git-send-email-yejune.deng@gmail.com>
References: <1607997865-3437-1-git-send-email-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 10:04:25 +0800 Yejune Deng wrote:
> See Documentation/timers/timers-howto.rst, msleep() is not
> for (1ms - 20ms), use usleep_range() instead.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
