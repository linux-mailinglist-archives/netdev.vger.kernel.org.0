Return-Path: <netdev+bounces-568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A516F837C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 710B91C217F8
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C74CA954;
	Fri,  5 May 2023 13:07:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293E156CD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1E7C433D2;
	Fri,  5 May 2023 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683292074;
	bh=79GP8oXho+dfqQeJ9uzaGIMD8UOrca7fRPGnKMX7260=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=ZicXFbz5jZNyVMlORYCz7kdzL7JnEhsJD8hTUYsluy8Ja7g6QjmtmrtEtzTBhfWXw
	 1MKOD8EZGapobKYgPTi/t5pOw74CzsRHSQoD7vsn9Xi+QRRSy/mHpyemajBuVjWOTM
	 zfx+JyQOc2dl+rVq4LyVtCbmNippsL6CbGNM+0kiLfkWCI0BI4Hg9rfdo/bI8rvO1a
	 3EKzQJXd5ZM8GCxTJmo8KeBdfpWgy4yi/X+BKdKt5L6yMAyWMsmsG5QHTu2sAmJZru
	 ziIQ/oBWQajqkALiJp/UpygjmsDaicyIus2cLG9TJLuiDOBevUsWyRB6KQzb9sfu8L
	 KKn8JK8W9vnJw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] wifi: ath10k: Use list_count_nodes()
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: 
 <e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr>
References: 
 <e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168329207040.10223.8921513791102227473.kvalo@kernel.org>
Date: Fri,  5 May 2023 13:07:52 +0000 (UTC)

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> ath10k_wmi_fw_stats_num_peers() and ath10k_wmi_fw_stats_num_vdevs() really
> look the same as list_count_nodes(), so use the latter instead of hand
> writing it.
> 
> The first ones use list_for_each_entry() and the other list_for_each(), but
> they both count the number of nodes in the list.
> 
> Compile tested only.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

fd7bc9d9d467 wifi: ath10k: Use list_count_nodes()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


