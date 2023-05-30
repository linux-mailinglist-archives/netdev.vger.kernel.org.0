Return-Path: <netdev+bounces-6235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA807154C0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 837AC281083
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16664A12;
	Tue, 30 May 2023 05:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95E46B9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D0C433EF;
	Tue, 30 May 2023 05:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423432;
	bh=YIE1jbD6qv3fPbOdGRC2Fp/dwDArDOqdaDS7Knw2oEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YaSau9Vf5FlS/qU3sIjys5dBZWiD2xUDdbIHlcu5uNNUGQx/D7posF7krJ9Ywdnnw
	 XAJI+ITfzO6e81D7LwdtaW1mtNENDPOE1GUcT4RNgw8wjie4hM4rvJa+TlKWLmkMiX
	 oFbuM0fyN1pCzBwT/TpRwkEm+7Y7YdpwdM9d2s8v3Gluck+wDnjXT1r+qVjR6dm4XC
	 m0Yx5ibajYwkFdjzl1mKuIsK8ubutsnVZkU0xHpdboJVj9PuK/rizn2SfbzNYInTPp
	 RteUsuAuSr0zE9tV+AUcot1L+TK3wc/rATEczd/mi0VRBw1xyvSkSQQiZdzI6UsCR0
	 5ycShPv0VK5iw==
Date: Mon, 29 May 2023 22:10:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bert Karwatzki <spasswolf@web.de>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, elder@linaro.org,
 netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: Use the correct value for IPA_STATUS_SIZE
Message-ID: <20230529221031.1a0a1a75@kernel.org>
In-Reply-To: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 May 2023 22:46:25 +0200 Bert Karwatzki wrote:
> commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c introduced
> IPA_STATUS_SIZE as a replacement for the size of the removed struct
> ipa_status. sizeof(struct ipa_status) was sizeof(__le32[8]), use this
> as IPA_STATUS_SIZE.
> 
> From 0623148733819bb5d3648b1ed404d57c8b6b31d8 Mon Sep 17 00:00:00 2001
> From: Bert Karwatzki <spasswolf@web.de>
> Date: Sat, 27 May 2023 22:16:52 +0200
> Subject: [PATCH] Use the correct value for IPA_STATUS_SIZE.
> IPA_STATUS_SIZE
>  was introduced in commit b8dc7d0eea5a7709bb534f1b3ca70d2d7de0b42c as a
>  replacment for the size of the removed struct ipa_status which had
> size =
>  sizeof(__le32[8]).

The posting looks damage, could you try sending again (with git
send-email maybe?)

Before you do:
 - please make sure the change applies to:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
 - add a correct fixes tag
 - fix issues pointed out by checkpatch --strict
-- 
pw-bot: cr

