Return-Path: <netdev+bounces-1857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6366FF559
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74D6A281659
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA94629;
	Thu, 11 May 2023 15:00:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802B436D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5043C433EF;
	Thu, 11 May 2023 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683817203;
	bh=3rMce9taMyuyTPORVVoSDDM/n3+9+9wJeP7JAsG6Fgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HnB4o2tgYGszRIAkA2zxdtqsi8PwSbQMUfFq7jGZ/Qa6+73EAO4TGKGF6vIO+DA5B
	 Lu47J6Lwz+S5w5FoHZdNjpQ0Z1jZsF4MRYu2cvRT+j3Hg2QWqQh3hZL2EVAuTHhcEj
	 MEYit4uRJ7T+nEbVRkQmbnU9hPCfFlfBWg1JB4Vf5w6SLfifv7UwBi7e9XwVHz/ugB
	 ixdWkk5HRqP0gm/nKB+7bkb+PU30gYusaV0jcUwJyrgtI2+XXasQnsRiaD0oR96G+L
	 Ev05xI045MCKTXQ+a9426oiA8gdZpv71sVdO/28XI5KQlH+yUeQ5ndaFLjm1AzFvWI
	 t4WTowae2G/hA==
Message-ID: <c782158a-2681-36b4-fd0e-1b99d610d802@kernel.org>
Date: Thu, 11 May 2023 09:00:01 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 net-next 1/4] selftests: Add SO_DONTROUTE option to
 nettest.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1683814269.git.gnault@redhat.com>
 <0b28378e6a34c9a1ffda95449a1a171491079f06.1683814269.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <0b28378e6a34c9a1ffda95449a1a171491079f06.1683814269.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/23 8:39 AM, Guillaume Nault wrote:
> Add --client-dontroute and --server-dontroute options to nettest. They
> allow to set the SO_DONTROUTE option to the client and server sockets
> respectively. This will be used by the following patches to test
> the SO_DONTROUTE kernel behaviour with TCP and UDP.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  v2: Use two different options for setting SO_DONTROUTE either on the
>      client or on the server socket.
> 
>  tools/testing/selftests/net/nettest.c | 46 ++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



