Return-Path: <netdev+bounces-8243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80A7E7233FF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ACE71C20DB3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 00:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1372718F;
	Tue,  6 Jun 2023 00:20:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AC87F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BED5C433EF;
	Tue,  6 Jun 2023 00:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686010837;
	bh=YAVubRtJbTXdXwrhoA5UIboSzrjR/al0UE5RUQfJV+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p3Phsm2R0AN/6dwsJCXO3vy138sNQT9gJubzGSn7toewH0GRJ6ty14RLquiHiIFcq
	 THJ5M9hANGUOlhnY0FJHcF85aPx4QGDpRCMR96Wuh+cyPv7gcgf1J6DVFLrFn1WKMc
	 6bvHgcrW87dtOarmaKmsK6Qk2+AKG1k1fuO9B6IEmUrroEBVycOpJQ1FMi3DQfQhQV
	 b4oJzxxANqyJYdyGB4OmcqWySSqqwdoC9nrKerS6NiE4QC1j3EaD6g6ELcn3RDAKvd
	 Qq8ZMf9BHKIP7AYob1lSLDJfcPzOsWMX1IXoTbdBqy1l4b0bCF1UBCasdbO159Ot6F
	 xCe+pnaWQb2sw==
Date: Mon, 5 Jun 2023 17:20:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com
Subject: Re: [PATCH net] netlink: specs: ethtool: fix random typos
Message-ID: <20230605172036.0e29b95a@kernel.org>
In-Reply-To: <CAKH8qBtgrQG-skeScctazy84VV5YL69t7G8gfNTiGFVyFUXLtg@mail.gmail.com>
References: <20230605233257.843977-1-kuba@kernel.org>
	<CAKH8qBtgrQG-skeScctazy84VV5YL69t7G8gfNTiGFVyFUXLtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 16:37:26 -0700 Stanislav Fomichev wrote:
> > -        nested-attributes: cable-test-nft-nest
> > +        nested-attributes: cable-test-ntf-nest  
> 
> So much NFTs! Long live NFTs :-D

Maybe if I named the patch "remove NFT references" we'd have made 
the news. Missed opportunity :D

