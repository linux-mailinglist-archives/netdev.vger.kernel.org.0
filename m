Return-Path: <netdev+bounces-9454-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16F872938C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53397281869
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C6F15C0;
	Fri,  9 Jun 2023 08:44:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDECEC2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93581C433EF;
	Fri,  9 Jun 2023 08:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686300276;
	bh=fFg6lMT5mgwssaYJox1k1cSODMd/5lzp5Ui9INcyiGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GOZdA82RS/srAniBwd31OCkmegD8K4/Afuv4HANTdRxNRNDH0cGna5Gi+/C/iUmtt
	 WwPfWziyFPQDQfo4zqk7cVRmyssVoB7QV0tBQ4jcghYaAE8JINQsFTab2S8Y1S1Ktv
	 OJDY3+Eb7A4D6tSH/lwlQ6NnfaSHAfrxqmR0CVDEB478jtkZvwTLiAC9Ljr4XXVcHh
	 o2AFpmuproAMrPcof3TVXq4GreIeVvsPoYSMr8rhPsKaXWk/NXVEG9b8y641fjH3Q4
	 aowT1H8DvT9t24ec6F6rjvokRe6BFAF5Fftw+RWZAi3kGBqpFJh3OBoQQag4Kfa2M/
	 vz29kB9zB0sRQ==
Date: Fri, 9 Jun 2023 10:44:31 +0200
From: Simon Horman <horms@kernel.org>
To: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Michael Walle <michael@walle.cc>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] nfc: store __be16 value in __be16 variable
Message-ID: <ZILmb79W+yz1PMal@kernel.org>
References: <20230608-nxp-nci-be16-v1-1-24a17345b27a@kernel.org>
 <CAH-L+nNeyy4WZ4MobwGnXGwpeFump9wX43NmNfwei+pGvuuY1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH-L+nNeyy4WZ4MobwGnXGwpeFump9wX43NmNfwei+pGvuuY1A@mail.gmail.com>

On Fri, Jun 09, 2023 at 09:53:16AM +0530, Kalesh Anakkur Purayil wrote:
> On Thu, Jun 8, 2023 at 4:52 PM Simon Horman <horms@kernel.org> wrote:
> 
> > Use a __be16 variable to store the store the big endian value of header
> >
> [Kalesh]: Minor nit, looks like a typo as "store the" is repeating.

Thanks,

of course you are right.
I'll address this in a v2.

-- 
pw-bot: cr



