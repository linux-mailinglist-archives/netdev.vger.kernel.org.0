Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04B286ED1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 08:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgJHGro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 02:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgJHGro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 02:47:44 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F49C061755;
        Wed,  7 Oct 2020 23:47:43 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4C6MG439PFzKmkc;
        Thu,  8 Oct 2020 08:47:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1602139656; bh=jUXIoA5ofK
        SgFEFV/CVi6d3U/mI3bQmSkxB6+AzdIGo=; b=wSgAvT7wi+74v14rK9gjrPgDk7
        /ilBkjmV1lJfxwV98SPh5rI/Jq8mtvEMe+7R7BRQMfv6ZOAj80JyOHZOVfdbI+Jx
        0thjDKr37vpwbaD+5CCdpBJG3opObBpAYmD/vx+udoW1SZtt+pUf8ZYLCS8WVo5m
        8yJ2rDlha7sf3lB7Mpz6EqRWu5GVL+nlK3fyl/q4eZ3ZVa9A5Ku5NGSxtBnYSah0
        OjtfU4OEIzfxE/qLHnKgpYZ9IJMAmwD1VLG+LhNFGeTjgFH+lQhyAvk9fqQUe2eC
        Eqdsl2n8QXvXjmuMfoTlIaz7Bosc7nnCbAeI2lda4qmoGX3NxuOA9i+y/KIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1602139658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ab538Rm1sSZQYzulkykYNmyxv6Ukn8i2E6k9sTNN+ro=;
        b=YEl1FfPwNQERwDiAEDB3Y0oZRSdAM7ZAoM7hpV7IG9bmL+7jyjTkoXZbvX+t4MxXLarzr7
        NE4R5HWO9cbx16RtypjuE9ngEFbGYnp+btjglLz6KBlNk3nNIv6NAfj6dTb+v6lxJCEk8N
        yac9fpL1PjDfr0+c2kRm/kmGjttM270nZ6tX0KSf2TDI5edR3Uey6ZlDP/Bzx+GNZ+j369
        6X9+uDO+heig7gH+NvRSXJrHt/dNROie+w9RjulO1CDGjHVWtxabulWj+dwFSCPivPoDQD
        bl6LbiV0eF8+6/QCZjtRLOSo9tTTJ9XtR6wKR8FAp4N0K2x8i8V2fnuTf/nHrg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id gqVnwssnlTsi; Thu,  8 Oct 2020 08:47:36 +0200 (CEST)
Date:   Thu, 8 Oct 2020 08:47:33 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Lars Melin <larsm17@gmail.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201008084733.41ba3cec@monster.powergraphx.local>
In-Reply-To: <20201006070201.GB26280@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org>
        <20201005082045.GL5141@localhost>
        <20201005130134.459b4de9@monster.powergraphx.local>
        <20201005110638.GP5141@localhost>
        <5222246c-08d7-dcf8-248d-c1fefc72c46f@gmail.com>
        <20201005140723.56f6c434@monster.powergraphx.local>
        <20201006070201.GB26280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -7.08 / 15.00 / 15.00
X-Rspamd-Queue-Id: D1652181D
X-Rspamd-UID: cd4ae1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 09:02:01 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Mon, Oct 05, 2020 at 02:07:23PM +0200, Wilken Gottwalt wrote:
> > On Mon, 5 Oct 2020 18:36:36 +0700 Lars Melin <larsm17@gmail.com> wrote:
> > > On 10/5/2020 18:06, Johan Hovold wrote:
> 
> > > > Do you remember the interface layout and why you blacklisted interface
> > > > 1?
> 
> > > It is very likely that Cellient has replaced the VID with their own and 
> > > kept the PID, it is something other mfgrs has done when buying modules 
> > > from Qualcomm's series of devices with predefined composition.
> > > 
> > > The MS Windows driver for 05c6:9025 describes the interfaces as:
> > > 
> > > MI_00 Qualcomm HS-USB Diagnostics 9025
> > > MI_01 Android Composite ADB Interface
> > > MI_02 Qualcomm HS-USB Android Modem 9025
> > > MI_03 Qualcomm HS-USB NMEA 9025
> > > MI_04 Qualcomm Wireless HS-USB Ethernet Adapter 9025
> > > MI_05 USB Mass Storage Device
> > > 
> > > where the net interface is for QMI/RMNET.
> > > It fully matches the blacklisting Wilken has done for 2692:9025
> > 
> > Does your device have a GPS connector? Mine had not and I'm not sure
> > if the description of MI_01 is actually correct. I remember looking at
> > this port and seeing bogus NMEA data.
> 
> Well if it's NMEA then the interface shouldn't be blacklisted (even if
> the values are bogus on your device), but if it's ADB it should be as
> that is handled by userspace.
> 
> Here's some lsusb output from a Cellient MPL200 that still uses the
> Qualcomm VID:
> 
> 	https://www.mail-archive.com/modemmanager-devel@lists.freedesktop.org/msg04523.html
> 
> which gives some support to Lars's hypothesis. I guess we'll just keep
> the first interface reserved.

Lars and Johan are right here. I found an older external Gobi driver
where I actually added comments saying interface 1 is ADB and interface 3
is NMEA delivering only zeroed values because of the missing antenna
connector, at least for the models I had access to.

Will
