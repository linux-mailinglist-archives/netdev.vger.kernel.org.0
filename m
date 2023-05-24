Return-Path: <netdev+bounces-4858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 251C570EC67
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E021C20AF8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D4F15CD;
	Wed, 24 May 2023 04:15:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B815BC
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43636C433D2;
	Wed, 24 May 2023 04:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684901725;
	bh=pzqF3+fTZFWa7l+PYU986gVqPLaWTC2i52rWguwN8Bo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n13WFMY+EkVHyaaabbdC5DdLAJKBCUTDSBSTXI1MjDjeoTexpUsN0mokloULuTU3k
	 6c8LjhPVhoHvaCkBX3RPfahyRzErAq6is7c1L6PqblsOPVX5upW/O60DLvScbwn8VC
	 tgPWdWkhg6K9JWpLkkvIBsTan7tr6oVw9AWDUqJVKDPJLi+CVQOyxgDNFRc8O5QtIx
	 lYw/c7svnsi7/TTzJH30SXhNaR+65sFxF2G/nyH1+DT9B9P69KXfSCKV8Iz8LoAr8L
	 mdEXMUowNTD8kKsOO7wEoqeOD4mlfqVJ8DugTk1rO3SxATB/funLoXfxUZj7Mk8S5R
	 y9tVauhSEj70A==
Date: Tue, 23 May 2023 21:15:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 0/3] devlink: small port_new/del() cleanup
Message-ID: <20230523211524.45f26a39@kernel.org>
In-Reply-To: <20230523123801.2007784-1-jiri@resnulli.us>
References: <20230523123801.2007784-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 14:37:58 +0200 Jiri Pirko wrote:
> This patchset cleans up couple of leftovers after recent devlink locking
> changes. Previously, both port_new/dev() commands were called without
> holding instance lock. Currently all devlink commands are called with
> instance lock held.
> 
> The first patch just removes redundant port notification.
> The second one removes couple of outdated comments.
> The last patch changes port_dev() to have devlink_port pointer as an arg
> instead of port_index, which makes it similar to the rest of port
> related ops.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

