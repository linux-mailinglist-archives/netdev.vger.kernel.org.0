Return-Path: <netdev+bounces-2856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 521377044B0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D549281510
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB2419E7F;
	Tue, 16 May 2023 05:24:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44331DDE3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FC7C43445;
	Tue, 16 May 2023 05:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684214658;
	bh=gBxrbeA0HTMoQOLh6X+GckvCVzQtgJYUiWcNxiQiCHU=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=GuF1zdvGzQQ6btF1/5DP6jjkyJ98+KzWJWyoLtzMdyXWz00Zq3kmFC1f8u9xEFBwF
	 B26rdTLPlJWdKNkijw+AA8PlaffcqpfBP3Wuv9gOBTdfx0L6TC7fX+IhO26ZsPjU/Z
	 wWiVkUJrQdNbvVorlFB1pmucYUBUZ7hjGomWSgJhc2kQ6hnHspMMu0IIEvVjY7PCyl
	 PdDJWoIr2w0Oj42nTLiSkJZ3QYfdDBNqs7krz3M/HO8/AyNDftFdZYaVawNJTJUkqN
	 VuIhlWo2O9JXH7XC3W8I7dvtf2bqEb8WSODAoKZ3kFqnT+MeGN1AgEi6n9SSko92ZS
	 JsGYs7jpmU1Ag==
From: Kalle Valo <kvalo@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Jakub Kicinski <kuba@kernel.org>,  "David S. Miller" <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Matthias Brugger <matthias.bgg@gmail.com>,  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,  linux-wireless@vger.kernel.org,  netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,  linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt7601u: update firmware path
References: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
Date: Tue, 16 May 2023 08:24:12 +0300
In-Reply-To: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
	(Daniel Golle's message of "Tue, 16 May 2023 00:56:53 +0200")
Message-ID: <87o7mkn91f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Daniel Golle <daniel@makrotopia.org> writes:

> mt7601u.bin was moved to mediatek/ folder in linux-wireless via commit
> 8451c2b1 ("mt76xx: Move the old Mediatek WiFi firmware to mediatek")
> and linux-firmware release 20230515.

Why was it moved?

> --- a/drivers/net/wireless/mediatek/mt7601u/usb.h
> +++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
> @@ -8,7 +8,7 @@
>  
>  #include "mt7601u.h"
>  
> -#define MT7601U_FIRMWARE	"mt7601u.bin"
> +#define MT7601U_FIRMWARE	"mediatek/mt7601u.bin"

How do we handle backwards compatibility? We have a rule that old
userspace needs to work with new kernel and this change breaks that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

