Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B845F30E4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388987AbfKGOJv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 09:09:51 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59971 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKGOJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:09:50 -0500
Received: from marcel-macpro.fritz.box (p5B3D2BA4.dip0.t-ipconnect.de [91.61.43.164])
        by mail.holtmann.org (Postfix) with ESMTPSA id 98E93CED08;
        Thu,  7 Nov 2019 15:18:52 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH 4/4] dt-bindings: net: bluetooth: update
 broadcom-bluetooth
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191106002923.109344-5-abhishekpandit@chromium.org>
Date:   Thu, 7 Nov 2019 15:09:48 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4AE3BBFC-DE79-478F-A9EE-A2243C30FA6E@holtmann.org>
References: <20191106002923.109344-1-abhishekpandit@chromium.org>
 <20191106002923.109344-5-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Add documentation for pcm-parameters.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> ---
> 
> Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> index c749dc297624..ae60277b5569 100644
> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> @@ -29,6 +29,9 @@ Optional properties:
>    - "lpo": external low power 32.768 kHz clock
>  - vbat-supply: phandle to regulator supply for VBAT
>  - vddio-supply: phandle to regulator supply for VDDIO
> + - pcm-parameters: When set, will configure PCM parameters on the device. The
> +   contents should be a 10-byte array corresponding to the pcm params (see
> +   btbcm.h for more information).
> 
> 
> Example:
> @@ -40,5 +43,6 @@ Example:
>        bluetooth {
>                compatible = "brcm,bcm43438-bt";
>                max-speed = <921600>;
> +               pcm-parameters = [1 2 0 1 1 0 0 0 0 0];
>        };
> };

I think about 1-2 years there have been a discussion on how to represent these values in a DT. I prefer we split these into separate values so it becomes usable by other drivers / vendors as well. In addition, maybe we start to focus on the values that differ from the default.

Regards

Marcel

