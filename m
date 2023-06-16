Return-Path: <netdev+bounces-11521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35A7733734
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1CA11C20FCB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30D51ACD0;
	Fri, 16 Jun 2023 17:12:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6419C18C07
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAB6C433C0;
	Fri, 16 Jun 2023 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686935550;
	bh=KlTwkwXblCNvivnAXZAG0KbO1kr/0iJApC9exLWjwQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XxMhIBTtbYbQNwDNDxZAKj3cIkAcPSZgQbghzI/y5G4TmoEbnnlNBKIXRO/4nC9Pz
	 lnlbV90YTs29wq7WR2g/xZfivFt0zKTLoPbLAlRwlbxgwUdRhxglqu3qjwlSDvWVYa
	 1m3zrPA60CALcQc8R/OriSte+FhSaVTQoBZhHpqta3Ls8XfM4o9fpzSHMDzFOhHkIS
	 ZlHmkMFPGB71aljLZTp5UvwdBm8c1HtU8TxO8xlaunuGtgVUVLXrXTCxu4pTRWwCql
	 ba9OnDVWuYMg51I2bvAyob67ucv7Wywg2o3YBpgYOT69qT1V2jqm0nRl2C5p77UKU3
	 JHW8XFRJKZzwQ==
Date: Fri, 16 Jun 2023 10:12:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Veerasenareddy Burru <vburru@marvell.com>
Cc: Sathesh B Edara <sedara@marvell.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, Satananda Burla <sburla@marvell.com>,
 "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
 <edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] MAINTAINERS: update email addresses of
 octeon_ep driver maintainers
Message-ID: <20230616101229.1e7339f0@kernel.org>
In-Reply-To: <BYAPR18MB2423D248B84D85F3C1A48159CC58A@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20230615121057.135003-1-sedara@marvell.com>
	<20230615101311.34f5199e@kernel.org>
	<BYAPR18MB2423D248B84D85F3C1A48159CC58A@BYAPR18MB2423.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 05:04:24 +0000 Veerasenareddy Burru wrote:
> > What does it mean to be a maintainer to you?  
> 
> Sathesh will also be maintaining and submitting the changes for
> octeon_ep drivers, going forward.
>
> Is the right way for this is, add Sathesh to MAINTAINERS list along
> with his first patch/patchset submission ?

The patch is perfectly fine. Please see my question as half survey half
commitment device. I don't think we have a crisp enough understanding
of responsibilities of "corporate" maintainers. It always worries me
when I see someone who never (AFAICT) sent an email to the list before
get nominated as a maintainer.

So I'd like to hear from Sathesh, clearly stated, what responsibilities
and SLAs he's taking on. Once we gather input of this nature from a
handful of maintainers maybe we can distill a guide in
Documentation/process/...

