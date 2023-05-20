Return-Path: <netdev+bounces-4057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B258470A562
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20063281B43
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5C164D;
	Sat, 20 May 2023 04:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF535363
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 04:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3AEC433D2;
	Sat, 20 May 2023 04:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684557964;
	bh=HQs9oX3Z7y5AdWiC72yxeuSHc4uWNpff3HLclY1Fb6Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y3F27g4Wa1yQOKb9gK3sjOAwU9kPX/hDiTXoPp4pe1vt397MxAs40ua/2lY5LxYy0
	 lf4dPi2IJpA3Z8WakasN3jYsDoKrrp4JshzAF8tqh80M6zU66ikLt2bR/W3fOJvfA/
	 T43x+RfeVRlDTq7IF4ZLmAazE3WC5Qz4CWQL1GDiCogEX5ZwhPgEFJ4hixyO7uWdPp
	 Kc1WJV5CO5iIrFHlvqr11ix2Pn9Z/nGwmkNmYvpIigf3TCnsOnczFmg9TiXMBBxobY
	 Bi8shFilqQdGgM8k9jX5Sg6i18e9CVhNt9oB3Hg7gO2DI2zRpWmxJeyJc9x5RqiOy7
	 BY4JwoHiz9ukg==
Date: Fri, 19 May 2023 21:46:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2023-05-19
Message-ID: <20230519214603.15bfac84@kernel.org>
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 10:55:42 -0700 Saeed Mahameed wrote:
> mlx5 misc changes and code clean up:
> 
> The following series contains general changes for improving
> E-Switch driver behavior.
> 
> 1) improving condition checking
> 2) Code clean up
> 3) Using metadata matching on send-to-vport rules.
> 4) Using RoCE v2 instead of v1 for loopback rules.

Acked-by: Jakub Kicinski <kuba@kernel.org>

FWIW..

