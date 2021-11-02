Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8027442FEC
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhKBONc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231433AbhKBONa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 10:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 627D861076;
        Tue,  2 Nov 2021 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635862255;
        bh=2CmondGJVaZHwBo/EQ7aruC3PEID6CW7T6gHHOD3VP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V0iRgECp3jK+KMMGzfi5fKDUbaQdzl5BU2W9lVtUtgBmU9055TbVnSCNYhw5wPkhF
         IldN2Sjztoe+MNG9FpSN1gOr9V4Or/BDOGPneMT0KkRXkE1vQnroLxBUTCQJMWUJVS
         Q0kBPqqmeXwXxDfJr6mGjWftMZJNjmrDlbDWHMBgT+Y5gygNISWUxQBg1yyuWHNY70
         dm3nfz7glcX4u81Q2JzbnU+vZ8mmcMP9hw6QF430W+fUr1x6cQ+FOWoDPlnA7kEKvi
         1yBJnpmOrBPXN4zlxiksRCYfhQYFmmaiYUj+m7vJFw7pYlJkzMPYM4PlqsSWopjQ6t
         qdk0MdjT5KB8Q==
Date:   Tue, 2 Nov 2021 07:10:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keescook@chromium.org, kvalo@codeaurora.org,
        miriam.rachel.korenblit@intel.com
Subject: Re: [GIT PULL] Networking for 5.16
Message-ID: <20211102071051.15a89ab6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
References: <20211102054237.3307077-1-kuba@kernel.org>
        <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 06:20:35 -0700 Linus Torvalds wrote:
> On Mon, Nov 1, 2021 at 10:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16  
> 
> I get quite a lot of
> 
>     ./scripts/pahole-flags.sh: line 7: return: can only `return' from
> a function or sourced script
> 
> with this. Why didn't anybopdy else notice? It seems entirely bogus
> and presumably happens everywhere else too.
> 
> It's shell script. You don't "return" from it. You "exit" from it.
> 
> Grr.

Sorry about that. 

Looks like the patch was merged on Friday, presumably nobody tried 
to build -next without pahole installed on their system since.

Let me correct for that by sending the PR on Tue next merge window.
Hopefully an extra day will be enough for someone to catch silly 
mistakes like this. I had to do a last minute TCP revert as well,
so yeah, seems like Monday was a little rushed on my side.
