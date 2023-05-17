Return-Path: <netdev+bounces-3178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CA0705E3D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AD731C20CDF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4FF1844;
	Wed, 17 May 2023 03:43:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFEF17E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF9FC4339B;
	Wed, 17 May 2023 03:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684295012;
	bh=CJLZ9WG82ZCCQiQbLCmrLAxhuqRoqcXOdpEago8o7qI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HPlmQmSpJmKanQGBKHF6no2TOxgwxkIsWVhlpF0nXhUvxD/7kO7YvVFlXW0gHwFgh
	 E9NFOpZlzYj5jVp1NuDH47L4i3F4MKiwvtE9YxP9FBoiqMZji/LMDLLu3kP+a4H8bG
	 XZB26s8VfJehSYu8ZnJPD9WLy4I8vZczhPQJZ3HSpRYBmt1rg0lt2DZ6Fw11qGTG7h
	 84LAs5Zt63rPHCgjTvrjXWtw8RDLSvljz8ug2W1eHvkjq4zy9jN+F5oBUu9bjaImBW
	 8Vakoy7D6dSXAyCgdijlU/sica3lKFIz0DuqD1sGXuLf1AyXk3XWDw74S74VB8zxqC
	 UaA5Bz6aGY7QQ==
Date: Tue, 16 May 2023 20:43:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Angus Chen <angus.chen@jaguarmicro.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 idosch@idosch.org, petrm@nvidia.com
Subject: Re: [PATCH v3] net: Remove low_thresh in ip defrag
Message-ID: <20230516204330.1443bc7c@kernel.org>
In-Reply-To: <20230517001820.1625-1-angus.chen@jaguarmicro.com>
References: <20230517001820.1625-1-angus.chen@jaguarmicro.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 08:18:20 +0800 Angus Chen wrote:
> As low_thresh has no work in fragment reassembles,mark it to be unused.
> And Mark it deprecated in sysctl Document.
> 
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>

We need to revert the old patch first, we can't remove the commit from
the git history because it would change all later hashes and break
rebasing.

Why are you renaming the member? Just add the comment and update the
documentation. You said you had a tested complaint, the tester will
only read the docs, right?
-- 
pw-bot: cr

