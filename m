Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36FC695205
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBMUiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMUiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:38:23 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E939BDDF;
        Mon, 13 Feb 2023 12:38:22 -0800 (PST)
Received: from [192.168.10.12] (unknown [39.45.179.179])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id DF25A6600013;
        Mon, 13 Feb 2023 20:38:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676320701;
        bh=fq69WVgNbrGinAN68EgUpT0UsJ02u0P+bko0XQCpqXw=;
        h=Date:Cc:To:From:Subject:From;
        b=mzNju+SCqbBSDZoGwXMVr08omuvvlAMsFNbYistdArfwoslteAGSQjmlFrpEOpy9o
         u8nCWRvT/v4nCJctTzmIfcB+cklN4oBPiKOukFxAJwe+D7Q6MagOCABJeRwhq8tVxE
         Uq+XPJCfWYt2rmmHINgqswtFup2WLKwV7PUYf+SgtLGoAoq8wFUDrHAIGOPn/ha5Ro
         9q4NyqJLK6PbAAPuk5AIWh8sgKITzZKWPq7emFmZfG+KINMVlvvZMxdgwOvphuigoB
         +qseBp7vYpn94Ynfuw6a2cPFhlxhtPZ2Fp9z+6fiOCkwXIYrlaFqbKje2EYoT/nSFm
         Uv7hZwa/HpMJg==
Message-ID: <2dcc7926-4d80-0d70-edf3-d05ea3dc542e@collabora.com>
Date:   Tue, 14 Feb 2023 01:38:13 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Language: en-US
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: [Issue Report] Realtek 8852AE Bluetooth audio issues while using WiFi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm running 6.1.0-3 kernel and getting Bluetooth audio glitches constantly
on a pair of buds and all the time when WiFi is connecting and working on
RTL 8852AE card. Some Bluetooth audio devices work fine without issue. But
some devices get glitchy audio all the time when Wifi is being used. The
audio becomes more and more glitchy as the WiFi use increases. [1] mentions
that the problem for Realtek 8723BE gets solved by switching to 5GHz wifi
or upgrading drives. Is this issue present on other operating systems for
this chip as well? Can it be solved for Linux if Wifi is used at 2.4 GHz?

Any pointers on this problem would be much appreciated.

04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8852AE
802.11ax PCIe Wireless Network Adapter
        Subsystem: Lenovo RTL8852AE 802.11ax PCIe Wireless Network Adapter
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 100
        IOMMU group: 15
        Region 0: I/O ports at 1000 [size=256]
        Region 2: Memory at d1700000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>
        Kernel driver in use: rtw89_8852ae
        Kernel modules: rtw89_8852ae

[1] https://wiki.archlinux.org/title/bluetooth_headset

-- 
BR,
Muhammad Usama Anjum
