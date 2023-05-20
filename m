Return-Path: <netdev+bounces-4056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2498370A55E
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AABCB1C20F54
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080A2363;
	Sat, 20 May 2023 04:43:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E29D7F2
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 04:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A82DC4339B;
	Sat, 20 May 2023 04:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684557821;
	bh=CuJImiBEkrvn52lFAsm6teL+b+fae0HBhV4TGWYEMGo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W8idQ1hFxdhzAUvtQ25+4eyUGAar4c5HkLwAPlgXRpiRunbTmJZW7V9EP3L/kqggo
	 UOMtrJYqEUuPAjTcrFLPga61H7IwCcrPku9+K/DSYsiisJQuJhZfYq6tNBNVz8kuBt
	 JhUO4OhsFWgfLfDIFuRaE9hRmKcBVcZHWVN0laCs396rM4Uk2QX5X30KLULarAQ/t2
	 +Vu0Ve5LJAmn0EW94QrROCCSTzEwjrOCtNv9C8P/5aOXLWqZDqPPIh9jRhoeYArbM2
	 8bjiaPiRxtmCnx7c33oQU5AylRu1sK3JnTuDYVa6WTVg0fbsjJFffdh/R1SVdO3uuX
	 Hf5O3CxbQSugA==
Date: Fri, 19 May 2023 21:43:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, bcm-kernel-feedback-list@broadcom.com,
 justinpopo6@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
 florian.fainelli@broadcom.com, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
 andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 richardcochran@gmail.com, sumit.semwal@linaro.org, christian.koenig@amd.com
Subject: Re: [PATCH net-next v3 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230519214339.12b5bbb3@kernel.org>
In-Reply-To: <1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
References: <1684531184-14009-1-git-send-email-justin.chen@broadcom.com>
	<1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 14:19:41 -0700 Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)

There are some sparse warnings where (try building with C=1).
Please also remove the inline keyword from all functions in source
files, unless you actually checked that the compiler does the wrong
thing.
-- 
pw-bot: cr

