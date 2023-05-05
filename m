Return-Path: <netdev+bounces-562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A21F6F827F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB60280EE5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AF16FA0;
	Fri,  5 May 2023 12:03:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345E156C8
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32BDC433EF;
	Fri,  5 May 2023 12:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683288199;
	bh=Ndf4luLTqs4g+H4PSvF6ERtG4AtnUUEJcgo5864W62E=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=SXZpN9CSSkf1w1OHnHLXuMwnio1laXiwGHsj8vus6U/oSpc6lMjTNSRxGHX4V31BI
	 b4YbmBUfD26Bp9GaEAr8IM4n/oXjm2o03PqFy53u3e0ZSKd73sAs+z5rgFVzQlKJcB
	 0mIAa4tBT3ik4nG0i/gms3GNiODyglbVTKDtijqjrJzO7SCzbhYtkCtyUW8xH5D1HP
	 jpV27RyuQkhKv99x/+PQGA9Ay/34YGZqm8AENDAzmn0KkNJw0JXiaXMLxRq5G2YlHy
	 3Q0mdnRAW7aBHBh6WxzLvqv4i6RQQBqRNNw59SZvIonXw4CeKdrWdMXDntjO4RaMJF
	 pnyRcjQ2LMbbw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: mt7601u: delete dead code checking debugfs
 returns
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230421092200.24456-1-wangjikai@hust.edu.cn>
References: <20230421092200.24456-1-wangjikai@hust.edu.cn>
To: Wang Jikai <wangjikai@hust.edu.cn>
Cc: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
        <angelogioacchino.delregno@collabora.com>,
 hust-os-kernel-patches@googlegroups.com, Wang Jikai <wangjikai@hust.edu.cn>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168328819522.30117.3097099418946262250.kvalo@kernel.org>
Date: Fri,  5 May 2023 12:03:16 +0000 (UTC)

Wang Jikai <wangjikai@hust.edu.cn> wrote:

> Smatch reports that:
> drivers/net/wireless/mediatek/mt7601u/debugfs.c:130
> mt7601u_init_debugfs() warn: 'dir' is an error pointer or valid".
> 
> Debugfs code is not supposed to need error checking so instead of
> changing this to if (IS_ERR()) the correct thing is to just delete
> the dead code.
> 
> Signed-off-by: Wang Jikai <wangjikai@hust.edu.cn>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Patch applied to wireless-next.git, thanks.

f3dc7bb037d8 wifi: mt7601u: delete dead code checking debugfs returns

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230421092200.24456-1-wangjikai@hust.edu.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


