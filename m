Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308D61B34FD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 04:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDVC0d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 22:26:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:46504 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVC0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 22:26:32 -0400
IronPort-SDR: 5oKxXyWBQ8rTr7ka/EEOdbZU6TNs/y4dhTH2bKNPcYKES3RaDlzLofMEf3mX61fFFNJgQLwtnv
 ghtlJ2N34Gwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 19:26:32 -0700
IronPort-SDR: XouFMgm3UzRANmXEwFh47GXqORtvDI7Fw0gdniRv0HcWWTppv0jqJqHmNsw/dY2m4plb4sChAm
 m/3AwyzWarKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="258910745"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2020 19:26:32 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 19:26:31 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX116.amr.corp.intel.com ([169.254.7.87]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 19:26:31 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Subject: RE: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Thread-Topic: [net-next 3/4] i40e: Add support for a new feature: Total Port
 Shutdown
Thread-Index: AQHWF38oXbYwrraOr02XwU5N6bu+wKiEUoqA///VLFCAALYCgP//i0LQ
Date:   Wed, 22 Apr 2020 02:26:31 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986705C1@ORSMSX112.amr.corp.intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-4-jeffrey.t.kirsher@intel.com>
        <20200421105551.6f41673a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498670105@ORSMSX112.amr.corp.intel.com>
 <20200421191359.0a48133b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421191359.0a48133b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 21, 2020 19:14
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Kubalewski, Arkadiusz
> <arkadiusz.kubalewski@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kwapulinski, Piotr
> <piotr.kwapulinski@intel.com>; Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com>
> Subject: Re: [net-next 3/4] i40e: Add support for a new feature: Total Port
> Shutdown
> 
> On Tue, 21 Apr 2020 22:36:21 +0000 Kirsher, Jeffrey T wrote:
> > > -----Original Message-----
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Tuesday, April 21, 2020 10:56
> > > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > > Cc: davem@davemloft.net; Kubalewski, Arkadiusz
> > > <arkadiusz.kubalewski@intel.com>; netdev@vger.kernel.org;
> > > nhorman@redhat.com; sassmann@redhat.com; Kwapulinski, Piotr
> > > <piotr.kwapulinski@intel.com>; Loktionov, Aleksandr
> > > <aleksandr.loktionov@intel.com>; Bowers, AndrewX
> > > <andrewx.bowers@intel.com>
> > > Subject: Re: [net-next 3/4] i40e: Add support for a new feature:
> > > Total Port Shutdown
> > >
> > > On Mon, 20 Apr 2020 18:49:31 -0700 Jeff Kirsher wrote:
> > > > From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> > > >
> > > > Currently after requesting to down a link on a physical network
> > > > port, the traffic is no longer being processed but the physical
> > > > link with a link partner is still established.
> > > >
> > > > Total Port Shutdown allows to completely shutdown the port on the
> > > > link-down procedure by physically removing the link from the port.
> > > >
> > > > Introduced changes:
> > > > - probe NVM if the feature was enabled at initialization of the
> > > > port
> > > > - special handling on link-down procedure to let FW physically
> > > > shutdown the port if the feature was enabled
> > >
> > > How is this different than link-down-on-close?
> > [Kirsher, Jeffrey T]
> >
> > First of all total-port-shutdown is a read only flag, the user cannot
> > set it from the OS.  It is possible to set it in bios, but only if the
> > motherboard supports it and the NIC has that capability.  Also, the
> > behavior on both slightly differs, link-down-on-close brings the link
> > down by sending (to firmware) phy_type=0, while total-port-shutdown
> > does not, the phy_type is not changed, instead firmware is using
> > I40E_AQ_PHY_ENABLE_LINK flag.
> 
> I see. IOW it's a flag that says the other flag is hard wired to on.
> 
> Why is it important to prevent user from performing the configuration?
> What if an old kernel is run which won't prevent it?
> 
> Let's drill down into what we actually want to express here and then look at the
> API. Michal has already converted ethtool link info to netlink..
[Kirsher, Jeffrey T] 

I know this feature was driven from a customer request/demand where the
link-down-on-close was not sufficient or caused issues.  I want to confirm what
I believe to be the answers to your questions before I respond to them.

> 
> > > Perhaps it'd be good to start documenting the private flags in
> > > Documentation/
> > [Kirsher, Jeffrey T]
> >
> > We could look at adding that information into our kernel
> > documentation, I am planning on updating the driver documentation in a
> > follow-up patch set.  Would a descriptive code comment help in this case?
> 
> Documentation should be sufficient, IMHO, if it's coming soon.
[Kirsher, Jeffrey T] 

It will be for the 5.8 kernel...  Probably won't be next week, will most likely be
1-2 weeks before I get to those changes/patch.
