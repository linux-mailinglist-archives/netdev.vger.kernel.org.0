Return-Path: <netdev+bounces-5829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 908CD713097
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:46:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4595B1C21171
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 23:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7935E2D25C;
	Fri, 26 May 2023 23:46:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF8D2A9CD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 23:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D471C433D2;
	Fri, 26 May 2023 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685144792;
	bh=I4lYkOFZvx58rbnVvULMZS4axHFQkxM1tVU7ysZFxbc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YxF7W0v30+RaDhyUCIcTWdQmXk9n6STtZIifXCad5BxcrGcNY6SKl8Y4aXLQR60m+
	 dXslAeWCp0u0OtKNG4xlfE+5q0E7L3pJL5ng2mTv+jGL2WG8pMk55ITw4lWANXxwpF
	 gnj15j20MP5dypfb3g20uB9qgpzpXTNeFzQmvXGq/nBdIEpHIyQgpwb+ufJ8c46zoZ
	 ijbuFLC5RAOCINXQWWPLXpyENEuS0MvA+2sDZ9uCdlgq5rlkYXW9F/R+ZilRgrWXWv
	 sffqM5w8Hhcjb/fEvsC4mSJohvtmpSjqSEmOgt+ATqWOU0q3p5AziP00XA1ZNqfrmq
	 gBRu16Ukuj8bg==
Date: Fri, 26 May 2023 16:46:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1 4/4] netlink: specs: add ynl spec for
 ovs_flow
Message-ID: <20230526164626.0c882b2e@kernel.org>
In-Reply-To: <20230526123223.35755-5-donald.hunter@gmail.com>
References: <20230526123223.35755-1-donald.hunter@gmail.com>
	<20230526123223.35755-5-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 13:32:23 +0100 Donald Hunter wrote:
> +      do: &flow-get-op
> +        request:
> +          attributes:
> +            - dp-ifindex
> +            - key
> +            - ufid
> +      dump: *flow-get-op

no reply: ?

