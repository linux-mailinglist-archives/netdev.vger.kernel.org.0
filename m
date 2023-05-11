Return-Path: <netdev+bounces-1888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2824D6FF679
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 420D61C20FEE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ACCA654;
	Thu, 11 May 2023 15:51:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A52629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB2AC433D2;
	Thu, 11 May 2023 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683820289;
	bh=1qyuFI1Ss0eKlEiLosnwvzOUJM2fGO3bXx2BxiOQHQU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HNbkp6sB1CZjL1eCtmc7KBdGFiq24qRYxGAjAMKWOOKOCYKo/3sxZd2JsSqIyJxfW
	 ZGCp0s8FR2kyVBuhvUDneO3yp/qsdkiz8nJpEtf+wgceMMPHOwq4YB3c/xdEj2cuq2
	 OduScZtU6ITDr80IicIEsfBg8Rd6QcqOdDeyIPf17tG2ce4JZZQ+s/5DvZqMp5hbT6
	 LmZ8Ba9ZAE1omxyC0/98rd+amPzqaKPQkkSdmVvOXMrbvEQzKBIWoJ61FyuPzkijps
	 dFzfr8JlefKEYN+Nc0EN8llt8Eix5wLInja+2Fbs1qnwKpxDj1jcIf0rxcJFdvWnTa
	 JgHAjWw+bpwmA==
Date: Thu, 11 May 2023 08:51:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Lukas Wunner <lukas@wunner.de>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Philipp Rosenberger <p.rosenberger@kunbus.com>, Zhi
 Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230511085128.3eb887e3@kernel.org>
In-Reply-To: <20230511065917.GT38143@unreal>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
	<20230509080627.GF38143@unreal>
	<20230509133620.GA14772@wunner.de>
	<20230509135613.GP38143@unreal>
	<20230510190517.26f11d4a@kernel.org>
	<33eec982e2ae94c7141d135f1de9bec02a60735b.camel@redhat.com>
	<20230511065917.GT38143@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 09:59:17 +0300 Leon Romanovsky wrote:
> And this is mainly the issue here. Lukas changes are not different from
> what many of us doing when we submit internal patches. We change/update/rewrite
> patches which make them different from internal variant.
> 
> Once the patches are public, they will have relevant changelog section.
> 
> I don't see how modifying-patches.rst can be seen differently.
> 
> BTW, Regarding know-to-blame reasoning, everyone who added his
> Signed-off-by to the patch is immediately suspicious.

Right, modifying-patches.rst does not apply to corpo patches.

Maybe the analogy from US law would be helpful to show how I think
about it -- corporation (especially working on its own product)
is one "legal person", Philipp and Lukas are separate "human persons".

IOW patch circulation and attribution within a corporation is naturally
different than between community members.

