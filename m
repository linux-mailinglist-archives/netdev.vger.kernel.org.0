Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2184A4BC2
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 17:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380287AbiAaQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 11:21:37 -0500
Received: from marcansoft.com ([212.63.210.85]:38398 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380259AbiAaQV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 11:21:29 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A809B419BC;
        Mon, 31 Jan 2022 16:21:20 +0000 (UTC)
Subject: Re: [PATCH v2 22/35] brcmfmac: chip: Handle 1024-unit sizes for TCM
 blocks
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-23-marcan@marcan.st>
 <ed387a90-586d-5071-baa6-bc66d4e7f22f@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <b150396e-83f0-6d6e-4b80-5ecfc04ec1a0@marcan.st>
Date:   Tue, 1 Feb 2022 01:21:17 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed387a90-586d-5071-baa6-bc66d4e7f22f@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2022 21.36, Arend van Spriel wrote:
>>   /** Return the TCM-RAM size of the ARMCR4 core. */
>> -static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
>> +static u32 brcmf_chip_tcm_ramsize(struct brcmf_chip_priv *ci,
>> +				  struct brcmf_core_priv *cr4)
> 
> Not sure why you add ci parameter here. It is not used below or am I 
> overlooking something.

Oops, looks like junk left behind from when I was trying to figure this
out. Removed. Sorry about that.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
