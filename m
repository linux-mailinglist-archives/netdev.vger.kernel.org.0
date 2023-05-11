Return-Path: <netdev+bounces-1858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DB36FF560
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD3B1281775
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B17629;
	Thu, 11 May 2023 15:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF036D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66014C433EF;
	Thu, 11 May 2023 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683817343;
	bh=E2rFALPn+rLHwSLImLMYVgFYjtTFYQ8cBNj6OK3CfoI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f57/lSOoMfNCd7zsps6MXopqKYatVTu4ANC7s1O2zhOr23B4Qnr66L8/DgciG3A/z
	 /T70Hmr9HahBDGN8EDoZWiuhGuo5SmEHdMn6LVj53ynOhQKlhVlk9ZzkQ4lbB1lmiI
	 1YYGtF7yo4F4oZ1/ji5gIfMD/2YUxBJGjF6pZaTSAjKQNgiIkZr67vPGVUuqCuL7CF
	 xTzmJyl0s181K/JMyYurQtTA07vYNiadRlFKvsIqEY+/9ioniB+PL3Tj9ZBSaHiSch
	 7S34+XJg6V0MFxukOOckipnBfTmRnNSYcTgAq8kUREaHPLPdvsqPfzgCxywzjuyNEW
	 H8f1v81Oiiniw==
Message-ID: <75f3cba0-4f4b-15ca-5cda-537fecd6b55b@kernel.org>
Date: Thu, 11 May 2023 09:02:22 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 net-next 2/4] selftests: fcnal: Test SO_DONTROUTE on
 TCP sockets.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1683814269.git.gnault@redhat.com>
 <a54cb9d143611e568d3e34b801e24dce440c309d.1683814269.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <a54cb9d143611e568d3e34b801e24dce440c309d.1683814269.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/23 8:39 AM, Guillaume Nault wrote:
> Use nettest --{client,server}-dontroute to test the kernel behaviour
> with TCP sockets having the SO_DONTROUTE option. Sending packets to a
> neighbour (on link) host, should work. When the host is behind a
> router, sending should fail.
> 
> Client and server sockets are tested independently, so that we can
> cover different TCP kernel paths.
> 
> SO_DONTROUTE also affects the syncookies path. So ipv4_tcp_dontroute()
> is made to work with or without syncookies, to cover both paths.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  v2: Use 'nettest -B' instead of invoking two nettest instances for
>      client and server.
> 
>  tools/testing/selftests/net/fcnal-test.sh | 56 +++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



