Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0206410C459
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 08:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfK1Hhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 02:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfK1Hhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 02:37:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E934215F2;
        Thu, 28 Nov 2019 07:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574926672;
        bh=E6ooghBPKODRSq+Df3l6R0vCJz+fINANfaRvtCLidgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYxr13D76ia0vGFJAA9r8RFYht5xr4SZ7SJsmMAsuAugeQW6NQ9ZMxMogUtdV8jar
         Nh4m54rd1gXwvgqSt9f/1RhYFAwvoxRBD/EJx3sMAt0rQLBtCRU5qwtYAGUt21VR7D
         NZ/FdMEcSuI/reLw4ZgQr+N+QqRx3RRnqP7J9Nlw=
Date:   Thu, 28 Nov 2019 08:35:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
Message-ID: <20191128073514.GC3317872@kroah.com>
References: <20191127203049.431810767@linuxfoundation.org>
 <CA+G9fYtFNKTYiqm0Bvk_nqBTjsRMKTtNxr6PhE8YaDXFjqwhYQ@mail.gmail.com>
 <CA+G9fYsuM-ALP_EtoFEzJiia26QnUvuKWsH0b-vi43Sp++es6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsuM-ALP_EtoFEzJiia26QnUvuKWsH0b-vi43Sp++es6A@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 11:51:37AM +0530, Naresh Kamboju wrote:
> Hi Greg,
> 
> > Kernel BUG noticed on x86_64 device while booting 4.14.157-rc1 kernel.
> 
> 
> The problematic patch is,
> >> Jouni Hogander <jouni.hogander@unikie.com>
> >>    net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> 
> And this kernel panic is been fixed by below patch,
> 
> commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Nov 20 19:19:07 2019 -0800
> 
>     net-sysfs: fix netdev_queue_add_kobject() breakage
> 
>     kobject_put() should only be called in error path.
> 
>     Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
> rx|netdev_queue_add_kobject")
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
>     Cc: Jouni Hogander <jouni.hogander@unikie.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks for the report, will go queue it up now.

greg k-h
