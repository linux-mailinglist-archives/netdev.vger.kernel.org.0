Return-Path: <netdev+bounces-7276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6556171F741
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F58028194B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F23CEDE;
	Fri,  2 Jun 2023 00:46:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1D0EA8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4881FC433EF;
	Fri,  2 Jun 2023 00:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685666808;
	bh=sQ//9ukc78LbNlbwU1LDfCPfy+d30hy4VDFCmKob73U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dgdvib8SCEPMcyyfGBUhnSWFf2Fz8BH9p/5VDjy6b6THQCcReVlfe5RLHn8flHfE2
	 YU7RLVGK1pi1a0kJrNb3QP1rcKXyhV6EtPciSXQ2MF+zy5SOZPrhccelwv56EGlN4b
	 UjFbP+kC4x1k9Fu+OVT5FtHR6I2Pwc+MltxQq1qteEkf12DSyBfWEf9XfL32tkU2iE
	 QqBCmysZRjXhynuWItb+9faRuSyiJvHninJ8Zn1+qd1l6jQ6LncmiqNzcwTNLbSpPk
	 ErvWOZQTBS//rI4Z03AFmbEVLgcnRqs7Vt63KL62FJRvJGmDYqplL2sMXz5c24Q7/K
	 2wz9lQ3UUcRng==
Message-ID: <0a59c9cb-84dc-15cb-421d-816cb08764fb@kernel.org>
Date: Thu, 1 Jun 2023 18:46:47 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net/ipv6: convert skip_notify_on_dev_down sysctl
 to u8
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, Matthieu Baerts <matthieu.baerts@tessares.net>,
 eric.dumazet@gmail.com
References: <20230601160445.1480257-1-edumazet@google.com>
 <20230601160445.1480257-3-edumazet@google.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230601160445.1480257-3-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/23 10:04 AM, Eric Dumazet wrote:
> Save a bit a space, and could help future sysctls to
> use the same pattern.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/net/netns/ipv6.h | 2 +-
>  net/ipv6/route.c         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


