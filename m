Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B9439AA26
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 20:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFCSi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 14:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCSi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 14:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2197B613D7;
        Thu,  3 Jun 2021 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622745402;
        bh=FwhSCnFU0UJW2nRbWaqzvrhP+56z8E67kW2nPD73Yz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PCSfGVR5MIP2734dt3tsc1wkIpv2avXJCGZ7wQkCN/71MeuQSzy/scHwUgS5DRlhe
         bQbqrfnM3K/bv3Ohh+kgKdHnYWVIZ+i+Q0bWAAH4myZ0Ha+ExXYzmF3bHUKQKT/m1v
         /gVyZhATL/V+i694vAdzjvfHnwR/jys1fXM3sSYY=
Date:   Thu, 3 Jun 2021 20:36:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SyzScope <syzscope@gmail.com>
Cc:     syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YLkhOFPU5mb5vspm@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <c40de1fa-c152-4c94-041a-7e014085c66e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40de1fa-c152-4c94-041a-7e014085c66e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 11:30:08AM -0700, SyzScope wrote:
> Hi developers,
> 
> Besides the control flow hijacking primitive we sent before, we managed to
> discover an additional double free primitive in this bug, making this bug
> even more dangerous.
> 
> We created a web page with detailed descriptions: https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-hci_chan_del
> 
> We understand that creating a patch can be time-consuming and there is
> probably a long list of bugs pending fixes. We hope that our security
> analysis can enable an informed decision on which bugs to fix first
> (prioritization).
> 
> Since the bug has been on syzbot for over ten months (first found on
> 08-03-2020 and still can be triggered on 05-08-2021), it is best to have the
> bug fixed early enough to avoid it being weaponized.

Wonderful, please help out by sending a fix for this.

thanks,

greg k-h
