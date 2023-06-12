Return-Path: <netdev+bounces-10192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE09372CC51
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E23728109A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8DC1E523;
	Mon, 12 Jun 2023 17:22:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E117AB7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D275BC433D2;
	Mon, 12 Jun 2023 17:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686590543;
	bh=vlOR8zUqa0xWW55aQjxka+rjurEYPK49ewDDW1z+1z4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AOWot06QUq5Or4bsqOqp8NpKFm67pisZsU/VnFLKpp3Bn8wEUPXECFNrhDLCqjnOP
	 w8j0RUzoLOKxb7TZEU8FSfRwTYmKMMuM3ebGHdNcCUiDnZNhzMLlFBJ6Qu/3r/6g4G
	 JIJ+dXFWiOKF1z/fQpS4tPP2aTy8Wvo14t1KfSXMgWbd5bdkTVg9ahh043CGMmJ0So
	 6A5u1SClwBjn8fBrofwA2Hh4TB1ilYxErKBtwsEfqz6lnlIPAp6fUdq+oxC7bdrn0V
	 NgZoqQogEMjf3Bc+PplGuovqo21f6WmfqzI5CqeJyCpwoND2XbVXtam3FYbZ7gTKnY
	 EyKwW9YvKwizA==
Date: Mon, 12 Jun 2023 10:22:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Wei Hu <weh@microsoft.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, Long Li <longli@microsoft.com>, Ajay Sharma
 <sharmaajay@microsoft.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, KY Srinivasan
 <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
 "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
 "shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>
Subject: Re: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana
 ib driver.
Message-ID: <20230612102221.2ca726fd@kernel.org>
In-Reply-To: <20230612061349.GM12152@unreal>
References: <20230606151747.1649305-1-weh@microsoft.com>
	<20230607213903.470f71ae@kernel.org>
	<SI2P153MB0441DAC4E756A1991A03520FBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
	<20230612061349.GM12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 09:13:49 +0300 Leon Romanovsky wrote:
> > Thanks for you comment. I am  new to the process. I have a few
> > questions regarding to this and hope you can help. First of all,
> > the patch is mostly for IB. Is it possible for the patch to just go
> > through the RDMA branch, since most of the changes are in RDMA?   
> 
> Yes, it can, we (RDMA) will handle it.

Probably, although it's better to teach them some process sooner
rather than later?

