Return-Path: <netdev+bounces-646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B22A46F8CF2
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 449E328111B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6DC101F1;
	Fri,  5 May 2023 23:58:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AB8D304;
	Fri,  5 May 2023 23:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C951FC433EF;
	Fri,  5 May 2023 23:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683331128;
	bh=o5wx+4P6YdZOTfD4FbhIf08nZzpS5Hc5OvyK3xBMcGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nEwObzL9FGv0BpBqs3URTqX85VLjuOZcBbPtEcosmjDlAu39JGwO97QCdnX03+F7N
	 F+aQA6asaZPG/iFv115/fiZvWNljaFz4BFeiY8fWJlgSjXnQweLceku1VF7FcNUEYt
	 OlAVRd7f+4I9f3ta0qjPJ/8f4WU4FdhGjrbDL+DDNgT1geWxyaEJaDnFZ9TQN+wEY8
	 MVUtR1uD5dSoNGwa1nD/nE1yqeVAUrVGDWRwi6obCLwCIvXNFUDW5YLq5+ttYdisOG
	 9JZTa8xNZYSDje+iY9D/9yhUQc6S854DyNtXPcBsq2OeS8fRdeC/x9Nw0GXXrNoq+i
	 4Qz5yCFwMPd5g==
Date: Fri, 5 May 2023 19:58:45 -0400
From: Chuck Lever <cel@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 0/5] Bug fixes for net/handshake
Message-ID: <ZFWYNW4JAOWX6ASq@manet.1015granger.net>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <20230505133918.3c7257e8@kernel.org>
 <ZFWOWErJ6eR/RX/X@manet.1015granger.net>
 <20230505164715.55a12c77@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505164715.55a12c77@kernel.org>

On Fri, May 05, 2023 at 04:47:15PM -0700, Jakub Kicinski wrote:
> On Fri, 5 May 2023 19:16:40 -0400 Chuck Lever wrote:
> > On Fri, May 05, 2023 at 01:39:18PM -0700, Jakub Kicinski wrote:
> > > On Thu, 04 May 2023 11:24:12 -0400 Chuck Lever wrote:  
> > > > I plan to send these as part of a 6.4-rc PR.  
> > > 
> > > Can you elaborate?  You'll send us the same code as PR?
> > > I'm about to send the first batch of fixes to Linus,
> > > I was going to apply this series.  
> > 
> > Since I am listed as a maintainer/supporter of net/handshake, I
> > assumed I can and should be sending changes through nfsd or some
> > other repo I can commit to.
> > 
> > netdev@ is also listed in MAINTAINERS, so I Cc'd you all on this
> > series. I did not intend for you to be responsible for merging the
> > series. We'll need to agree on a workflow going forward.
> 
> Let me talk to DaveM and Paolo -- with NFS being the main user
> taking it via your trees is likely fine. But if it's a generic TLS
> handshake and other users will appear - netdev trees may be a more
> natural central point :S DaveM and Paolo are more familiar with
> existing cases of similar nature (rxrpc?)..

Makes sense. We expect NVMe to become a consumer in the near future,
and have considered a putative in-kernel QUIC implementation to be
another potential consumer down the road.

