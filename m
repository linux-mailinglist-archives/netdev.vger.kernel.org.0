Return-Path: <netdev+bounces-561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 112426F8278
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 381F9281007
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E147479FE;
	Fri,  5 May 2023 12:02:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F6156C6
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52167C433D2;
	Fri,  5 May 2023 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683288150;
	bh=nbaPAqCZ0ApBkXNXBOc2q5/hPJyXqyM1jtg1d1NSImQ=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=oBVIJZ8gfjJPFebPgZDymaw2OqePdHrgpsH/82m4mYRkC0xkVJby4S5uSI+ua7uUM
	 3qfR3ROKQFpIkJzUnfc1QVu6iQ2CRFlmjEQAfTmg01RKYixOQAqvNZkzWLZbGlhTnR
	 nGC0Dg4nUk4FquZzBvLRnf4CnsK18QQg2HgYgJssT7XcK75qWAG7YlMsgQo3KNvzdK
	 8Aye1rgH03MF2PryyEiQR0UgojTWxurrw7TqVB67s0GIAigSuQ2xLJTbklgj8qnbcd
	 fhHueJ3AdeXxtdbOoCL/rpj1J+uEbvvFhvwoTQe10Souei2UXO9IWjMCnHDsfCpyN/
	 83KG89ucSagiw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] wifi: mwifiex: Use list_count_nodes()
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: 
 <e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr>
References: 
 <e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
 Ganapathi Bhat <ganapathi017@gmail.com>,
 Sharvari Harisangam <sharvari.harisangam@nxp.com>,
 Xinming Hu <huxinming820@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168328814540.30117.8252541774240707709.kvalo@kernel.org>
Date: Fri,  5 May 2023 12:02:27 +0000 (UTC)

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> mwifiex_wmm_list_len() is the same as list_count_nodes(), so use the latter
> instead of hand writing it.
> 
> Turn 'ba_stream_num' and 'ba_stream_max' in size_t to keep the same type
> as what is returned by list_count_nodes().
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-next.git, thanks.

c401bde6ead4 wifi: mwifiex: Use list_count_nodes()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


