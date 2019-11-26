Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7268410A380
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfKZRnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:43:00 -0500
Received: from mail.andi.de1.cc ([85.214.55.253]:52988 "EHLO mail.andi.de1.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfKZRm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 12:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UJNRgJYokU+UFBwtU2ynndrvNCEKdJJFP6ze1hNesKA=; b=VKQR+Zj0Q2r4WCNqxVBEMXCJjm
        RRPVV3THF0fJGtGADLnmC3BHkJB8U1LtDHLaPwPHJlAQBz3ItPNT3J7gDYOaFtND5sNia0Ae0EW1+
        NYUDqVaIHwiA2ZCjoGEkaup2w7a6HGwXYfTWOgZ30upF+ndNyu9OCENAbVNv71gvbTbQ=;
Received: from p200300ccff0be6001a3da2fffebfd33a.dip0.t-ipconnect.de ([2003:cc:ff0b:e600:1a3d:a2ff:febf:d33a] helo=aktux)
        by mail.andi.de1.cc with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1iZerL-0001ZJ-Vf; Tue, 26 Nov 2019 18:42:44 +0100
Date:   Tue, 26 Nov 2019 18:42:42 +0100
From:   Andreas Kemnade <andreas@kemnade.info>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@pyra-handheld.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexios Zavras <alexios.zavras@intel.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Letux-kernel] [PATCH 0/2] net: wireless: ti: wl1251: sdio:
 remove ti, power-gpio
Message-ID: <20191126184242.365603a2@aktux>
In-Reply-To: <0101016ea8691109-5beadf07-b3ba-4d31-a516-c7f3015f2316-000000@us-west-2.amazonses.com>
References: <cover.1574591746.git.hns@goldelico.com>
        <0101016ea8691109-5beadf07-b3ba-4d31-a516-c7f3015f2316-000000@us-west-2.amazonses.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.3 (+)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 15:51:28 +0000
Kalle Valo <kvalo@codeaurora.org> wrote:

> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
> 
> > The driver has been updated to use the mmc/sdio core
> > which does full power control. So we do no longer need
> > the power control gipo.
> >
> > Note that it is still needed for the SPI based interface
> > (N900).
> >
> > Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> > Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz
> >
> > H. Nikolaus Schaller (2):
> >   DTS: bindings: wl1251: mark ti,power-gpio as optional
> >   net: wireless: ti: wl1251: sdio: remove ti,power-gpio
> >
> >  .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
> >  drivers/net/wireless/ti/wl1251/sdio.c         | 30 -------------------
> >  2 files changed, 2 insertions(+), 31 deletions(-)  
> 
> Via which tree are these planned to go? Please always document that in
> the cover letter so that maintainers don't need to guess.
> 
Hmm, this is about bisect issues and the former misc pandora
fix/cleanup series now in linux-next that make you doubt it should go
via wireless/net?
So the question is whether it depends on that?

Regards,
Andreas
