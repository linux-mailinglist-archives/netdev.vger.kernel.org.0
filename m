Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55798337F27
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhCKUjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhCKUit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:38:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FAA64F87;
        Thu, 11 Mar 2021 20:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495129;
        bh=8qk+t4Se0OgXakD2pLBQ6PuuOIhC1+z3sY3KxjsZ2iA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tiJgX7enU7AVwQZk8qoVZjyvvExd/IRN4gxnf3NnoIxwNWGvhMBL06jihQw+ULRaM
         zTRwPFEVTk34naMObUzC5q/z2JKv+OSsN7ShuAXwxjnf+mp9pHdVpj/9mS7eJkM5H7
         7xNrrweWNgZVSXSUcL88IJCYe/WKe5jCbGbmU+PMQy8hyOYpBjl2FXDyF9t9slRz/z
         b+Ty4onGKF0l9jRh3d4RGHUMUf/w0ndkE1lpO017vTOYQTPLfKA3Ab7CwDdg6Ol2Y2
         LiLk1qgp55asAgGneg7VEzOFtcoyammYUQZgQg9Khq2B+qA+aoLVSJsjVHDobYLpuI
         awNGgV9ww6yzw==
Date:   Thu, 11 Mar 2021 12:38:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netdevsim: fib: Remove redundant code
Message-ID: <20210311123848.0af494b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615446661-67765-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615446661-67765-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 15:11:01 +0800 Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:874:5-8: Unneeded variable: "err". Return
> "0" on line 889.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
