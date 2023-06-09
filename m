Return-Path: <netdev+bounces-9654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6363072A20D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06496281912
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116A9209B2;
	Fri,  9 Jun 2023 18:21:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50F214262
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49E9C433D2;
	Fri,  9 Jun 2023 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686334909;
	bh=z0U+T4NBLJIzLaGQ11TsMq9w4sS9Wsa35rEyaDvHHhI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n62SRJXDraazhvPOEV703d15Lqsr3ATCcJCHM+nCDGnwdxN43L+DpOLwG92wSg5r/
	 qyCZzHi/KxQxKl542ATr9KisWYr+F62MozavklFyAp5LXBm8TI76D7XtQtFfMp2/iB
	 0+0nJ4SyFSy902vQGOm/DHFsvhmdNIZPrD28gZ75CwgUzxGx46HlQnZZYjc7KLnvul
	 VTbti37lNWNiWk1BiCQis2eSUm+3Xj1Sq+2kDWXK2Qu2rrXs3tvyWK8hAkIvhY5ZYR
	 JfvH1Z5MJ/vGrXnppkVi/VxzKZOII6CSQoy8R9cv0hxZ+ywZag9wv2cD8IILM5pAm2
	 UV2oRlNgeUPCg==
Date: Fri, 9 Jun 2023 11:21:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, tgraf@suug.ch, herbert@gondor.apana.org.au,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com
Subject: Re: [RFC PATCH net-next 0/4] rhashtable: length helper for
 rhashtable and rhltable
Message-ID: <20230609112147.24cd3756@kernel.org>
In-Reply-To: <41d16737-6bdc-2def-402d-04d69127faf9@mojatatu.com>
References: <20230609151332.263152-1-pctammela@mojatatu.com>
	<20230609103644.7bdd3873@kernel.org>
	<41d16737-6bdc-2def-402d-04d69127faf9@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 15:13:40 -0300 Pedro Tammela wrote:
> > I mean the name of the helper is not great. > IDK what length of a hashtable is. Feels like a Python-ism.  
> 
> Well 'length' has been the term used in a few languages (Python, Rust, 
> Go, etc...) so it felt the most fitting. If you have any suggestions in 
> mind, do tell; Some that crossed my mind were:
> - count
> - size
> - elems
> - num

count and elems sound best to me

