Return-Path: <netdev+bounces-2731-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E44703828
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A36C1C20C54
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5270FC10;
	Mon, 15 May 2023 17:27:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1610AFC00
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 17:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB03C4339B;
	Mon, 15 May 2023 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684171670;
	bh=UuSgjjBV4WZVwkj2ylCc5QJeOtjGCuWcDfyxvfN6Jyc=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=A66t/1SjKSKR+Ge/HG8ONJzulN76GKl90Res+/U5i+EdS1N/IUyG3av7qut0Ud3PO
	 Yo+KvKKKNOzlWRmpjveLtjDUImbMnOWOxHC0I1wHiNLoIkcftgqmZf+ofKPxGok5vq
	 MzR2KVOFSr3Aw59wCOptViQm2oypATYacBdprEqoYHpV4OdX6APldw+0VCELOOlM1d
	 ZWo5ej6hhHvNPFfVb9rij8psTHrDqC/M2ClTtK14CpUCaKKGCkk3NU/oVU5WUv/mW1
	 YxJdPQbO60BfjVQFGcb+M4s2wV85cXrFzat8p9lYiftoOppulEQ7wl+yKr/Rm5W/5S
	 ZK79tMDq6nf/w==
Message-ID: <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
Date: Mon, 15 May 2023 11:27:49 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] net/tcp: don't peek at tail for io_uring zc
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> Move tcp_write_queue_tail() to SOCK_ZEROCOPY specific flag as zerocopy
> setup for msghdr->ubuf_info doesn't need to peek into the last request.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv4/tcp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


