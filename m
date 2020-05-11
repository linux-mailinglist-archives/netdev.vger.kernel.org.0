Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3071CD666
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgEKKUo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 May 2020 06:20:44 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34435 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgEKKUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:20:43 -0400
Received: from [192.168.1.91] (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8258DCECE3;
        Mon, 11 May 2020 12:30:23 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: pull request: bluetooth-next 2020-05-09
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200509152445.262a84f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 11 May 2020 12:20:10 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BC8E9B93-8D4F-4983-9D97-8D19BF27736C@holtmann.org>
References: <20200509184928.GA26120@jhedberg-mac01.local>
 <20200509152445.262a84f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>> Here's another set of Bluetooth patches for the 5.8 kernel:
>> 
>> - Add support for Intel Typhoon Peak device (8087:0032)
>> - Add device tree bindings for Realtek RTL8723BS device
>> - Add device tree bindings for Qualcomm QCA9377 device
>> - Add support for experimental features configuration through mgmt
>> - Multiple fixes & cleanups to the btbcm driver
>> - Add support for LE scatternet topology for selected devices
>> - A few other smaller fixes & cleanups
>> 
>> Please let me know if there are any issues pulling. Thanks.
> 
> Is your tree immutable, is there a chance you could still get the missing sign-off?
> 
> Commit bf1f79470a62 ("Bluetooth: btusb: Add support for Intel Bluetooth Device Typhoon Peak (8087:0032)")
> 	author Signed-off-by missing
> 	author email:    raghuram.hegde@intel.com
> 	committer email: marcel@holtmann.org
> 	Signed-off-by: Amit K Bag <amit.k.bag@intel.com>
> 	Signed-off-by: Tumkur Narayan, Chethan <chethan.tumkur.narayan@intel.com>
> 	Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> 
> Also, in the same patch:
> 
> ---------------------------------------------------------------
> 0015-Bluetooth-btusb-Add-support-for-Intel-Bluetooth-Devi.patch
> ---------------------------------------------------------------
> ERROR: code indent should use tabs where possible
> #55: FILE: drivers/bluetooth/btusb.c:346:
> +                                                     BTUSB_WIDEBAND_SPEECH},$
> 
> WARNING: please, no spaces at the start of a line
> #55: FILE: drivers/bluetooth/btusb.c:346:
> +                                                     BTUSB_WIDEBAND_SPEECH},$
> 
> WARNING: Missing Signed-off-by: line by nominal patch author '"Hegde, Raghuram" <raghuram.hegde@intel.com>'
> 
> total: 1 errors, 2 warnings, 0 checks, 8 lines checked

I took this patch out. They should fix it up and re-submit it.

> 
> 
> And:
> 
> ------------------------------------------------------------
> 0016-dt-bindings-net-bluetooth-Add-rtl8723bs-bluetooth.patch
> ------------------------------------------------------------
> WARNING: DT binding documents should be licensed (GPL-2.0-only OR BSD-2-Clause)
> #23: FILE: Documentation/devicetree/bindings/net/realtek-bluetooth.yaml:1:
> +# SPDX-License-Identifier: GPL-2.0
> 
> total: 0 errors, 2 warnings, 0 checks, 54 lines checked

I try to get this fixed, but it might have to come in a subsequent pull request.

> 
> ---------------------------------------------------------------
> 0026-Bluetooth-Introduce-debug-feature-when-dynamic-debug.patch
> ---------------------------------------------------------------
> WARNING: Prefer [subsystem eg: netdev]_dbg([subsystem]dev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #99: FILE: net/bluetooth/lib.c:212:
> +	printk(KERN_DEBUG pr_fmt("%pV"), &vaf);

This one is on purpose and has to be printk.

> WARNING: Missing a blank line after declarations
> #135: FILE: net/bluetooth/mgmt.c:3740:
> +		u32 flags = bt_dbg_get() ? BIT(0) : 0;
> +		memcpy(rp->features[idx].uuid, debug_uuid, 16);
> 
> WARNING: Missing a blank line after declarations
> #173: FILE: net/bluetooth/mgmt.c:3788:
> +			bool changed = bt_dbg_get();
> +			bt_dbg_set(false);

These two were on purpose, but while at it, I fixed them up.

> WARNING: 'Paramters' may be misspelled - perhaps 'Parameters'?
> #197: FILE: net/bluetooth/mgmt.c:3812:
> +		/* Paramters are limited to a single octet */

This was a dumb spelling mistake and I fixed it up.

Thanks for checking everything. I think Johan will just send a new pull request.

Regards

Marcel

