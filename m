Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529A83A0E4
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFHRge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 13:36:34 -0400
Received: from first.geanix.com ([116.203.34.67]:34268 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfFHRge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 13:36:34 -0400
Received: from [192.168.100.94] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id B2FB61384;
        Sat,  8 Jun 2019 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1560015263; bh=mNDoHCkSun3d06zVPINHndHBS2P/YpVpsE58jkB97uI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=KDVrfnj6Q2/3X4WHeL7nexlV1oU9MaxK3Q1Q2sKUHBg/oZ1PlD7FHaO+L39oaV2jC
         WZDNuRRQnn90rqwl1vQscJsQrXcHf2kU8/CrNWauypXMFMncznDENlddkEt42uI25Y
         tPCVmo/gh/ele1/afR/AyNT9zspH2kNTphGRXfY3Wu5O2Tj2iQ9AfV/hEu2N5nTcCi
         frbQNHRWqLYLjj5k7tSHkYQm6isB1KeWCXgW1Mm7eyk4eL6uae0ZjKIUNtfEg7/T3F
         ARqc7uYTL6tOB2Jkdfwc+OzbiUNQw+JcIhHS+aKxex03IuV66ix5krgofBCI98Bclw
         lRMTd/M3jRz9w==
Subject: Re: [PATCH 1/2] can: flexcan: add support for DT property
 'wakeup-source'
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        mkl@pengutronix.de, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, aisheng.dong@nxp.com,
        qiangqing.zhang@nxp.com
References: <20190409083949.27917-1-sean@geanix.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <61ce24fa-34ca-326a-dcd2-75d2783c43c8@geanix.com>
Date:   Sat, 8 Jun 2019 19:36:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190409083949.27917-1-sean@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kind ping :-)

On 09/04/2019 10.39, Sean Nyekjaer wrote:
> The flexcan controller can be forced as a wakeup source by
> stating that explicitly in the device's .dts file using the
> "wakeup-source" boolean property.
> 
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> ---
>   drivers/net/can/flexcan.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index c46e6ce22701..df3d2abd98e4 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1373,6 +1373,9 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
>   
>   	device_set_wakeup_capable(&pdev->dev, true);
>   
> +	if (of_property_read_bool(np, "wakeup-source"))
> +		device_set_wakeup_enable(&pdev->dev, true);
> +
>   	return 0;
>   }
>   
> 
