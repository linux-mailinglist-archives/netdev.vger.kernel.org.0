Return-Path: <netdev+bounces-7509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 199E27207F6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C827428194F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C674A332F6;
	Fri,  2 Jun 2023 16:54:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A0332E1;
	Fri,  2 Jun 2023 16:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BABC433D2;
	Fri,  2 Jun 2023 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685724848;
	bh=cn8PP+KjC0WdCEavBUy1xLwsTmD3K1c7Pp/44YdagUc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MLYFWvjvPLphpN5Mb3iQJwqqIMW3Dm2kYlBVp41Lqw8WsAX2cMaz15LCUGAYUrfO8
	 dEl/ZeJ8RVHSiktRjhv531xztCw8MXvkribL1MhTA1BeWUVMGJQh+DrDWJQ88s5R/s
	 FzTdeVacX2FN2l3W+NxvYwMjE504jwU5c9EHrT6DrAS5f0Lj8UQAtSdBS+g1+UmhLR
	 M/9Hymur+J7mDh+QCGUl/WKTGzPKwjB5enIcpbdfXxUeqyeUbbwLYPHJdHZqFILDSH
	 rpvL7Fa8sXCxdtMMEPeVKT+v7dmT98RsUDzG458g99hy6fLAaoeljHz8v0Spw48SXf
	 XAwm/r7XfSyKA==
Date: Fri, 2 Jun 2023 09:54:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>, Chuck
 Lever III <chuck.lever@oracle.com>, "elic@nvidia.com" <elic@nvidia.com>,
 "saeedm@nvidia.com" <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>, "open list:NETWORKING [GENERAL]"
 <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Message-ID: <20230602095407.109bdffc@kernel.org>
In-Reply-To: <ZHn8xALvQ/wKER1t@ziepe.ca>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
	<bf2594bb-94e0-5c89-88ad-935dee2ac95c@leemhuis.info>
	<5b235e0f-cd4c-a453-d648-5a4e9080ac19@leemhuis.info>
	<AAFDF38A-E59A-4D6A-8EC2-113861C8B5DB@oracle.com>
	<bb2df75d-05be-3f7b-693a-84be195dc2f1@leemhuis.info>
	<ZHn8xALvQ/wKER1t@ziepe.ca>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 11:29:24 -0300 Jason Gunthorpe wrote:
> > > Also, checkpatch.pl is now complaining about Closes: tags instead
> > > of Link: tags. A bug was never opened for this issue.  
> > 
> > That was a change by somebody else, but FWIW, just use Closes: (instead
> > of Link:) with a link to the report on lore, that tag is not reserved
> > for bugs.
> > 
> > /me will go and update his boilerplate text used above  
> 
> And now you say they should be closes not link?
> 
> Oy it makes my head hurt all these rules.

+1

I don't understand why the Closes tag were accepted. 
I may be misremembering but I thought Linus wanted Link tags:

Link: https://bla/bla

optionally with a trailer:

Link: https://bla/bla # closes

The checkpatch warning is just adding an annoying amount of noise
for all of use who don't use Closes tags.

