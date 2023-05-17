Return-Path: <netdev+bounces-3380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C6EC706C25
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A06A2816E6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B62F5CB0;
	Wed, 17 May 2023 15:06:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0269E524E
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D895C433D2;
	Wed, 17 May 2023 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684335985;
	bh=uj3yY1AQxYZ5vT1NpUTbFozGPyly3ykjZNUb52/KP+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TB0P7qc7sqyKrutmMUYIP9Aryjc6+VsVHC5s/C8RCzKNIma73U9n6kIJX6vn8Q/+D
	 13wWhU9FrBZBi/uq/FNfUJP5NKdDCp/a/YhyDCS39U8VVEFxOeird1HkAqAKfnnnv/
	 wKEmyocF4G19gelpmZAeSIrfdJAKKzXgmkJbtPiYjebeH1NH1guklKHoaj/XEhytet
	 v2xao5IngygO7BCpJqhDUDIe7TgCu0bf+9/wFbuPXPChWUf4RrQBftA96Z1mQSQDyV
	 yZU1ud73567zxvHRXP++zc9lU0BvkaQqw6sX6HxCHPF/4BJmedLoZnmPquDCMs5p54
	 uiop1DizSRCzQ==
Date: Wed, 17 May 2023 08:06:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document
 spi-cpol/cpha
Message-ID: <20230517080624.672d52a2@kernel.org>
In-Reply-To: <50cc1727-999f-9b7a-ef09-14461fa4ddfb@linaro.org>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
	<20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
	<20230515105035.kzmygf2ru2jhusek@skbuf>
	<20230516201000.49216ca0@kernel.org>
	<50cc1727-999f-9b7a-ef09-14461fa4ddfb@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 10:26:38 +0200 Krzysztof Kozlowski wrote:
> On 17/05/2023 05:10, Jakub Kicinski wrote:
> > On Mon, 15 May 2023 13:50:35 +0300 Vladimir Oltean wrote:  
> >> On Mon, May 15, 2023 at 09:45:25AM +0200, Krzysztof Kozlowski wrote:  
>  [...]  
> >>
> >> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> > 
> > Is my instinct that this should go to net-next correct?  
> 
> It would be great missing net-next was pointed out by checkpatch.pl.

FWIW, I'd have taken the patch as is. There isn't much the current
build tester can do for dt-bindings, anyway. But thanks for the resend
:)

I was wondering about checkpatch, too, but haven't come up with any
great solution. The problem is kind of at an intersection of checkpatch
and get_maintainer.

