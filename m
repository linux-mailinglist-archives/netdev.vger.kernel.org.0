Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549F0122F7B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfLQO4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:56:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:40919 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfLQO4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 09:56:39 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 06:56:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="221779419"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 17 Dec 2019 06:56:33 -0800
Received: by lahna (sSMTP sendmail emulation); Tue, 17 Dec 2019 16:56:32 +0200
Date:   Tue, 17 Dec 2019 16:56:32 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20191217145632.GM2913417@lahna.fi.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
 <20191217123345.31850-4-mika.westerberg@linux.intel.com>
 <20191217124745.GC3175457@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217124745.GC3175457@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:47:45PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Dec 17, 2019 at 03:33:39PM +0300, Mika Westerberg wrote:
> > USB4 1.0 section 6.4.2.7 specifies a new field (PG) in notification
> > packet that is sent as response of hot plug/unplug events. This field
> > tells whether the acknowledgment is for plug or unplug event. This needs
> > to be set accordingly in order the router to send further hot plug
> > notifications.
> > 
> > To make it simpler we fill the field unconditionally. Legacy devices do
> > not look at this field so there should be no problems with them.
> > 
> > While there rename tb_cfg_error() to tb_cfg_ack_plug() and update the
> > log message accordingly. The function is only used to ack plug/unplug
> > events.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> First 3 patches look "trivial" enough for me to take right now, any
> objection to that?

No objections from my side :)

> Should I be using my usb tree for this?

Yes, I think it makes sense now that this is also under USB IF umbrella.
