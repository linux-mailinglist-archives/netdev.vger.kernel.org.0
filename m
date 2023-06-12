Return-Path: <netdev+bounces-10130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A778B72C6D6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB282281106
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73F719E54;
	Mon, 12 Jun 2023 14:03:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746FD18AF3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E364EC433D2;
	Mon, 12 Jun 2023 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686578619;
	bh=m2x4W7kPo9/C2W8ESj9pCncyc9QUnweaZx9AdOT6u7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sWM8rh3aFqAyJET1RR/9mSGir5kUAyhAo9xVP7ZvKTbprGEwtXaX0YOPJj5+urCii
	 A8XjvKh7l+dX/pcOa0Qsb0NLAggXzMWc24gM7p07DEO2ECrFMrNqTlBVvBDW/ig7fN
	 wrAALs8oY0DfUT5kUvwHICmUks2OtI7wEj6cgNY6ulKCxb1kqfnIxkchCUVDobSiaF
	 FGe7bDKleGkFC+0JZSBNIAjyvU3Rk1lIxEl4z8Ui1h9y8zujL+6brNs3v8gEQ1PrcK
	 jNsvxuz+wav7Pf86E2X2n7QNAr7Lnx/ONP3XktUCdDRyzXvwrnGCP6qsYF4/KNnpBt
	 4h2rr1iNwDBeg==
Message-ID: <a166c00d-d759-b905-5bfc-db61f58b7663@kernel.org>
Date: Mon, 12 Jun 2023 17:03:33 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Call of_node_put() on
 error path
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
From: Roger Quadros <rogerq@kernel.org>
In-Reply-To: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/06/2023 10:18, Dan Carpenter wrote:
> This code returns directly but it should instead call of_node_put()
> to drop some reference counts.
> 
> Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Roger Quadros <rogerq@kernel.org>

