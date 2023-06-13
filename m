Return-Path: <netdev+bounces-10403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F67072E598
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64A9A1C20C9B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D9138CCC;
	Tue, 13 Jun 2023 14:22:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C2522B;
	Tue, 13 Jun 2023 14:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66085C433F0;
	Tue, 13 Jun 2023 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686666172;
	bh=uaFeJzmCxlczQeNB4wjNR1p0Vrwz4zgph2jIve82GkA=;
	h=From:To:Cc:Subject:Date:From;
	b=ZuISURTvbhSW/SoXlALwokHgjZzX5GB4acwTW7pOvOm1WaVJ/yM9OPv3mQ1wQn1z7
	 OGMI/SlP7+KxqnTJUzRHls3cnE0tKBjg57xnBXrTWTR2uuhy8K+/y6xTmxWs2LITc9
	 +EzI1xlyUA4Zc5z3L3kU9LyU6r6EBk+iu1mjDa4o+kxiTL6/DgLS4PWjYzTfBbcmTn
	 V1k30kU/KwJ8ZOeP6V5+tMiJmJ75luLSSMBrxr+oaCE4Mx0TJWfweH0RcfDZvjMDVE
	 9Pm+KV5djfrgBR5SYq3ya90zL5dG93tkzvOExr0cVX+qbH2EkE6wJ6dK0G3LCNRg7L
	 7h7sz1ezBqNUQ==
From: Kalle Valo <kvalo@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
         regressions@lists.linux.dev,
         Johannes Berg <johannes@sipsolutions.net>,
         Jakub Kicinski <kuba@kernel.org>
Subject: Closing down the wireless trees for a summer break?
Date: Tue, 13 Jun 2023 17:22:47 +0300
Message-ID: <87y1kncuh4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Me and Johannes are planning to take a longer break from upstream this
summer. To keep things simple my suggestion is that we would official
close wireless and wireless-next trees from June 23rd to August 14th
(approximately).

During that time urgent fixes would need go directly to the net tree.
Patches can keep flowing to the wireless list but the the net
maintainers will follow the list and they'll just apply them to the
net tree directly.

The plan here is that -next patches would have to wait for
wireless-next to open. Luckily the merge window for v6.6 most likely
opens beginning of September[1] so after our break we would have few
weeks to get -next patches ready for v6.6.

And the v6.5 -next patches should be ready by Monday June 19th so that we
have enough time to get them into the tree before we close the trees.

What do people think, would this work? This is the first time we are
doing this so we would like to hear any comments about this, both
negative and positive. You can also reply to me and Johannes privately,
if that's easier.

Kalle

[1] https://phb-crystal-ball.sipsolutions.net/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

