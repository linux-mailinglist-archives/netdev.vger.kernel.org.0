Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B56311F1B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBFRVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhBFRVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6365E64E25;
        Sat,  6 Feb 2021 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612632042;
        bh=vT+OZ0+J6YDkOfgJ0UGRFetxiP4TxzYz/O2HEuyAV9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IJccEAr3xD3S5Jom33rDyAR6i2vSqx9v0i6B4uDC8IITA/OIasEV8K8F0gIaUYXxR
         qI4/djOypd9912krb2Pf6RODeBzX/PpDSASy/VX3X9J39nv5rZfkczYdwEpG+Uz11Y
         OHW7x89WL4oCcj5NubFBrUvjSEG2e1ZZk3fq4Z8Oat1EbWCTUKpBhw+XuQgamMEVDa
         YiSraoTI+C6GQACoRfmCOXbmLHDWoyJjZ3oGMdrrv0zG8IvNVmrnkb3uh3sytI6tTy
         nRCEbN0yxRlimjuo6IyZTfGXq8/IAilDeDMJnOoXEWd91O8QB6X03uYdiSDlpAqgvF
         i4UlmDgaZ3uuQ==
Date:   Sat, 6 Feb 2021 09:20:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [net v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210206092041.77eb5455@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206091903.3c02f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
        <20210206091903.3c02f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 09:19:03 -0800 Jakub Kicinski wrote:
> On Fri,  5 Feb 2021 23:02:03 -0800 Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> > 
> > Explicitly define reserved field and require it to be 0-valued.
> > 
> > Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > Suggested-by: David Ahern <dsahern@gmail.com>
> > Suggested-by: Leon Romanovsky <leon@kernel.org>
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Applying: tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
> Using index info to reconstruct a base tree...
> M	include/uapi/linux/tcp.h
> M	net/ipv4/tcp.c
> Falling back to patching base and 3-way merge...
> Auto-merging net/ipv4/tcp.c
> Auto-merging include/uapi/linux/tcp.h
> CONFLICT (content): Merge conflict in include/uapi/linux/tcp.h
> error: Failed to merge in the changes.
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> Patch failed at 0001 tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

Ah, you just marked it for the wrong tree. Please repost with net-next
in the subject tag, otherwise build bot won't handle it.
