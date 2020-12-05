Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67492CF8A7
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgLEBg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgLEBg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:36:27 -0500
Date:   Fri, 4 Dec 2020 17:35:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607132146;
        bh=PPcbi5kX48lAnAAV42n3Mn52LYVn0f8jItBLvb+bZII=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=u8B9SkUiRZadiolQHVsajYqJO5u6vlsGcQ4jPMbb4dhEfVxK/l3s10KKizI73VoF7
         5qKxQDpEgcLuFxmbdMzn0aPVV12+/rWXqQf06xp4aM3+M1xPaxdQevy14PLTPjsuMS
         FZWMpFrFDysxGV/20ZUdv/OvLCAgEHc3lFsPTswPrwuHncu3aPb7Dz+2tcFvg4gc6w
         Xm2dAQ053ZWHn/wyImoa7+M//1NTvLfBqBQr4F3JouKTlw603CNkwJTBYfpqEYb6aE
         MBy1vMvQr7geXdG5uO+raZ0CScWTqEr5Bv6xnkv4FHySvK5mstrZKBcBv2HYbjTMLK
         ndDS7BJ+bzAsQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net] mac80211: mesh: fix mesh_pathtbl_init() error path
Message-ID: <20201204173545.767203e9@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <03b6e1ab6d4d51f2a3dde7439fbc24c8a9a930c6.camel@sipsolutions.net>
References: <20201204162428.2583119-1-eric.dumazet@gmail.com>
        <03b6e1ab6d4d51f2a3dde7439fbc24c8a9a930c6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 17:29:39 +0100 Johannes Berg wrote:
> On Fri, 2020-12-04 at 08:24 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
> > while tbl_path rhashtable has not yet been initialized, which causes
> > panics.
> > 
> > Simply factorize the rhashtable_init() call into mesh_table_alloc()

> > Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>  
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Jakub, if you want to take it to the net tree I wouldn't mind at all,
> since I _just_ sent a pull request a little while ago.

Sure thing. 

Applied, thanks!
