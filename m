Return-Path: <netdev+bounces-3170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A0C705DBF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD944280D49
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CAC17ED;
	Wed, 17 May 2023 03:10:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490417E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06150C433D2;
	Wed, 17 May 2023 03:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684293002;
	bh=CvgKMPZQolVfURyUe01p1pbE6VTWA4kAeN43nJikG/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OHX/f4RBRpR3oy+7N7fFsxyvDaRurBylxoSDfwLuGU4hPIbBLCRvRWpzRKsbPUC98
	 5218G5vbpvK0Dn9rt61WJ8NlmcdgD9vjO1AnAcCcp88qbOUxSik6MFvAnJDBNs2nTU
	 NOGklEn1oqLpcVRBhF/vtPJOh4V9l+yBTLTjTxSGFkghoXT7E8jKiX1XVB++V+6JK5
	 w7u9t8uPdotDydWqRS23huvPMbcQLJ6NF+OsZdhacHXlWT1ubr0gl8QTqhwSHIGTzV
	 5zmSNa50rjkj/M42gWdRFr7HfVrKp16ameaTFLIXQR98OlzX2YkCYkfQPAo3eanpui
	 gDnEqEk1hl1Yw==
Date: Tue, 16 May 2023 20:10:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Andrew Lunn
 <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof
 Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
 <conor+dt@kernel.org>, netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document
 spi-cpol/cpha
Message-ID: <20230516201000.49216ca0@kernel.org>
In-Reply-To: <20230515105035.kzmygf2ru2jhusek@skbuf>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
	<20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
	<20230515105035.kzmygf2ru2jhusek@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 May 2023 13:50:35 +0300 Vladimir Oltean wrote:
> On Mon, May 15, 2023 at 09:45:25AM +0200, Krzysztof Kozlowski wrote:
> > Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
> > SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:
> > 
> >   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> > 
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Is my instinct that this should go to net-next correct?

