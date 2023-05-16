Return-Path: <netdev+bounces-3083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D21F67055F7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:27:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF3CA1C20A8D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0505E3113C;
	Tue, 16 May 2023 18:27:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB6C107A5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:27:33 +0000 (UTC)
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467C23C0C;
	Tue, 16 May 2023 11:27:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 9BC9737C;
	Tue, 16 May 2023 18:27:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9BC9737C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1684261642; bh=eN2ihpB81pubM9V7Ow/ieCvi6pmkxFrLrOBSx1pwDUM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a6XcpakvTlccL8bwSblV8FiFyb/HkCs9Vy/4i8xreg5JjcGZ5cPr3A0uDLQmOI/P9
	 K9iKOp4B+zREyNda5EUmsQT5eo+sMYJTsz4M7VL/PxWk/+1YvTzapczKp2N+P39uNt
	 NfZdFmiphHXX3QX1XOBdhThKP7PWCb8qlgyg0XpccAMQjBq/9seQgpzFlowUfMAVGg
	 JmK4Cer43S+0ZlRVEBkmibN+7vh/A2n2nFBhW25YfZKYWOSenPKrTaWZ8rWo1HSTYr
	 +dpewPVgPdylhdlmRlAW442YFdgyK8f2YI4qmGfvSMHQNKa8zo7Y2yqkjK5PeJEwwi
	 6iZbSQvtzLTgQ==
From: Jonathan Corbet <corbet@lwn.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Networking
 <netdev@vger.kernel.org>, Remote Direct Memory Access Kernel Subsystem
 <linux-rdma@vger.kernel.org>, Linux Documentation
 <linux-doc@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Bagas Sanjaya <bagasdotme@gmail.com>, Gal Pressman
 <gal@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>, Maher Sanalla
 <msanalla@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net v2 4/4] Documentation: net/mlx5: Wrap notes in
 admonition blocks
In-Reply-To: <20230510035415.16956-5-bagasdotme@gmail.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-5-bagasdotme@gmail.com>
Date: Tue, 16 May 2023 12:27:21 -0600
Message-ID: <874joccet2.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> Wrap note paragraphs in note:: directive as it better fit for the
> purpose of noting devlink commands.
>
> Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
> Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/devlink.rst             | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

So these changes seem harmless, but the Fixes: tags seem completely
inappropriate here.  This is format tweaking, not a bug fix.

Thanks,

jon

