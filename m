Return-Path: <netdev+bounces-236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7000A6F630A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 04:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 555CE1C21098
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 02:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9330DEA6;
	Thu,  4 May 2023 02:55:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3304A7C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 02:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E26C433EF;
	Thu,  4 May 2023 02:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683168910;
	bh=FylaWKz62wVaqtqGNNjP+df9sVg09nj91zoWC6rJvqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ajCZtdlFVdqv+//MJVJtJ7MrxdgTq0OR77nmRNLzm9OT6a4yJwB5Jqfmg5hRI+y+X
	 uP36n5RzrR29G7GkMze1wSGWpxa09eqYPVHR5OTEVGT1VhB2gOZOlytgrVWSvrrU2P
	 LyQBG6P37/sitiKcuSsNaJ4aG4LxereI0KrhltnGLr8fxKZ6sT6UYbEgZrdGRaC0YF
	 9wigyRWVqJX8BVoRvTdpg89dVpkG0hBYZMFNWTqditZyeYfMSZaRThuJb+ayOisVq2
	 RIVmhsx/sIj1U03fE7Lv0ky+C38Fl2YLlOygWGyqn7J//MoX6pJBCvHIg/sSUnqLHG
	 totYkyYaMGIUg==
Date: Wed, 3 May 2023 19:55:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jon Maloy <jmaloy@redhat.com>, Xin Long <lucien.xin@gmail.com>
Cc: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>, network dev
 <netdev@vger.kernel.org>, "tipc-discussion@lists.sourceforge.net"
 <tipc-discussion@lists.sourceforge.net>, "davem@davemloft.net"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>
Subject: Re: [PATCHv2 net 2/3] tipc: do not update mtu if msg_max is too
 small in mtu negotiation
Message-ID: <20230503195509.1d637de6@kernel.org>
In-Reply-To: <d7ccfcc9-b446-66ad-ab04-baa1cdbbe0ce@redhat.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
	<0d328807d5087d0b6d03c3d2e5f355cd44ed576a.1683065352.git.lucien.xin@gmail.com>
	<DB9PR05MB90784F5E870CF98996BD406A886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
	<CADvbK_f5YPuY0eaZj5JcixUU7rFQosuAWg8PdorrGz08ve6DmA@mail.gmail.com>
	<d7ccfcc9-b446-66ad-ab04-baa1cdbbe0ce@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 15:29:07 -0400 Jon Maloy wrote:
> > I think it's correct to NOT use ''---' for version changes, see the
> > comment from davem:
> >
> >    https://lore.kernel.org/netdev/20160415.172858.253625178036493951.davem@davemloft.net/
> >
> > unless there are some new rules I missed.  
> I have not seen this one before, and I disagree with David here. Many of 
> the changes
> between versions are trivial, and some comments even incomprehensible 
> once the patch has
> been applied.
> I have always put them after the "---" comment, and I will continue to 
> do so until David starts
> rejecting such patches.
> 
> But ok, do as you find right.

Yes, I think the motivation has changed a bit since we now have 
the permanent lore archive and we add links when applying patches.
The change log is easy to find on lore, even after the --- delimiter.

