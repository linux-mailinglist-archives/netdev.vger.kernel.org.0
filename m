Return-Path: <netdev+bounces-1875-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F37A6FF624
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D878A1C20FCE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7771641;
	Thu, 11 May 2023 15:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451A8629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75585C433EF;
	Thu, 11 May 2023 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683819502;
	bh=Td5HP6TP3K83360YR/MjsrMoI2xW08/giFCz9NLYbAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E//E09ovBXL1ZIxZeTaaKiNKSG681Z9Hk7MOTirWKxJjvnSXUCsPDEQFA9SOHGI5j
	 3y2A2vH+Tg9PeOA/fBuS7c+cSp77J2SXn58leFSxm2A6tcJtz7bpGgf2Rpu7OI+lJH
	 zwK3QFHMAsDKFmeZexLyqjChW8aTrdOnnSeNoxzeQk/XvykzKq/zbF6LwBoxcpPxzj
	 AC/rgFw0n+4QNF6gnYvq3os0/WACy1ij/i871bL5e2oiiZFPu8xINaMAbJz9+feapo
	 Df7m5snweR729mTDsijKX1ZpgxUNKrrExxKmC5t5XrmTclNJdpJUfThocou8XOrHAZ
	 Uwudp99pnaRuQ==
Date: Thu, 11 May 2023 08:38:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?5YiY5rWp5q+F?= <iccccc@hust.edu.cn>
Cc: "david s. miller" <davem@davemloft.net>, "david ahern"
 <dsahern@kernel.org>, "eric dumazet" <edumazet@google.com>, "paolo abeni"
 <pabeni@redhat.com>, hust-os-kernel-patches@googlegroups.com,
 yalongz@hust.edu.cn, error27@gmail.com, "dongliang mu" <dzm91@hust.edu.cn>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to
 ERR_PTR()' warning
Message-ID: <20230511083820.3c87f138@kernel.org>
In-Reply-To: <5bd5bfa.4758.1880b4c8bb2.Coremail.iccccc@hust.edu.cn>
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
	<5bd5bfa.4758.1880b4c8bb2.Coremail.iccccc@hust.edu.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 May 2023 22:52:25 +0800 (GMT+08:00) =E5=88=98=E6=B5=A9=E6=AF=85 =
wrote:
> ping?

Do not send "pings", if you don't understand the discussion reply=20
to the correct email and say "I don't understand".

