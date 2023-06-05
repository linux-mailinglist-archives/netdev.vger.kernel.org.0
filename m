Return-Path: <netdev+bounces-8231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F065A72333C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E3281C20E14
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5697C2F5;
	Mon,  5 Jun 2023 22:33:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47C05256
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 22:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BEFC433EF;
	Mon,  5 Jun 2023 22:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686004435;
	bh=Tqjwije9sLgBSKVPubakZQef4W29AG6vJdvRbwzWZFA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u4UpGwVAXBNmNOBdzFx2eOpybeXThMuPcjcEDpb2NvlXw2cu+FC/OTJCsZx330ANA
	 ltRzzkE8ui5JByaYoCTzdMFV2PZrrWvNUkDpDh0jha8XpttHWzXWT+ePGhofCUdKE3
	 Q5lNLMwhAfF3Xd8bBszufYjvzh3itiXD8/PnET6xVflb5MpRr5Yd+XuaEpAfCYDUq7
	 sv8v1Ybbgh6I9s7CICIIx/xVvdL73k+fhMTh1xmVjNkwzhuOTbVbkWbV20yCUgSOPr
	 tR5qNAtb+o0ibrLWy8YExtafobLRv8gypF8PNeyJwJkdgbWz+BKVhUl6/B/abzxxAZ
	 B3YTRXdsObNzg==
Date: Mon, 5 Jun 2023 15:33:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas
 Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
 netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Andi Shyti
 <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v9 0/4] drm/i915: use ref_tracker library for tracking
 wakerefs
Message-ID: <20230605153353.029a57ce@kernel.org>
In-Reply-To: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
References: <20230224-track_gt-v9-0-5b47a33f55d1@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 02 Jun 2023 12:21:32 +0200 Andrzej Hajda wrote:
> This is reviewed series of ref_tracker patches, ready to merge
> via network tree, rebased on net-next/main.
> i915 patches will be merged later via intel-gfx tree.

FWIW I'll try to merge these on top of the -rc4 tag so
with a bit of luck you should be able to cross merge cleanly
into another -next tree.

