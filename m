Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235BD36AF64
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhDZIAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhDZIAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 04:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AD16105A;
        Mon, 26 Apr 2021 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619423982;
        bh=+2O4A36yPwK7BKEhZw/DxclUvVORbj/dAxbiPIB2zUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svtSjMEGip4pEdp2QNNz6mWuh9qgWOBHDFclADT6KvDQDEHkeV4SKz0JJWLVBOMOa
         ZHYX/nKyHEXPdGyc5YhdVZfrm29y2CNt5Bg7MxuiPtvz9t8Uvd7ULU5pcvKWIgsWLk
         +BRi981A/n432hG9geR0LSdfRphDamG6p84Sswqis93Mg3O77agZ26SBDH36m7ky0O
         qfLFTHuSEEEq7KrUx8rr2QBEpqaWOhEoXkcdlbq6z5ABfoUEjckrqaV7DKD5zUT+CJ
         CaX+pAXPJztxA00ox+Tv5EFeYqDgUBEptq5cV1bMNdbZO0QcEmL2LBkHq1c22+w2iI
         oMdSPV7QtB3DQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1law9n-0001e2-0i; Mon, 26 Apr 2021 09:59:52 +0200
Date:   Mon, 26 Apr 2021 09:59:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leonardo Antoniazzi <leoanto@aruba.it>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: hso driver kernel NULL pointer dereference
Message-ID: <YIZy96hlzl6Z/Gwv@hovoldconsulting.com>
References: <20210425233509.9ce29da49037e1a421000bdd@aruba.it>
 <YIZsnF7FqeQ+eDM0@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIZsnF7FqeQ+eDM0@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:32:44AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Apr 25, 2021 at 11:35:09PM +0200, Leonardo Antoniazzi wrote:
> > Hello,
> > removing my usb-modem (option icon 226) i get this oops (i attached the dmesg output):
> > 
> > BUG: kernel NULL pointer dereference, address: 0000000000000068
> > 
> > reverting this patch fix the problem on detaching the modem:
> > 
> > https://marc.info/?l=linux-usb&m=161781851805582&w=2
> > 
> > I'm not a developer, i hope the attached dmesg.txt will suffice
> 
> Ick, that's not good.
> 
> Anirudh, can you please look into this as it's caused by 8a12f8836145
> ("net: hso: fix null-ptr-deref during tty device unregistration") which
> is merged into 5.12.

I found the bug. Patch coming.

Johan
