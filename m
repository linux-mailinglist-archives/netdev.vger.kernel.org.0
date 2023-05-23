Return-Path: <netdev+bounces-4466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE9770D0CB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D2228113C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C371C35;
	Tue, 23 May 2023 02:05:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBD01C08
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E6CC433EF;
	Tue, 23 May 2023 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684807516;
	bh=98O7VgNuMGNSu4HhCRX9uBBylnf5BFeRBBwKmuvbrT0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YAI5QUiwwA/PgrlJUpl86lTlACOL6WjXMe5NPCtPARbqkscHf9GEMlPS8q6yqY9Kh
	 GTw5qKJiEQdNvlL2jaO9SZEyNXWfizze5SrahuzRpjjXP2ixScBlnPhZjPAweQM20u
	 2+7wKlJshdrlqUndHVflQ+DCMzJfpIqmhVLEN6ohRki0PWQQE7vtCcz6KLjsmLFo70
	 09oW/1C5fPUGK9xuanYa5SHyqctgjTd7iw5AF0Sb/6H3pjiyVelBIJWTuuStv2lve8
	 OfVlX5MZooOEJ5YnVay0Fy+bSb9rDYAgP/uho4WQ0ZYcwfae2VlJwGqZAU7mr9RKyh
	 5RR39aM0AzlHg==
Date: Mon, 22 May 2023 19:05:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: netdev: document the existence of the mail
 bot
Message-ID: <20230522190515.2793193f@kernel.org>
In-Reply-To: <043df418-28f0-49e5-bff0-2ea511148bb6@lunn.ch>
References: <20230522230903.1853151-1-kuba@kernel.org>
	<043df418-28f0-49e5-bff0-2ea511148bb6@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 03:46:46 +0200 Andrew Lunn wrote:
> > +Instead of delegating patchwork permissions netdev uses a simple mail
> > +bot which looks for special commands/lines within the emails sent to
> > +the mailing list. For example to mark a series as Changes Requested
> > +one needs to send the following line anywhere in the email thread::
> > +
> > +  pw-bot: changes-requested  
> 
> ...
> 
> > +  https://patchwork.hopto.org/pw-bot.html  
> 
> [Evil grin]
> So your patch did not trigger the bot. Lets see if my reply does?
> [/Evil grin]

Commands must be on separate lines, with no extra white space.
I wonder if that proves the documentation is insufficient :)

