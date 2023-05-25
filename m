Return-Path: <netdev+bounces-5400-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 727C0711196
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DBDA1C208CC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E4F1C779;
	Thu, 25 May 2023 17:03:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB406168D3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D09C433D2;
	Thu, 25 May 2023 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685034199;
	bh=K9n01kiiSt4kRO6VRK0U3IaunCH/mjPmCGWushqaFCE=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=BW+9I/AXFnxNseELZ+15IxLElvl0zyNLVlnJWYcHRu0IrlpC7jiZkWiUGQ8ZvhK3q
	 HDr4fK4ssieD0qGC5k2Q/3YYQNbFKR078nRvsLNTW20nEiWjqcyMrEojIfYlTdzgtx
	 9UDH0sEMDZuKXC15O/yHOmcO8CKMQKKE8yGFosNNsLr4xOQ6S/Ds2T7MHWC5xzNTmv
	 6AWxobC8SwwDD3AnHlwIvELVJjS0nezwg0M2RHeKo83dd9PcITpL+SR9FKuut3eAV4
	 9iGLND/JSCEJTLidzJQUP1YWvPU7jpz0dFv/C1NyhzUzsIEx3BhSJHKrQmzJ93fuVl
	 PNGocxeBKbxDg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: wil6210: fw: Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZGKHByxujJoygK+l@work>
References: <ZGKHByxujJoygK+l@work>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168503419448.19957.18092228078896033455.kvalo@kernel.org>
Date: Thu, 25 May 2023 17:03:17 +0000 (UTC)

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/287
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

cbb3debbb163 wifi: wil6210: fw: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZGKHByxujJoygK+l@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


