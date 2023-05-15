Return-Path: <netdev+bounces-2741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A557703C8E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB141281302
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF47717FF2;
	Mon, 15 May 2023 18:25:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966EC2C8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFE5C433D2;
	Mon, 15 May 2023 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684175128;
	bh=Ig15CCmRbUDwPdPSwSK6wyvGYkr4LLBCPsnJsdn+kxc=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=WWqgCUvVE4SWqJhd6/HvsEI3yUhzihrHCFHep97/HecWMzqFFL7iqK68FJ7dIxva/
	 GrB6/PUR+dRLm7VYmWDCGyy2ENv+QXUHT4TlgWcnErrfnGVcLAaqH+nT6Y+dBLzyNI
	 ix4gmt5lVp4+27curWS55iBcCO4G1aIQw2n8A8NLLyQGHkhCeMUSEhS+g9PNpLsPKG
	 5rciF5NncV3/zcYcVXwTuNjXAgSIlLZ/MGksntjpYkMRv7EFZd6gzHiFkV76+isBTB
	 ynZI8nZ7vnhdbeiPCm6yRhOAr/RTrFXP6K/r2By+1emMjkPhH4cjN5FQOWOCRJWZOR
	 J5I+CSUtoNCOQ==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: wcc: Add debug messages
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230509100420.26094-1-matthias.bgg@kernel.org>
References: <20230509100420.26094-1-matthias.bgg@kernel.org>
To: matthias.bgg@kernel.org
Cc: Arend van Spriel <aspriel@gmail.com>,
 Franky Lin <franky.lin@broadcom.com>,
 Hante Meuleman <hante.meuleman@broadcom.com>,
 Paolo Abeni <pabeni@redhat.com>, brcm80211-dev-list.pdl@broadcom.com,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
 SHA-cyfmac-dev-list@infineon.com,
 Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
 Matthias Brugger <mbrugger@suse.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168417511892.10390.13808783964763445641.kvalo@kernel.org>
Date: Mon, 15 May 2023 18:25:25 +0000 (UTC)

matthias.bgg@kernel.org wrote:

> From: Matthias Brugger <mbrugger@suse.com>
> 
> The message is attach and detach function are merly for debugging,
> change them from pr_err to pr_debug.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-next.git, thanks.

87807f77a03d wifi: brcmfmac: wcc: Add debug messages

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230509100420.26094-1-matthias.bgg@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


