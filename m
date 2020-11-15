Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B362B318C
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKOALE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOALE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:11:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEE7D24178;
        Sun, 15 Nov 2020 00:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605399063;
        bh=ausyRdwkTHyIJR+09uzrUUTP/tY+6qBd1l9h80mbEYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQ/fk40HgEk7wSLf7Cv5b25KlHrdGKqzG2ZEW0vX3qTmwlVJ2D/dhQrU4qMSstcdG
         Bu/qWjxb3s55sHzkF59Jz9KbSBVbyhi56hCAQuFZbNVqXcck2c0+xL+0Lbhc6tkCkC
         4t1zjmNtPbvooCoF/XWpuLNyJ7jOiKwcXFypS2zA=
Date:   Sat, 14 Nov 2020 16:11:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] tcp: avoid indirect call in
 __sk_stream_memory_free()
Message-ID: <20201114161102.10561023@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113150809.3443527-1-eric.dumazet@gmail.com>
References: <20201113150809.3443527-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 07:08:07 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Small improvement for CONFIG_RETPOLINE=y, when dealing with TCP sockets.

Applied, thank you!
