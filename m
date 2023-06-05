Return-Path: <netdev+bounces-8224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FDF72327D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F688281446
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933D027706;
	Mon,  5 Jun 2023 21:46:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CAABE59
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0457C433EF;
	Mon,  5 Jun 2023 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686001566;
	bh=ruKKekv1mdzJIBzHaypDGjsbXQi+hjq8aqAGGuaFVig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qgxShDrPLicbM0MFZ4ctiQMuSPZKVpELfH/YxjpY5/btRZk2iL0qaUwmsHqLcSJpT
	 vUqSB6NzG3iwMCse67Pb0DSAJaRHN2JZhtdrqRBezKq6orcBv9+iNAjPiiEGgxwTAr
	 4oFe1S01/UZSWYznxzxWw2R2cbhl1WZ4wqpxgru6ksqi1POHqrRwVeWgtbTY52XFIE
	 7TnObDDinm/TMiI66TzmO+2TsjO1i3XH0JC/Ng3u+WqIBSpDiLFUqhjT/u+ZIb36J/
	 d/FvMMRqp3AfQHRCllOa34JteynsSs4wPMW+PqGLwiGOxRJgSJZcNfhYzzOtV3y2HJ
	 GpsKckCUUXpQw==
Date: Mon, 5 Jun 2023 14:46:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, Heiner
 Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: net: phy: realtek: Support external PHY clock
Message-ID: <20230605144605.63d43396@kernel.org>
In-Reply-To: <20230605144501.31f49920@kernel.org>
References: <20230605151953.48539-1-detlev.casanova@collabora.com>
	<20230605144501.31f49920@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 14:45:01 -0700 Jakub Kicinski wrote:
> On Mon,  5 Jun 2023 11:19:50 -0400 Detlev Casanova wrote:
> > Some PHYs can use an external clock that must be enabled before
> > communicating with them.  
> 
> Please add a [PATCH v4 0/0] prefix to the subject of the cover letter
> (or use --cover-letter with git format-patch to generate the template).
> Otherwise patchwork doesn't realize this is a cover letter.

And so it didn't realize you already sent a v4...
FWIW we ask people not to repost within 24h, confuses reviewers.

