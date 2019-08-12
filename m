Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878388A6BA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfHLTBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfHLTBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 15:01:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82EB320679;
        Mon, 12 Aug 2019 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565636491;
        bh=Cs2oMB53k2wKFOnhQE2Y5U59oiCCpOdSLCO/UYkCXgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGkzINWGORCuiHLQtyEKzlojXFUxhSn0iYYWnnbJzP8P914Z6srb0Tiy6Xwh9+8tF
         0K/cr0Ni1p9QWLZ9rD6885rpwvMC7jNTGbdCmwX7F2b+8oL28AA5sIGs8Jlmi/b+EZ
         3nyw6LcN3jQAUODuTnwIUkFHo2UVUSdIwdUbAVVc=
Date:   Mon, 12 Aug 2019 21:01:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 13/17] mvpp2: no need to check return value of
 debugfs_create functions
Message-ID: <20190812190128.GB14905@kroah.com>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
 <20190810101732.26612-14-gregkh@linuxfoundation.org>
 <CAKwvOdnP4OU9g_ebjnT=r1WcGRvsFsgv3NbguhFKOtt8RWNHwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnP4OU9g_ebjnT=r1WcGRvsFsgv3NbguhFKOtt8RWNHwA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 10:55:51AM -0700, Nick Desaulniers wrote:
> On Sat, Aug 10, 2019 at 3:17 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> 
> Maybe adding this recommendation to the comment block above the
> definition of debugfs_create_dir() in fs/debugfs/inode.c would help
> prevent this issue in the future?  What failure means, and how to
> proceed can be tricky; more documentation can only help in this
> regard.

If it was there, would you have read it?  :)

I'll add it to the list for when I revamp the debugfs documentation that
is already in the kernel, that very few people actually read...

thanks,

greg k-h
