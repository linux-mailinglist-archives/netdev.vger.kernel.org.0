Return-Path: <netdev+bounces-11608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F24733AC1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7DA52815FA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BA91F92C;
	Fri, 16 Jun 2023 20:24:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6A71ED4C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8288C433C0;
	Fri, 16 Jun 2023 20:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686947062;
	bh=ylK/aMvjc0mF4TCdWZsUj13+p9LnNqCg6DUkuSeqkN8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gacFiApmwalo+MUgUrbHlYCv5PzshUTcrNuTY89HSvwEzbmWvKcMVPnMoreZK2ZxY
	 NZo/a1E7VpD0e+kHwpYerQi0GiIAGVX+XbTcuzwA3i4Pi5u56BadD0LmFf33Yd93UB
	 2LzfZCQozNXendn4uR2qAFgMWOnSl9/pBGrmKU17jJ41pgSwbnVBG3DJajeT02FMOM
	 EhPvf18TxhwnNlFXTVXEJB1KcgwPVkluVvHQB2hc9mZ27f98sfljiTSeHwxq4e0r2o
	 0ktreHt441n1VQXFRISqotjnxI6EmPs1WP5210ARxQ4s5nQnQv7TS4P1pmnD29MBqP
	 AcIkznp4GC0TA==
Date: Fri, 16 Jun 2023 13:24:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, netdev@vger.kernel.org, eric.dumazet@gmail.com, syzbot
 <syzkaller@googlegroups.com>, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next] ipv6: also use netdev_hold() in
 ip6_route_check_nh()
Message-ID: <20230616132420.3add6e75@kernel.org>
In-Reply-To: <20230616085752.3348131-1-edumazet@google.com>
References: <20230616085752.3348131-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 08:57:52 +0000 Eric Dumazet wrote:
> In blamed commit, we missed the fact that ip6_validate_gw()
> could change dev under us from ip6_route_check_nh()
> 
> In this fix, I use GFP_ATOMIC in order to not pass too many additional
> arguments to ip6_validate_gw() and ip6_route_check_nh() only
> for a rarely used debug feature.

Eeh.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thank you!

