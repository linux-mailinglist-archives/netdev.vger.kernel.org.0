Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C017483FB6
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiADKRw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 05:17:52 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:44897 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiADKRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:17:51 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id B22BE20000A;
        Tue,  4 Jan 2022 10:17:49 +0000 (UTC)
Date:   Tue, 4 Jan 2022 11:17:48 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [wpan-tools 6/7] iwpan: Add full scan support
Message-ID: <20220104111748.5a4f99de@xps13>
In-Reply-To: <CAB_54W5Nhhmz2paJ+RjscqFqHo1kZJf-3NPiGP8PAjWGjhecqA@mail.gmail.com>
References: <20211222155816.256405-1-miquel.raynal@bootlin.com>
        <20211222155816.256405-7-miquel.raynal@bootlin.com>
        <CAB_54W5Nhhmz2paJ+RjscqFqHo1kZJf-3NPiGP8PAjWGjhecqA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 22 Dec 2021 12:19:36 -0500:

> Hi,
> 
> I did a quick overlook of those patches and I am very happy to see
> such patches and I will try them out in the next few days! Thanks.

Sure, thanks for the feedback all along this series, I'll try to
discuss and address all the points you raised.

> On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > From: David Girault <david.girault@qorvo.com>
> >
> > Bring support for different scanning operations, such as starting or
> > aborting a scan operation with a given configuration, dumping the list
> > of discovered PANs, and flushing the list.
> >
> > It also brings support for a couple of semi-debug features, such as a
> > manual beacon request to ask sending or stopping beacons out of a
> > particular interface. This is particularly useful when trying to
> > validate the scanning support without proper hardware.
> >
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  DEST/usr/local/bin/iwpan      | Bin 0 -> 178448 bytes
> >  DEST/usr/local/bin/wpan-hwsim | Bin 0 -> 45056 bytes
> >  DEST/usr/local/bin/wpan-ping  | Bin 0 -> 47840 bytes  
> 
> I think those binaries were added by accident, or?

Oops! Of course I'll drop them all.

Thanks,
Miquèl
