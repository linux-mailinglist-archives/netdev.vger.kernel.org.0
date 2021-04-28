Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0736E083
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 22:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhD1Ur6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 16:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhD1Urz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 16:47:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F83361026;
        Wed, 28 Apr 2021 20:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619642829;
        bh=MbOb2Pbxyp+AJJ6Ht72OYsybaRAs6aTQt/GQEr5hdBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ab8bvbYicwuepAfCcnKNJqE+BePqvJcbIDH23GhNKE77uejV3GqDFlLluIV55+DmC
         GnxNhcvt3p9ADwTtBDKSnJe4xXYDOM22o/ynHsBMusqlk/Brwg4h9/E/9iIFKccSPM
         dk0JBAiG6j+6J7KmKJ7IEfKREpVfppcHiUEBxfdpPxUlJNWDwGV3dfHuJeOtEKyZlM
         kz0EPfVtIm2xvUmcPCFllRhFGUELR6iNzH27kzjaUoHCmgJCgEiifAPBtOh/ul52kP
         R/PMp5h7dJ5V/4hJe4nFwY9AbVHZIZmUAFbSmaTOro2exohI8ZDHbINZR9H+FRob6C
         47/XDaeoZcCDg==
Date:   Wed, 28 Apr 2021 13:47:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2021-04-28
Message-ID: <20210428134708.5dc0a300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210427233740.22238-1-daniel@iogearbox.net>
References: <20210427233740.22238-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 01:37:40 +0200 Daniel Borkmann wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 19 non-merge commits during the last 2 day(s) which contain
> a total of 36 files changed, 494 insertions(+), 313 deletions(-).
> 
> The main changes are:
> 
> 1) Add link detach and following re-attach for trampolines, from Jiri Olsa.
> 
> 2) Use kernel's "binary printf" lib for formatted output BPF helpers (which
>    avoids the needs for variadic argument handling), from Florent Revest.
> 
> 3) Fix verifier 64 to 32 bit min/max bound propagation, from Daniel Borkmann.
> 
> 4) Convert cpumap to use netif_receive_skb_list(), from Lorenzo Bianconi.
> 
> 5) Add generic batched-ops support to percpu array map, from Pedro Tammela.
> 
> 6) Various CO-RE relocation BPF selftests fixes, from Andrii Nakryiko.
> 
> 7) Misc doc rst fixes, from Hengqi Chen.

Pulled, thanks!
