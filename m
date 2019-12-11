Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3252811A4F8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfLKHUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:20:20 -0500
Received: from ni.piap.pl ([195.187.100.5]:34146 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfLKHUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 02:20:19 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 02:20:19 EST
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 8B26144395F;
        Wed, 11 Dec 2019 08:10:34 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 8B26144395F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1576048235; bh=NzjEtJBbGMnp7Oker2Ku1W7VereultBIRwFu42VbqH0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ddfu2lN5c/GDpBgFP7CSUj0b136P+lVeJ7gwAXrjiOc/imCh/fKKl06s4jiNWd3W6
         ghZTZ3rWpbxy0U0jx8x6F4oyrkOb+j4jZNenBXXxV0t87/bTxylOTmAAjyPY2pKW0j
         p+4ER4qIEmPNUzF+DwzgjA2TKIAZAhR6S+H4y0LA=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: Re: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
References: <20191209151256.2497534-1-arnd@arndb.de>
        <20191209151256.2497534-4-arnd@arndb.de>
Date:   Wed, 11 Dec 2019 08:10:34 +0100
In-Reply-To: <20191209151256.2497534-4-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 9 Dec 2019 16:12:56 +0100")
Message-ID: <m3d0cvjq1h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.721, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd,

Arnd Bergmann <arnd@arndb.de> writes:

> - Most other supported HDLC hardware that we supoprt is for the ISA or
>   PCI buses.

I would be surprised if there is anybody left with ISA sync serial
stuff, but the PCI hardware still has some users - these machines don't
need to be upgraded yearly. Most people have migrated away, though.
--=20

Krzysztof Halasa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
