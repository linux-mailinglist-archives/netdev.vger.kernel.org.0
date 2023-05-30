Return-Path: <netdev+bounces-6530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D86D1716D64
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77B641C20D04
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC2F2109C;
	Tue, 30 May 2023 19:20:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D88206B5;
	Tue, 30 May 2023 19:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E32C433D2;
	Tue, 30 May 2023 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685474457;
	bh=QmKwcl2ZuW1gdTA3BXuLFByGwO29mki0wacNBQJ81dE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DyK9cdjt0pHVVtWQoLIWw5C8XLxbeXBt0Fzvh15Nf5KlKTpb8YM+TIm3FrYwSEAsz
	 ESPDtSHLG9UgFazFZ/h/Bnixoz9U7wS6kNlGOqpjQFOPwyVcFMZQkpyVnIQ+/9Xx08
	 BOVpz7nqE2u/DhhpltAQar008SeWe56CmeSPJ2/3wI0PbLiorOlsOB0cFBIpEBnOsJ
	 CoUdBz5w5D6FIssrM/pBvsNXVzqjuEvqgCJbLVx8DQawI9bZ60WFDfL5qDhKPtnDEh
	 ILvdIzvlxIUCDmnVVBTC2Ms+kj8KBo3MFX+XH7gOypcDDrVhba/BNx+vE4VK6unAWS
	 Sfhc0iykp7LjA==
Date: Tue, 30 May 2023 12:20:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2023-05-26
Message-ID: <20230530122056.73b57def@kernel.org>
In-Reply-To: <484ffbc6-69e8-864e-35c5-61c38fd0c116@iogearbox.net>
References: <20230526222747.17775-1-daniel@iogearbox.net>
	<20230526173003.55cad641@kernel.org>
	<484ffbc6-69e8-864e-35c5-61c38fd0c116@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 11:29:50 +0200 Daniel Borkmann wrote:
> >> 1) Add the capability to destroy sockets in BPF through a new kfunc, from Aditi Ghag.  
> > 
> > Is there a reason this wasn't CCed to netdev?  
> 
> Hm, good point. I think this was oversight as this was submitter's first patch series
> for upstream. I did see Paolo reviewing one of the revisions, but yes netdev should have
> been in Cc throughout all the revisions. Sorry about that, we'll watch out the Cc list
> more closely and point this out if this happens again in future.

Thanks! Just wanted to make sure nothing changed in terms of posting,
ahead of the highly anticipated tcx and meta device work :)

