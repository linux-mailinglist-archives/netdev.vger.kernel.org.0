Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2369C33D8DD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbhCPQO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:14:29 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:39495 "EHLO
        6.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238517AbhCPQOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:14:05 -0400
X-Greylist: delayed 8841 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 12:14:05 EDT
Received: from player772.ha.ovh.net (unknown [10.110.103.226])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id BB521202A9B
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 14:46:42 +0100 (CET)
Received: from RCM-web5.webmail.mail.ovh.net (klient.box3.pl [176.114.232.43])
        (Authenticated sender: rafal@milecki.pl)
        by player772.ha.ovh.net (Postfix) with ESMTPSA id 4BB2E1C28560E;
        Tue, 16 Mar 2021 13:46:36 +0000 (UTC)
MIME-Version: 1.0
Date:   Tue, 16 Mar 2021 14:46:36 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: broadcom: BCM4908_ENET should not default to y,
 unconditionally
In-Reply-To: <20210316133853.2376863-1-geert+renesas@glider.be>
References: <20210316133853.2376863-1-geert+renesas@glider.be>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <789a2fb70742de1cc0435f82a85d23c9@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 176.114.232.43
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 13169088264365051455
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgheeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggffhffvufgjfhgfkfigihgtgfesthejjhdttdervdenucfhrhhomheptfgrfhgrlhgpofhilhgvtghkihcuoehrrghfrghlsehmihhlvggtkhhirdhplheqnecuggftrfgrthhtvghrnhepveefvdetjeffueefkeeuuedvgefhgeegjefgvedvgeeiteduueeivdeltedthfetnecukfhppedtrddtrddtrddtpddujeeirdduudegrddvfedvrdegfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjedvrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprhgrfhgrlhesmhhilhgvtghkihdrphhlpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-16 14:38, Geert Uytterhoeven wrote:
> Merely enabling CONFIG_COMPILE_TEST should not enable additional code.
> To fix this, drop the automatic enabling of BCM4908_ENET.
> 
> Fixes: 4feffeadbcb2e5b1 ("net: broadcom: bcm4908enet: add BCM4908
> controller driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Feel free to change to "default y if ARCH_BCM4908" and
> 
>     To fix this, restrict the automatic enabling of BCM4908_ENET to
>     ARCH_BCM4908.
> 
> if you think BCM4908 SoCs cannot be used without enabling this.

Yes, please make it
default y if ARCH_BCM4908
instead.
