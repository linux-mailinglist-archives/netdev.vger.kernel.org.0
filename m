Return-Path: <netdev+bounces-1923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 135776FF98F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39CEB281918
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B750206A0;
	Thu, 11 May 2023 18:48:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD87F363
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 18:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F042C433EF;
	Thu, 11 May 2023 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683830903;
	bh=MOpjCej7la+TxcX/pRWRxu2bXO2lIfZWDfTIG4oGEYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Md2ZYi3krmHt1hfKrjpVImzxOZQFNnxP1jBJ8IqH2ehgBLXj5M0eKg6GqM/tWXW3U
	 axQpIoOuYZzyLAeHJggF6wuhmrrjTnO8m3X2chu2I9ay3F/zTT8TRkOLLpwyAFArSA
	 eaBstWMJfPcw/pEorI7ga1AFwH6WWkRlh3sxzT3iUvdfIHbjgBUGosV5ceBn7qLgDb
	 Q8Yl4TUM9ZckuDTYqHxCnEx8DInl97CTfCJiKUFX1I1cCvEuMaEo9D5WzoFKZ0t7lH
	 rlpgiTC9TgvoM5Ihry2x5D2D2yz6tYBlGBKHldI91zrBg/OF9uIAFWazR8S4ZJaNXc
	 ND1IkzX0PMkvw==
Date: Thu, 11 May 2023 21:48:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Philipp Rosenberger <p.rosenberger@kunbus.com>,
	Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230511184818.GV38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
 <20230509080627.GF38143@unreal>
 <20230509133620.GA14772@wunner.de>
 <20230509135613.GP38143@unreal>
 <20230510190517.26f11d4a@kernel.org>
 <33eec982e2ae94c7141d135f1de9bec02a60735b.camel@redhat.com>
 <20230511065917.GT38143@unreal>
 <20230511085128.3eb887e3@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511085128.3eb887e3@kernel.org>

On Thu, May 11, 2023 at 08:51:28AM -0700, Jakub Kicinski wrote:
> On Thu, 11 May 2023 09:59:17 +0300 Leon Romanovsky wrote:
> > And this is mainly the issue here. Lukas changes are not different from
> > what many of us doing when we submit internal patches. We change/update/rewrite
> > patches which make them different from internal variant.
> > 
> > Once the patches are public, they will have relevant changelog section.
> > 
> > I don't see how modifying-patches.rst can be seen differently.
> > 
> > BTW, Regarding know-to-blame reasoning, everyone who added his
> > Signed-off-by to the patch is immediately suspicious.
> 
> Right, modifying-patches.rst does not apply to corpo patches.
> 
> Maybe the analogy from US law would be helpful to show how I think
> about it -- corporation (especially working on its own product)
> is one "legal person", Philipp and Lukas are separate "human persons".

You have no reliable way to know the relation between person A and person B.

> 
> IOW patch circulation and attribution within a corporation is naturally
> different than between community members.

Yes and no, it is very dependant on corporation.

Thanks

