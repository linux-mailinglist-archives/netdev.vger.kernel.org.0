Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97179DF502
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfJUSWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:22:37 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:22262 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfJUSWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571682152;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ESbJhDnm5bjuVodC9kh4h0sdAOT1wrM2a4p9lLw+WMU=;
        b=XmU7ZkYxfp33BkQgcl5YpwmrWOM3l9F4xslYbs0zMYcPe1FXsqxa3XsANba9HChcWM
        4cZ0ZHMZdtIuY8sVtIzzS9lqfLLABXmNe3wvcbzP/ozh5hH9UI2vAifvvWsF6PpFkgPa
        af7eo60FnAsUhj6NkntPeV3aEl6f1iELqirCKW7anm1T0OUlb5RRRC5CWwjVqR+HXumx
        rc6lN7ZBZlqyr1hpXGSoAuH7cDwcn3UYriAHPqVPh110ZL6SOhqs81FdQixc1LXzw1pr
        iaK9jWwik10QrAdrWZjDzEIJ5b3WItr3nK395plCbUZV7lzgu0+Vil3ikaEmYIlirdiM
        1xRA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDVCbXA4Ewxc="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9LIMGM7B
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 21 Oct 2019 20:22:16 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 3/9] DTS: ARM: pandora-common: define wl1251 as child node of mmc3
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191021171321.GZ5610@atomide.com>
Date:   Mon, 21 Oct 2019 20:22:15 +0200
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C476142-BC54-4950-8B7A-A422ABC2AEB9@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com> <58c57f194e35b2a055a58081a0ea0d3ffcd07b6d.1571430329.git.hns@goldelico.com> <20191021171321.GZ5610@atomide.com>
To:     Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 21.10.2019 um 19:13 schrieb Tony Lindgren <tony@atomide.com>:
>=20
> * H. Nikolaus Schaller <hns@goldelico.com> [191018 20:28]:
>> Since v4.7 the dma initialization requires that there is a
>> device tree property for "rx" and "tx" channels which is
>> not provided by the pdata-quirks initialization.
>>=20
>> By conversion of the mmc3 setup to device tree this will
>> finally allows to remove the OpenPandora wlan specific omap3
>> data-quirks.
>>=20
>> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
>=20
> Here you have the subject line the wrong way around,
> please update it to start with "ARM: dts: ...".

Ok.

