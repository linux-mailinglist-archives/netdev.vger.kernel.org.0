Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F30A4DCF16
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiCQT6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiCQT6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:58:30 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BEC273808
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647547023;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Cc:To:Subject:From:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=0kHIYtNRyfc63kuFEWIsqQh0ypHZqcGdcH+UyuiJeAs=;
    b=oUpuHYu6KUyjk7GTCVPrpvPWVhvZku2T5GztWn4cNjALuIr2vJdGv4+rMKhezVV7Ox
    DlapIvoa2IJ5jMayg3Daw1ridqwB2FyU4veGbrJ9eM2Lp6lYunsvHcdm6led9n53ij4B
    OA4M8jzmYkejOm1vtbR6lRN5vTNy9eNCjPLvnNjwuP7S8QHZEyRzthejZ9e818rP9/5V
    2EOmPAmeIxATcp+l9JFToFToE1x3TPOIVJQQy+TyRLmcWlxzisXpg+bTAtjihskkGkTd
    aYmcbJV2xeLewWMXEG7oBzg8UpArFKU1lB4N4Y74EwW46QyyEjwhcTwEhZW0UG2h7EPG
    Eh7Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2HJv33fx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 17 Mar 2022 20:57:03 +0100 (CET)
Message-ID: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
Date:   Thu, 17 Mar 2022 20:56:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Subject: net-next: regression: patch "iwlwifi: acpi: move ppag code from mvm
 to fw/acpi" (e8e10a37c51c) breaks wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Matt Chen <matt.chen@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

the patch "iwlwifi: acpi: move ppag code from mvm to fw/acpi" (net-next 
commit e8e10a37c51c) breaks the wifi on my HP Elitebook 840 G5.

I detected the problem when working on the latest net-next tree and the 
wifi was fine until this patch.

Please let me know if you need support for testing.

Regards,
Oliver

[    0.000000] Linux version 5.17.0-rc3-nn-01325-ge8e10a37c51c (xxx) 
(gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 
2.35.2) #15 SMP PREEMPT Thu Mar 17 20:41:21 CET 2022
(..)
[   12.001911] cfg80211: Loading compiled-in X.509 certificates for 
regulatory database
[   12.029737] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   12.034170] cfg80211: loaded regulatory.db is malformed or signature 
is missing/invalid
[   12.086287] Bluetooth: Core ver 2.22
[   12.087533] NET: Registered PF_BLUETOOTH protocol family
[   12.090401] Bluetooth: HCI device and connection manager initialized
[   12.090452] Bluetooth: HCI socket layer initialized
[   12.090457] Bluetooth: L2CAP socket layer initialized
[   12.090516] Bluetooth: SCO socket layer initialized
[   12.136999] Intel(R) Wireless WiFi driver for Linux
[   12.138353] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
[   12.144928] iwlwifi 0000:01:00.0: loaded firmware version 
36.ad812ee0.0 8265-36.ucode op_mode iwlmvm
[   12.224682] usbcore: registered new interface driver btusb
[   12.248689] Bluetooth: hci0: Bootloader revision 0.0 build 26 week 38 
2015
[   12.250374] Bluetooth: hci0: Device revision is 16
[   12.251288] Bluetooth: hci0: Secure boot is enabled
[   12.252377] Bluetooth: hci0: OTP lock is enabled
[   12.253229] Bluetooth: hci0: API lock is enabled
[   12.254090] Bluetooth: hci0: Debug lock is disabled
[   12.255009] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[   12.260320] Bluetooth: hci0: Found device firmware: intel/ibt-12-16.sfi
[   12.373476] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band 
Wireless AC 8265, REV=0x230
[   12.442732] iwlwifi 0000:01:00.0: base HW address: 48:89:e7:1b:ee:64, 
OTP minor version: 0x0
[   12.545287] intel_rapl_common: Found RAPL domain package
[   12.545326] intel_rapl_common: Found RAPL domain core
[   12.545350] intel_rapl_common: Found RAPL domain uncore
[   12.545375] intel_rapl_common: Found RAPL domain psys
[   12.545785] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   12.850332] hp_wmi: query 0x4 returned error 0x5
[   12.852738] hp_wmi: query 0xd returned error 0x5
[   12.894436] input: HP WMI hotkeys as /devices/virtual/input/input23
[   12.960086] hp_wmi: query 0x1b returned error 0x5
[   13.053127] iwlwifi 0000:01:00.0 wlp1s0: renamed from wlan0
[   13.114622] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   13.114625] Bluetooth: BNEP filters: protocol multicast
[   13.114631] Bluetooth: BNEP socket layer initialized
[   13.811222] Bluetooth: hci0: Waiting for firmware download to complete
[   13.811636] Bluetooth: hci0: Firmware loaded in 1514074 usecs
[   13.812493] Bluetooth: hci0: Waiting for device to boot
[   13.824416] Bluetooth: hci0: Device booted in 12199 usecs
[   13.824418] Bluetooth: hci0: Malformed MSFT vendor event: 0x02
[   13.824806] Bluetooth: hci0: Found Intel DDC parameters: 
intel/ibt-12-16.ddc
[   13.827429] Bluetooth: hci0: Applying Intel DDC parameters completed
[   13.828449] Bluetooth: hci0: Firmware revision 0.1 build 50 week 12 2019
[   13.845837] iwlwifi 0000:01:00.0: mac start retry 0
[   13.895993] NET: Registered PF_ALG protocol family
[   14.100027] iwlwifi 0000:01:00.0: mac start retry 1
[   14.349522] iwlwifi 0000:01:00.0: mac start retry 2
[   14.594141] iwlwifi 0000:01:00.0: mac start retry 0
[   14.835957] iwlwifi 0000:01:00.0: mac start retry 1
[   15.075966] iwlwifi 0000:01:00.0: mac start retry 2
[   15.326159] iwlwifi 0000:01:00.0: mac start retry 0
[   15.568003] iwlwifi 0000:01:00.0: mac start retry 1
[   15.570772] Bluetooth: RFCOMM TTY layer initialized
[   15.570784] Bluetooth: RFCOMM socket layer initialized
[   15.570800] Bluetooth: RFCOMM ver 1.11
[   15.832467] iwlwifi 0000:01:00.0: mac start retry 2
[   16.109220] iwlwifi 0000:01:00.0: mac start retry 0
[   16.378910] iwlwifi 0000:01:00.0: mac start retry 1
[   16.646092] iwlwifi 0000:01:00.0: mac start retry 2
[   27.288232] iwlwifi 0000:01:00.0: mac start retry 0
[   27.553616] iwlwifi 0000:01:00.0: mac start retry 1
[   27.818481] iwlwifi 0000:01:00.0: mac start retry 2
[   28.088457] iwlwifi 0000:01:00.0: mac start retry 0
[   28.354671] iwlwifi 0000:01:00.0: mac start retry 1
[   28.620348] iwlwifi 0000:01:00.0: mac start retry 2
[   39.290524] iwlwifi 0000:01:00.0: mac start retry 0
[   39.554416] iwlwifi 0000:01:00.0: mac start retry 1
[   39.820355] iwlwifi 0000:01:00.0: mac start retry 2
[   40.085494] iwlwifi 0000:01:00.0: mac start retry 0
[   40.348142] iwlwifi 0000:01:00.0: mac start retry 1
[   40.614622] iwlwifi 0000:01:00.0: mac start retry 2
[   51.296158] iwlwifi 0000:01:00.0: mac start retry 0
[   51.564189] iwlwifi 0000:01:00.0: mac start retry 1
[   51.832335] iwlwifi 0000:01:00.0: mac start retry 2
[   52.100712] iwlwifi 0000:01:00.0: mac start retry 0
[   52.366818] iwlwifi 0000:01:00.0: mac start retry 1
[   52.630498] iwlwifi 0000:01:00.0: mac start retry 2
[   63.300472] iwlwifi 0000:01:00.0: mac start retry 0
[   63.570028] iwlwifi 0000:01:00.0: mac start retry 1
[   63.836321] iwlwifi 0000:01:00.0: mac start retry 2
[   64.107436] iwlwifi 0000:01:00.0: mac start retry 0
[   64.377235] iwlwifi 0000:01:00.0: mac start retry 1
[   64.646305] iwlwifi 0000:01:00.0: mac start retry 2
[   75.298137] iwlwifi 0000:01:00.0: mac start retry 0
[   75.564421] iwlwifi 0000:01:00.0: mac start retry 1
[   75.829962] iwlwifi 0000:01:00.0: mac start retry 2
[   76.102979] iwlwifi 0000:01:00.0: mac start retry 0
[   76.372426] iwlwifi 0000:01:00.0: mac start retry 1
[   76.641806] iwlwifi 0000:01:00.0: mac start retry 2


