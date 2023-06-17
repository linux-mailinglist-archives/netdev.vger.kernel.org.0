Return-Path: <netdev+bounces-11692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE251733EEB
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E49B28187D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB94569A;
	Sat, 17 Jun 2023 06:56:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED2A5231
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C66C433C0;
	Sat, 17 Jun 2023 06:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686985012;
	bh=veE2WNgzYfU28/blRsRVL5I2YM28nkc3vtUXW8+nNT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ue5GpNl0fuOKBySPHBZw1piM/lLb+Q/U908foDQGPvB73v01iuByG8US8E7rsp2Lk
	 dAM+dLsAxqL5RizkGBh3E61nIgDVHqhR9CYjnQ/SswTQyVcTDWckFwcmFAD0RYMpHy
	 V2hwriX+VjD1Z18k8aycwrrOfkwNACHs8V6cLmBvdAll+CsMT1HaWoDrAegM5zJM1D
	 zE86E4u5vVnFFZ3WVMp395kZouqa0n3ZRBY8dF4I85vtfdabv8XZVsAvV8jMu41g8g
	 A5X/nfidByrMeuDo5wtSE+jwR705L9uTwDo85pqeUgdCcllBmWAPGGLltuGD9jRqnQ
	 nQjhrKO8l+7+Q==
Date: Fri, 16 Jun 2023 23:56:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, pavan.kumar.linga@intel.com,
 emil.s.tantilov@intel.com, jesse.brandeburg@intel.com,
 sridhar.samudrala@intel.com, shiraz.saleem@intel.com,
 sindhu.devale@intel.com, willemb@google.com, decot@google.com,
 andrew@lunn.ch, leon@kernel.org, mst@redhat.com, simon.horman@corigine.com,
 shannon.nelson@amd.com, stephen@networkplumber.org
Subject: Re: [PATCH net-next v3 00/15][pull request] Introduce Intel IDPF
 driver
Message-ID: <20230616235651.58b9519c@kernel.org>
In-Reply-To: <20230616231341.2885622-1-anthony.l.nguyen@intel.com>
References: <20230616231341.2885622-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 16:13:26 -0700 Tony Nguyen wrote:
> v3:
> Patch 5:
>  * instead of void, used 'struct virtchnl2_create_vport' type for
>    vport_params_recvd and vport_params_reqd and removed the typecasting
>  * used u16/u32 as needed instead of int for variables which cannot be
>    negative and updated in all the places whereever applicable
> Patch 6:
>  * changed the commit message to "add ptypes and MAC filter support"
>  * used the sender Signed-off-by as the last tag on all the patches
>  * removed unnecessary variables 0-init
>  * instead of fixing the code in this commit, fixed it in the commit
>    where the change was introduced first
>  * moved get_type_info struct on to the stack instead of memory alloc
>  * moved mutex_lock and ptype_info memory alloc outside while loop and
>    adjusted the return flow
>  * used 'break' instead of 'continue' in ptype id switch case

Ah, missed this, busy times.
Luckily I commented on different patches than the ones that changed.
-- 
pw-bot: cr

