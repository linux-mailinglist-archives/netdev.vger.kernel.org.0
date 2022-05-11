Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B35234F4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbiEKODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239915AbiEKODb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:03:31 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBDA6222A;
        Wed, 11 May 2022 07:03:25 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 24BE2s8Q339080
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 15:02:56 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9d:7e02:9be5:c549:1a72:4709])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 24BE2mkY1776500
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 16:02:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1652277769; bh=DHWph95rimkwGjzf97VFn8lFh4hE7zrtoxEu4vReoe0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=BBzpCAY9guLewJjoSiJcAJIlQFnkS63/PJ7y9EogVY0fa5Xcw5OFNB7VsgvboMcRP
         21IRRZKzYjuYNMx10pHLaFN/KMyrAeYdHkkkMWbQ/Tjpy00kGEnvMYS8g/uz5iLU4H
         WvTIh5Uu9PKj9E8dQTUlozOa3kOI0vfA2oCMgID0=
Received: (nullmailer pid 343687 invoked by uid 1000);
        Wed, 11 May 2022 14:02:48 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     David Ober <dober6023@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        mpearson@lenovo.com, dober@lenovo.com
Subject: Re: [PATCH v2] net: usb: r8152: Add in new Devices that are
 supported for Mac-Passthru
Organization: m
References: <20220511133926.246464-1-dober6023@gmail.com>
Date:   Wed, 11 May 2022 16:02:48 +0200
In-Reply-To: <20220511133926.246464-1-dober6023@gmail.com> (David Ober's
        message of "Wed, 11 May 2022 09:39:26 -0400")
Message-ID: <874k1wdv5j.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ober <dober6023@gmail.com> writes:

> Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the origi=
nal
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
> index c2da3438387c..c32b9bf90baa 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -771,6 +771,9 @@ enum rtl8152_flags {
>  };
>=20=20
>  #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> +#define DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1	0x8153


We used to have a macro named PRODUCT_ID_RTL8153 for this magic number,
but it was removed in 2014:

commit 662412d14bfa6a672626e4470cab73b75c8b42f0
Author: hayeswang <hayeswang@realtek.com>
Date:   Thu Nov 6 12:47:40 2014 +0800

    r8152: remove the definitions of the PID
=20=20=20=20
    The PIDs are only used in the id table, so the definitions are
    unnacessary. Remove them wouldn't have confusion.
=20=20=20=20
    Signed-off-by: Hayes Wang <hayeswang@realtek.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cf1b8a7a4c77..66b139a8b6ca 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -461,11 +461,7 @@ enum rtl8152_flags {
=20
 /* Define these values to match your device */
 #define VENDOR_ID_REALTEK              0x0bda
-#define PRODUCT_ID_RTL8152             0x8152
-#define PRODUCT_ID_RTL8153             0x8153
-
 #define VENDOR_ID_SAMSUNG              0x04e8
-#define PRODUCT_ID_SAMSUNG             0xa101
=20
 #define MCU_TYPE_PLA                   0x0100
 #define MCU_TYPE_USB                   0x0000
@@ -3898,9 +3894,9 @@ static void rtl8152_disconnect(struct usb_interface *=
intf)
=20
 /* table of devices that work with this driver */
 static struct usb_device_id rtl8152_table[] =3D {
-       {USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8152)},
-       {USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8153)},
-       {USB_DEVICE(VENDOR_ID_SAMSUNG, PRODUCT_ID_SAMSUNG)},
+       {USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
+       {USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
+       {USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
        {}
 };
=20


Re-introducing it as  DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1 is
confusing/obfuscating in several ways:

 - the same value is now used two places in the driver, but only one of
   those places use the macro
=20=20
 - the name indicates that this is somehow unique to a specific Thinkpad
   product, which it obviously isn't.  It's one of the most common
   device IDs for ethernet USB dongles at the moment, used by any number
   of vendors

 - the attempt to treat these devices differently based on the parent
   vendor will cause confusion for anyone connecting any of these
   dongles to a Lenovo hub.  This will match so much more than one
   specific dock product


I beleive I've said this before, but these policies would have been much
better handled in userspace with the system mac address being a resource
made available by some acpi driver. But whatever.  I look forward to
seeing the FCC unlock logic for Lenovo X55 modems added to the
drivers/bus/mhi/host/pci_generic.c driver.

=20=20
Bj=C3=B8rn
