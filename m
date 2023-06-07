Return-Path: <netdev+bounces-8687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08907725313
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FD3C1C20B98
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A90CA31;
	Wed,  7 Jun 2023 04:57:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368AA7C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9BAC433EF;
	Wed,  7 Jun 2023 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686113819;
	bh=w9cuCvrQsGECruI1dZGpMTNeTMP6TOOv7UoVvZeEMEA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KZDcELGx+0RA9xqfmHLiSV6ZLlUISS3v5+u/chVmwrhe77MrrLfQP++kqE7x6uTDT
	 ennhf70Yk9D7lrDVe0GHPOrUBmV4foCGE9J7WsSQ8FH2XuI5eAoPuorFdVMFPpscNy
	 PWsQlKswT0TEgXkeSTzLAwa9vruOPA1tj6/1+cCVyzn2IjWKwj9L2sGjdSJTZhJB7o
	 tz1A2SErAa2asqa450dTp7GAFctTZrK2JdsiWp8ASSjrfyj5B90Hs+JdnZPpe4P1Zb
	 Na4dCPM4QiiF9SQDMZG9p2UxBWz1bWTXhUR/r/hJ2BYx1qxQjU14oyxc5mm+MbIL9+
	 02x/PL6H4bELQ==
Date: Tue, 6 Jun 2023 21:56:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: <edward.cree@amd.com>
Cc: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
 <edumazet@google.com>, Edward Cree <ecree.xilinx@gmail.com>,
 <netdev@vger.kernel.org>, <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
Message-ID: <20230606215658.3192feec@kernel.org>
In-Reply-To: <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
	<286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 20:17:38 +0100 edward.cree@amd.com wrote:
> +			dev_hold(neigh->egdev = dst->dev);

Please use the ref-tracker enabled helpers in new code.
And the assignment on a separate line, please.

