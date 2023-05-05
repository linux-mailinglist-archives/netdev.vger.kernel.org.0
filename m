Return-Path: <netdev+bounces-624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC8116F89AB
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A12E71C2196B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 526FFC8FA;
	Fri,  5 May 2023 19:43:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB047C12D;
	Fri,  5 May 2023 19:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C762C433EF;
	Fri,  5 May 2023 19:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683315795;
	bh=6dxAgKG4hAGopqCTb/ZShYU4PmbIwiS1PKhIlgTyilE=;
	h=Date:From:To:In-Reply-To:References:Subject:From;
	b=S6ZYyDIQY3DsXPP2TeKyEHp+b8TCMXbIn1wVyUloSWIv2AaRa8cWyi1sK1zGaHP1t
	 OinfPYC35FxnIJfFSb9jdZYaGfXfTLckLXIVN1VF2IQ035d8msQqaMAVMFtWs1PJ0K
	 Z9TGX66lob7Io9/3bFvskMSn02zYVr0078W+BuWFq6o6kevzqTICVKdrOpzeQiQ5tL
	 v4rE8T1C7h3tgi8VCtGaYnFj+lV7dJlWI2xtoCySHbkGCZYsjahCEddMMDIgzQbOBo
	 wIpXFcrhOWiicCqF+n59RPB35UTWcR3gwvIxo8CJICHERllYh2dhlB6TW2vpX0jLb7
	 79wfbilTpa+Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68D06C395C8;
	Fri,  5 May 2023 19:43:15 +0000 (UTC)
Date: Fri, 05 May 2023 19:43:16 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: "Kernel.org Bugbot" <bugbot@kernel.org>
To: borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org, 
 bugs@lists.linux.dev, netdev@vger.kernel.org
Message-ID: <20230505-b217401c5-05ade88415f3@bugzilla.kernel.org>
In-Reply-To: <20230504-b217401c0-873168e318a9@bugzilla.kernel.org>
References: <20230504-b217401c0-873168e318a9@bugzilla.kernel.org>
Subject: Re: TCP_ULP option is not working for tls
X-Bugzilla-Product: Linux
X-Bugzilla-Component: Kernel
X-Mailer: peebz 0.1

kubakici writes via Kernel.org Bugzilla:

Sounds like it. I'm not familiar with the Android kernel but the tls code either needs to be loaded as a module or compiled in, and since /proc/sys/net/ipv4/tcp_available_ulp is empty - neither seems to be the case on your system.

View: https://bugzilla.kernel.org/show_bug.cgi?id=217401#c5
You can reply to this message to join the discussion.
-- 
Deet-doot-dot, I am a bot.
Kernel.org Bugzilla (peebz 0.1)


