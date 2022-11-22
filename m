Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2A7633731
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 09:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiKVIb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 03:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiKVIbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 03:31:35 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B3C41988;
        Tue, 22 Nov 2022 00:31:22 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aee3b.dynamic.kabel-deutschland.de [95.90.238.59])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0E50161EA1932;
        Tue, 22 Nov 2022 09:31:20 +0100 (CET)
Message-ID: <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
Date:   Tue, 22 Nov 2022 09:31:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH -next] Bluetooth: Fix Kconfig warning for BT_HIDP
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jkosina@suse.cz, gregkh@linuxfoundation.org,
        benjamin.tissoires@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221122034246.24408-1-yuehaibing@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221122034246.24408-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear YueHaibing,


Thank you for your patch.


Am 22.11.22 um 04:42 schrieb YueHaibing:

Maybe use the more specific summary below:

Bluetooth: Add HID_SUPPORT dependency for BT_HIDP

> commit 25621bcc8976 add HID_SUPPORT, and HID depends on it now.

add*s*

or

Commit 25621bcc8976 ("HID: Kconfig: split HID support and hid-core 
compilation") introduces the new Kconfig symbol HID_SUPPORT …


Kind regards,

Paul


> Add HID_SUPPORT dependency for BT_HIDP to fix the warning:
> 
> WARNING: unmet direct dependencies detected for HID
>    Depends on [n]: HID_SUPPORT [=n]
>    Selected by [m]:
>    - BT_HIDP [=m] && NET [=y] && BT_BREDR [=y] && INPUT [=m]
> 
> Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   net/bluetooth/hidp/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
> index 14100f341f33..6746be07e222 100644
> --- a/net/bluetooth/hidp/Kconfig
> +++ b/net/bluetooth/hidp/Kconfig
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   config BT_HIDP
>   	tristate "HIDP protocol support"
> -	depends on BT_BREDR && INPUT
> +	depends on BT_BREDR && INPUT && HID_SUPPORT
>   	select HID
>   	help
>   	  HIDP (Human Interface Device Protocol) is a transport layer
