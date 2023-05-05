Return-Path: <netdev+bounces-503-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BAA6F7D7D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9178F280F64
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467C74C74;
	Fri,  5 May 2023 07:09:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0DDED1;
	Fri,  5 May 2023 07:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73FB9C433EF;
	Fri,  5 May 2023 07:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683270548;
	bh=O1Zuhjh6WHzPi7wm/Fj52TtB4sZ3gbb/9sReXtkwefM=;
	h=Date:From:To:In-Reply-To:References:Subject:From;
	b=TpwuJ8MOGYruf9zM72ugE5OcnwGROxmL3YHdoNgtVajNjybLZVBmRl8ZOcO6Or/ic
	 ywvw0fWgKjpMQg3tvhmrAJxJfvOyHXyHbrIaFTaGzJp6LHBcEdPwAdtSa9ThnmTFPU
	 GAs3EdDLrEnhYNuqozT3VC/ghj7fLPNKH8Bcfc+/q9mR4OC5WnkDufnlLZgsxJ9/ei
	 ZfJaUy790QGjXFVLx89j1FPQcOg6uNkhIeddtMTWF0uyieU9zolffBox8A1xWoB5t0
	 enbpzsPjm0kkLBJSRlij5Fxr0jdAUxLgGwRvXkael26IeAXUfeXn34Ol+pIYRhevdi
	 0okYJUdfXB3RA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 587ACE5FFC4;
	Fri,  5 May 2023 07:09:08 +0000 (UTC)
Date: Fri, 05 May 2023 07:09:08 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: "Kernel.org Bugbot" <bugbot@kernel.org>
To: bugs@lists.linux.dev, john.fastabend@gmail.com, kuba@kernel.org, 
 borisp@nvidia.com, netdev@vger.kernel.org
Message-ID: <20230505-b217401c4-cd378b9379f8@bugzilla.kernel.org>
In-Reply-To: <20230504-b217401c0-873168e318a9@bugzilla.kernel.org>
References: <20230504-b217401c0-873168e318a9@bugzilla.kernel.org>
Subject: Re: TCP_ULP option is not working for tls
X-Bugzilla-Product: Linux
X-Bugzilla-Component: Kernel
X-Mailer: peebz 0.1

sumit.200744 writes via Kernel.org Bugzilla:

Trying it on android platform. Seems TLS is not enabled in kernel

# modprobe tls
modprobe: No module configuration directories given.

# insmod tls
insmod: tls: No such file or directory

# cat /proc/sys/net/ipv4/tcp_available_ulp

# grep CONFIG_TLS /boot/config-*
grep: /boot/config-*: No such file or directory

View: https://bugzilla.kernel.org/show_bug.cgi?id=217401#c4
You can reply to this message to join the discussion.
-- 
Deet-doot-dot, I am a bot.
Kernel.org Bugzilla (peebz 0.1)


