Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4176B463A9B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhK3P41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:56:27 -0500
Received: from mail.nic.cz ([217.31.204.67]:39260 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243175AbhK3Pzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:55:47 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2021 10:55:47 EST
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPSA id 6D454140577;
        Tue, 30 Nov 2021 16:42:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1638286964; bh=8TR3qlYsK3Az09Pd8qbsb4Dk/ceVDz6LhvnklASXhjg=;
        h=Date:From:To;
        b=VFl6toQeTA9Z8arPO4WGaYahOSwz0ayQzmEsZ3IiUhVG2ovqtBeF9XaHyWGeFiSbo
         v12JmnI2QB3u9Vq6V5dtijvf6aw8d3N21Fp+6BGFJQZzK/PK9aQAE8sMj5eKDgLK7S
         6jhbjyCBauRrRgIzSo4QVzQEOyKMGKTLUhOf1itw=
Date:   Tue, 30 Nov 2021 16:42:43 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 2/5] net: dsa: replace phylink_get_interfaces()
 with phylink_get_caps()
Message-ID: <20211130164243.7cf61323@thinkpad>
In-Reply-To: <E1ms2tV-00ECJA-2v@rmk-PC.armlinux.org.uk>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
        <E1ms2tV-00ECJA-2v@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.4 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 13:10:01 +0000
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Phylink needs slightly more information than phylink_get_interfaces()
> allows us to get from the DSA drivers - we need the MAC capabilities.
> Replace the phylink_get_interfaces() method with phylink_get_caps() to
> allow DSA drivers to fill in the phylink_config MAC capabilities field
> as well.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
