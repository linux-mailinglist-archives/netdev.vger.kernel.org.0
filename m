Return-Path: <netdev+bounces-5498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D662B711E6D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF1D1C20F87
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87EE1C05;
	Fri, 26 May 2023 03:26:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6804717F3;
	Fri, 26 May 2023 03:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F170C433EF;
	Fri, 26 May 2023 03:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685071559;
	bh=BTIaAcxw6JMw/kBG+7/ytX8/qt2HopHJ9Nqlbp6SrPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eIztQ0pfSz7V7fBvUzeog84FT45VkAZ2Lae27wsJjMo2fG1neQr92ibbIFgGHsQ2d
	 r4JJTPcmgjMJnT+uzL6zfSlfkfBY8dFo++z67mnF7wrr/9P/KiWD0ShmXwko8V+SIE
	 zoqSY3IREiAbPn2Znwq2kn2tRNNV2Ly7FViIEibdDkP7RxB1FMhHu22yVTGyQYbsN2
	 OX4koaThdA9hIKe7/x64Ho3jdyINstDb+ujciIDpcmybpuL5c2X9JGIqtJNRCxc5Ni
	 jKHY5EnBMTUPsHPsGt8BBA+PoBgarYho9GcKQlrbQUIpEZqkQSQWDIuFJen+j5HryZ
	 CMMU/YZeGrRJQ==
Date: Thu, 25 May 2023 20:25:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
 olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
 wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
 leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
 linux-rdma@vger.kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
 hawk@kernel.org, tglx@linutronix.de, shradhagupta@linux.microsoft.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2,net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
Message-ID: <20230525202557.5a5f020b@kernel.org>
In-Reply-To: <1685025990-14598-1-git-send-email-haiyangz@microsoft.com>
References: <1685025990-14598-1-git-send-email-haiyangz@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 07:46:30 -0700 Haiyang Zhang wrote:
> lot caching and memory overhead, hence perf regression.

Horatiu's ask for more details was perfectly reasonable.
Provide more details to give the distros and users an
idea of the order of magnitude of the problem. Example
workload and relative perf hit, anything.

Please do not repost within 24 hours:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
-- 
pw-bot: cr

