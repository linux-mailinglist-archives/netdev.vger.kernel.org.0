Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E12D3346
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgLHUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbgLHUPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:15:07 -0500
Date:   Tue, 8 Dec 2020 10:57:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607453835;
        bh=nUQD3ATbGAfmHiRoZYcfIqfnV4nRrf3bRKgqa0XzXgo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qfJBwJoAjDEvdD4t1uBWoO9l9yk0+lTeQXjRHsu5TU6VFhS439bBI7ctgxdFXW/2O
         24INnAV61p4JweFouLiUWDTvdxtA8kKF0V0u6TZMpDDKhVzONnablH0nYCFekAasL+
         wRyvKv/+Vammh/I5sWMaqaGrff+bavZRhs1S5AVSG51TJSUjCoK5f3DRTYYjF4iAVv
         jZ7LCXjfWnKn8wOr50Qk3NbucgQsq/xCBH9qUNqp86UFdoU/btPAWvKKwkt0Gq15Un
         EZrKVE5ksuhhWusMboK/B+zKO536kq29bXVLYwpKghh2Ri9jeY14KECCW6l2z2Rwji
         LZC6nKKP6r2Sg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell
 Prestera Ethernet Switch driver
Message-ID: <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
        <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
        <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 08:39:17 -0800 Jakub Kicinski wrote:
> On Tue, 8 Dec 2020 09:22:52 +0000 Mickey Rachamim wrote:
> > > > +S:	Supported
> > > > +W:	http://www.marvell.com    
> > > 
> > > The website entry is for a project-specific website. If you have a link to a site with open resources about the chips/driver that'd be great, otherwise please drop it. Also https is expected these days ;)    
> > 
> > Can I placed here the Github project link?
> > https://github.com/Marvell-switching/switchdev-prestera  
> 
> Yes!

Actually, what's the relationship of the code in this repo with the
upstream code? Is this your queue of changes you plan to upstream?
The lack of commit history is suspicious.
