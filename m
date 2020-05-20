Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29301DA7A9
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgETCDI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 22:03:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:1550 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgETCDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 22:03:07 -0400
IronPort-SDR: ScJqahLTVYw8PY7IfZAkCJg3L0Uhe38mm4NowYg5b3HW+bzzyGGNKxTZgAxpkAEfHJoyKaxL0H
 3O+dv6F9Xijg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 19:03:07 -0700
IronPort-SDR: S3lvo9b5n1NV8B1tPpM4iHh4tBhSgIgN98HG7rnUMaKWHrRUOiqrfToyc9xK/MCu6OzwI51AJs
 6/0rWL0RoQ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,412,1583222400"; 
   d="scan'208";a="282520023"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 19 May 2020 19:03:07 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 19 May 2020 19:03:07 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.218]) with mapi id 14.03.0439.000;
 Tue, 19 May 2020 19:03:06 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Thread-Topic: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Thread-Index: AQHWLjo4zxakhy/5jEi2QtFU4xpWyaiwrcAA//+LEQA=
Date:   Wed, 20 May 2020 02:03:06 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986C170F@ORSMSX112.amr.corp.intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
 <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519190026.5334f3c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, May 19, 2020 19:00
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com
> Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
> Updates 2020-05-19
> 
> On Tue, 19 May 2020 17:04:05 -0700 Jeff Kirsher wrote:
> > This series contains updates to igc only.
> >
> > Sasha cleans up the igc driver code that is not used or needed.
> >
> > Vitaly cleans up driver code that was used to support Virtualization
> > on a device that is not supported by igc, so remove the dead code.
> >
> > Andre renames a few macros to align with register and field names
> > described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> > and EType Queue Filter registers to the list of registers dumped by
> > igc_get_regs().  Added additional debug messages and updated return
> > codes for unsupported features.  Refactored the VLAN priority
> > filtering code to move the core logic into igc_main.c.  Cleaned up
> > duplicate code and useless code.
> 
> No automated warnings :)
> 
> It's a little strange how both TCI and ETYPE filters take the queue ID.
> Looking at the code it's not immediately clear which one take precedence. Can
> I install two rules for the same TCI and different ETYPE or vice versa?
[Kirsher, Jeffrey T] 

Adding Andre and Sasha to answer your questions, Jakub...
