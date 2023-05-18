Return-Path: <netdev+bounces-3478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 295927076D8
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 02:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8D172816A7
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 00:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53CD8191;
	Thu, 18 May 2023 00:18:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776A6160
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9288C433EF;
	Thu, 18 May 2023 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684369111;
	bh=CdjamDfFKfw4UVZkYBLyqAh6PTQXoprARJKRWqO3yxw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tg/RURouWtqQNyQD+rjL7EG8WFbrqDsz/h4piDUEGgi4zQ93Cvdk2YG36td/5ZfpQ
	 YnJ8KYEeM6Cd+lT5ZXPxpVtEHLGgKP6Im07rUadCBG8wDQWQNS2STrxq10/OK+DazY
	 Hy/9SxM+SWdD73P6KSrzW+C2/dMN4VQzV2aEZy6cweDKTOVkCFOvSggDPVWZouIEZG
	 wn6Zbh4hDErUCWxqXT86YWiGBEhXgq2GFVGXq41nuDZkIuRZI2zSfouZBq416Weyl5
	 97JQ/OFcNyLPXHmaT921QAMILBfSUpiD/+LRdBmFR5Pypv8uLpZmxoUNk+VDg0USzX
	 EaV8tMaFiIH9g==
Date: Wed, 17 May 2023 17:18:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Forst <forst@pen.gy>
Cc: Simon Horman <simon.horman@corigine.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
 Georgi Valkov <gvalkov@gmail.com>
Subject: Re: [PATCH] net: usb: ipheth: add CDC NCM support
Message-ID: <20230517171830.5af5c1c4@kernel.org>
In-Reply-To: <00275913-6b7c-9b91-4f5c-d8a425bd3e46@pen.gy>
References: <20230516210127.35841-1-forst@pen.gy>
	<ZGSb4l8XcxclFsB1@corigine.com>
	<00275913-6b7c-9b91-4f5c-d8a425bd3e46@pen.gy>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 22:30:18 +0000 Forst wrote:
> [encrypted.asc  application/octet-stream (5747 bytes)] 

FWIW people on CC are not getting your emails.
Could you disable the encryption or whatever you have going? :|

