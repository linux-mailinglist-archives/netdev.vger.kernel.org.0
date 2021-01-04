Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003072E9FA7
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhADVxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADVxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:53:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28FD62225E;
        Mon,  4 Jan 2021 21:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609797159;
        bh=tWf1KjhleDkzxXSyHtxWS2EXTln3fgr2x+m1gRLWB5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N1aCTHZQS/IBR21UsrjIFxWAqWOgj889QZcW2uuO5qsYHD+2HihbiQRqYhXxYszf2
         eaN67cf9Szmz7glG380QQk8+otTh4mUcDvZnIIhWi1OkOv8jeLheZjyusavIe2cxiX
         flHTR0JS/OUtOOsTLJiZiir/KC/fq4I+ACnwHUtN1Kw3jLNAQ71YyKBnCA/PpomQo7
         +f7jFR3kUQvK+0ajcc1ZuF2cvm/DULCNdC+ILInvdr0USSwHX4otZFN11dXjWxZgGZ
         h0RjkU3yi8z5AfHpllaKHPFrp4TinT81sGvkMBlZRvL4S7k1zhdDMOMP71DvaQC48I
         +t7/xxSMuyBNw==
Date:   Mon, 4 Jan 2021 13:52:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Hauke Mehrtens <hauke@hauke-m.de>,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN
 also for internal PHYs
Message-ID: <20210104135237.064fba8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFBinCD7cOPZf8NpkhpRG2PiuMcjtqwxu7vQQoXULpCBbTCAoA@mail.gmail.com>
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
        <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
        <X/EnSv8gyprpOWRr@lunn.ch>
        <CAFBinCD7cOPZf8NpkhpRG2PiuMcjtqwxu7vQQoXULpCBbTCAoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 Jan 2021 03:12:21 +0100 Martin Blumenstingl wrote:
> Hi Andrew,
> 
> On Sun, Jan 3, 2021 at 3:09 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sun, Jan 03, 2021 at 02:25:43AM +0100, Martin Blumenstingl wrote:  
> > > Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
> > > Without this the PHY link is detected properly and ethtool statistics
> > > for TX are increasing but there's no RX traffic coming in.
> > >
> > > Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> > > Cc: stable@vger.kernel.org  
> >
> > Hi Martin
> >
> > No need to Cc: stable. David or Jakub will handle the backport to
> > stable.  You should however set the subject to [PATCH net 1/2] and
> > base the patches on the net tree, not net-next.  
> do you recommend re-sending these patches and changing the subject?
> the lantiq_gswip.c driver is identical in -net and -net-next and so
> the patch will apply fine in both cases

Resend is pretty much always a safe bet. But since as you said trees 
are identical at the moment I made an exception applied as is :)

Thanks everyone!
