Return-Path: <netdev+bounces-9251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A93A728440
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 820221C20FFB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8550715AC3;
	Thu,  8 Jun 2023 15:53:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491D3BA39
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 15:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CE5C433EF;
	Thu,  8 Jun 2023 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686239581;
	bh=Po1lmrNIHxIkkg5pQXmLrqS8g+Asjhe6BSmkVqoxCKc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VhzKvIGy47oGl1El2qxOq60UGP2V3VsF9Z+3lPsSVkR+8UibOhUYVRj9Lf4khBhzJ
	 aiTQlYvPuMyOl8lvuPD73yV9wgQqnUJaspHVdya27CaUBjwATY6fIGUIJ8MpnA3lgj
	 sMTiHUNs99k39JU/dIjlVZykpVLQDXl73ZbrCUtMfanbxCqH1A+HGZJKSLS1ryI/Xh
	 0v4LKfqaItqtbH6hXKieT2Kh5IIqTHYTnUy2PjjmlWUwrZjpdJ8uexwVcqP0jSKC0B
	 JjdYsZsyVUkgtedvtudltDmTDHL6Q8jjNMo5SDI4OINEsedL8HJBKLpChDbCMvOgxT
	 EWfFnzV1pr5Eg==
Date: Thu, 8 Jun 2023 08:53:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 10/11] tools: ynl: generate code for the
 devlink family
Message-ID: <20230608085300.5294f323@kernel.org>
In-Reply-To: <ZIHAIdzVJVMB7jDN@corigine.com>
References: <20230607202403.1089925-1-kuba@kernel.org>
	<20230607202403.1089925-11-kuba@kernel.org>
	<ZIHAIdzVJVMB7jDN@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Jun 2023 13:48:49 +0200 Simon Horman wrote:
> On Wed, Jun 07, 2023 at 01:24:02PM -0700, Jakub Kicinski wrote:
> > Admittedly the devlink.yaml spec is fairly limitted,  
> 
> nit: limitted -> limited

I'll fix when applying if that's okay (assuming it's the only comment).

