Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444EC42C2CE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhJMOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhJMOWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:22:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C8F6610A2;
        Wed, 13 Oct 2021 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634134843;
        bh=OkUGPmr2zk19BhOFZL4WOXYVOIbey/ov0aRoYoGKEbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GBxCPPQJV6wtqQNztoLxB3QEjt9xcOdRIuABiufO0C0WgKfWhsxyIR5d1jKaOnOhn
         k76PrdrmHH5U8MAY4KPmyijZOoRKD6E9KpRfzkywIXm4lnxAXOLsD+9qzHvYcY5PmJ
         TfWn53crGXymxpTwuRngxvEXjdfGrMgqIsK3/GLetrD6Jray/uFisLjVhUtROkhUuU
         kirZnx5XBWnco4Vs3wWJZ5kxtieywq2YiPKC8i4UKgDnu7eOVNJIIAbeOLHLbJlNp9
         FNVkdoOz8IezoNlxeJaKDbVzD/CHewTvtCdR7gMu1bRsLZVT/S7RXWovk+ZkkMjrgl
         oTF26B+S4IRKQ==
Date:   Wed, 13 Oct 2021 07:20:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Strejc Cyril <cyril.strejc@skoda.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: multicast router does not fill UDP csum of its own
 forwarded packets
Message-ID: <20211013072042.2b6077e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3fc5b9be1d73417a99756404c0089814@skoda.cz>
References: <3fc5b9be1d73417a99756404c0089814@skoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 20:08:36 +0000 Strejc Cyril wrote:
> please let me summarize a problem regarding Linux multicast routing
> in combination with L4 checksum offloading and own (locally produced)
> multicast packets being forwarded.

Hi Cyril, thanks for the report, looks like nobody has immediate
feedback to share. Could you resend the patch in more usual form 
so that it's easier to review and harder to ignore? 

Please put your description into the commit message (line wrapped 
at 72 characters), run ./scripts/checkpatch.pl --strict on the patch
and submit it with git send-email?
