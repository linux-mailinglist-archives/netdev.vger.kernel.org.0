Return-Path: <netdev+bounces-744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3182E6F97AE
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6796C1C21C55
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCB0210C;
	Sun,  7 May 2023 08:27:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A901C04;
	Sun,  7 May 2023 08:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C77BC433EF;
	Sun,  7 May 2023 08:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683448039;
	bh=39BFUDcaURhMF4m+2rfCdcLkfYLPT9HwFFpyNWFN7kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8yNs80uFv5GCq/IOo3JN5+gUqLdbp/56uVpM0GcFML9ZiKNQdur01+dbJpln8l/C
	 qriH2cT3YB9AB7c7PXCQ4SzgJPwMo0zBh50mAFxF20kZ2N5MEoz/CsEw4aE3h46I1T
	 7mepT3t2groO3iM1jIsWK+2NE0RtlUO3ngIYfmeM6VW+9p+ARNENHuhP7EE6SUCj5w
	 Uzju9coYIYy0ejDNsGoXgPJSr4HmaGhJqL6a1lB+PSxafEuntRswQQmVDoVlWnqyIO
	 M5onUrQ0MDTJM2QS2BrvHnsaOTiYYQ3pZKiZLHLFqhHSpSZObtn+b3Ej0XVLQxs1bq
	 72vBaN3unkasQ==
Date: Sun, 7 May 2023 11:27:15 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 6/6] net/handshake: Enable the SNI extension to work
 properly
Message-ID: <20230507082715.GJ525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333405010.7813.3126925595560504793.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333405010.7813.3126925595560504793.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:47:40PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> Enable the upper layer protocol to specify the SNI peername. This
> avoids the need for tlshd to use a DNS lookup, which can return a
> hostname that doesn't match the incoming certificate's SubjectName.
> 
> Fixes: 2fd5532044a8 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  Documentation/netlink/specs/handshake.yaml |    4 ++++
>  Documentation/networking/tls-handshake.rst |    5 +++++
>  include/net/handshake.h                    |    1 +
>  include/uapi/linux/handshake.h             |    1 +
>  net/handshake/tlshd.c                      |    8 ++++++++
>  5 files changed, 19 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

