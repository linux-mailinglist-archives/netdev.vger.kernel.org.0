Return-Path: <netdev+bounces-518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F8B6F7DFE
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8629028102A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFB04C77;
	Fri,  5 May 2023 07:34:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD020E7
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7692C433EF;
	Fri,  5 May 2023 07:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683272043;
	bh=jou+LQyRCQeaGqtTBsEiVuLJnU3kOUVjVpVeFNIl5Ko=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=KD8aHhQAFm5Q+jkMUhdKwNqSdtUZx8KYgUV+nSnu0TU6U/OHW2ixhUQ/3vLWnkFwF
	 4I6UfdRf8Brxc/wEravSL6tad5g7lnkPNCJi5GxmX2PepXfJack9f6vtIOSAeI/DFu
	 BNp/hQvbN4e5zoTsXvWJsoe+wv8Kv+063Dng7izZF+FfCvRnowAstQIDYbUqqv6P1x
	 FMl/S6D2MFYoLQd2hRT2/fgYlwt9cAPw/EfIAufkylQMC5q48laVFYidtJ5lRzpjHe
	 PE3RHf9Nwr/7Bfuybi/c5lLeUBaZkW9Mo6H06WprAwyotv0xnR0zgSS1sdXxCF89O8
	 H6dWD51cZ5sLA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtl8xxxu: rtl8xxxu_rx_complete(): remove unnecessary return
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230427185936.923777-1-martin@kaiser.cx>
References: <20230427185936.923777-1-martin@kaiser.cx>
To: Martin Kaiser <martin@kaiser.cx>
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Martin Kaiser <martin@kaiser.cx>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168327203908.10202.16212695864478416217.kvalo@kernel.org>
Date: Fri,  5 May 2023 07:34:00 +0000 (UTC)

Martin Kaiser <martin@kaiser.cx> wrote:

> Remove a return statement at the end of a void function.
> 
> This fixes a checkpatch warning.
> 
> WARNING: void function return statements are not generally useful
> 6206: FILE: ./drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:6206:
> +  return;
> +}
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

271a588d34ed wifi: rtl8xxxu: rtl8xxxu_rx_complete(): remove unnecessary return

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230427185936.923777-1-martin@kaiser.cx/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


