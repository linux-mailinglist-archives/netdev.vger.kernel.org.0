Return-Path: <netdev+bounces-9671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6877B72A2A8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9171C20E5B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70233408E2;
	Fri,  9 Jun 2023 18:55:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEC408D9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E11C433D2;
	Fri,  9 Jun 2023 18:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686336945;
	bh=+opSJ7Ax5vhFMWeYbggrDX+TGywkzv0VvjKwMLx03NQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3HKwfiDQYRJdwHD+956HQoSi6vMvkoOrIhHhcqU3pdb1zh+619FLG5BvhSsPMaau
	 bb9icW/ed/EaYr9l0iikkcuTGuIwzCpnzVQ/9LQUn8v0cGq2+N0+R8gJd8UZJYPGMt
	 pUvN1ADyWfxfROB5kSwcQgTK7bRzSAzE90WcHRPOQNlWVQTM2XokGPR3//+yjgsgR9
	 W6n2zIFJVGpnicK8Bqsb2L6XJoh/SxR87K+Jfh9R7a0d9TSm/s+JDaA35YL4jeYsYm
	 1YTHcDVeGigsJSfmdfvKaJkCphe7L/pTWV/ycVhIo2qyhIXvoHcOJU/KARJj9VASZv
	 StxpwAsJMq/fA==
Date: Fri, 9 Jun 2023 12:55:42 -0600
From: David Ahern <dsahern@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next] net: move gso declarations and functions to
 their own files
Message-ID: <20230609185542.GA23541@u2004-local>
References: <20230608191738.3947077-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608191738.3947077-1-edumazet@google.com>

On Thu, Jun 08, 2023 at 07:17:37PM +0000, Eric Dumazet wrote:
> Move declarations into include/net/gso.h and code into net/core/gso.c
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>

Reviewed-by: David Ahern <dsahern@kernel.org>

