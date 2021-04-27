Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB136BF22
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 08:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhD0GL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 02:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhD0GL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 02:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35F51613B4;
        Tue, 27 Apr 2021 06:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619503874;
        bh=+uKxx7pcWNI1KVq9j120Buam3AqeRoA/M5qay05sy6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O27G2KCDFMyTbKa5QdyfFAD1hFoGuALd39WkENjKHvEbQnGZ7UHx3dfFxBj4zsOif
         vkc1vJEk74jQqaPFQVVJcls1V/2kj00OnKIeqCJpRn+uzFocJ63UYib37xezJJoHQZ
         TK3cTz7A6M71yT5ATejpwuJ6NSrebuPCdUmYf5Eg=
Date:   Tue, 27 Apr 2021 08:11:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     johan@kernel.org, leoanto@aruba.it, linux-usb@vger.kernel.org,
        kuba@kernel.org, mail@anirudhrb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hso: fix NULL-deref on disconnect regression
Message-ID: <YIeq/fjbzqJkjVaH@kroah.com>
References: <20210426112911.fb3593c3a9ecbabf98a13313@aruba.it>
 <YIaJcgmiJFERvbEF@hovoldconsulting.com>
 <YIaM9B/UZ1qHAC9+@kroah.com>
 <20210426.130919.1291678249925211750.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426.130919.1291678249925211750.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 01:09:19PM -0700, David Miller wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Mon, 26 Apr 2021 11:50:44 +0200
> 
> > netdev maintainers, mind if I take this fix through my tree to Linus
> > this week, or can you all get it to him before -rc1 through the
> > networking tree?
> 
> I tossed this into net-next so Linus will see it later this week.

Wonderful, thanks!

greg k-h
