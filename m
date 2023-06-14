Return-Path: <netdev+bounces-10854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5307308C8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B97731C20907
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBA011CB9;
	Wed, 14 Jun 2023 19:51:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9500C2EC11
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF328C433C0;
	Wed, 14 Jun 2023 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686772266;
	bh=XixhRXNacZf86/Ab3M9lMGOYV4VdBeeg4pCVwps5JRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A1g+XWgdsLQsKEltC0MaZo2pukro9VJdv1s3vLg/vWL9lCMspmn0odUrAmldGNBFT
	 GStQLkX7kvz6iUWv9NRRp/ElhFw9Jx1e8PFszG5BQ2xvX6XV63NpIsqaRiOD8FXkeY
	 h7Plogp2/P1gKuI52Ou2MS60jcXxb20f+T+f/ZVqGTHUXRLjEYTZbconRAld9C3rPC
	 Q7bVyFq8sSMfCKP+mJ5E9zpYJk+MEhU75D9xHB+HSBia4rHuYTcIF/sKUxYNSe3KKO
	 U+DRMkDL3FcprsRptdO5hpBJ7rO/p9hihrN/U1zvfKCZ5v66d+Zm2uhmPe25KdebgD
	 NiSCAjfchdFVQ==
Date: Wed, 14 Jun 2023 12:51:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>, vburru@marvell.com,
 aayarekar@marvell.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, sburla@marvell.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeon_ep: Add missing check for ioremap
Message-ID: <20230614125104.0d29b00c@kernel.org>
In-Reply-To: <CAH-L+nM3kPWxyLn_iO7ktmd5E+URG=EfPW2FWnd6fxdSVdb7Hg@mail.gmail.com>
References: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
	<CAH-L+nM3kPWxyLn_iO7ktmd5E+URG=EfPW2FWnd6fxdSVdb7Hg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 11:33:17 +0530 Kalesh Anakkur Purayil wrote:
> >         kfree(oct->conf);
> >         return -1;
> >  
> [Kalesh]: fix to return -ENOMEM instead of -1.

The author is not touching the return code, seems unrelated.

