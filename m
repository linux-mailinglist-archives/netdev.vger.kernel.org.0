Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B416486381
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbiAFLLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbiAFLLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:11:04 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D29C061245;
        Thu,  6 Jan 2022 03:11:04 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A50A941F55;
        Thu,  6 Jan 2022 11:10:53 +0000 (UTC)
Message-ID: <6a54eabe-1013-0e3c-024d-971178278dc9@marcan.st>
Date:   Thu, 6 Jan 2022 20:10:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 02/35] brcmfmac: pcie: Declare missing firmware files
 in pcie.c
Content-Language: en-US
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
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
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
 <20220104072658.69756-3-marcan@marcan.st>
 <3268b423-09eb-e7d9-b427-fc964d217087@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <3268b423-09eb-e7d9-b427-fc964d217087@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/06 18:56, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> Move one of the declarations from sdio.c to pcie.c, since it makes no
>> sense in the former (SDIO support is optional), and add missing ones.
> 
> Actually, any bus is optional so each bus should indeed declare the 
> applicable firmware names/patterns.

Of course; I didn't mean *only* SDIO support is optional :)

>> +/* firmware config files */
>> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
> 
> what is this one for? Those would be covered by the specific 
> BRCMF_FW_DEF() macro instances, no?

The BRCMF_FW_DEF() macro only declares the .bin file; BRCMF_FW_CLM_DEF
declares that and the .clm_blob. Neither declare the NVRAM .txt.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
