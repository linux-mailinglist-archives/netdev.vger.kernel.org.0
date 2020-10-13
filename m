Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DE28D27C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgJMQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:44:09 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:22333 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgJMQoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 12:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602607447;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=OZ7zYsDouacPwyCPa7aXDDiin8TYVeABf/NDLjhE2OE=;
        b=UO7ETVwGQgs2XHeWh7ulHKxSdUcZp5ji1ROY+qPMEaOvVrjb3yAlZhzqhuKXsjCyH5
        rVKUanIA2EDena2hsjBSO3xDWxXIamLP3OWByPXjf7mqzVH9IlHeQ8/LKswKSgj3Y0yZ
        BGV1HulF/Vzn5TgF3ljabl3A70EW/dTQMylbuAdd4TSN7WxuA3WRVI7xWa0AG0a4BGMA
        cWhcKmdhPPurQI0uXGBPmRPpy2Mbuf+xzhxWgIIQVadcx8NXSK2jEKUB5u+lIP6N0cSh
        UaVy8+gsi2RZyBwSvzLSDXDhm2BRlXRAfYN5z6qMXCrjIhM6HB2LKI6p1TSDPjIAp9fO
        04fw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVch5mEtI"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9DGhuTiE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 13 Oct 2020 18:43:56 +0200 (CEST)
Subject: Re: [PATCH] can: Explain PDU in CAN_ISOTP help text
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201013141341.28487-1-geert+renesas@glider.be>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <8e7bface-eef3-c5eb-a822-aec79c6992ac@hartkopp.net>
Date:   Tue, 13 Oct 2020 18:43:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201013141341.28487-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.10.20 16:13, Geert Uytterhoeven wrote:
> The help text for the CAN_ISOTP config symbol uses the acronym "PDU".
> However, this acronym is not explained here, nor in
> Documentation/networking/can.rst.
> Expand the acronym to make it easier for users to decide if they need to
> enable the CAN_ISOTP option or not.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Yes, when you are so deep into it that PDU becomes a word like dog or 
cat ;-)

Thanks,
Oliver

> ---
>   net/can/Kconfig | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/Kconfig b/net/can/Kconfig
> index 224e5e0283a986d9..7c9958df91d353c8 100644
> --- a/net/can/Kconfig
> +++ b/net/can/Kconfig
> @@ -62,8 +62,9 @@ config CAN_ISOTP
>   	  communication between CAN nodes via two defined CAN Identifiers.
>   	  As CAN frames can only transport a small amount of data bytes
>   	  (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
> -	  segmentation is needed to transport longer PDUs as needed e.g. for
> -	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
> +	  segmentation is needed to transport longer Protocol Data Units (PDU)
> +	  as needed e.g. for vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN
> +	  traffic.
>   	  This protocol driver implements data transfers according to
>   	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
>   	  If you want to perform automotive vehicle diagnostic services (UDS),
> 
