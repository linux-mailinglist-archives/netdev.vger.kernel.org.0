Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2216002
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfEGJBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:01:43 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:43662 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfEGJBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 05:01:43 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 3CDFA6E34;
        Tue,  7 May 2019 11:01:39 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id dba1650f;
        Tue, 7 May 2019 11:01:37 +0200 (CEST)
Date:   Tue, 7 May 2019 11:01:37 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devel@driverdev.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Kerr <jk@ozlabs.org>
Subject: netdev patchwork issues [Was: Re: [PATCH net-next v2 0/4]
 of_get_mac_address ERR_PTR fixes]
Message-ID: <20190507090137.GJ81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
 <20190507071914.GJ2269@kadam>
 <20190507083918.GI81826@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507083918.GI81826@meh.true.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Štetiar <ynezz@true.cz> [2019-05-07 10:39:18]:

[adding Jeremy to the Cc: loop]

> it was applied[2] to David's net-next tree, but unfortunately partialy, just 9
> patches out of 10, as the patch 05/10 in that series (which is patch 1/4 in
> this series) never reached netdev mailing list and patchwork, probably because
> of some netdev mailing list software and/or patchwork hiccup, very likely due
> to the long list of recipients in that patch and as I'm not subscribed to the
> netdev (due to the high traffic) I'm probably treaten somehow differently.

For the record, I've following in my ~/.gitconfig:

 [sendemail.linux]
    tocmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nol"
    cccmd ="`pwd`/scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats --nom"

and I've sent the patches with the following command:

 git send-email \
	--to netdev@vger.kernel.org \
	--to 'David S. Miller <davem@davemloft.net>' \
	--cc 'Andrew Lunn <andrew@lunn.ch>' \
	--cc 'Florian Fainelli <f.fainelli@gmail.com>' \
	--cc 'Heiner Kallweit <hkallweit1@gmail.com>' \
	--cc 'Frank Rowand <frowand.list@gmail.com>' \
	--cc 'devel@driverdev.osuosl.org' \
	--cc 'linux-kernel@vger.kernel.org' \
	--cc 'Greg Kroah-Hartman <gregkh@linuxfoundation.org>' \
	--cc 'Maxime Ripard <maxime.ripard@bootlin.com>' \
	--identity linux tmp/nvmem-fix-v2/000*

which resulted just in the following 4 bounces:

 * nbd@openwrt.org (no such recipient)
 * ks.giri@samsung.com (no such recipient)
 * vipul.pandya@samsung.com (no such recipient)

 Your mail to 'linux-arm-kernel' with the subject

    [PATCH net-next v2 1/4] net: ethernet: support of_get_mac_address new ERR_PTR error

 Is being held until the list moderator can review it for approval.  The reason
 it is being held:

    Too many recipients to the message

So maybe netdev have similar moderation stuff enabled, but doesn't send out
this notices back? I've "fixed" the issue with the following workaround:

 git send-email \
 	--to netdev@vger.kernel.org \
	--in-reply-to '<1557177887-30446-1-git-send-email-ynezz@true.cz>' \
	tmp/nvmem-fix-v2/0001-net-ethernet-support-of_get_mac_address-new-ERR_PTR-.patch

That is, just using netdev as the sole recipient and then the patch has
appeared in the patchwork and in the mailing list archive as well.

-- ynezz
