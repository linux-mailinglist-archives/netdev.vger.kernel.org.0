Return-Path: <netdev+bounces-645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B626F8CE3
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 691B81C21A0C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80938101EF;
	Fri,  5 May 2023 23:47:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB898C12D;
	Fri,  5 May 2023 23:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56739C433EF;
	Fri,  5 May 2023 23:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683330436;
	bh=NZ7URjmvoWTcc6qha6e9dsNrE0AhjdKFqtTbNb1bDSE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=feE9cetjXP9q+fs/AOT45dpGVUR4CbIgdOEQ/E/8DNiPbgVkxMdQlJYaSPjV9JInv
	 dDUHokT9gJGYnAUHD7EKr2hlV/2rhdRQy2BSfhkkVOoYGZLgqkFM/8+lTlO+/tLiS2
	 6uL1vIOGTDN6PJ41NsEv2mQgI9ecGcAzxcHNZG8oQ8qTuo2QD9KGd4HVaN4J+zv4JY
	 ISB0nDiiMUipCoXGL9Nh0hzgSoiIZV8rOvfCrtCloMlJIPJU7VWcKypiL1b77KxuWc
	 K0DfN+S+bA7yM3LoPSEzBJ66eUeuSRNWE3DoB4+j2kDpgfHF3JMNvO+tlEkK6v6rXb
	 SmMmxu346XBgw==
Date: Fri, 5 May 2023 16:47:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
 dan.carpenter@linaro.org
Subject: Re: [PATCH 0/5] Bug fixes for net/handshake
Message-ID: <20230505164715.55a12c77@kernel.org>
In-Reply-To: <ZFWOWErJ6eR/RX/X@manet.1015granger.net>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
	<20230505133918.3c7257e8@kernel.org>
	<ZFWOWErJ6eR/RX/X@manet.1015granger.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 May 2023 19:16:40 -0400 Chuck Lever wrote:
> On Fri, May 05, 2023 at 01:39:18PM -0700, Jakub Kicinski wrote:
> > On Thu, 04 May 2023 11:24:12 -0400 Chuck Lever wrote:  
> > > I plan to send these as part of a 6.4-rc PR.  
> > 
> > Can you elaborate?  You'll send us the same code as PR?
> > I'm about to send the first batch of fixes to Linus,
> > I was going to apply this series.  
> 
> Since I am listed as a maintainer/supporter of net/handshake, I
> assumed I can and should be sending changes through nfsd or some
> other repo I can commit to.
> 
> netdev@ is also listed in MAINTAINERS, so I Cc'd you all on this
> series. I did not intend for you to be responsible for merging the
> series. We'll need to agree on a workflow going forward.

Let me talk to DaveM and Paolo -- with NFS being the main user
taking it via your trees is likely fine. But if it's a generic TLS
handshake and other users will appear - netdev trees may be a more
natural central point :S DaveM and Paolo are more familiar with
existing cases of similar nature (rxrpc?)..

> Since you had some review questions about one of the patches,
> maybe that patch should not be merged at this time by either of us.

Right, I noticed the cover message first then started looking more 
in depth at the code :)

