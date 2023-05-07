Return-Path: <netdev+bounces-745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFE86F97B0
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F12B28121F
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972781FD9;
	Sun,  7 May 2023 08:27:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F41C04;
	Sun,  7 May 2023 08:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F31C433EF;
	Sun,  7 May 2023 08:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683448074;
	bh=luhCUiWvTKFZW0rqUS0UuzAGiUr2t0MkDIwftiLSgQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EuRV+j9/6qrKXkHOCy1z/kx8OV4ygs9w/rG2cZgaZyOTX17uSmuOQDSRNlrQwDzdw
	 V+PWg/Z92PfzaLwzETMtKaLulDBXMVo8bwO44OO1x6BOa6YdFcPOwQgz/eyf3fGuSi
	 weJJOiQbv59/m7rdWl2E+jbniSvIt5vibJx/4brqG7DgScPW2Cww2o/7LdejQPgDaP
	 5Kj7TkOMKklr8LqY3BUT2rexqY26En0WXr31lBpQayRIV/4rllnF3UeHJrMgMURowA
	 +8htQt/XBCTqVwU/8wdQsqILRh0rsjlSXQgA9L80ZlBSrHNnvpzkDkRdGDeRQT+Bxf
	 pgvDFnlOVgHGw==
Date: Sun, 7 May 2023 11:27:50 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 5/6] net/handshake: Unpin sock->file if a handshake is
 cancelled
Message-ID: <20230507082750.GK525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333403089.7813.511134747683134976.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333403089.7813.511134747683134976.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:47:13PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If user space never calls DONE, sock->file's reference count remains
> elevated. Enable sock->file to be freed eventually in this case.
> 
> Reported-by: Jakub Kacinski <kuba@kernel.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/handshake/handshake.h |    1 +
>  net/handshake/request.c   |    4 ++++
>  2 files changed, 5 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

