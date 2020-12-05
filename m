Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C152A2CF7D1
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgLEAKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLEAKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:10:06 -0500
Date:   Fri, 4 Dec 2020 16:09:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607126966;
        bh=3oHDGeeF1GqqXg4FoxMbracGhGTzKQb1qv5/cfL79bY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJnqUjjqRKv3uMisJCCjqn0XtrJM8B0EOjRYQ20aX4M8X+xSqYr3PDM3OYcnorhf4
         /L0neFg27HAYYhqHGZdv6hJ8ldwV2rcOw7rNxX3T/gxArIRebME82QEbD77g4pZ7iJ
         HRXeeJs7ji48F6F7OBMMtU5j1+3ioWzNca2FuRZuzk1IaRl3tjLoeIfQ6we5D9RrrD
         VI1KauV38TShYhnQu7N4YK3YXmub1lbL9LMs5KkteMks8HTOyAg29BFekWUycHjLfg
         OuDBydZ9kShVUCmsidr+q1JHR1YByzxubNHdncPV/PojXJhAKYx/uGvi3kl7gqSvi6
         f2y2vlpBRsrWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com,
        ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
Message-ID: <20201204160924.2e170514@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 13:49:53 +0100 Enrico Weigelt, metux IT consult
wrote:
> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>

Thanks for the patches. Please drop the "metux IT consult" from the
addresses. The from space is supposed to be for your name.

> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index f292e0267bb9..683e9e825b9e 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -36,15 +36,10 @@
>  #include "vlan.h"
>  #include "vlanproc.h"
>  
> -#define DRV_VERSION "1.8"
> -
>  /* Global VLAN variables */
>  
>  unsigned int vlan_net_id __read_mostly;
>  
> -const char vlan_fullname[] = "802.1Q VLAN Support";
> -const char vlan_version[] = DRV_VERSION;

This patches does not build. Please redo it more carefully.

You'll need to fix and resend the entire series. When you do so please
provide a cover letter, even if it only contains a couple of sentences
and separate the patches for bluetooth and batman-adv out as stand
alone patches, so the respective maintainers can pick them up.
