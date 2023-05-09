Return-Path: <netdev+bounces-1179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1AE6FC823
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D19242812F1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C51182D7;
	Tue,  9 May 2023 13:41:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253DA6116
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F63C433EF;
	Tue,  9 May 2023 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683639687;
	bh=R7cToSUJhPLimXgiY5o29IKd+9R8oGu8VsdxVABf9ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lTj6WY0BXcDV9ys7JEOJjBBwIi9uXroTPcTCRQxpHBKrxwpyloSetG5EVBWinhcuM
	 cnt5/jRHD1+ai3KhQ8BTeFLc4oEtCn9u09Q6Gp84Z/mrXefSAzArR6fBEJnwPPVp89
	 JXIu2A8aZur2TJn1fIr3WCxqU1Eaem/cjQ5u+Jdc8i8+cMBiLCxioPWEkkHgJ2M4pl
	 fKQKVjmAsRihbL4ywFRojFtDKzuc4Ismv4QeuiHZ4lR1ZNgVR0eBNcRHQpArBu3JCb
	 F9f2yoY8qNZqqkWXPYVi6Zz+ZLPAW+t1lx9wum47L5cnkMO7bVp29azsEc5Qjtok8L
	 UgJKswNQl0EXA==
Date: Tue, 9 May 2023 16:41:23 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/2] net: remove __skb_frag_set_page()
Message-ID: <20230509134123.GM38143@unreal>
References: <20230509114337.21005-1-linyunsheng@huawei.com>
 <20230509114337.21005-3-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509114337.21005-3-linyunsheng@huawei.com>

On Tue, May 09, 2023 at 07:43:37PM +0800, Yunsheng Lin wrote:
> The remaining users calling __skb_frag_set_page() with
> page being NULL seems to be doing defensive programming,
> as shinfo->nr_frags is already decremented, so remove
> them.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> RFC: remove a local variable as pointed out by Simon.
> ---
>  drivers/net/ethernet/broadcom/bnx2.c      |  1 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c |  5 +----
>  include/linux/skbuff.h                    | 12 ------------
>  3 files changed, 1 insertion(+), 17 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

