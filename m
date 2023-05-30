Return-Path: <netdev+bounces-6398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B7C716258
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E10521C20BC3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BEA209A6;
	Tue, 30 May 2023 13:42:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611811993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9EDC433D2;
	Tue, 30 May 2023 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685454178;
	bh=88twlvhBpz/dbRVQNZujTvpnfWesPLuIsK8tph8tdlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jVKnFkvJq39Cvb+WW3ywNYWG9VAHM6Lwf/cJgsbIqABjC3ecepZZVvquVtHE2yO/j
	 ysknKcnQx5aWgWvNEUzXbouSVaS+HSF+mmCyP/4W0rMnPif2GRs5UxLcQNezRzHdsv
	 rwXYVapbMGdwgefrS0ormPmbxqx+xhfdg8kNX77U=
Date: Tue, 30 May 2023 14:42:55 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dragos-Marian Panait <dragos.panait@windriver.com>
Cc: stable@vger.kernel.org, Ruihan Li <lrh2000@pku.edu.cn>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] Hardening against CVE-2023-2002
Message-ID: <2023053030-moaning-endanger-ac26@gregkh>
References: <20230530131740.269890-1-dragos.panait@windriver.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530131740.269890-1-dragos.panait@windriver.com>

On Tue, May 30, 2023 at 04:17:39PM +0300, Dragos-Marian Panait wrote:
> The following commit is needed to harden against CVE-2023-2002:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2
> 
> Ruihan Li (1):
>   bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
> 
>  net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> 
> base-commit: b3f141a5bc7f877e96528dd31a139854ec4d6017
> -- 
> 2.40.1
> 

Nit, for 1 patch series, no need for a cover letter, you can put the
same info below the --- line if that's easier.

thanks,

greg k-h

