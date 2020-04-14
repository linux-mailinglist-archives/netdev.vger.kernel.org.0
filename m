Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D4D1A70B6
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403898AbgDNB4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403886AbgDNB4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 21:56:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FF22072A;
        Tue, 14 Apr 2020 01:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586829389;
        bh=Cd82VnejhhkQscnV18lC9k8mbe1pFiTSGkbEBDM4dmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HjPCcC7u/wzSi+5wVMPcigjuCFvZs4lUbdo4gR7AOd+2cudiOgjnd38RmtON3hy0J
         Tgc73Upi/Kxqo0uRXnISaBi0dymURPNbjIbK7LE2ZSWl9fkQo5jkP6nrXgHSC39dBa
         mhK2+y7I+Ood2+r+L81amwlf50n8cVTw1Jou5kok=
Date:   Mon, 13 Apr 2020 21:56:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>, Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414015627.GA1068@sasha-vm>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 10:59:35AM -0700, Jakub Kicinski wrote:
>On Sun, 12 Apr 2020 10:10:22 +0300 Or Gerlitz wrote:
>> On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> > [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]
>>
>> Sasha,
>>
>> This was pushed to net-next without a fixes tag, and there're probably
>> reasons for that.
>> As you can see the possible null deref is not even reproducible without another
>> patch which for itself was also net-next and not net one.
>>
>> If a team is not pushing patch to net nor putting a fixes that, I
>> don't think it's correct

While it's great that you're putting the effort into adding a fixes tag
to your commits, I'm not sure what a fixes tag has to do with inclusion
in a stable tree.

It's a great help when we look into queueing something up, but on it's
own it doesn't imply anything.

>> to go and pick that into stable and from there to customer production kernels.

This mail is your two week warning that this patch might get queued to
stable, nothing was actually queued just yet.

>> Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
>> mlx5 the maintainer is specifically pointing which patches should go
>> to stable and

I'm curious, how does this process work? Is it on a mailing list
somewhere?

>> to what releases there and this is done with care and thinking ahead, why do we
>> want to add on that? and why this can be something which is just
>> automatic selection?
>>
>> We have customers running production system with LTS 4.4.x and 4.9.y (along with
>> 4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
>> should go there, I don't
>> see a benefit from adding auto-selection, the converse.
>
>FWIW I had the same thoughts about the nfp driver, and I indicated to
>Sasha to skip it in the auto selection, which AFAICT worked nicely.
>
>Maybe we should communicate more clearly that maintainers who carefully
>select patches for stable should opt out of auto-selection?

I've added drivers/net/ethernet/mellanox/ to my blacklist for auto
selection. It's very easy to opt out, just ask... I've never argued with
anyone around this - the maintainers of any given subsystem know about
it way better than me.

-- 
Thanks,
Sasha
