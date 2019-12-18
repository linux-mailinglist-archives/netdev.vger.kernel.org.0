Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26BC1249CE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfLROfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfLROfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:35:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F6621582;
        Wed, 18 Dec 2019 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576679735;
        bh=G9LOa7DDtMFx6fo5UNpdN4LqcfbHJ8Jh2m+0GPeXuW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EPDQCciNs0RAV9AJVWl23tHKtSKOkMBOLKuP3kEpUcXdTsZtQUwwogVgKAkGL/HS1
         UQqgpSY/vhYN1FntjSRk3E55/X8RxbOGsn09dgwC0FeiW2G4HomiMTKl66gpXmQmYo
         oxUbVn3C+jija+IcvpdVLIbt1rJB51EaKgt7Wdtg=
Date:   Wed, 18 Dec 2019 15:35:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] thunderbolt: Populate PG field in hot plug
 acknowledgment packet
Message-ID: <20191218143533.GA262880@kroah.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
 <20191217123345.31850-4-mika.westerberg@linux.intel.com>
 <20191217124745.GC3175457@kroah.com>
 <20191217145632.GM2913417@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217145632.GM2913417@lahna.fi.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 04:56:32PM +0200, Mika Westerberg wrote:
> On Tue, Dec 17, 2019 at 01:47:45PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Dec 17, 2019 at 03:33:39PM +0300, Mika Westerberg wrote:
> > > USB4 1.0 section 6.4.2.7 specifies a new field (PG) in notification
> > > packet that is sent as response of hot plug/unplug events. This field
> > > tells whether the acknowledgment is for plug or unplug event. This needs
> > > to be set accordingly in order the router to send further hot plug
> > > notifications.
> > > 
> > > To make it simpler we fill the field unconditionally. Legacy devices do
> > > not look at this field so there should be no problems with them.
> > > 
> > > While there rename tb_cfg_error() to tb_cfg_ack_plug() and update the
> > > log message accordingly. The function is only used to ack plug/unplug
> > > events.
> > > 
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > First 3 patches look "trivial" enough for me to take right now, any
> > objection to that?
> 
> No objections from my side :)
> 
> > Should I be using my usb tree for this?
> 
> Yes, I think it makes sense now that this is also under USB IF umbrella.

Ok, now done, thanks.

greg k-h
