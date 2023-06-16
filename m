Return-Path: <netdev+bounces-11548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9653733879
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D5B1C21040
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC3B1D2AF;
	Fri, 16 Jun 2023 18:54:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1C1B915;
	Fri, 16 Jun 2023 18:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DACC433C9;
	Fri, 16 Jun 2023 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686941663;
	bh=0dbpgIQpQlZbtrW3rVouz+6CCZUXx6As4VlGNo5D7ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EiIWf4Nqk5OmEjkdyBZcePFuIMAHPbb0Wzhc6Qs607b5GCyzTM2ZluQ+eXwgCBy5O
	 njSWgp7QImwiW3EXdf02TPpV/KYYinVg2N3yL9rxVgFR1UtdjhSRb6Y2vg03sM6/RT
	 nfyqjGr540NdGYcThFDpCwHmk3zefFyrc5RnC4MDinN91XaZaAhFGxsc8zNF/Z6Hpg
	 MrwbMhPzCFfAr5fUywrFwKSfYYvsBN99J0bXMkrab4pyzJCPOHaXf7u1Gjqz0OOyVG
	 XIitrHFMw/VKjEBZckAVGg19+qq81K/UNahWcb+lIgx0CFbWW2bg2Pc2SPpb3cxWYo
	 BcFSw7fGMOzHg==
Date: Fri, 16 Jun 2023 11:54:21 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] xdp_rxq_info_reg fixes for mlx5e
Message-ID: <ZIyv3b+Cn2m+/Oi9@x130>
References: <20230614090006.594909-1-maxtram95@gmail.com>
 <20230615223250.422eb67a@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230615223250.422eb67a@kernel.org>

On 15 Jun 22:32, Jakub Kicinski wrote:
>On Wed, 14 Jun 2023 12:00:04 +0300 Maxim Mikityanskiy wrote:
>> Marked for net-next, as I'm not sure what the consensus was, but they
>> can be applied cleanly to net as well.
>
>Sorry for lack of clarity, you should drop the fixes tags.
>If not implementing something was a bug most of the patches we merge
>would have a fixes tag. That devalues the Fixes tag completely.
>You can still ask Greg/Sasha to backport it later if you want.
>

You don't think this should go to net ? 

The first 3 version were targeting net branch .. I don't know why Maxim
decided to switch v4 to net-next, Maybe I missed an email ? 

IMHO, I think these are net worthy since they are fixing 
issues with blabla, for commits claiming to add support for blabla.

I already applied those earlier to my net queue and was working on
submission today, let me know if you are ok for me to send those two
patches in my today's net PR.

Thanks,
Saeed


