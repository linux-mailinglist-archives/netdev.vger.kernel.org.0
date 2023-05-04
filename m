Return-Path: <netdev+bounces-246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB746F65B9
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B341280C5E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2866B1111;
	Thu,  4 May 2023 07:29:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D553E1861
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AE2C4339B;
	Thu,  4 May 2023 07:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683185397;
	bh=WNEFMNmQsK51QMNGJ8XauKO9/SbZVRuHCAz9XHkKmgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X1YDVsfvjN/uqC4HDXkTBsREVWEsq63XeJfxaypW3yGjZGRvcaCtEUhTNLwVQAIsg
	 XtQQZqLssAn2GUbfzpiIRjcRRDFf1fmae9ZVa/kwTcMNOg2hB8hK0Ou1hss264IjoR
	 oTY+Zlj1ggvRIID4X7UKtu4IstDe9+b7Qrdxg9FJcgdPKuOAyEd9WQj3pfIU0pKGYZ
	 88QvxTK+21bJNrzcYoUvDmPppB4Z+b6ndM+0k7ezh2zxUZyoQ98q6PmrFM0XeGKxo3
	 OOKNu5LM8hm++pKP/nYXA9HIAfUATpkYqCEgDCsIuQHcdpTPlh/7NztKPH988o6KDU
	 lfRcpG+4Kd2eQ==
Date: Thu, 4 May 2023 10:29:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Message-ID: <20230504072953.GP525452@unreal>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>

On Wed, May 03, 2023 at 02:02:33PM +0000, Chuck Lever III wrote:
> 
> 
> > On May 3, 2023, at 2:34 AM, Eli Cohen <elic@nvidia.com> wrote:
> > 
> > Hi Chuck,
> > 
> > Just verifying, could you make sure your server and card firmware are up to date?
> 
> Device firmware updated to 16.35.2000; no change.
> 
> System firmware is dated September 2016. I'll see if I can get
> something more recent installed.

We are trying to reproduce this issue internally.

Thanks

