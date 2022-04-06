Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392E64F6293
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiDFPIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiDFPHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:07:09 -0400
X-Greylist: delayed 820 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 05:00:52 PDT
Received: from ni.piap.pl (ni.piap.pl [195.187.100.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762121BB1BC;
        Wed,  6 Apr 2022 05:00:52 -0700 (PDT)
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        by ni.piap.pl (Postfix) with ESMTPSA id 8DE72C3F3EEF;
        Wed,  6 Apr 2022 13:46:02 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 8DE72C3F3EEF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1649245563; bh=H2cw5bwLYJGOZRFezh751pUAu0IoxnfSLAdQ8KkcA+g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X6APw25+prmI1lRCueZabWGEyveFGkJXp4CmKeEWB1P6Vz0iBdJkNWjBsYgK53fgw
         XskpSAhFTW8vfhnCTi/NtOJR08fC5Qp+hA2ga4gMuwQ8nlidjgYhaz+5LSZZYUbFpu
         /dc/NICx65clCBEmfHRWYBIi8aGKfRZA8MGriGIg=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Arnd Bergmann <arnd@kernel.org>, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH net-next] net: wan: remove the lanmedia (lmc) driver
References: <20220406041548.643503-1-kuba@kernel.org>
Sender: khalasa@piap.pl
Date:   Wed, 06 Apr 2022 13:46:02 +0200
In-Reply-To: <20220406041548.643503-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Tue, 5 Apr 2022 21:15:48 -0700")
Message-ID: <m3k0c2fn9h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 3
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, not scanned, whitelist
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> The driver for LAN Media WAN interfaces spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
>
> Let's remove this driver, there isn't much changing in the APIs,
> if users come forward we can apologize and revert.

I wouldn't hold my breath, though :-)

Acked-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>
--=20
Krzysztof "Chris" Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
