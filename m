Return-Path: <netdev+bounces-6378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB12716089
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53F43280FD8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E66019926;
	Tue, 30 May 2023 12:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94F154B0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CB7C433EF;
	Tue, 30 May 2023 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685451127;
	bh=oevBEs+dx9KfQQJHe/Budkz7y0IyMsmern9/98xwUIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QDvGyAbqToyk2/obb4diQCN2NQXotTl63dwNe0MQNXdnkZhBfzFkXPa3wkWPNcg4x
	 bXAW6UyGUI0w/093gpR2hGgWjTgvTjZKHz0GEflep2qPkeExUKDLKb1v7lTTh8fB1l
	 ufvEhbog54OnOojhZZ5EEH98zX+C9VNeCPnKqBdk=
Date: Tue, 30 May 2023 13:52:05 +0100
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
Subject: Re: [PATCH 6.1 1/1] bluetooth: Add cmd validity checks at the start
 of hci_sock_ioctl()
Message-ID: <2023053043-duo-collide-fd9c@gregkh>
References: <20230530122629.231821-1-dragos.panait@windriver.com>
 <20230530122629.231821-2-dragos.panait@windriver.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530122629.231821-2-dragos.panait@windriver.com>

On Tue, May 30, 2023 at 03:26:29PM +0300, Dragos-Marian Panait wrote:
> From: Ruihan Li <lrh2000@pku.edu.cn>
> 
> commit 000c2fa2c144c499c881a101819cf1936a1f7cf2 upstream.

What about newer kernels (and older ones)?  Do you want to upgrade and
have a regression?

greg k-h

