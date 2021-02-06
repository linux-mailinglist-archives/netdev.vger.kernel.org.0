Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B74311F17
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBFRTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFRTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:19:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF9364E84;
        Sat,  6 Feb 2021 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612631944;
        bh=4eMN3BRMV7OKO0ss2kzqY3KEa7Xubl1tJ9bYTQxzBgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sYVbE0ZU4qKyNgSSww9Tnfw6ep3lki7iUo2cbp4o29ZQbeqqn5apL3LSqanJowJsP
         s8/5Yab24gF9MJFCoEQyqyjvnAKyXYvUkQBSw1aMERhMm/mEHDzjsroo2PYlzmJsL7
         58xCTupReRDWKh0jj0tsBU4dyVy6ka/4aCKt3SGNKAaWqiAYwI5jK/KGj07pvvVSg0
         LhHmWFni6PxXoF09oQNuoCZgu13uFSASiidDBWMdlYCyfO2TVPtXXuVXy23UneE9Ez
         ytvRvxqkcFSxmiILatJO1BJnd1OfrkOzPw1RVGwkE1FLKtu/lksJy4/HaFjoZX9Rlq
         3htMQNuTm8D2w==
Date:   Sat, 6 Feb 2021 09:19:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [net v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210206091903.3c02f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
References: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 23:02:03 -0800 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it to be 0-valued.
> 
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>

Applying: tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
Using index info to reconstruct a base tree...
M	include/uapi/linux/tcp.h
M	net/ipv4/tcp.c
Falling back to patching base and 3-way merge...
Auto-merging net/ipv4/tcp.c
Auto-merging include/uapi/linux/tcp.h
CONFLICT (content): Merge conflict in include/uapi/linux/tcp.h
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

