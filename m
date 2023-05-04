Return-Path: <netdev+bounces-299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C44D76F6F3E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CF491C2115A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB668946D;
	Thu,  4 May 2023 15:41:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3922F48
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148D6C433EF;
	Thu,  4 May 2023 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683214872;
	bh=sAdW9GZ5XIdh4/HuslCiUTwmd7Ncys1QSJLA9ClxIOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GBaMrNy+8Ey1z+0RmA7asZ3QyArDktHDijl0L+iGOIFLF4xp6b+Y4W2nftsfL0zF7
	 EJCQ9CtUviUe+Q25AY4/hNW/+4O18TW8CDSahtYToXb3fGs/uJKbiX7QpAY5loa0uE
	 YX1hC75MoJfk6WCglsRFvN0+Bt1JOUI8T4cN9xTqbdvypiK/+FT8/+mKpQbivWwb7i
	 hXqzhJ/obmDzi/t5s1WuSdyOGLKSJtCnlc93e70FJ+WgytRRx4PEfe98IjioQ5PldR
	 D/0DPXSpVv2fzvDr0p7IHwR99/PNGPMXIvGVSWF1ZIOvvRRZD7ikIa9eSWs7WaH+9F
	 ToYTK+iwPVkww==
Date: Thu, 4 May 2023 08:41:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Max Georgiev <glipus@gmail.com>
Cc: kory.maincent@bootlin.com, netdev@vger.kernel.org,
 maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: Re: [RFC PATCH net-next v6 2/5] net: Add ifreq pointer field to
 kernel_hwtstamp_config structure
Message-ID: <20230504084110.28cdc6a1@kernel.org>
In-Reply-To: <CAP5jrPGEjx-BvVDx5YSmrGSobPJJ9Uxk8N2wDG--+LGxHP7KCA@mail.gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
	<20230502043150.17097-3-glipus@gmail.com>
	<20230503200545.2ff5d9d2@kernel.org>
	<CAP5jrPGEjx-BvVDx5YSmrGSobPJJ9Uxk8N2wDG--+LGxHP7KCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 09:21:42 -0600 Max Georgiev wrote:
> Got it, wil update both generic_hwtstamp_get_lower() and
> generic_hwtstamp_set_lower().
> 
> What would be the best practice with updating a single patch in a
> stack (or a couple of
> patches in a stack)? Should I resend only the updated patch(es), or
> should I increment the
> patch stack revision and resend all the parches?

You'll need to resend all, but this is minor enough that, unless
there's more comments, I'd just wait until Monday and send non-RFC 
at that point (with "a" driver conversion included).

