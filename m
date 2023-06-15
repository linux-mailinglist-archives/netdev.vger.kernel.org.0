Return-Path: <netdev+bounces-11241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 896D47321F8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21868281506
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A68174E8;
	Thu, 15 Jun 2023 21:56:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21485174D7
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A4BC433C0;
	Thu, 15 Jun 2023 21:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686866216;
	bh=sVL6CyVNVWcGlgpeKE2BOh4nrSS0ILp310rkQcHNpG0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZZo1L1xz6F2BZYPcP80HIdb0gVBo7b1QZbHhM3zTqZ1cmJzTo1HKo3mLTztaFLOOQ
	 3Gunvck9kxh0k47kLRwIqtbu5RzUvgVkyvw/3TMc2WJhDrixMaH2b4wGN3Puset3as
	 uOQvRD5ZII6qiiKP9VUJdqUjvREGnzRzCDrrCS1JgBhjkWbMdfrtXeqRbKY/SehLzS
	 +lzArNHRZWfkMA6kJSK8suicTE4xD+9DcmSu41d0XtxRbk/TF/hwhotIfajkcZZKy1
	 h7dHJPg4G3WbjOtp2Vy+E/U9egWU1UfUwLsrLRru+zjTDXFqopqtuREtjnIP0CwiTX
	 pkUZ2HhLGBWFg==
Date: Thu, 15 Jun 2023 14:56:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 dsahern@gmail.com, "helpdesk@kernel.org" <helpdesk@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with
 reference tracking
Message-ID: <20230615145655.14889c71@kernel.org>
In-Reply-To: <20230615-praying-viper-e71c8b@meerkat>
References: <20230612214944.1837648-1-kuba@kernel.org>
	<168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
	<20230615100021.43d2d041@kernel.org>
	<20230615-73rd-axle-trots-7e1c65@meerkat>
	<20230615131747.49e9238e@kernel.org>
	<20230615-praying-viper-e71c8b@meerkat>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 16:22:28 -0400 Konstantin Ryabitsev wrote:
> Yes, I'll see if I can teach the bot to regenerate the diff with --histogram
> when there is no match.

Perfect, thank you!

