Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BC3489743
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbiAJLVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244598AbiAJLVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:21:16 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF25C06173F;
        Mon, 10 Jan 2022 03:21:16 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B8FCA41AC8;
        Mon, 10 Jan 2022 11:21:05 +0000 (UTC)
Message-ID: <5226bf9f-fb0f-5dc5-3b82-2125fc229526@marcan.st>
Date:   Mon, 10 Jan 2022 20:21:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 00/35] brcmfmac: Support Apple T2 and M1 platforms
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
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
 <87tuebvqw4.fsf@kernel.org>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <87tuebvqw4.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/10 19:14, Kalle Valo wrote:
> Hector Martin <marcan@marcan.st> writes:
> 
>> Hi everyone,
>>
>> Happy new year! This 35-patch series adds proper support for the
>> Broadcom FullMAC chips used on Apple T2 and M1 platforms:
>>
>> - BCM4355C1
>> - BCM4364B2/B3
>> - BCM4377B3
>> - BCM4378B1
>> - BCM4387C2
> 
> 35 patches is a lot to review. It would make things easier for reviewers
> if you can split this into smaller patchsets, 10-12 patches per set is
> what I usually recommend. More info in the wiki link below.

The patches are already split into logical groupings, so I think there
isn't much more to be gained by sending them separately. As I described
in the cover letter:

01~09: Firmware selection stuff
10~14: Add support for BCM4378
15~20: Add BCM4355/4364/4377 on top
21~27: Add BCM4387 and its newer requirements
28~32: Misc fixes
33~35: TxCap & calibration support

If you want to review the series piecemeal, feel free to stop at any of
those boundaries; the series will still make sense and is useful at any
of those stopping points.

Note that the firmware selection stuff (in particular patches #4 and #6)
will change quite a bit in v3 from the review feedback so far, so you
might want to skip reviewing those in detail for v2.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
