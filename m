Return-Path: <netdev+bounces-742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8FB6F97AC
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC6EE1C21C49
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97221FD9;
	Sun,  7 May 2023 08:26:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E131C04;
	Sun,  7 May 2023 08:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1479DC433D2;
	Sun,  7 May 2023 08:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683448003;
	bh=zFzx0BQjFVOJ719pWktaEBEXuqLT77RvY5ycpr8p390=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bS1KKQY7JZtRX27knochv2syHf/n8jyj0Ye81aiGbW7N2rsdZKhcJltvDLnVCzhHg
	 r4hsGgaIfgtXC8dOaS2193ziqRk+kmG2bg005BUn6Wu+SqQpOuHV6oQA09OhnJOdWP
	 88rWtXnj2iutCMK9UJRN+KjLvERfZqR0emr4Lz4uGS0hlI3tmbNFeWOX/9iWmiNItU
	 Ed60ArN2PZg95IdFNnxkPdKF6UD5NDATnoRunIOKKoWyqRZUZbmZGTDQkhDiBTiFS1
	 V5SS7WUIqnvcVD6OBTsDbuqHYWsOUNfDRb0pp1ipPGl4yBGvbU50snyIX9YCCLxpp7
	 rEZ5qMroGl+sg==
Date: Sun, 7 May 2023 11:26:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 3/6] net/handshake: Fix uninitialized local variable
Message-ID: <20230507082639.GH525452@unreal>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333397774.7813.3273700580854407784.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333397774.7813.3273700580854407784.stgit@oracle-102.nfsv4bat.org>

On Fri, May 05, 2023 at 08:46:27PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> trace_handshake_cmd_done_err() simply records the pointer in @req,
> so initializing it to NULL is sufficient and safe.
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

