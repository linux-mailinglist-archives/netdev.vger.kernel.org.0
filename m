Return-Path: <netdev+bounces-740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA406F97A2
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C449C281108
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B563823A2;
	Sun,  7 May 2023 08:20:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A381FD9;
	Sun,  7 May 2023 08:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3363AC4339C;
	Sun,  7 May 2023 08:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683447642;
	bh=xYM3ytp2FZNE6DHCOlUbuSgnqlqvEIAzOaUX3+zEY3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0GH64lRZ4VqHiuPcn/1Sc3/M0SIk6nyMcrar6z7ocTFp8sAaZzGEcOLShz7+BC3s
	 mnVrdM74koiAmQQoG55RAwJ4Cxal3t8zmKb9Bv3W0WGTQjV5VVcG6Jok8WTbacR6Q+
	 vbSlRftMXfzPiFfruxpjoHhOOKsq3fcGLjLQ+g8F/WwObXPpCpqmYCCqeMOctMDfXp
	 6cAeVdMX+Lkqd3vOnxdSuTcsMsbRAbPB2EcurEpmycNn/p3huyr2l0fRBIgGJOxTm4
	 Ujh/E/7dMIPcr7caQj34pQg77PEWaMPVuZa+6jx36QAaXWF2hAA4HeI0DnHpPshCfA
	 VcJN+hiGeKPwg==
Date: Sun, 7 May 2023 11:20:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 1/6] net/handshake: Remove unneeded check from
 handshake_dup()
Message-ID: <20230507082038.GF525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333392465.7813.6150331019194277990.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333392465.7813.6150331019194277990.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:45:34PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> handshake_req_submit() now verifies that the socket has a file.
> 
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/handshake/netlink.c |    3 ---
>  1 file changed, 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

