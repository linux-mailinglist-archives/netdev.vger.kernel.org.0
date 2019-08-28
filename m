Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7479F9AA
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfH1FAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:00:55 -0400
Received: from baldur.buserror.net ([165.227.176.147]:49236 "EHLO
        baldur.buserror.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfH1FAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:00:54 -0400
X-Greylist: delayed 2497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2019 01:00:54 EDT
Received: from [2601:449:8400:7293:12bf:48ff:fe84:c9a0]
        by baldur.buserror.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <oss@buserror.net>)
        id 1i2pQN-0007F3-6K; Tue, 27 Aug 2019 23:19:12 -0500
Message-ID: <b535dcfc3d6b06ca583dc26703d4adc958eacdd8.camel@buserror.net>
From:   Scott Wood <oss@buserror.net>
To:     Valentin Longchamp <valentin@longchamp.me>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 27 Aug 2019 23:19:10 -0500
In-Reply-To: <CADYrJDxsQ3H7b_BHOfmfTNb1OuXt+vzTg4k8Goj8tKPaaOMz_g@mail.gmail.com>
References: <20190714200501.1276-1-valentin@longchamp.me>
         <CADYrJDwvwVThmOwHZ4Moqenf=-iqoHC+yJ_uxtrD8sDso33rjg@mail.gmail.com>
         <2243421e574c72c5e75d27cc0122338e2e0bde63.camel@buserror.net>
         <VI1PR04MB55679AAE8DDC3160B9CCE073ECDC0@VI1PR04MB5567.eurprd04.prod.outlook.com>
         <CADYrJDxsQ3H7b_BHOfmfTNb1OuXt+vzTg4k8Goj8tKPaaOMz_g@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2601:449:8400:7293:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: valentin@longchamp.me, madalin.bucur@nxp.com, linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org, netdev@vger.kernel.org
X-SA-Exim-Mail-From: oss@buserror.net
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on baldur.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  -15 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -1.5 GREYLIST_ISWHITE The incoming server has been whitelisted for
        *      this recipient and sender
Subject: Re: [PATCH] powerpc/kmcent2: update the ethernet devices' phy
 properties
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-08 at 23:09 +0200, Valentin Longchamp wrote:
> Le mar. 30 juil. 2019 à 11:44, Madalin-cristian Bucur
> <madalin.bucur@nxp.com> a écrit :
> > 
> > > -----Original Message-----
> > > 
> > > > Le dim. 14 juil. 2019 à 22:05, Valentin Longchamp
> > > > <valentin@longchamp.me> a écrit :
> > > > > 
> > > > > Change all phy-connection-type properties to phy-mode that are
> > > > > better
> > > > > supported by the fman driver.
> > > > > 
> > > > > Use the more readable fixed-link node for the 2 sgmii links.
> > > > > 
> > > > > Change the RGMII link to rgmii-id as the clock delays are added by
> > > > > the
> > > > > phy.
> > > > > 
> > > > > Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
> > > 
> > > I don't see any other uses of phy-mode in arch/powerpc/boot/dts/fsl, and
> > > I see
> > > lots of phy-connection-type with fman.  Madalin, does this patch look
> > > OK?
> > > 
> > > -Scott
> > 
> > Hi,
> > 
> > we are using "phy-connection-type" not "phy-mode" for the NXP (former
> > Freescale)
> > DPAA platforms. While the two seem to be interchangeable ("phy-mode" seems
> > to be
> > more recent, looking at the device tree bindings), the driver code in
> > Linux seems
> > to use one or the other, not both so one should stick with the variant the
> > driver
> > is using. To make things more complex, there may be dependencies in
> > bootloaders,
> > I see code in u-boot using only "phy-connection-type" or only "phy-mode".
> > 
> > I'd leave "phy-connection-type" as is.
> 
> So I have finally had time to have a look and now I understand what
> happens. You are right, there are bootloader dependencies: u-boot
> calls fdt_fixup_phy_connection() that somehow in our case adds (or
> changes if already in the device tree) the phy-connection-type
> property to a wrong value ! By having a phy-mode in the device tree,
> that is not changed by u-boot and by chance picked up by the kernel
> fman driver (of_get_phy_mode() ) over phy-connection-mode, the below
> patch fixes it for us.
> 
> I agree with you, it's not correct to have both phy-connection-type
> and phy-mode. Ideally, u-boot on the board should be reworked so that
> it does not perform the above wrong fixup. However, in an "unfixed"
> .dtb (I have disabled fdt_fixup_phy_connection), the device tree in
> the end only has either phy-connection-type or phy-mode, according to
> what was chosen in the .dts file. And the fman driver works well with
> both (thanks to the call to of_get_phy_mode() ). I would therefore
> argue that even if all other DPAA platforms use phy-connection-type,
> phy-mode is valid as well. (Furthermore we already have hundreds of
> such boards in the field and we don't really support "remote" u-boot
> update, so the u-boot fix is going to be difficult for us to pull).
> 
> Valentin

Madalin, are you OK with the patch given this explanation?

-Scott


