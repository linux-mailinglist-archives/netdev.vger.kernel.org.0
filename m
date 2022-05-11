Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A37523197
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiEKL26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiEKL24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:28:56 -0400
Received: from mxout01.lancloud.ru (mxout01.lancloud.ru [45.84.86.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D211CFF3;
        Wed, 11 May 2022 04:28:50 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 53A1F20CDA45
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] Additions to the list of devices that can be used for
 Lenovo Pass-thru feature
To:     David Ober <dober6023@gmail.com>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <aaron.ma@canonical.com>
CC:     <mpearson@lenovo.com>, <dober@lenovo.com>
References: <20220511093826.245118-1-dober6023@gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <472e0ce0-b18a-c2b7-f7d2-288993962f45@omp.ru>
Date:   Wed, 11 May 2022 14:28:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220511093826.245118-1-dober6023@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/11/22 12:38 PM, David Ober wrote:

> net: usb: r8152: Add in new Devices that are supported for Mac-Passthru

   This should be in the subject.

> Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the original
> Realtek USB ethernet Vendor and Product IDs
> If the Network device is Realtek verify that it is on a Lenovo USB hub
> before enabling the passthru feature
> 
> This also adds in the device IDs for the Lenovo USB Dongle and one other
> USB-C dock
> 
> Signed-off-by: David Ober <dober6023@gmail.com>
> ---
>  drivers/net/usb/r8152.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c2da3438387c..7d43c772b85d 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> @@ -9644,10 +9647,19 @@ static int rtl8152_probe(struct usb_interface *intf,
>  
>  	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
>  		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> +		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
> +		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
>  		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
>  		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
>  			tp->lenovo_macpassthru = 1;
>  		}
> +        }

   Indent with tabs please.

> +	else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&

   The preceding } should be on the same line.

> +                 (le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {

   Indent with tabs please.

[...]

MBR, Sergey
