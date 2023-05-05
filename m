Return-Path: <netdev+bounces-612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E646F88CF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DC7A2810A2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D37C8CF;
	Fri,  5 May 2023 18:44:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD4156EF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F46AC433EF;
	Fri,  5 May 2023 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683312286;
	bh=XMLU9Chg9nCGmsB5GqPhEvGzD7ENvye9j/2FzMvK1Ls=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mYiEHsUvpnOR/j6nzoHoZO+ntSQe/k5FOTbc5iwMbkUKY/pkXq6uaXuX2eLrR1efx
	 7rNL/2EGs3SwYb4BuekBZLO1dHmpRvSRkDbpBA5niQNqH3cDBxozRBmU2iYA4WJcsz
	 sAg2jXfReszG2eeVc7C7byAe6jDYP8vvUHZSuYg4ptOpi1+tDwg7zCozJYEq272yo9
	 l0lFNNnfV6khn2jQu1sQvbta7N3FSKeiufF7l825BnqjucPa2rX4qXpCkAyP6ytR7l
	 VaT0XswV9G5+x/89IfTnUcuHLEP4+jP6ZW/pM6Cxes7ytehfzCA5bezjwVb6jKbrY/
	 PRJtkRqyYahMQ==
Date: Fri, 5 May 2023 11:44:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org
Subject: Re: [RFC PATCH 11/13] netdevice.h: Fix parentheses around macro
 parameter use
Message-ID: <20230505114445.49082b62@kernel.org>
In-Reply-To: <20230504200527.1935944-12-mathieu.desnoyers@efficios.com>
References: <20230504200527.1935944-1-mathieu.desnoyers@efficios.com>
	<20230504200527.1935944-12-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  4 May 2023 16:05:25 -0400 Mathieu Desnoyers wrote:
> Add missing parentheses around macro parameter use in the following
> pattern:
> 
> - "x - 1" changed for "(x) - 1",
> - "x->member" changed for "(x)->member".
> 
> to ensure operator precedence behaves as expected.
> 
> Remove useless parentheses around macro parameter use in the following
> pattern:
> 
> - m((x), y) changed for m(x, y), because comma has the lowest operator
>   precedence, which makes the extra comma useless.

Sure, why not. Can we take it via netdev, tho?
I can't have any dependencies, right?

