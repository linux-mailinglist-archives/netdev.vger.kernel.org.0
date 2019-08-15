Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FEC8EDBD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbfHOOJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbfHOOJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 10:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0255E206C2;
        Thu, 15 Aug 2019 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565878169;
        bh=qI9h9nBCGYM6wxrHHdZIKSZlkvciJpvGgpMj+MRLCSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OalJt220U2hUSNlPq12VGjCDakEekU3+4/YWFOMP0atX2xS6NyFkIvs4Q64MNaZDa
         ChiObKL5AMXAwJPzL+lDCeJpkGasdkfCm2fAVlE2Z/1Ew9/fi+gQ8d594gtmwMabub
         ZavpkNoPwTQFrM+Exxh9gTv1vIN+JKFZO8TnPWrk=
Date:   Thu, 15 Aug 2019 16:09:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v5 10/18] compat_ioctl: move SIOCOUTQ out of
 compat_ioctl.c
Message-ID: <20190815140927.GA23267@kroah.com>
References: <20190814204259.120942-1-arnd@arndb.de>
 <20190814205521.122180-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814205521.122180-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:54:45PM +0200, Arnd Bergmann wrote:
> All users of this call are in socket or tty code, so handling
> it there means we can avoid the table entry in fs/compat_ioctl.c.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/tty/tty_io.c | 1 +
>  fs/compat_ioctl.c    | 2 --
>  net/socket.c         | 2 ++
>  3 files changed, 3 insertions(+), 2 deletions(-)a

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
