Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54AE36B0BB
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhDZJgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232685AbhDZJgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7EF46103E;
        Mon, 26 Apr 2021 09:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619429735;
        bh=bLpWGYOQ2/M+ci5Sjuq25051I+IODYqeokzOZ36nF9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELRro1aqNRHwkv3KvqoNQ0Rl3kdWm1zeHFWfKZE/H7+mNlU5SwEghQ1xYhwZ+/eOA
         HYDFfGeY5F5VBxvyMppJrxg11d/jo9T6Q91CEyOKSfIGtUMh08bIadA6ryO7AFMRa0
         RKJnBILHgbUg64CjoqoTgoS/lTF2ZNuM/fN3mABK1BqoAMM8TM0sIhJmqaxc+frkoT
         ZGhq6gntykkgXryFV6+2StcDX//W4x02FczsLjHnzID4r+rn6VHSolBeybt93RGD3T
         BHCWEecm+AL9UXBvlenkpQOJlAfqYGE8lDg7lLbHhFYWMXMJWa4gfzx+3hGpKwtGGL
         gOyymuXHDar6w==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1laxec-00045S-7F; Mon, 26 Apr 2021 11:35:46 +0200
Date:   Mon, 26 Apr 2021 11:35:46 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Leonardo Antoniazzi <leoanto@aruba.it>
Cc:     linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix NULL-deref on disconnect regression
Message-ID: <YIaJcgmiJFERvbEF@hovoldconsulting.com>
References: <20210426081149.10498-1-johan@kernel.org>
 <20210426112911.fb3593c3a9ecbabf98a13313@aruba.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426112911.fb3593c3a9ecbabf98a13313@aruba.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:29:11AM +0200, Leonardo Antoniazzi wrote:
> On Mon, 26 Apr 2021 10:11:49 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
> > Commit 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device
> > unregistration") fixed the racy minor allocation reported by syzbot, but
> > introduced an unconditional NULL-pointer dereference on every disconnect
> > instead.
> > 
> > Specifically, the serial device table must no longer be accessed after
> > the minor has been released by hso_serial_tty_unregister().
> > 
> > Fixes: 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device unregistration")
> > Cc: stable@vger.kernel.org
> > Cc: Anirudh Rayabharam <mail@anirudhrb.com>
> > Reported-by: Leonardo Antoniazzi <leoanto@aruba.it>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---

> the patch fix the problem

Thanks for confirming.

Next time, please keep the CC list intact when replying so that everyone
sees that you've tested it.

Johan
