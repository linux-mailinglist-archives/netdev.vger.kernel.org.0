Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D25551466
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239968AbiFTJax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiFTJa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:30:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7A913D1D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:30:26 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o3Djl-0005DN-74; Mon, 20 Jun 2022 11:30:25 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o3Djk-0006c3-MO; Mon, 20 Jun 2022 11:30:24 +0200
Date:   Mon, 20 Jun 2022 11:30:24 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Ernesto Vigano' <lanciadelsole@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Fwd: question on driver for phy dp83td510e
Message-ID: <20220620093024.GB23685@pengutronix.de>
References: <CAM3i8OEGrux+ku7hL20oGO10f=CDLkpcg3wH6hRbheEdacWnfw@mail.gmail.com>
 <CAM3i8OF1mC21wzwfsvhQTK7PPa0myCwftyhA9U1r7HR_0Q3fLQ@mail.gmail.com>
 <CAM3i8OFjvOkLGELkrKEo3B7x0hP=uPrYaPL05=0WXygvYJNZCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM3i8OFjvOkLGELkrKEo3B7x0hP=uPrYaPL05=0WXygvYJNZCQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ernesto,

Cc-ing: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 10:45:59AM +0200, Ernesto Vigano' wrote:
> I see that some weeks ago a driver for phy dp83td510e from TI
> (https://www.ti.com/product/DP83TD510E).
> I see that it's really different from the Linux driver supplied by TI
> on its official repo
> https://git.ti.com/gitweb?p=ti-analog-linux-kernel/dmurphy-analog.git;a=commit;h=fefa908e4e3262455a0cec08f3bb7161d7792d02
> As an example, TI writes some undocumented register for version 1.0 of the PHY.

I do not have version 1.0 PHY. May be it is presilicon FPGA version of
the devices.

> Should I forget about the TI driver?

Yes. If you have some issue, please report them of send patches, against
mainline driver.

> Or is there something that should be integrated in
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/dp83td510.c
> ?

If it is fixing something, then yes.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
