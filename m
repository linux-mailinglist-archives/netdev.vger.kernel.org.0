Return-Path: <netdev+bounces-8628-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA2A724ECD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B52D7280FD1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0705B2A9F6;
	Tue,  6 Jun 2023 21:29:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF631FBED
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 21:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A584C433EF;
	Tue,  6 Jun 2023 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686086948;
	bh=k5dh5UqC/q7zNRQQgS95fX7gkoUieGfOD7x/ugEKKhM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eIkkDuie0nqk9UmDo1LBJ+f+bKAv58jJdfhRWxjSgF+akX4V38UmQ/9kFOoQGpCK6
	 clLxnDZHLQKPJzL13Mae0xSjVA0fkwl2I8m5rx7m+K2yarDesBaDPnotDoFZjx5atI
	 XCOEzUIgDU103Mdr7dCB796LLJXjgOgUuEm5TDdpOD1ibgy0o5OI6cVdXP0QqQ/m2X
	 JGdh/QmiDD8f9moxqZaAOW+hBqRZuWVmqwJ7PA3jCnpSGPwaLO+VlLJo8uZvRhv6WC
	 v6SpM36Qob7NPst5ZhjS/uSGM9tk5x49uj1fwqJTifCNme3p66xu7kmc5RlMWyaNxe
	 25bRZNqf7es/w==
Date: Tue, 6 Jun 2023 14:29:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Patrick Thompson <ptf@google.com>, LKML <linux-kernel@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH] r8169: Disable multicast filter for RTL_GIGA_MAC_VER_46
Message-ID: <20230606142907.456eec7e@kernel.org>
In-Reply-To: <7aa7af7f-7d27-02bf-bfa8-3551d5551d61@gmail.com>
References: <20230606140041.3244713-1-ptf@google.com>
	<CAJs+hrHAz17Kvr=9e2FR+R=qZK1TyhpMyHKzSKO9k8fidHhTsA@mail.gmail.com>
	<7aa7af7f-7d27-02bf-bfa8-3551d5551d61@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 17:11:27 +0200 Heiner Kallweit wrote:
> Thanks for the report and the patch. I just asked a contact in Realtek
> whether more chip versions may be affected. Then the patch should be
> extended accordingly. Let's wait few days for a response.
> 
> I think we should make this a fix. Add the following as Fixes tag
> and annotate the patch as "net" (see netdev FAQ).
> 
> 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")

Perhaps it's best if you repost with the Fixes tag included once
Realtek responded. 

