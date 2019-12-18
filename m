Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51451249D1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfLROgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfLROgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:36:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE05021582;
        Wed, 18 Dec 2019 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576679774;
        bh=FpUdA1QKWT2FMoEcuoACKH1w02F3qC9LrxYVeOcepE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z5JFSoDvpzTAXEgxhZ7iNHCLZuS4ul/I/bJ9fRGugJEaqGuSVh++cYgwa1TfAVnbv
         vH3NhLDpEGPmGVktvsZcR0DZsrZIb8gKL4o2X/eFyY9ICzUcbTBUhiliW/X6jogrLa
         puk47+4oaztkf/u+YpulP7S+2dY2IMw+V4FiFy1Y=
Date:   Wed, 18 Dec 2019 15:36:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Mario.Limonciello@dell.com" <Mario.Limonciello@dell.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/9] thunderbolt: Add initial support for USB4
Message-ID: <20191218143612.GB262880@kroah.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
 <20191217123345.31850-5-mika.westerberg@linux.intel.com>
 <PSXP216MB043843D1E5E4A65780272FB480530@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PSXP216MB043843D1E5E4A65780272FB480530@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 09:34:45AM +0000, Nicholas Johnson wrote:
> On Tue, Dec 17, 2019 at 03:33:40PM +0300, Mika Westerberg wrote:
> > USB4 is the public specification based on Thunderbolt 3 protocol. There
> > are some differences in register layouts and flows. In addition to PCIe
> > and DP tunneling, USB4 supports tunneling of USB 3.x. USB4 is also
> > backward compatible with Thunderbolt 3 (and older generations but the
> > spec only talks about 3rd generation). USB4 compliant devices can be
> > identified by checking USB4 version field in router configuration space.
> > 
> > This patch adds initial support for USB4 compliant hosts and devices
> > which enables following features provided by the existing functionality
> > in the driver:
> > 
> >   - PCIe tunneling
> >   - Display Port tunneling
> Nitpick: DisplayPort is a single word.

Please learn to trim replies, it was a pain to read this message :(

