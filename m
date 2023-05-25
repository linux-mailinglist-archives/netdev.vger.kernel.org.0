Return-Path: <netdev+bounces-5401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF7B71119A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EFF12815B2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DD51C77F;
	Thu, 25 May 2023 17:04:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB927E3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD71EC433EF;
	Thu, 25 May 2023 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685034237;
	bh=TPlPKAj0p+zEqi9z0wS9kwH6FfheU3xhHZLDGA9HSMI=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=WulJw5conWhP1Dnf+r2lYH3dRz1hcS/L7rpxgSyv16nh8X3+iYKTxP70dPDmOzojR
	 2GHX+1oVGYrIqKu1JFz07eKVxqPse+fqem4POSGVurzyMgcY0j8RhH/0utl01k7WDb
	 +aSbKnhEELRwjJ7lOHvMHLjzthAUb17SjlVzSpLb1bpXx1oz7hE0/bB3Ty98OecFjP
	 n4arCtcvZhXXxTtroxeDwI0jZBK36e3cBOUSzo/QnU/CJ8LAE08EG0vCmB/eSfFYUs
	 OYzfPvUabl9HwQrJesUFxJZXqu8A5p26immo0He1XiaVrxx38rTxnCu7BNUzAotaa3
	 8QqrRnsqcE1yw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: wil6210: wmi: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <ZGKHM+MWFsuqzTjm@work>
References: <ZGKHM+MWFsuqzTjm@work>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168503423402.19957.8400109691029717015.kvalo@kernel.org>
Date: Thu, 25 May 2023 17:03:55 +0000 (UTC)

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Zero-length arrays are deprecated, and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/288
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

27044b57f8a5 wifi: wil6210: wmi: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/ZGKHM+MWFsuqzTjm@work/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


