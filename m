Return-Path: <netdev+bounces-1860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 063436FF565
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1CD91C20F74
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1F062A;
	Thu, 11 May 2023 15:04:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C099629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3F0C433EF;
	Thu, 11 May 2023 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683817472;
	bh=3o6rtK5cchdoarAHzCOdOF63kkXXfBPbEFcnTi+IOXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bHgBLLE48OKj9v5CO/YHbn5dggxc9pObV+mFprbQrmc92214o+FBVglk/RX6Z9kco
	 3MGeNC3AVKsrpv+7RQRUjpNHVTEybxTXjj0oNVi5E3FisaNbBxhqlq33kq+PNCy+Wi
	 c7S1nG4mrfB7BsSxgkEDY8VwzCpYqKZeUPJSRcskCaJlzKrXPfju/SburfwFYp7N2O
	 DwAVLtO3TIO5CdfoUWQxnuLiodjQIf78qG+g/7wmwqMZgE7uGNzLVeix9Acu/akgV1
	 VyTO7UvZFUmYvTlYeUoPFBmY+vtr6l1mkvfBdJ6Cr9jQN5+rTf+tcxlTKnwKdiRBpx
	 v4xAG62+pSUzQ==
Message-ID: <69af34f8-2984-1dca-147f-f99ab5bc4f4d@kernel.org>
Date: Thu, 11 May 2023 09:04:31 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 net-next 4/4] selftests: fcnal: Test SO_DONTROUTE on
 raw and ping sockets.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1683814269.git.gnault@redhat.com>
 <f3af7d329b439264cf16c63482679c7648ce35ba.1683814269.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <f3af7d329b439264cf16c63482679c7648ce35ba.1683814269.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/23 8:39 AM, Guillaume Nault wrote:
> Use ping -r to test the kernel behaviour with raw and ping sockets
> having the SO_DONTROUTE option.
> 
> Since ipv4_ping_novrf() is called with different values of
> net.ipv4.ping_group_range, then it tests both raw and ping sockets
> (ping uses ping sockets if its user ID belongs to ping_group_range
> and raw sockets otherwise).
> 
> With both socket types, sending packets to a neighbour (on link) host,
> should work. When the host is behind a router, sending should fail.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



