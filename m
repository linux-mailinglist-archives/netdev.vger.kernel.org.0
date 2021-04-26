Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7736BA8F
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbhDZUKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 16:10:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35800 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241724AbhDZUKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 16:10:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C73E84F48ADC4;
        Mon, 26 Apr 2021 13:09:23 -0700 (PDT)
Date:   Mon, 26 Apr 2021 13:09:19 -0700 (PDT)
Message-Id: <20210426.130919.1291678249925211750.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     johan@kernel.org, leoanto@aruba.it, linux-usb@vger.kernel.org,
        kuba@kernel.org, mail@anirudhrb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix NULL-deref on disconnect regression
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YIaM9B/UZ1qHAC9+@kroah.com>
References: <20210426112911.fb3593c3a9ecbabf98a13313@aruba.it>
        <YIaJcgmiJFERvbEF@hovoldconsulting.com>
        <YIaM9B/UZ1qHAC9+@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 26 Apr 2021 13:09:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 26 Apr 2021 11:50:44 +0200

> netdev maintainers, mind if I take this fix through my tree to Linus
> this week, or can you all get it to him before -rc1 through the
> networking tree?

I tossed this into net-next so Linus will see it later this week.

Thanks.
