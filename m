Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C971482E78
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 07:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiACG1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 01:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiACG1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 01:27:37 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBB9C061761;
        Sun,  2 Jan 2022 22:27:37 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6FC5D42528;
        Mon,  3 Jan 2022 06:27:27 +0000 (UTC)
Message-ID: <9974e68b-f591-81ec-d91f-1b9b14c09edd@marcan.st>
Date:   Mon, 3 Jan 2022 15:27:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 00/34] brcmfmac: Support Apple T2 and M1 platforms
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <CACRpkdY1qL6s45qMq65mCrdDDjNfoksadO3Va=zSUhT41pBktw@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CACRpkdY1qL6s45qMq65mCrdDDjNfoksadO3Va=zSUhT41pBktw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 15:25, Linus Walleij wrote:
> On Sun, Dec 26, 2021 at 4:36 PM Hector Martin <marcan@marcan.st> wrote:
> 
>> Merry Christmas! This year Santa brings us a 34-patch series to add
>> proper support for the Broadcom FullMAC chips used on Apple T2 and M1
>> platforms:
> 
> I tried to review as best I could, when I think I know what I'm doing I state
> Reviewed-by and when I think it just LooksGoodToMe(TM) I replied
> Acked-by. If I missed some patch you can assume Acked-by from me
> on these as well.
> 
> Thanks for doing this, some really old bugs and code improvements long
> overdue is in the series, much appreciated.
> 
> Yours,
> Linus Walleij
> 

Thanks for the comprehensive review! I'm glad this all makes some sense
and I'm not crazy about the approach :)

I'll wait a bit for any other feedback that might come in and then
submit a v2 with the fixes/changes mentioned so far.

Cheers,
-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
