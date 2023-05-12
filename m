Return-Path: <netdev+bounces-1989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 519546FFE32
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DDE11C210D1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97737F0;
	Fri, 12 May 2023 00:58:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B1539D;
	Fri, 12 May 2023 00:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5282CC433D2;
	Fri, 12 May 2023 00:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683853087;
	bh=Na7tNUvEVf6ByVUC4k87U3onJNIuQV7IWaT3nOoxrPA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ap1p4ygC9tf7kD886uOAEwUgJVinAxtgj6i8xx+YbFmZllbUDXazxNaM5rPdydFTo
	 9qtNJO5RVcIybs+Z13CIck/ETTTsOxKoNh5mFhGFOd2c7tLmfip5Yv6mAWDn3NLJt3
	 14ddehiK2OMAn5laRsPWu4WfW7FUi6naMMhvSNX4dk5/taJV5qHjhhtZT195R2msb8
	 v4LHG/1cdnfeOppwShDTLotMgoLA4s3fYTuAOSLZ3FciDrogG8D9T96NsyHyX7hEqb
	 Sb16m7V/SXK81T7BuyOl+IgfLiNBBSEJDiaDnc8mNtBzMA3BUs4yXLofvdfWsMGu2I
	 l85908kduF9pg==
Date: Thu, 11 May 2023 17:58:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Clark
 Wang <xiaoning.wang@nxp.com>, NXP Linux Team <linux-imx@nxp.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend
 <john.fastabend@gmail.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH v2 net 1/1] net: fec: using the standard return codes
 when xdp xmit errors
Message-ID: <20230511175806.4b1f84f6@kernel.org>
In-Reply-To: <20230511175542.0bf5b773@kernel.org>
References: <20230510200523.1352951-1-shenwei.wang@nxp.com>
	<20230511175542.0bf5b773@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 17:55:42 -0700 Jakub Kicinski wrote:
> On Wed, 10 May 2023 15:05:23 -0500 Shenwei Wang wrote:
> > -		xdp_return_frame(frame);  
> 
> This line is a bug fix (double free).
> 
> I'm going to apply v2, it's good enough.

Let me take that back, I'll reply to v2.

