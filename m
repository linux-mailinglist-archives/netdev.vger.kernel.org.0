Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9260B492A07
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiARQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:03:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36660 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346164AbiARQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:03:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0F04612B9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2825C00446;
        Tue, 18 Jan 2022 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642521832;
        bh=V5B7LD9HolE5cShovMok5fHfXZlkQa7ny0vTUwL++pE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGa0s8+QsQsBIbfGj8K5TI8XWRXOeHbVCiTm1W+e1Gd4JT+cfCdswXYS6Jz/ILujX
         OwIuGIa84oLhgYWldTh4uB+I6XoK5pp+c8Hc97zU8xEwuxkq4NUA2jTVgXwGuya4C9
         jZQoyUXREEeybbL0NlAAkEJ7wRhFfh3aqx3bQ0TBSXaOiUzu/7rgr4myVzOFQNMwtK
         x37FdAZO4keAqznjXw4CBSBh+OFvQE4utOmA2NWmhYuzRuLBH4hkuYrf7XEtTjLJMQ
         F0SGG5eu4oBvlNKx/Y6xt0n5feT4x04xsPK4TVsbQ7F/Ys9WUBofZpDDklYLuyDoEZ
         GqYcfrEG7lfdA==
Date:   Tue, 18 Jan 2022 08:03:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        tom@herbertland.com, zeil@yandex-team.ru, davem@davemloft.net
Subject: Re: [RFC PATCH v3 net-next 4/4] tcp: change SYN ACK retransmit
 behaviour to account for rehash
Message-ID: <20220118080350.5765ed94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <614E2777-315B-4C47-94B8-F6E9D6F3E4B5@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
        <20211206191111.14376-1-hmukos@yandex-team.ru>
        <20211206191111.14376-5-hmukos@yandex-team.ru>
        <614E2777-315B-4C47-94B8-F6E9D6F3E4B5@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 18:31:37 +0300 Akhmat Karakotov wrote:
> We got the patch reviewed couple of weeks ago, please let us know what
> further steps are required before merge. Thanks, Akhmat.

We rarely merge RFC patchsets these days, you need to repost without
the RFC marking. Obviously keeping Eric's Acks. You should also CC
the bpf list & maintainers on patch 3. Please repost next week, the
merge window is still ongoing and net-next is closed for another few
days:

http://vger.kernel.org/~davem/net-next.html
