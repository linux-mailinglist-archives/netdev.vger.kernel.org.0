Return-Path: <netdev+bounces-54-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BDE6F4EEB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D95E61C20A09
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A7A807;
	Wed,  3 May 2023 02:49:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB07F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CE0C433D2;
	Wed,  3 May 2023 02:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683082175;
	bh=vahBFwbRv7ZfI3pIqaM/5OC1jAwrrhTHcSp7BMpX3Mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nVVhToPSI0G9q8sYexS+38vhXuReboVTnPFwALqa3XrRPt5PAlp34BoM7hr6kyrlJ
	 7vgPO9Mc57p8TOrvqWWgFRRihswxx9H94d89zM3zFY4qtshJjAk7PRKn3Zx3cLrM3O
	 KhFuEoh5rHO1Z6wE6nlAMAnSwYhoO+melBlykDnhb2tzaNoXM8dNW5EEFctMZhE7xW
	 Y6v7OX/RuOq09E+6aqrsyyoqwMcFkU1WKeYwpt34wtKWEYkqxiJN4Wpyd5qtUqmi5E
	 WGXO6UdarRfzA1hhp3p4ZPsR36qZY8LPPFN9T/bDPDOm4jIz2bTuXeA9Yye/af1orj
	 +Xw6bqsuNHIIw==
Date: Wed, 3 May 2023 10:49:31 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: syzbot <syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com>
Cc: broonie@kernel.org, davem@davemloft.net, edumazet@google.com,
	groeck@chromium.org, jiri@resnulli.us, kuba@kernel.org,
	linmq006@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [net?] WARNING in print_bfs_bug (2)
Message-ID: <ZFHLu13XQZpOn/8T@google.com>
References: <000000000000e5ee7305f0f975e8@google.com>
 <000000000000db8c6605fa8178df@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000db8c6605fa8178df@google.com>

On Sat, Apr 29, 2023 at 03:54:28PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 0a034d93ee929a9ea89f3fa5f1d8492435b9ee6e
> Author: Miaoqian Lin <linmq006@gmail.com>
> Date:   Fri Jun 3 13:10:43 2022 +0000
> 
>     ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d40608280000
> start commit:   042334a8d424 atlantic:hw_atl2:hw_atl2_utils_fw: Remove unn..
> git tree:       net-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10340608280000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d40608280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7205cdba522fe4bc
> dashboard link: https://syzkaller.appspot.com/bug?extid=630f83b42d801d922b8b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147328f8280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1665151c280000
> 
> Reported-by: syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com
> Fixes: 0a034d93ee92 ("ASoC: cros_ec_codec: Fix refcount leak in cros_ec_codec_platform_probe")

I failed to see the connection between the oops and commit 0a034d93ee92.

