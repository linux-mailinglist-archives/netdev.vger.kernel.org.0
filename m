Return-Path: <netdev+bounces-11187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59846731EC4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8570F1C20E26
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6D02E0D1;
	Thu, 15 Jun 2023 17:13:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B92E0C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C0C433C0;
	Thu, 15 Jun 2023 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686849192;
	bh=6SSLfq7V5KSJahhpCRu3vSuXfzu8zM6CNBuGD++Tk0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=phCffPkLNX0UBga6d1orlfNRaESNiSxbsmQERAK3BObYlcIhwwrUTZ4/YTrNV+cRe
	 9CWWLJuh2C24kTQbg97+zMch/haxICc6NsOk52eMBCFHyvM+f6VyWPMaDoeDRcY4Fb
	 ZBEMGiYxkUkHJ46BqIFm5F6FVVgyqRpLaJgwKIko88DUbbl9BzYsPbcdznq8f1r/bh
	 gACE7I3Zar6yxyDY++P39TDUe76zY7YIR0JrWGiENZCsCqBehHl58hIk//b4WZNuE+
	 HNQSKN9i3hbxJ04RACBVWoor9jXCbbDn5iSshUsXVeANn1DDhnzRsh+ByBKwBlgNRD
	 1f7KBK4OjMN5w==
Date: Thu, 15 Jun 2023 10:13:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sathesh Edara <sedara@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, <sburla@marvell.com>,
 <vburru@marvell.com>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: update email addresses of octeon_ep driver
 maintainers
Message-ID: <20230615101311.34f5199e@kernel.org>
In-Reply-To: <20230615121057.135003-1-sedara@marvell.com>
References: <20230615121057.135003-1-sedara@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 05:10:57 -0700 Sathesh Edara wrote:
> Update email addresses of Marvell octeon_ep driver maintainers.
> Also remove a former maintainer.

What does it mean to be a maintainer to you?

$ git log --author=sedara@marvell.com
$ git log --grep=sedara@marvell.com
$ 

