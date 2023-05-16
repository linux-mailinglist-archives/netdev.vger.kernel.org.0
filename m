Return-Path: <netdev+bounces-3126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3719A705AA6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D4128137E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B05629110;
	Tue, 16 May 2023 22:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A998290F6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819DDC433EF;
	Tue, 16 May 2023 22:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684276622;
	bh=IiAK7QVYdYVsem35FW1p0MBdsSji3BGNOue2Nk3ycaY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mnlM+uflWJJDIsrLLf0MHYw1Qtc10DB6EptX1eyhePE1rkuuQq5jqvjjAOzr0xT/w
	 jw4Gx0v4RROfQKogfvGcpFlPFNr7fLN3ThHBUMvOfXz5y0gTGCldqh2yO6Pu07Uasb
	 mVDJr+oG7kUxV1IRulWJDZIICYAwPCHyUt5fs2pKvBmQCqc7MNdBBIDIV6kG3X/vlX
	 bFCLuxMrJ4bVxjDNtf/l2wEuJSdfzV1uvvE3Q+bf3xASNUYVTEFQNmjlqhDT/oMddX
	 UvacSHjIq99/8yBrUSfmPd7g1N9VGekjaX0eqnu8b9lD68yD7l1AsBRJqbAZnvAxSV
	 CRejixJeTV3FA==
Date: Tue, 16 May 2023 15:37:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Networking
 <netdev@vger.kernel.org>, Remote Direct Memory Access Kernel Subsystem
 <linux-rdma@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Gal
 Pressman <gal@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Maher
 Sanalla <msanalla@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Tariq
 Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net v2 0/4] Documentation fixes for Mellanox mlx5
 devlink info
Message-ID: <20230516153700.2bd46b47@kernel.org>
In-Reply-To: <87zg64b05d.fsf@meer.lwn.net>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
	<30df7ad7-3b8b-c578-b153-7bf0a38fa0cc@gmail.com>
	<87zg64b05d.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 12:29:18 -0600 Jonathan Corbet wrote:
> > If there is no response from mellanox and/or netdev maintainers,
> > would you like to review and pick this series up?
> 
> They seem OK other than the gratuitous use of Fixes tags.  The netdev
> maintainers are generally responsive and on top of things, though, and I
> don't think there would be any justification for bypassing them here.

I'm expecting Saeed to pick them up to the mlx5 tree. Either that 
or tell us to take them in. I think he was out and traveling recently.
Let's give him some time :|

