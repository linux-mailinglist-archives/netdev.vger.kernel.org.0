Return-Path: <netdev+bounces-966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDFB6FB81C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58EF41C20A0E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD70B11C83;
	Mon,  8 May 2023 20:09:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD9211193;
	Mon,  8 May 2023 20:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C60AC433EF;
	Mon,  8 May 2023 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683576585;
	bh=4ZYRG+YiH474zWpI41416ytA6fpX7/XY91vw37d1V5w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Du/4nYep6dkPXZKJNA6Z9jEfR6lIxMQuGap7tYvJrsw9JYzjhzrccZdH64OteUZWm
	 nZsVJf1efhpmHyVJkqimDHKEg+4yH540/QUx84gSZSC01kMkdh6UyvLVigWmro8L/p
	 MKDMZxH8Ir7TkYtYcBzkiFdJtdUIVOJvdYJzLV+obsbFvZEYfJ8hDjjDcoPJyTvKE6
	 G8ooKh94bZLCIwVUWr7dCj5JsC0az/5m4DlFSSUWRBbhn+BqK4kJpTVYqxC+7bkro9
	 ul/NAXUYm7B7eI54oxbbgAVNTWRktNDNNoRspsoRp2ry/SxBB6Yi0qUwxDWaXXfLfj
	 +3CYP0a+FsuBQ==
Date: Mon, 8 May 2023 13:09:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>,
 =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>, Hayes Wang
 <hayeswang@realtek.com>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Stanislav Fomichev <sdf@fomichev.me>,
 workflows@vger.kernel.org
Subject: Re: [regression] Kernel OOPS on boot with Kernel 6.3(.1) and
 RTL8153 Gigabit Ethernet Adapter
Message-ID: <20230508130944.30699c33@kernel.org>
In-Reply-To: <9284a9ec-d7c9-68e8-7384-07291894937b@leemhuis.info>
References: <ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info>
	<87lei36q27.fsf@miraculix.mork.no>
	<20230505120436.6ff8cfca@kernel.org>
	<57dbce31-daa9-9674-513e-f123b94950da@leemhuis.info>
	<20230505123744.16666106@kernel.org>
	<9284a9ec-d7c9-68e8-7384-07291894937b@leemhuis.info>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 6 May 2023 08:20:23 +0200 Linux regression tracking (Thorsten
Leemhuis) wrote:
> > I don't seem to have the permissions on BZ, but I'm guessing we could
> > do the opposite - you could flip bugbot on first to have it flush the BZ
> > report to the list, and then reply on the list with regzbot tracking?  
> 
> That's the plan for the future, but for now I don't want to do that, as
> it might mess up other peoples workflows, as hinted above already and
> discussed here:
> 
> https://lore.kernel.org/all/1f0ebf13-ab0f-d512-6106-3ebf7cb372f1@leemhuis.info/
> 
> That was only recently, but if you jump in there as well it might
> persuade Konstantin to enable bugbot for other products/components. Then
> I could and would do what you suggested.

CC: workflows

I'm a bit confused. I understand that we don't want to automatically
send all bugzilla reports to the ML. But AFAIU this is to avoid spamming
the list / messing with people's existing BZ workflow.
If you pre-triage the problem and decide to forward it to the list -
whether you do it with buzbot + regzbot or manual + regzbot is moot.

The bugbot can be enabled per BZ entry (AFAIU), so you can flip it
individually for the thread you want to report. It should flush that 
BZ to the list. At which point you can follow your normal ML regression
process.

Where did I go off the rails?

