Return-Path: <netdev+bounces-5123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D02CA70FBA9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA0FF28118D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDF919E58;
	Wed, 24 May 2023 16:26:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7E31951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFB6C433EF;
	Wed, 24 May 2023 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684945569;
	bh=/qd27nGL4fKKx4zLyunER0QiAnaS9DUkbTI0LrriqRc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MJ5tr2grUKPRDx3I5pw4NV9MXUnlTZbweK3wx84TkB2c0ZnscFokg21SGRANPEk73
	 PRaKoLZXs0oUxDo+2MibknM5qpfnmOqcoSMUD1nOpD0rnMnihJDyNRewP4kgnZmMhd
	 XxkuraYb6CQffmHHESDKmIyNQthcYhSlbxl7LmSffmV1kLBhLTqvujTnsdhH+v02ku
	 Rqna7us2Icv+RvxzagW9EY9r9sUpsoaHiT8qyutF4mnZLa4pxoiJwSNlavs1pRXdAg
	 u1SjzaS9PpntTNOeF19t6vExpApy5Qcmw/0aNNgcwYp6PPcDsKZVpX/o9YEBpq6+PD
	 UnNACb+yYCnhg==
Date: Wed, 24 May 2023 09:26:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
 <netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
 <przemyslaw.kitszel@intel.com>
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Message-ID: <20230524092607.17123289@kernel.org>
In-Reply-To: <98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
	<ZG367+pNuYtvHXPh@nanopsycho>
	<98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 15:25:22 +0200 Wilczynski, Michal wrote:
> >> For performance reasons there is a need to have support for selectable
> >> Tx scheduler topology. Currently firmware supports only the default
> >> 9-layer and 5-layer topology. This patch series enables switch from
> >> default to 5-layer topology, if user decides to opt-in.  
> > Why exactly the user cares which FW implementation you use. From what I
> > see, there is a FW but causing unequal queue distribution in some cases,
> > you fox this. Why would the user want to alter the behaviour between
> > fixed and unfixed?  
> 
> I wouldn't say it's a FW bug. Both approaches - 9-layer and 5-layer
> have their own pros and cons, and in some cases 5-layer is
> preferable, especially if the user desires the performance to be
> better. But at the same time the user gives up the layers in a tree
> that are actually useful in some cases (especially if using DCB, but
> also recently added devlink-rate implementation).

I didn't notice mentions of DCB and devlink-rate in the series.
The whole thing is really poorly explained.

