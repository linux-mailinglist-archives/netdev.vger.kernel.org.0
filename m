Return-Path: <netdev+bounces-50-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2B56F4ECF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BAC4280D66
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD09805;
	Wed,  3 May 2023 02:20:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9A97E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C088BC433EF;
	Wed,  3 May 2023 02:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683080426;
	bh=bo0HlLk/0v6qzsyOqBWj0ZUl4zv2sak5dvJi3hB9PCc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RT2gy8WiLZQjD0EFCTeooCO/tnZrx252vLMTH8p9FEz6fgD3jzb/FR6y6/jLQTOda
	 nq2dx+liX/faLKnInTb4hc9VbjEngswu/QQChpvtGrUOmme9Ur9wBYdbsexfEvikAP
	 2PEjQ6OzrwVamZmV4Ttp39E5xsibgD1HskLKlIBHZDcMURC7zKt7VnrsrGUcZcqWW/
	 XADAoPuE8gpzoxyOO/S7mPkEq8GdDUgAJB8Is1cSx4gKtOaXuBXOJrl222TeVFDDB2
	 jqpWSEYiCGRePXsLS5eT7yG7EN2GhQ9FBbk/k9VVFxqtx5xJ2T78Q/vYFkoQ/c0i5U
	 lU3mIuPO7c3Tg==
Date: Tue, 2 May 2023 19:20:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
 <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
 <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
 <anthony.l.nguyen@intel.com>, <willemb@google.com>, <decot@google.com>,
 <pabeni@redhat.com>, <edumazet@google.com>, <davem@davemloft.net>,
 <alan.brady@intel.com>, <madhu.chittim@intel.com>,
 <phani.r.burra@intel.com>, <shailendra.bhatnagar@intel.com>,
 <pavan.kumar.linga@intel.com>, <shannon.nelson@amd.com>,
 <simon.horman@corigine.com>, <leon@kernel.org>
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
Message-ID: <20230502192024.28029188@kernel.org>
In-Reply-To: <965fa809-6cdd-7050-1516-72cc33713972@intel.com>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
	<20230426194623.5b922067@kernel.org>
	<97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
	<20230426202907.2e07f031@kernel.org>
	<965fa809-6cdd-7050-1516-72cc33713972@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Apr 2023 15:23:12 -0700 Jesse Brandeburg wrote:
> > Jesse, does it sound workable to you? What do you have in mind in terms
> > of the process long term if/once this driver gets merged?  
> 
> Sorry for the thrash on this one.
> 
> We have a proposal by doing these two things in the future:
> 1) to: intel-wired-lan, cc: netdev until we've addressed review comments
> 2) use [iwl-next ] or [iwl-net] in the Subject: when reviewing on
> intel-wired-lan, and cc:netdev, to make clear the intent in both headers
> and Subject line.
> 
> There are two discussions here
> 1) we can solve the "net-next subject" vs cc:netdev via my proposal
> above, would appreciate your feedback.
> 2) Long term, this driver will join the "normal flow" of individual
> patch series that are sent to intel-wired-lan and cc:netdev, but I'd
> like those that are sent from Intel non-maintainers to always use
> [iwl-next], [iwl-net], and Tony or I will provide series to:
> maintainers, cc:netdev with the Subject: [net-next] or [net]

Sounds like a good scheme, let's try it!
Thanks!

