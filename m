Return-Path: <netdev+bounces-6682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F4B7176DA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD5AB1C20DC9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7771399;
	Wed, 31 May 2023 06:30:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD9A925
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C0C433D2;
	Wed, 31 May 2023 06:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685514656;
	bh=DOrJw/Yu+3HP/enxWknLVzppckY+Vfwhgf5NKSUm6Z0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SgG3MQwq5sTeyl4dM+tNVJoqSw1EOYJiJrO4e/dekneZTqmvsBnvRAWaX24dX8iJ3
	 0pWutt6CKxvzZdfTKcw6hMyICxk6JRNbdeIIXe6o611aGqzot5cBur6tPxFM9bnJfN
	 T1GQs8eI4EUnyrAUhFGVO6Ghw8nYQ4z5J5H4PZCef3OvbaSY0Ds0P4q6oTfTPoVO7R
	 ldGDLezq1YBxSsJJIpchfI/1igAfuSuYH2J3lJ6IsV8rcR/HZpFhtKdPqTHYEBFjnd
	 7fUTKay6fRD08jinoqWVn6GabAZjmXK8Lm0TumC8GtiLwNezumk2t3arZyy/Qh1b4X
	 Meo7aFGgywiQw==
Date: Tue, 30 May 2023 23:30:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: don't set sw irq coalescing defaults in
 case of PREEMPT_RT
Message-ID: <20230530233055.44e18e3a@kernel.org>
In-Reply-To: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
References: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 28 May 2023 19:39:59 +0200 Heiner Kallweit wrote:
> If PREEMPT_RT is set, then assume that the user focuses on minimum
> latency. Therefore don't set sw irq coalescing defaults.
> This affects the defaults only, users can override these settings
> via sysfs.

Did someone complain? I don't have an opinion, but I'm curious what
prompted the patch.

