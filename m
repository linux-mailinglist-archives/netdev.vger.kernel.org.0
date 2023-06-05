Return-Path: <netdev+bounces-7988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F8872260C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E80131C20B9F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E846FA4;
	Mon,  5 Jun 2023 12:37:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5723F525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:37:31 +0000 (UTC)
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F3D11B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:37:10 -0700 (PDT)
Received: from proxmox-mailgw.intranet.prolan.hu (localhost.localdomain [127.0.0.1])
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTP id 3FDB3A00D2;
	Mon,  5 Jun 2023 14:37:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prolan.hu; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=mail; bh=C92QP0B4k7vpHBCwXp37
	/kc5FcgcF0jUV0UCKWEzhqg=; b=gDBeed29lNRXAlNHgR2QYsPh9DrnukcW94cj
	lzGu6j46vqoK1EkuQLuFfe7YcZMRMvTWVve6MSQVLeKwu9D9fBIxgM+8jkUYucJL
	NvhydzNYR1nk6shlVKOmerFFUZrmSTeyiJ0QRQ2SV+nleQZ9aRI3u5qMRwaGNcsz
	iDqQVoraIRMHCKeH3nFBpWRnhTmMn672c0/iI6jDIA7gPr53ntACI6NZIx95f4fO
	essu8d8HK0Kv0i9kGUwCjcx6CUiMElGlxQyySSxbo8LES3qQ/UDbWXvTIcLooHLY
	fwJmXpTQfP19FyveRp3dvQDX9R3rZ3o+91OMj5ZByR6l9MouJxh2oXCiLHbs18Ee
	WxMAHZd6lYaxD0QhGi7QiH7tZdc5r3OMXTJTaP5PjorgeWFlXBRPYLZ63QWOVwfm
	Z3z36woq4I7985gQiaXniHmcMf68qVRPav+BJLp564/y6Q9lEYO9ZNM6KtRu2JN+
	fnsXFDPKSLoq11Y304d+QFUuQPY2MNYkVaTj1+AokAyHD8QkrEM3SdNakWRgdUyK
	SqmO++Pum6du2AY8AjLKZBa9MHtZmBfzjFyCP2GxzWAg8ctUrm7fqKMZGc4/p+ot
	xIgkS/zCzH5rGwTjgkg33SbrFzpHxKpqoFYnCsfCxti73QqG7EKxegpNnDWt7O8o
	QJJRFDE=
Message-ID: <e67321c3-2a81-170a-0394-bdb00beb7182@prolan.hu>
Date: Mon, 5 Jun 2023 14:35:33 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Content-Language: en-US
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>, Richard Cochran
	<richardcochran@gmail.com>, <kernel@pengutronix.de>, Jakub Kicinski
	<kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
References: <20230605094402.85071-1-csokas.bence@prolan.hu>
 <20230605-surfboard-implosive-d1700e274b20-mkl@pengutronix.de>
From: =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20230605-surfboard-implosive-d1700e274b20-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29B0A0C25462716B
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023. 06. 05. 11:51, Marc Kleine-Budde wrote:
> On 05.06.2023 11:44:03, Csókás Bence wrote:
>> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> 
> You probably want to add a patch description.

Is it necessary for such a trivial refactor commit? I thought the commit 
msg already said it all. What else do you think I should include still?


Would something like this be sufficient?
"Rename local `struct fec_enet_private *adapter` to `fep` in 
`fec_ptp_gettime()` to match the rest of the driver"

> 
> regards,
> Marc
> 

Thanks,
Bence


