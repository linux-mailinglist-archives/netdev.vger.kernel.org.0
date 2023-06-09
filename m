Return-Path: <netdev+bounces-9642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 274F772A15B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7326B1C208B7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F708206A2;
	Fri,  9 Jun 2023 17:36:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1B1C76B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300FBC433EF;
	Fri,  9 Jun 2023 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686332205;
	bh=82+hIpp4+zLyIYltv5EFD7Xt9RfEL/2sd5uvTP6cshA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Itlz/z2khbl8b0UO6TF1e1WORvcN0ccTapasD3gcywDJR7YdKMObchLgvo9XAduoC
	 xp9O+bnXyLvH5tjCQvw+7sdVwUdBFDoTE/wCqQcBz4f0Vqx0BCo0VpxtKiK58nBkYm
	 Dg498dtNGDGMi7Fb0nVCk9IIGITTVYgSpZ9BVNuwfO+sPQX2NemdhwSG5Dvh5SMZSz
	 6Skgj+xcjzaxBb9oLtKx/f7ETqENA8m3kpMmIhiAvqQr2jworMN6JKGclxCUIjYcqR
	 xakc456u6LOp98vidNP+3dq1YWnslQ+ganyWvM+L3qFbn5o4oDAGRUuyXe+WZVStPI
	 JodCZBs2/rcYw==
Date: Fri, 9 Jun 2023 10:36:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, tgraf@suug.ch, herbert@gondor.apana.org.au,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com
Subject: Re: [RFC PATCH net-next 0/4] rhashtable: length helper for
 rhashtable and rhltable
Message-ID: <20230609103644.7bdd3873@kernel.org>
In-Reply-To: <20230609151332.263152-1-pctammela@mojatatu.com>
References: <20230609151332.263152-1-pctammela@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jun 2023 12:13:28 -0300 Pedro Tammela wrote:
> Whenever someone wants to retrieve the total number of elements in a
> rhashtable/rhltable it needs to open code the access to 'nelems'.
> Therefore provide a helper for such operation and convert two accesses as
> an example.

IMHO read of nelems is much more readable than len(). I mean the name
of the helper is not great. IDK what length of a hashtable is. Feels
like a Python-ism.

