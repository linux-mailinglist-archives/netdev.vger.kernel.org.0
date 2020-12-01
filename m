Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CFF2CB0C6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 00:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgLAX3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 18:29:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgLAX3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 18:29:41 -0500
Date:   Tue, 1 Dec 2020 15:28:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606865340;
        bh=blo93ZjCWj28XI7NruL8kZHVQl0f9ekNLlcAo04n8as=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=rAdAmEp1qoufLSejL1OCxGfxZ7Fy1pLIHiqJRhbAJ8HoLsksazm51w0CYS0FFpKrT
         m4YTEQO/7Y7JXfd8dj/Mk8NDlM5lWKUAEzty2GTlgb+gGFMpt1zyqZqOQGbGOgZzmF
         uV9Kta8oy/05V8vQbWISXVYjkU461boSW9AJjUpg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: Re: [net] tipc: fix incompatible mtu of transmission
Message-ID: <20201201152858.4346db6f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130025544.3602-1-hoang.h.le@dektech.com.au>
References: <20201130025544.3602-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 09:55:44 +0700 Hoang Huu Le wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> In commit 682cd3cf946b6
> ("tipc: confgiure and apply UDP bearer MTU on running links"), we
> introduced a function to change UDP bearer MTU and applied this new value
> across existing per-link. However, we did not apply this new MTU value at
> node level. This lead to packet dropped at link level if its size is
> greater than new MTU value.
> 
> To fix this issue, we also apply this new MTU value for node level.
> 
> Fixes: 682cd3cf946b6 ("tipc: confgiure and apply UDP bearer MTU on running links")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied, thanks!
