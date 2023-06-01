Return-Path: <netdev+bounces-7186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D7F71F07E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65A201C21076
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B7746FE0;
	Thu,  1 Jun 2023 17:18:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09764253D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DF8C433EF;
	Thu,  1 Jun 2023 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685639889;
	bh=rmHFArekaGiZKmQ4ziA9csHRSAucq2oWTt/lCe73L1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iUk2l35RTUEH2L4IMsBA4fbLDaA5Lj610c0mdiM2klA9M/8oSzJxop86q+KXmO6Uw
	 oV73orKsz+L76WpEzmtX6YdC6jvuAPcgzoLOqcL18mnXhspJzPhCZCzDv88U7jjxYi
	 LSyK8TaFIb8Ilr2P2MhRoc74XeBYFvJlf5c2SLpkc9r4/sHBvyZ7efUT0YUn0WbbXL
	 eDNAHuUMQHP6WRjnQ9QVV+Zy9Nso6ClbLwcZxdp2+8yzmbrCgrh4QOHdSyjYuG+aTN
	 v3x56RSvEnyoQu1OgGJi5DzePWVR+c4rQJ49eiBg9W4Xg74BoqWXn0eWpC9P94zEOR
	 cxadhV6GfK8Vg==
Date: Thu, 1 Jun 2023 10:18:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, netdev@vger.kernel.org, Rodrigo Vivi
 <rodrigo.vivi@kernel.org>, intel-gfx@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Chris Wilson
 <chris@chris-wilson.co.uk>, Daniel Vetter <daniel@ffwll.ch>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>, Dmitry Vyukov
 <dvyukov@google.com>
Subject: Re: [Intel-gfx] [PATCH v8 0/7] drm/i915: use ref_tracker library
 for tracking wakerefs
Message-ID: <20230601101807.7e0363bf@kernel.org>
In-Reply-To: <b7811942-da09-7295-4774-46360715f147@intel.com>
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com>
	<55aa19b3-58d4-02ae-efd1-c3f3d0f21ce6@intel.com>
	<ZFVhx2PBdcwpNNl0@rdvivi-mobl4>
	<bb49bbd6-1ff2-8dba-11d1-6b6ab2ccd986@intel.com>
	<b7811942-da09-7295-4774-46360715f147@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 19:14:50 +0200 Andrzej Hajda wrote:
> Ping on the series, everything reviewed.
> Eric, Dave, Jakub, could you take patches 1-4 via net tree?

Sure thing, would you mind reposting them separately?
Easier for us to apply and it's been over a month since posting,
a fresh run of build bots won't hurt either.

