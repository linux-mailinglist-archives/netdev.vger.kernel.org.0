Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE05D27BABC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgI2CPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:15:43 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:18888 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgI2CPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:15:43 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d35 with ME
        id ZeFS230032lQRaH03eFZCk; Tue, 29 Sep 2020 04:15:40 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 29 Sep 2020 04:15:40 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Subject: Re: [PATCH 6/6] USB: cdc-acm: blacklist ETAS ES58X device
Date:   Tue, 29 Sep 2020 11:15:02 +0900
Message-Id: <20200929021502.18163-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927055226.GA701624@kroah.com>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr> <20200926175810.278529-7-mailhol.vincent@wanadoo.fr> <20200927054520.GB699448@kroah.com> <20200927055226.GA701624@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Did you mean to send this twice?

Sorry for that, I screwed things up a first time when sending the
patches: only included the CAN mailing list
(linux-can@vger.kernel.org) but ommitted linux-kernel@vger.kernel.org
in the cover letter. As a result, it broke the chain reply on lkml.org
so I preferred to resend it.

> > And where are the 5 other patches in this series?

I used the --cc-cmd="scripts/get_maintainer.pl -i" option in git
send-email to send the series. The five other patches are not related
to USB core but to CAN core, so you were not included in CC by the
script. Now, I understand this is confusing, I will take care to CC
you on the full series when sending V2. One more time, sorry for that.

For your information, the full patch series is available here:
https://lkml.org/lkml/2020/9/26/319

> > And finally, it's a good idea to include the output of 'lsusb -v' for
> > devices that need quirks so we can figure things out later on, can you
> > fix up your changelog to include that information?

Noted, will be included in v2 of the patch series.

> Also, why is the device saying it is a cdc-acm compliant device when it
> is not?  Why lie to the operating system like that?

This is a leftover debug feature used during development. Future
firmware version will have it remove but users with older revision
will still face this issue which can be confusing.

I will also amend the changelog to better reflect above reason.
