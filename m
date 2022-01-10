Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C039F48961B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiAJKPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbiAJKPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:15:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B6EC06173F;
        Mon, 10 Jan 2022 02:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA476124F;
        Mon, 10 Jan 2022 10:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AC9C36AE9;
        Mon, 10 Jan 2022 10:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641809700;
        bh=TqPm7m1Wb0a6egGV5nH0SK7kmvwvQl7qaDYB8oW0lRI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=I3cjis+qAfD7EQerPM4kuOUMwDEb3ZOZsqOYvntuzr1hkMELGVgFz2nvHuizhMVfZ
         QjYt9GHQ7DHbOo8js2Fr3Jc2u0VGLIr5Bly6Dzko9F12sRFh5KlxyR+ENl/rDz7EEZ
         40MVYplTsfpmduxc9qUSMv+tGMioliFZLmAQF7oflzipOrDlaqUg8ATHC/phjiD42V
         cFBGydolIxzFam5/EAxsK9Lm+GLMSZxgtmylQYe1m4HZgCYcrtl170EUb0iYoCve54
         H62LgEm/F7I3Lx+Lc6riTLV/STC+qiUXtHPJ1nVXMOImJGZRbUcqu0mBm4ktVwvMBT
         wwqEGPt+Mm6cA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
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
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
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
Subject: Re: [PATCH v2 00/35] brcmfmac: Support Apple T2 and M1 platforms
References: <20220104072658.69756-1-marcan@marcan.st>
Date:   Mon, 10 Jan 2022 12:14:51 +0200
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st> (Hector Martin's
        message of "Tue, 4 Jan 2022 16:26:23 +0900")
Message-ID: <87tuebvqw4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> writes:

> Hi everyone,
>
> Happy new year! This 35-patch series adds proper support for the
> Broadcom FullMAC chips used on Apple T2 and M1 platforms:
>
> - BCM4355C1
> - BCM4364B2/B3
> - BCM4377B3
> - BCM4378B1
> - BCM4387C2

35 patches is a lot to review. It would make things easier for reviewers
if you can split this into smaller patchsets, 10-12 patches per set is
what I usually recommend. More info in the wiki link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
