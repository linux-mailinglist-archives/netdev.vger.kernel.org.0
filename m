Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00445DCEF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhKYPMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237127AbhKYPLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:11:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECFC560462;
        Thu, 25 Nov 2021 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637852893;
        bh=vsPAmw0CLfpTTLQZb0v80AqWZdpKrLQESsME3KfzgKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SVcWSE8MRCPIfWXdc9z617CF8W5QqoBs0wh6QdivoMJbZuYVOdQlSvHBPANHXQVXP
         skpFHRPezDw2twBoUr4pY7sTGFNTynd4hLlcOClBl6a8P229zSHKflsY0f632yVq6O
         MPnlGK4mjMXIbMr/rxaCL6rPm9MA369dKO9GB92bh8+G0Dbn6erQb86LRQeD6XQ6mh
         xbdWDf5IAJRoNT7IjGlf22n7/P/fuyw5gaQL/H0OmGxtvTR9Q1yirKi6J2roDK7uA8
         NAf4ZCaGjy8indjGpKQFDC1Q6AwKpZQYwCJNbRA+pxAMqkmvKhJq6500V1EiTzd9qp
         NNE73hQKCSWuA==
Date:   Thu, 25 Nov 2021 07:08:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radha Mohan <mohun106@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sgoutham@marvell.com
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP
 VF devices
Message-ID: <20211125070812.1432d2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
References: <20211125021822.6236-1-radhac@marvell.com>
        <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
        <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 22:00:49 -0800 Radha Mohan wrote:
> On Wed, Nov 24, 2021 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 24 Nov 2021 18:21:04 -0800 Radha Mohan wrote:  
> > > This patch adds netdev interface for SDP VFs. This interface can be used
> > > to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> > > mode.  
> >
> > All your SDP/SDK/management interfaces do not fit into our netdev
> > model of the world and should be removed upstream.  
> 
> SDP is our System DMA Packet Interface which sends/receives network
> packets to NIX block. It is similar to CGX, LBK blocks but only
> difference is the medium being PCIe. So if you have accepted that I
> believe you can accept this as well.

Nope, I have not accepted that. I was just too lazy to send a revert
after it was merged.
