Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60079C8CCF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfJBPYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfJBPYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 11:24:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35CAC21848;
        Wed,  2 Oct 2019 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570029840;
        bh=vnShoyAAwy0G7Ur6m2l39KMZHCAx71ZotdUc9wWJ7to=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3dZT2aYbkrgG5xyhudAgpq2WS/+QwCl9wW4amF0xrQqy+bFnaFnFt6bk3B7eAZLH
         fSttMQTf57XCDstVnz0KMBlyH9KhCUeDPoX4caXCL/XHxYs5XJmUMLhYGmOp9wXvKt
         MbZkD6YEW0P2hchHzN7WoO/v44xrx061fT4FX6PM=
Date:   Wed, 2 Oct 2019 17:23:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        Frank Iwanitz <friw@hms-networks.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 3/5] staging: fieldbus core: add support for device
 configuration
Message-ID: <20191002152358.GA1748000@kroah.com>
References: <20190918183552.28959-1-TheSven73@gmail.com>
 <20190918183552.28959-4-TheSven73@gmail.com>
 <20190930140621.GB2280096@kroah.com>
 <CAGngYiXWF-qwTiC95oUQobYRwuruZ6Uu7USwPRqhhyw-mogv7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiXWF-qwTiC95oUQobYRwuruZ6Uu7USwPRqhhyw-mogv7w@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 11:07:47AM -0400, Sven Van Asbroeck wrote:
> On Mon, Sep 30, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Why is a new way of doing configuration needed here?  What does this
> > provide that the current code doesn't already do?
> 
> The fieldbus core doesn't have a configuration mechanism yet. This
> patch adds one.
> I deliberately omitted configuration when the core was added - I wanted to keep
> complexity to a minimum. I'm sorry I didn't make this clearer.
> 
> As a result, the current core can only work with cards that either don't require
> any config, or get it straight from the network/PLC. Profinet is a good example
> of this. Most cards do require config however. So does the hms flnet card, which
> I tried to add in the patchset.

If the code works with some subset now, then why not work to get this
cleaned up properly and out of staging and then add new features like
this type of configuration system afterward?

Why is this a requirement to add while the code is in staging?

thanks,

greg k-h
