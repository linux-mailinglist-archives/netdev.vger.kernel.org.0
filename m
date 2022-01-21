Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7274960B3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350535AbiAUO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:27:05 -0500
Received: from asav22.altibox.net ([109.247.116.9]:32964 "EHLO
        asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381032AbiAUO0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:26:45 -0500
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id E680321080;
        Fri, 21 Jan 2022 15:26:41 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:8b0a:1e21:3a05:ad2e:f4a6])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 20LEQfS6137323
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 21 Jan 2022 15:26:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1642775201; bh=PBPG5wCwjmhlkp/d0m3QR81AmmLc7jVs9mBp8SFIIRw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=X+hO9L3LMpD9r0jlYJLKqKJeCxPea50xMABZY/UrYfMP2zOckfFyT8bvWOKucgW8l
         y7p9DKePp1Z3reEhjavrLhZ0U1LRqcSul7foz/jb7cNfROHCx9fyLjsQuNXnZIYZje
         A+MoZdKYNwHPOOhDABwDBlPq9JWuSzVc0VAXuda8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nAus8-0009TD-0S; Fri, 21 Jan 2022 15:26:36 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: rfkill: wwan does not show up in rfkill command
Organization: m
References: <CAOMZO5BJRVt7dG=76j8RZ63Wgr4eyZdZNPU5dz=1uG+PBQGyMw@mail.gmail.com>
Date:   Fri, 21 Jan 2022 15:26:35 +0100
In-Reply-To: <CAOMZO5BJRVt7dG=76j8RZ63Wgr4eyZdZNPU5dz=1uG+PBQGyMw@mail.gmail.com>
        (Fabio Estevam's message of "Fri, 21 Jan 2022 11:06:12 -0300")
Message-ID: <87lez9w4f8.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=f6Fm+t6M c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=DghFqjY3_ZEA:10 a=M51BFTxLslgA:10
        a=pGLkceISAAAA:8 a=XQfiQ5jn4EtLdwmV2-kA:9 a=QEXdDO2ut3YA:10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fabio Estevam <festevam@gmail.com> writes:

> Hi,
>
> I am running kernel 5.10.92 on an imx7d SoC.
>
> The wwan interface is brought up:
>
> usb 2-1: New USB device found, idVendor=3D2c7c, idProduct=3D0296, bcdDevi=
ce=3D 0.00
> usb 2-1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D4
> usb 2-1: Product: Qualcomm CDMA Technologies MSM
> usb 2-1: Manufacturer: Qualcomm, Incorporated
> usb 2-1: SerialNumber: 7d1563c1
> option 2-1:1.0: GSM modem (1-port) converter detected
> usb 2-1: GSM modem (1-port) converter now attached to ttyUSB0
> option 2-1:1.1: GSM modem (1-port) converter detected
> usb 2-1: GSM modem (1-port) converter now attached to ttyUSB1
> option 2-1:1.2: GSM modem (1-port) converter detected
> usb 2-1: GSM modem (1-port) converter now attached to ttyUSB2
> option 2-1:1.3: GSM modem (1-port) converter detected
> usb 2-1: GSM modem (1-port) converter now attached to ttyUSB3
> qmi_wwan 2-1:1.4: cdc-wdm0: USB WDM device
> qmi_wwan 2-1:1.4 wwan0: register 'qmi_wwan' at usb-ci_hdrc.1-1,
> WWAN/QMI device, 0e:31:86:6b:xx:xx
>
> When I run the rfkill command, only the Wifi interface shows up:
>
> root@CGW0000000:~# rfkill
> ID TYPE DEVICE      SOFT      HARD
>  0 wlan phy0   unblocked unblocked
>
> Shouldn't the wwan interface also be listed in the rfkill output?

This is a platform issue IMHO.  The externail W_DISABLE input is the
only meaningful rfkill device.  Controlling it is platform specific,
independent of the modem hardware.

Mapping W_DISABLE to an rfkill device is by typically done be drivers
like this ACPI driver in my Thinkpad:

root@miraculix:/tmp# rfkill
ID TYPE      DEVICE                   SOFT      HARD
 0 bluetooth tpacpi_bluetooth_sw unblocked unblocked
 1 wwan      tpacpi_wwan_sw      unblocked unblocked
 2 wlan      phy0                unblocked unblocked
 3 bluetooth hci0                unblocked unblocked


In theory we could have had an rfkill implementation in the wwan
subsystem too, similar to that redundant hci0 rfkill.  But I don't think
it's currently going to fly, given that the modem radio typically is
managed by multiple distinct drivers (tty, net, ++).

> Is there anything that needs to be done for wwan to appear there?
>
> Also, there is a GPIO that connects to the modem (W_DISABLE) pin, but
> it seems it is not possible currently to use rkfill gpio with device
> tree, right? I saw some previous attempts to add rfkill gpio support
> in devicetree, but none was accepted.

This I don't know anything about...  But it does sound like a good
solution for any platfrom using DT and a W_DISABLE GPIO.  Wonder why
that wasn't accepted?


Bj=C3=B8rn
