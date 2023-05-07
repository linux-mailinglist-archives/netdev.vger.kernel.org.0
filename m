Return-Path: <netdev+bounces-743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CAEDD6F97AD
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD7311C21C0C
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E814210C;
	Sun,  7 May 2023 08:27:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F691C04;
	Sun,  7 May 2023 08:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDF7C433EF;
	Sun,  7 May 2023 08:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683448020;
	bh=qt9QyauR2MiiUcFYMewwWNdLQR+7zHdSs02BNyXj3vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VXzMMd80x0yKhrISkUqytkE6yWC8BCT5RW6HlI9WiOJDapdvENQE4RAfB85Lp2y36
	 RW/QEzT8IeHcpOWZHcZQYP3ukOr/stDdpew2IPX53cIftlgh8hg6wiV2x18/Hco6Fn
	 Zuhn5rxho8UOcQT4cgJZGVEJ8BH5i/4AJBT3iNBT8lWzSaA6yUxXUWA5nDB17bEHrN
	 igqyNm6Gk52QburV9bTn2gM7ABocHSITxRlcsaPVzukS0EJ/ri+IocyU34HVe4HVF8
	 b9evQrQBIitDySosmyOsT/fA2r2wTHwHMdz5Lc/G5DChtGnxlSKeXgQCIYF4qngVLx
	 ztQg0J2kOD38g==
Date: Sun, 7 May 2023 11:26:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 4/6] net/handshake: handshake_genl_notify() shouldn't
 ignore @flags
Message-ID: <20230507082656.GI525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333400429.7813.12377237975512449615.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333400429.7813.12377237975512449615.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:46:54PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/handshake/netlink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

