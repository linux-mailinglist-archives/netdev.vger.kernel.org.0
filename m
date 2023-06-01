Return-Path: <netdev+bounces-6984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2385D7191F0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A22132816F0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 04:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8254823B9;
	Thu,  1 Jun 2023 04:41:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9081878
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 04:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6318AC433EF;
	Thu,  1 Jun 2023 04:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685594511;
	bh=ky4mR1cJE7WCesKxH6aaf+JK5+lIqgajYd9irBlEbY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pB3wpVHxZZar5qF3MQ9DLa2z79UUtaxFs2gPclrFKJvyigPrAS25/N3E0GYo6ej58
	 uwD6gtP/WdOObwuHRL0x1xi0QLR2SrOY+eLXuv6aHqAEyMnIqdbRPfm8TNiU02TR9X
	 879GYrjN0ddGnWtZlqsLCce1BG1VYrhrSdGf4/8XJOKXiGjWkq9qU/7mcYk57bHBDL
	 UIK7BO03MA8HaPzQlPobzV5q3B4rGlRmUuKv/HVLrJih8luoPVox1YPii5ykrYJ8FD
	 jHNfR8mN3I5mFEcLZ3uMGYxuYcfqnIbWwW2uyIgcjGDYck+7WgfwAj9YaOaaFaHh7y
	 2SXK9dnsQZRsQ==
Date: Wed, 31 May 2023 21:41:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>,
 "privat@egil-hjelmeland.no" <privat@egil-hjelmeland.no>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "f.fainelli@gmail.com"
 <f.fainelli@gmail.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Message-ID: <20230531214150.2e0f03d1@kernel.org>
In-Reply-To: <20230531153519.t3go47caebkchltv@skbuf>
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
	<20230531151620.rqdaf2dlp5jsn6mk@skbuf>
	<426c54cdaa001d55cdcacee4ae9e7712cee617c2.camel@siemens.com>
	<20230531153519.t3go47caebkchltv@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 18:35:19 +0300 Vladimir Oltean wrote:
> If you want to be completely sure I didn't just throw a wrench into
> your plans, feel free to resend a v2 with just my review tag
> (dropping my Fixes tag)

FWIW if you worry that the Fixes tag will get added automatically - 
for whatever reason that still doesn't work. We add them manually
when someone provides a tag in response.

