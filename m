Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72823D585C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGZKdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhGZKdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7990160184;
        Mon, 26 Jul 2021 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627298050;
        bh=W9GU23h8JqXuVx3Zrr0eWbRa095s4Id54sN23YORlwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0LtcUN6j3/ABTB8fiFXu5VbY6sb7K+qhs/msGmUFewk3CxJJh3DdwXAlJGUUUoOp
         fb55z/YcSBLqTwXklrRL52SslhkYY0ip+Gw7L7cPLn9xZZauK4F/nDlYxsVn7HaoBy
         0Ak5IKZecIyxRsG+57xGmtlq+ssoH/36wwRTFs6c=
Date:   Mon, 26 Jul 2021 13:14:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into
 r8152_main.c and r8152_fw.c
Message-ID: <YP6Y+i5VzZOJjoW7@kroah.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
 <1394712342-15778-373-Taiwan-albertk@realtek.com>
 <YP5mFKeJsGezjdve@kroah.com>
 <c6b44f93a5b14fbb98d4c6cb0ed2a77f@realtek.com>
 <YP50SIgqAEyKWSpA@kroah.com>
 <47801164b7b3406b895be1542e0ce4a2@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47801164b7b3406b895be1542e0ce4a2@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 11:09:06AM +0000, Hayes Wang wrote:
> Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, July 26, 2021 4:37 PM
> [...]
> > You also do other things, like renaming defines, which is not just
> > moving code around, right?
> 
> Yes. You are right.

So resend the series and only do "one thing per patch" please.

> [...]
> > I do not know, is it really easier to find things in 3 different files
> > instead of one?  That's up to you, but you did not say why this change
> > is needed.
> 
> We support a new chip or feature with a test driver.
> The test driver is similar with the upstream driver, except
> the method of the firmware. After we confirm that the
> test driver work fine, we compare the differences with
> the upstream driver and submit patches. And the code
> about firmware takes us more time to find out the
> differences. Therefore, I wish to move the part of
> the firmware out.

Great, then submit the broken up driver as part of a patchset that adds
new device support, as that makes more sense when that happens, right?

thanks,

greg k-h
