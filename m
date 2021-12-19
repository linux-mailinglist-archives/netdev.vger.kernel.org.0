Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01CC47A17D
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 18:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhLSRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 12:17:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34104 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhLSRRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 12:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BKWAYL47JFJaZRS92IGpz1iysGkYA5br3xDiNdelryc=; b=XvA8Eai5KBxdkRvX10go2bQv6g
        n++5ziNpBAGpXgP8B3nxp6MD/6dW1OgqFHncHmJfa6OytbDP1LJecsBX3cfu/EMfhl4w8P2xoLUt1
        7VqdnsJOCzbu0Fx0ktu0yBE2qib3nxIqLTcPOiyWN3+OM7Nbnsaz2kvbCxZENtnLzA4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1myzoI-00Gy8y-Jr; Sun, 19 Dec 2021 18:17:22 +0100
Date:   Sun, 19 Dec 2021 18:17:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@rempel-privat.de, netdev@vger.kernel.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
Message-ID: <Yb9pIs2nmm8oEViQ@lunn.ch>
References: <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
 <000000000000e99dbc05d3755514@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e99dbc05d3755514@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 05:03:09PM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com

So it looks like you were right. But maybe ret < sizeof(smsr) would be
better?

	Andrew
