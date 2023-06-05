Return-Path: <netdev+bounces-8152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C90D4722EA4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4033B1C209DD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23CD2263F;
	Mon,  5 Jun 2023 18:21:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCB022623
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B97C433D2;
	Mon,  5 Jun 2023 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685989299;
	bh=XILyVGCrV1RwhErsOtjHXQIissMx6pKKMWDtLGx445Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aDpebFeKwEyDph4I14Q8EevvmAIrdcL5/ji0elqcEhxHJgSCoVdQQO7i9zBDnnE0l
	 XbDbF1xj/g0oVEP8Rn3ramrDpCNjOhDSv9xeeAuLKCSd+KgCwR3my81F8+1/svlnXe
	 sxWym7wKhmrLdgtgn9ca4LqtTCxBFHyKVFnrWOqtt9kTvwvN1JfqktGjQh967wDpAj
	 wZCnGrY29n+B2uF/HRQ/2Qi5ck6C0rGA83nvISrCq/Slmwn7k8npKqw3A7/Qvv7pV6
	 yIu0UkHPj+nOcvyTpA5RrhwlWdjsMWeiPai/lUkXuNAMQz928gAaC9R495tdAk6r4P
	 FhbOKDx7AlOwA==
Date: Mon, 5 Jun 2023 11:21:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <20230605112138.7fb4b963@kernel.org>
In-Reply-To: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 13:53:49 -0700 Justin Chen wrote:
> The netlink version of set_wol checks for not supported wolopts and avoids
> setting wol when the correct wolopt is already set. If we do the same with
> the ioctl version then we can remove these checks from the driver layer.
> 
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>

If I understand the discussion correctly the patch is ready to be
applied. Could you repost it? It has been marked as "changes requested"
in patchwork, I'm not 100% sure about the reason.

