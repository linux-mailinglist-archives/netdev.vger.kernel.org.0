Return-Path: <netdev+bounces-8230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 763E8723317
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9E5B1C20D3A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA6E2772A;
	Mon,  5 Jun 2023 22:21:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BAB1C752
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B98AC433D2;
	Mon,  5 Jun 2023 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686003699;
	bh=dCL+k3F63GFuMKYpU11gd3w+RnYFIFLaP63gLGgRE90=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QSwHoX9DlN9xlKIDBfLDen+kWaFdczHr7IxcySA/0oLmLp6JrRiN/uPEYqwRTZ6cF
	 jIWIKxrJdU951c1VeP8HgmLfPg7uUy8OxyUrGAu0U/0/GwtbM3k4G/tbkSKpQfJWQO
	 saSzxsp2WjAgpliO0f81Z9OTU6byPUto10pDDHVBKZcZJiEvRIw8bXKNRpcv4fP+Zg
	 Vts1dpfEjfVwRs9jpMuGE+Nrg1RtT3TYsw1tFssgsGViPf40tZWhhXDDzjN9TQKqYl
	 uv0Z8cl1f+BlSVkJoVy0yddaNh7QzOq0CEa3BfsC59XgK6qdTw/5lycOhHdDjRG/bV
	 uf+weP3EG6Hrg==
Date: Mon, 5 Jun 2023 15:21:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v14 3/8] net: split off _napi_busy_loop()
Message-ID: <20230605152138.1c93a261@kernel.org>
In-Reply-To: <20230605212009.1992313-4-shr@devkernel.io>
References: <20230605212009.1992313-1-shr@devkernel.io>
	<20230605212009.1992313-4-shr@devkernel.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Jun 2023 14:20:04 -0700 Stefan Roesch wrote:
> +static void _napi_busy_loop(unsigned int napi_id,

IDK how much of an official kernel coding style this rule is but 
I think that double underscore is more idiomatic..

>  		    bool (*loop_end)(void *, unsigned long),
> -		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
> +		    void *loop_end_arg, bool prefer_busy_poll, u16 budget,
> +		    bool rcu)
-- 
pw-bot: cr

