Return-Path: <netdev+bounces-5402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AF671119C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 663B72815DA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29071D2A2;
	Thu, 25 May 2023 17:04:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D63168D3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB65C433D2;
	Thu, 25 May 2023 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685034293;
	bh=gBgpG9vTwOaMKv/+/eY1oC9MAIfEaLOfyfZw8B7xYrs=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=pio0Er+luZrzNM1SJ2AttAghtZM4LVeBGEhQJeM8Btg85aqeZ7C0Uk0WtKDGG48Hh
	 3SvpKa7OJKD21AzpxfUrxY0K6PiIbpIG2Cd1EidA3FOwdiYMtDsgP8c3SnaoTyDCDL
	 Oth+XHrdB2RPFdHB9gRJXFxYMD8tTQsG6iL+PvNWZrcwn22p4nktAuZOzgSkPimdPP
	 huP2sDOiV5QXSqeEwmdAHnJEqY6wOR4r41JG04UUpZQGMabslLkYHOfui+rP+xmMF1
	 vmSqg+dYqpgXHSHm4Abtsp/KplIC8kVbOGMHywkQCNCCSvMycqmrifBux7tTi59mFm
	 oYEmkyuR07H3g==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] wifi: ath9k: don't allow to overwrite ENDPOINT0
 attributes
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230516150427.79469-1-pchelkin@ispras.ru>
References: <20230516150427.79469-1-pchelkin@ispras.ru>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
 Fedor Pchelkin <pchelkin@ispras.ru>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Takeshi Misawa <jeliantsurux@gmail.com>,
 Alexey Khoroshilov <khoroshilov@ispras.ru>, lvc-project@linuxtesting.org,
 syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168503428836.19957.620283860814904448.kvalo@kernel.org>
Date: Thu, 25 May 2023 17:04:50 +0000 (UTC)

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> A bad USB device is able to construct a service connection response
> message with target endpoint being ENDPOINT0 which is reserved for
> HTC_CTRL_RSVD_SVC and should not be modified to be used for any other
> services.
> 
> Reject such service connection responses.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

061b0cb9327b wifi: ath9k: don't allow to overwrite ENDPOINT0 attributes

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230516150427.79469-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


