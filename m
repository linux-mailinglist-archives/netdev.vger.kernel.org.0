Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6490D46A542
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348124AbhLFTA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:00:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348094AbhLFTA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:00:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77DD3B8111E;
        Mon,  6 Dec 2021 18:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFF1C341C8;
        Mon,  6 Dec 2021 18:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638817045;
        bh=kgixWDSqMcZnHwfXTjwAEg6St2LR2wH+ynRHOH3oFrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DHlUIgjf4DhGeR5A5picVsZ7O7NSgF2Sc4GF4PiI/wvdxdRpzqUW81XA3o7HlW7Ha
         w7uxD//nyeZOZj7g+GK2A/RhOrhSt9fRJiC2Z138+kKbkI77ur+CKkWBXtmqNrZ1Pk
         1IngkEm/sxfGrbxyJi1dkBMsQiATc5PxDU5Aqr6sMAsZXeb2QE8ielRUfBv8aRaGF9
         8fXVd7DJoScMmq6vEskFbarGrHdydSPCRKWId4+4lx83mwxdix8Ud7g5SwET6ATOI4
         Jo/T4ulWl6l2XW8d/HL24+LqpFM+QsGqIYcEDNbUF6CDx9ChpIEhJsvoZNV64WO8Qi
         Gq31h1wVu9bcw==
Date:   Mon, 6 Dec 2021 10:57:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.linux.dev,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
Subject: Re: [PATCH mptcp] mptcp: remove tcp ulp setsockopt support
Message-ID: <20211206105724.0bf71c56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2297cabb-be69-98ef-f4fc-d9472c7820cc@linux.intel.com>
References: <00000000000040972505d24e88e3@google.com>
        <20211205192700.25396-1-fw@strlen.de>
        <20211206075326.700f2078@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211206075515.3cf5b0df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2297cabb-be69-98ef-f4fc-d9472c7820cc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 10:44:16 -0800 (PST) Mat Martineau wrote:
> If you could mark this as "Not Applicable" in netdevbpf patchwork, we'll 
> apply it to the mptcp tree and resubmit to netdev with some related 
> patches.

For sure, I was asking because technically I added the code that hit
the oops to tls a week or so ago, so I wanted to make sure it's not 
my fault ;) Marked in pw appropriately now.
