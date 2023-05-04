Return-Path: <netdev+bounces-230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A407A6F62BD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 670F11C21077
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2865A44;
	Thu,  4 May 2023 01:49:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432007E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB1FC433D2;
	Thu,  4 May 2023 01:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683164969;
	bh=6SyTKbVcajyYbNLJTfLkhCT7g/RGQ6mt+51ZNxG89JY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HkCNopdxlGhmaXqy6jbwrBacnksKw0nWAGpajVw5/5AP/0p/6PgFN9Fqn8uDP/c8q
	 uP9h7lQQgC67pEAH9Q6AiqlhqRAkcfHCwGqqv6zAMHfIc2hbb4Gi1bXuUTCeSQ1MOP
	 WOjHnPXVfoZaGkRQtCDwu3mIh4BlMBfDuQWdT3fVAMbAXYTkKoG0PnbLz9FtHMw7UY
	 p0M9WTq0y4b1BDNwALKhlhNvZVLnn3TmoC8rNwNRJ76fPGnSQn5H9S7QHQkF+RZ1mT
	 1V67W0SqP2swwDd1SeIkSw2jQqILJclB6onfOzG2RFWzakvs3CKBoA/6ERt92PPXgt
	 PTSZAX3sVrhew==
Date: Wed, 3 May 2023 18:49:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Simon Horman
 <simon.horman@corigine.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long
 <lucien.xin@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH net v4] sctp: fix a potential OOB access in
 sctp_sched_set_sched()
Message-ID: <20230503184928.458eb0da@kernel.org>
In-Reply-To: <20230503133752.4176720-1-Ilia.Gavrilov@infotecs.ru>
References: <ZFJX3KLkcu4nON7l@t14s.localdomain>
	<20230503133752.4176720-1-Ilia.Gavrilov@infotecs.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 13:37:59 +0000 Gavrilov Ilia wrote:
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to OOB access.
> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.

Not a fix, so it needs to wait for net-next to open, see below.
When you repost please do so separately, not in the existing thread.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer


