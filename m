Return-Path: <netdev+bounces-12176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E03EF736937
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DE221C203DB
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FF3FC1B;
	Tue, 20 Jun 2023 10:26:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45311FBFE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCA1C433C8;
	Tue, 20 Jun 2023 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687256794;
	bh=Pm9sy2rMlMGkxvexM4D8WBfM6mwhGIuMyl4IfHISPIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfYexD7t8NQLaZ3HaQHVSKkdDFh6Vs4LD1P8C1uF8IWZauvQLGjBcmNXK2OcaTRKm
	 AUrwq4IC6w9E2WsOtRD4ktKSMvjWLEXBHf0/lYK/ghJAV3CvsLYYvXPW7a2VL8HlVa
	 qopUjnYxvckoJ99MKSTlp14EB5njYvW1OioJHmhcM8JbLoXvTqGKO/njIr/svhApaN
	 mRydgNWXFU7TDyEuk2dLqcCWNOxTMGN8I6bqjDjY8c2D4siU7SEwrL9u1t5SZm/XYZ
	 iLeCsctRbzeBSQVRfR55PaGi74HErVuAG+9Z/z64L+Ojv//afqhLqkjFF6Dg42fFMV
	 TLfB4LEID3RLw==
Date: Tue, 20 Jun 2023 11:26:29 +0100
From: Lee Jones <lee@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
Message-ID: <20230620102629.GD1472962@google.com>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
 <20230619104030.GB1472962@google.com>
 <dd82d1bd-a225-4452-a9a6-fb447bdb070e@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd82d1bd-a225-4452-a9a6-fb447bdb070e@lunn.ch>

On Mon, 19 Jun 2023, Andrew Lunn wrote:

> > Seeing as we're on -rc7 already, any reason why we shouldn't hold off
> > and simply apply these against LEDs once v6.5 is released?
> 
> Each subsystem has its own policies. netdev tends to accept patches
> right up until the merge window opens, sometimes even a couple of days
> into the merge window for low risk changes. Maybe this is because
> netdev is fast moving, two weeks of not merging results in a big
> backlog of patches, making it a bumpy restart once merging is started
> again. And is some of those late patches breaks something, there is
> still 7 weeks to fix it.
> 
> Since this is cross subsystems i would expect both subsystems
> Maintainers to agree to a merge or not. If you want to be more
> conservative than netdev, wait until after the next merge window,
> please say so.
> 
> If you do decided to wait, you are going to need to create another
> stable branch to pull into netdev. I know it is not a huge overhead,
> but it is still work, coordination etc.

Can you clarify you last point for me please?

-- 
Lee Jones [李琼斯]

