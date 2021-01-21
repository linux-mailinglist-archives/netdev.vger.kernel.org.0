Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DCD2FF025
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbhAUQYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:24:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387613AbhAUQDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 11:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0082223118;
        Thu, 21 Jan 2021 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611244946;
        bh=ClBUDFhX2m6o6C6NQVp/H0xERYYuUpDQS2ROMyhuGbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+CYrVK9yN7vLM4utwyBz7lo7CpLvyq15oFAispxoXRTi9lL+JF1wnBdKAxMltW+l
         Fpb7FRqHUt2eRiO4KTQMp3pqyqq+w2pIlUiKwq0hAGQQTUnUsM9BVkmuBC1EuDuIYt
         eBiJFsUOEFWVNiyumKNWHkiSXkgIcfOqiwJYFQtMTKR1dXQ98ibAxDk+DIXRDRxYB9
         Lcu7dIPXVHZukGsu+sySCI6weRBpZX8LolEP81lpjTg2T2TGv12vJQH2yHSbIKQCwj
         51lVZV5fR1ZWjZAMzmFnt2Uvljf2szDoYCq09cFq5xHEJ+Hf6px2jiG4AbVdS4XBHJ
         Q9/79XvskOs4w==
Date:   Thu, 21 Jan 2021 11:02:24 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linux-stm32] [PATCH AUTOSEL 5.10 28/45] net: stmmac: Fixed mtu
 channged by cache aligned
Message-ID: <20210121160224.GD4035784@sasha-vm>
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-28-sashal@kernel.org>
 <20210119220815.039ac330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210120142659.GC4035784@sasha-vm>
 <7564ebe1-20e9-36d5-11a7-bcfe27f70987@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7564ebe1-20e9-36d5-11a7-bcfe27f70987@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 03:39:22PM +0100, Ahmad Fatoum wrote:
>On 20.01.21 15:26, Sasha Levin wrote:
>> On Tue, Jan 19, 2021 at 10:08:15PM -0800, Jakub Kicinski wrote:
>>> This was applied 6 days ago, I thought you said you wait two weeks.
>>> What am I missing?
>>
>> The "AUTOSEL" review cycle is an additional hurdle automatically
>> selected patches need to clear before being queued up. There are 7 days
>> between the day I sent the review for these and the first day I might
>> queue them up.
>
>I guess this could benefit from being documented in
>Documentation/process/stable-kernel-rules.rst? Or is this documented
>elsewhere?

This is not documented because it's not part of the -stable process,
it's just the way I currently handle AUTOSEL stuff. The timeline
requirement for -stable is:

	"It or an equivalent fix must already exist in Linus' tree (upstream)"
-- 
Thanks,
Sasha
