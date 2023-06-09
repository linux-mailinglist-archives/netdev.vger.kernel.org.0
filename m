Return-Path: <netdev+bounces-9698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B147C72A426
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56C32281A35
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A86922611;
	Fri,  9 Jun 2023 20:12:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0C1408CF
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7F8C433EF;
	Fri,  9 Jun 2023 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686341574;
	bh=5QXBWfT3McVoDL8GcvDKbyJA6sEXfvSsfFkUeNdpUc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fpUM0NDr8BbaxAOZcH1EBiuNV9BxE4EowKrGyehbT/gHmCwPP4m2pmF3f01T5p122
	 oNm2qEIt+aUBY/hzvF/iaDSMQH+GsnbTt0ZA7lb3aXEqC5iYfIt23wAMLfT5B8NbBe
	 oxBJG9U6nP3TOdS7CqtfyXhT5tHgBY+aCAhka370Wt32VWzFRQ4+GOHaRuybyvglRv
	 /dvRe4A0zCoRCBf9Q4rBASD3nD5rnCTrG8iEFL33zAYQo6OCRiz6zU7kWdHurBybBc
	 zz/vnTCtK/kvio75048zNx/i20y4jP2kp93+U3J4LQ6vK+3vMc9umM5nPRp/DDPala
	 Ls5eVPfvhjGaA==
Date: Fri, 9 Jun 2023 22:12:51 +0200
From: Simon Horman <horms@kernel.org>
To: Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: Make dmae_reg_go_c static
Message-ID: <ZIOHw9Tj8YJGViN2@kernel.org>
References: <20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org>

On Fri, Jun 09, 2023 at 03:51:30PM +0200, Simon Horman wrote:
> Make dmae_reg_go_c static, it is only used in bnx2x_main.c
> 
> Flagged by Sparse as:
> 
>  .../bnx2x_main.c:291:11: warning: symbol 'dmae_reg_go_c' was not declared. Should it be static?
> 
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>

Sorry, it looks like I didn't test this as I thought I had,
and it breaks the build.

-- 
pw-bot: reject


