Return-Path: <netdev+bounces-228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CF96F62A1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5361C2106A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 01:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A29A40;
	Thu,  4 May 2023 01:27:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BA97E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85242C433D2;
	Thu,  4 May 2023 01:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683163629;
	bh=vSNHM8IwjApXI0g25/Ijgrmh+L5/WEeIOhf4ewqQxBU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UDsEud398qklCzfTLzg8pECABRpVVdstEk46IoaN9Zz0l5PsgWRS+B2VxRSFmBrvS
	 XoO9x8KJNTpVu1mDZ9FRfd2A8P70D25ebVgN+fwn2ch9x+FwuWoXalpbX2YZkKy0Sx
	 pjSxMejKUOX1b0E9B1iKlY7uKAklC3+D3BwEFyG9nHZl+YJ++iuH8D4jBlRrmXG/pi
	 0tDRVdjzXfj+XPSDFWtxqNBSmd8t17J9d7TBVB1xIVDqih9N4yci40TwSQgvd8pJ0P
	 pXRbZS0PVxz/LpqsS8TKYHqST0xlCtBUmOwYDl5AhgYHna3EHxVHILrpEs/6Kt20Ah
	 OhwjSnwzhtWAw==
Date: Wed, 3 May 2023 18:27:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: brett.creeley@amd.com, netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for
 vlan offload
Message-ID: <20230503182708.70f479d9@kernel.org>
In-Reply-To: <ccfccde0-9753-1e54-75b0-f6f1d683d765@amd.com>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
	<20230502164336.1e8974af@kernel.org>
	<ccfccde0-9753-1e54-75b0-f6f1d683d765@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 15:49:27 -0700 Shannon Nelson wrote:
> Given that there is no traffic to the host PF in this case, and I can't 
> do anything more than wave my hands at vague promises for the future, 
> perhaps tc and representors is the wrong path for now.

If it's not a priority for AMD to have an upstream implementation
that's fine. There's not point over-complicating the discussion.

> But there remains a need for some port related configuration.  I can 
> take a stab at adding this concept to "devlink port function" and see 
> what discussion follows from there.

You mean setting vlan encap via devlink?
I don't know why you'd do that. It will certainly aggravate me,
and I doubt anyone will care/support you.

