Return-Path: <netdev+bounces-6994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 930A07192BE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E48E281494
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6423C6FC0;
	Thu,  1 Jun 2023 05:52:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2660D7464
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A10EC433D2;
	Thu,  1 Jun 2023 05:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685598753;
	bh=+kSrPSy30WrPPb97+wFDdfpXxxXIri6f+YbeBWlxfK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qwdpR/1aMpjLDhF+6cXoj1YX/Bgh2avJOUcT/U5K6RJiGf01o2xw20SHZ1jCSJp3/
	 d477JgoeisIsv5tgXHutruqcUVKWvCRu5X59j2jEylT/Fn73X1Bhis2xgzU6tqxNoP
	 9I+nyQnP9QKzvsfAyE6ZN54GBjEcvM2k2ZT3e0SU2w1eguvASm/fp3H2D/fokb4iw+
	 UWBGLWfgwmf6vrUdZtJRxWa38k0cG9LNz2PhxbBMZj+8CHmLJ9i6r1g2uwyY0khC/f
	 /Je4A6kA4ydiRYwU7OusBmjaYacR63EUr02C6yAlWMC+PRXjRNOg3MbW4yah5srm9O
	 y9EijM8KeKbow==
Date: Wed, 31 May 2023 22:52:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 davthompson@nvidia.com, asmaa@nvidia.com, mkl@pengutronix.de,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Message-ID: <20230531225232.4e83d6ae@kernel.org>
In-Reply-To: <20230531075451.47524-1-jiasheng@iscas.ac.cn>
References: <20230531075451.47524-1-jiasheng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 15:54:51 +0800 Jiasheng Jiang wrote:
> Add the check for the return value of the platform_get_irq and
> return error if it fails.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")

You need to CC all the authors of the patch limings@nvidia.com seems 
to be missing.
-- 
pw-bot: cr

