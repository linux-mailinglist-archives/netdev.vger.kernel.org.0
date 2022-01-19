Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F7493FD0
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356727AbiASSY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 13:24:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40736 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242946AbiASSY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 13:24:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DABFB81B07
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 18:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D51BC004E1;
        Wed, 19 Jan 2022 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642616694;
        bh=whfuGNC9nB9Tg8SY9W3rZVZBak18vSQnzLYTO/+2fCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DLGzbI3/ej2mOaufTfM7KTJvSebYzYqY1eu3MuRav7QLy8LE1ekqZp3NdoQYbUIYH
         VbesRUyEm645VV16g9MWScIVw56eom3CcJAwVO1stsMxUIP5cJvLO+BW5RlL1w1cVQ
         QF+Hbrdx/wVeuJzm174HuKBzHJeAafCLjmx6pt2/il4DRD1ygd99hCU9KywwgNBAg1
         EcXqJhUWX4lnYAjM5VvfdB46adiTO3bAzjj9YYJ3H1Dj3an1yQGy3uhBdzqGmbDmpr
         FyK7Em5vATw6H8gWP7t1zIgHNg+1nXQxyzeaO1e+h5ugOEVdttuVfxXzNwBvDxEpFx
         rvb5E9k9pkpzg==
Date:   Wed, 19 Jan 2022 10:24:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net 0/2] ipv4: avoid pathological hash tables
Message-ID: <20220119102453.08f12a72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220119100413.4077866-1-eric.dumazet@gmail.com>
References: <20220119100413.4077866-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 02:04:11 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This series speeds up netns dismantles on hosts
> having many active netns, by making sure two hash tables
> used for IPV4 fib contains uniformly spread items.
> 
> v2: changed second patch to add fib_info_laddrhash_bucket()
>     for consistency (David Ahern suggestion).

Applied, thanks! (the bot does not want to respond for some reason)
