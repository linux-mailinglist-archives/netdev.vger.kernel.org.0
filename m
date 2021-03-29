Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF3E34D6E2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhC2SUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230374AbhC2SU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 14:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CBBF6191F;
        Mon, 29 Mar 2021 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617042028;
        bh=zRuAiebII2KdhJ0CV598cE62FQdR/vx99IFJ0oPvQ3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ex7fhcBNQp5BqBdLmRdbVuSv/ixMj/G/O6RawGlApk2B5MqoF0J2dyH/HLlItzUWv
         qNjdl5utGFf6QJ65CLYeTJV8ibUtMO+aQzdUBe7tHWB9T1ByoJN/v0hPfn32cWKr6c
         3nE9i1UbO91g/NAQFYSjgxZviu1Fb8loUK5Qn0+Y=
Date:   Mon, 29 Mar 2021 20:20:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alaa Emad <alaaemadhossney.ae@gmail.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: Re: [PATCH] wireless/nl80211.c: fix uninitialized variable
Message-ID: <YGIaaezqxNmhVcmn@kroah.com>
References: <20210329163036.135761-1-alaaemadhossney.ae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329163036.135761-1-alaaemadhossney.ae@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 06:30:36PM +0200, Alaa Emad wrote:
> Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
> Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>

You need to provide some changelog text here, I know I can not take
patches without that, maybe the wireless maintainer is more flexible :)

thanks,

greg k-h
