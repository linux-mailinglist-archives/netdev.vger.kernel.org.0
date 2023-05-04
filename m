Return-Path: <netdev+bounces-308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 219016F6FC8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9559280DBB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01B2AD59;
	Thu,  4 May 2023 16:19:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030061855;
	Thu,  4 May 2023 16:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4881C433D2;
	Thu,  4 May 2023 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683217169;
	bh=MCDsCw8PlIebNhXq0uhmBzX07U2IHj1T9Lsb0KdzCL8=;
	h=From:To:Subject:Date:From;
	b=hnJLogRK+S/s+QFITAoP9NSiEPJE1QPHB2NIJ6OtzAvWn2HccJPajEKC6Mx0oQyia
	 kvY6cd6fXe26cdmozDs0DjChBUwV6av65Oa7VUX+yQw3P6Iq8L9kJX7WDnWUNglJxs
	 YPyW2z8aUacZuGAlli8MFI8whR4A+GhFLVQEYa1wSwCXIN89jRCG4lZWDGQ9N9RvhJ
	 v6PNeOwoedUFkAXExO51+4eL9CjjLnovEUHunBvoCy1xLVrBJy6gX5QGhWOobJOZyY
	 VxbcsDoyVgavgid63HKIo9LWff5Uml0939Ct2TtGBJRlo8ZUaD0ziCM7yULSbsbrvM
	 Iko6XUxFUWPQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81491E5FFFA;
	Thu,  4 May 2023 16:19:29 +0000 (UTC)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: "Kernel.org Bugbot" <bugbot@kernel.org>
To: bugs@lists.linux.dev, netdev@vger.kernel.org, john.fastabend@gmail.com, 
 kuba@kernel.org, borisp@nvidia.com
Message-ID: <20230504-b217401c0-873168e318a9@bugzilla.kernel.org>
Subject: TCP_ULP option is not working for tls
X-Bugzilla-Product: Linux
X-Bugzilla-Component: Kernel
X-Mailer: peebz 0.1
Date: Thu,  4 May 2023 16:19:29 +0000 (UTC)

sumit.200744 writes via Kernel.org Bugzilla:

TCP socket was created as below
int sfd = socket(AF_INET,SOCK_STREAM,0).

socket connection was established between server and client using accept and connect calls.

To enable TCP_ULP, setsockopt was used as below
Client:
setsockopt(sfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
Server:
setsockopt(nsfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));

but setsockopt is returning -1 with error ENOENT - "No such file or directory". Is anything missing for above usage ?

Which kernel version has TLS option enabled which is mentioned in https://www.kernel.org/doc/html/latest/networking/tls.html#kernel-tls ?

View: https://bugzilla.kernel.org/show_bug.cgi?id=217401#c0
You can reply to this message to join the discussion.
-- 
Deet-doot-dot, I am a bot.
Kernel.org Bugzilla (peebz 0.1)


