Return-Path: <netdev+bounces-7017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE57719336
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C82828159E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E616BA58;
	Thu,  1 Jun 2023 06:27:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B3A2916
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7413C433D2;
	Thu,  1 Jun 2023 06:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685600843;
	bh=B01TcQGDboiLGShWWyZcY4lDUPQ6pacYmh5T9cOJ9nU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cjZryNE/di2tcvyRk9knd6WUruHc2ePrJSF1kBDCpcRDVz/CuWqIsYMMkNDqr7nc8
	 xDKJRbF9uyIIowvfGZDFmwcfFPOCB86GgJj9UpPTGFoSRCiwnECUFAzCsHj3lxSWL2
	 moEHOMBYVGEAxJaP3yueWHGQtRV5tXmKeWpaPvGSy+wky7b93d9tKUH+XD46yemn7j
	 pyQhxwOtBe5bIahgmBUueFgYPivEtvFNmsbWAb01ULEZ42hybf+6QElbiJC8AsnPi6
	 t6gIgn5IeKNp12ZLCHJEthAU8vf4KSrmuLxYvFJMRuUdWt/W/iNCLrDY6jfH441WO0
	 GJ5dD9YXslO+g==
Date: Wed, 31 May 2023 23:27:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 davthompson@nvidia.com, asmaa@nvidia.com, mkl@pengutronix.de,
 limings@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Message-ID: <20230531232721.4ee4a46f@kernel.org>
In-Reply-To: <20230601061908.1076-1-jiasheng@iscas.ac.cn>
References: <20230601061908.1076-1-jiasheng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Jun 2023 14:19:08 +0800 Jiasheng Jiang wrote:
> Add the check for the return value of the platform_get_irq and
> return error if it fails.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

BTW I looked thru my sent messages and I complained to you about not
CCing people at least twice before. Please start paying attention or
we'll stop paying attention to your patches.

