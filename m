Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B8CEBD3
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfJGS3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:29:55 -0400
Received: from mx.0dd.nl ([5.2.79.48]:58318 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbfJGS3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 14:29:55 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 5F2975FBBE;
        Mon,  7 Oct 2019 20:29:51 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="gB6StrYQ";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 103F33BDFA;
        Mon,  7 Oct 2019 20:29:51 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 103F33BDFA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570472991;
        bh=PJRj7CNzltxsgCzgkYQhlPJcmHFIWoaKnYaHjEpLLi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gB6StrYQNgVdqp0Wvh6BgRF67o63rl9KVghZwNF9rt+P5skb0TrlBjzDbNoU7sp2L
         N8cslb82wxENmE1kJiR1XMHcNDoRKcmRns4k9r2J1YlhZuru7SpxgKCteHwwPiTlTp
         ZlVvxvwWytQf3Cg4EZap6E4lgXeS2S7LenS0p4Ib1Ue+cBQhUBStBtORIH4Bkjw8s5
         OxHW0tzHwEPILuD1hIu9FIVWS0CWIF7/dLaZjiYwy54nhKLMIGW2JtQbUuRDRs6AOT
         7+mYpM4uugfhs/gewc4uMheLEbDr8zDfobM9KWoIb6vbjZgF0Yd/59ErEcDnTt7G2L
         Kyw9Mebp0COig==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 07 Oct 2019 18:29:51 +0000
Date:   Mon, 07 Oct 2019 18:29:51 +0000
Message-ID: <20191007182951.Horde.3g45LJ1CPqFA0OM9CNZND4A@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net,v2 1/2] net: ethernet: mediatek: Fix MT7629 missing
 GMII mode support
References: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
 <20191007070844.14212-2-Mark-MC.Lee@mediatek.com>
In-Reply-To: <20191007070844.14212-2-Mark-MC.Lee@mediatek.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting MarkLee <Mark-MC.Lee@mediatek.com>:

> Add missing configuration for mt7629 gmii mode support
>
> Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
> Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
> --
> v1->v2:
> * no change
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index c61069340f4f..703adb96429e 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -261,6 +261,7 @@ static void mtk_mac_config(struct phylink_config  
> *config, unsigned int mode,
>  		ge_mode = 0;
>  		switch (state->interface) {
>  		case PHY_INTERFACE_MODE_MII:
> +		case PHY_INTERFACE_MODE_GMII:
>  			ge_mode = 1;
>  			break;
>  		case PHY_INTERFACE_MODE_REVMII:
> --
> 2.17.1

Reviewed-by: René van Dorst <opensource@vdorst.com>

