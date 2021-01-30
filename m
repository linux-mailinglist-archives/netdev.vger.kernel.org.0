Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DAC3092E7
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhA3JJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233233AbhA3JI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:08:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FE564E15;
        Sat, 30 Jan 2021 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611989285;
        bh=SQJjNA79+nqIdvoNyhPXB2HwtA3pYRZWMBc9MZuXOEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TceFGD34ivYu81kcMQyrhKFfRf8wLXKQdHV07aH5NyHZoyJzuHE7BNHWROAVYyi4u
         Eh5BBvGJK4Ty8KgT08FWaMnIW0Nzhp6mU2ysZzPSBhKcdUzlsH9BtElhsV3owxh2gs
         tfYHk3bNC2U+RRcMaGH/86T3MUN9PG9u69YRiQui32kRiU1KvdapDO/2OBPY1UEnDW
         yslJJa6JLmrHKzq7iXCCfy/MqRUY8HhMQDkIa8/07NZftPy0xJWS7WfiSNWzJWP/ul
         OCkiBxBAqs0HxNA1plLJlc1cZ+hD2j4viqgYi2wkq4AqOckw59Bel5yZbmgBorxClm
         oHnmOo3kyziRQ==
Date:   Fri, 29 Jan 2021 22:48:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: proc: speedup /proc/net/netstat
Message-ID: <20210129224804.6cb4e348@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128162145.1703601-1-eric.dumazet@gmail.com>
References: <20210128162145.1703601-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 08:21:45 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use cache friendly helpers to better use cpu caches
> while reading /proc/net/netstat
> 
> Tested on a platform with 256 threads (AMD Rome)
> 
> Before: 305 usec spent in netstat_seq_show()
> After: 130 usec spent in netstat_seq_show()
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

The bot just doesn't like to reply to you :) If it happens
again I'll poke Konstantin. Maybe third time is the charm.

Anyway, applied a few hours ago, thank you!
