Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1ED230DD5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbgG1Pai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730637AbgG1Pah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:30:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA9CD206D4;
        Tue, 28 Jul 2020 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595950237;
        bh=zemweQXddKbLvL5Mw6dvsBIj/JO81g5ivJX6E4yPUpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DnVfC0myMfSdBeXXDbjcCaDP3MPxQPLx6vreiLqEX55LqEAo4s+RowIkv1f1UgFnO
         b2w+KMbaMUefDBT0zeahrXDxINTkGktbxbrYtI00pvVQNhnqrbFBNY3Evw88dc8v3/
         +q9sEXBmwZIevAUfDBhdAbBk/qkOTF97MoHwjXAQ=
Date:   Tue, 28 Jul 2020 17:30:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
Subject: Re: [PATCH] usb: hso: check for return value in
 hso_serial_common_create()
Message-ID: <20200728153030.GB3656785@kroah.com>
References: <a42328b6-6d45-577f-f605-337b91c19f1a@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a42328b6-6d45-577f-f605-337b91c19f1a@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 03:19:00PM +0200, Markus Elfring wrote:
> > in case of an error tty_register_device_attr() returns ERR_PTR(),
> > add IS_ERR() check
> 
> I suggest to improve this change description a bit.
> 
> Will the tag “Fixes” become helpful for the commit message?
> 
> 
> …
> > +++ b/drivers/net/usb/hso.c
> …
> > @@ -2311,6 +2313,7 @@  static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
> >  	return 0;
> >  exit:
> >  	hso_serial_tty_unregister(serial);
> > +exit2:
> >  	hso_serial_common_free(serial);
> >  	return -1;
> >  }
> 
> Can other labels (like “unregister_serial” and “free_serial”) be preferred here?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?id=92ed301919932f777713b9172e525674157e983d#n485
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
