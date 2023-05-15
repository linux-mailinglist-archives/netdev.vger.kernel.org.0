Return-Path: <netdev+bounces-2607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8FB702B00
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDF951C20960
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5575A954;
	Mon, 15 May 2023 11:01:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D781C13
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0F1C433D2;
	Mon, 15 May 2023 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684148499;
	bh=4mAlHlm1TO+UKzBjyEfEjZ5xwoceajajA0/RCVAfT9c=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=KRueawOOoYcKfWSH7TfEO522jF9PaGfxSKPu0QxQKWiqfTz1nRZhxeKa2m75dAjUq
	 8Jrd868VI7XxsTavXjpnE1hxwK5ghwDbybsd7vuY7mnapbyiOe83GmmG2ZXZOjRq7N
	 BbEcWFIyc2tWp13VlKyroY2QalRUmBMbciPFb3/clg96l5HE9XBl0JodYtUomJNDEb
	 UvKS2TvD3HCiS9J8GQFQcpfZP/s8nCuaULTXKYsK65ch7ocOFufq9lZcUzCx68C6sG
	 OBydeKSp4N+aiUtwDTi/mJG0e4TNq7gBqt1UZZwVsJZjQH6VzO+KNTzDOpf39+dbRF
	 r8lTnnbFHn0DQ==
From: Kalle Valo <kvalo@kernel.org>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: <linux-wireless@vger.kernel.org>,  <netdev@vger.kernel.org>,  <johannes@sipsolutions.net>,  <davem@davemloft.net>,  <edumazet@google.com>,  <kuba@kernel.org>,  <pabeni@redhat.com>,  <jaewan@google.com>,  <steen.hegelund@microchip.com>,  <weiyongjun1@huawei.com>,  <yuehaibing@huawei.com>,  <syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net-next,v2] mac80211_hwsim: fix memory leak in hwsim_new_radio_nl
References: <20230515092227.2691437-1-shaozhengchao@huawei.com>
Date: Mon, 15 May 2023 14:01:34 +0300
In-Reply-To: <20230515092227.2691437-1-shaozhengchao@huawei.com> (Zhengchao
	Shao's message of "Mon, 15 May 2023 17:22:27 +0800")
Message-ID: <87ilctn9ip.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> When parse_pmsr_capa failed in hwsim_new_radio_nl, the memory resources
> applied for by pmsr_capa are not released. Add release processing to the
> incorrect path.
>
> Fixes: 92d13386ec55 ("mac80211_hwsim: add PMSR capability support")
> Reported-by: syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: move the value assigned to pmsr_capa before parse_pmsr_capa
> ---
>  drivers/net/wireless/virtual/mac80211_hwsim.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

drivers/net/wireless changes go to wireless-next, not net-next. But no
need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

