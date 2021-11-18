Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4051455394
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 04:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbhKREBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241854AbhKREBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:01:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A70B161269;
        Thu, 18 Nov 2021 03:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637207930;
        bh=PeT3h6587hPciMpeoH24VLeE8g8L+2AhtHuJfh0VoSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=glxqKAO60AsBcU9Ql2Lz3V1VGHtLIGhC7EQvsIucAWa0Xk4xhqlfZLq5PLm0VU3y8
         pEKEY+8o4lQKVSb+GFYwDGIpmSL25imFkmNZfQ3vysl39yTq4r/8Wkb54YRtagW4eW
         RV5M1nBegUE+5jNGtqY5wThxk43UakNRZGLCmrfPEC8Ir3GJx2OeG+HEGWVcJixeVW
         8hTWmfNlxPkMGGC+s9dX2l4+o39M9zQJoSlEojvPLoMLOZ79MY4mQYcfeiRW58qpni
         QRWBmcn1vk4sEOpmPUY7R/GhnnCz5qkXvECgb71aaXTmqt6fNxnQYM8RLvdDor1psj
         6s+5IM+oPhOlA==
Date:   Wed, 17 Nov 2021 19:58:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhangyue <zhangyue1@kylinos.cn>
Cc:     davem@davemloft.net, jesse.brandeburg@intel.com,
        gregkh@linuxfoundation.org, ecree@solarflare.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: de4x5: fix the problem that the array
 'lp->phy[8]' may be out of bound
Message-ID: <20211117195848.6bb56a84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211113212921.356392-1-zhangyue1@kylinos.cn>
References: <20211113212921.356392-1-zhangyue1@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Nov 2021 05:29:21 +0800 zhangyue wrote:
> In line 5001, if all id in the array 'lp->phy[8]' is not 0, when the
> 'for' end, the 'k' is 8.
> 
> At this time, the array 'lp->phy[8]' may be out of bound.
> 
> Signed-off-by: zhangyue <zhangyue1@kylinos.cn>

Please fix the date on your system and repost.
