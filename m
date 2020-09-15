Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10991269AB6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgIOAwf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Sep 2020 20:52:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:2061 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgIOAwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 20:52:35 -0400
IronPort-SDR: rQOIoU29IzXLafQdsXaMY1ItU5vOmnScmeq8nqFMvH+oKgxlK91EX1NKYb73DyuGNX+YsdFENw
 HzDrcO4JsJTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158465903"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="158465903"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 17:52:35 -0700
IronPort-SDR: MZ8oNwqMPSRetKGA38r9yyCyjgr+EVZ/3G0KFpgtrWVFu0u/Ofl5AmUEovOoQI8BV1dAQdvc6R
 Aov6L7H0pzSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="506552030"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 14 Sep 2020 17:52:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 17:52:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 17:52:34 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Mon, 14 Sep 2020 17:52:34 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Thread-Topic: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Thread-Index: AQHWhjIy1XtTgA09OkC4iFBec0oM7alf38CAgAEUNQCAAAX0AIAAFKSAgAAXiYCAAGgMgIABEk6AgAY9zQCAAGpXgP//n/EQ
Date:   Tue, 15 Sep 2020 00:52:34 +0000
Message-ID: <6a91a0d73a1747038d7d0d8a40cb5273@intel.com>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
 <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Monday, September 14, 2020 4:36 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Shannon Nelson <snelson@pensando.io>; netdev@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
> 
> On Mon, 14 Sep 2020 16:15:28 -0700 Jacob Keller wrote:
> > On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
> > > IOW drop the component parameter from the normal helper, cause almost
> > > nobody uses that. The add a more full featured __ version, which would
> > > take the arg struct, the struct would include the timeout value.
> > >
> > I would point out that the ice driver does use it to help indicate which
> > section of the flash is currently being updated.
> >
> > i.e.
> >
> > $ devlink dev flash pci/0000:af:00.0 file firmware.bin
> > Preparing to flash
> > [fw.mgmt] Erasing
> > [fw.mgmt] Erasing done
> > [fw.mgmt] Flashing 100%
> > [fw.mgmt] Flashing done 100%
> > [fw.undi] Erasing
> > [fw.undi] Erasing done
> > [fw.undi] Flashing 100%
> > [fw.undi] Flashing done 100%
> > [fw.netlist] Erasing
> > [fw.netlist] Erasing done
> > [fw.netlist] Flashing 100%
> > [fw.netlist] Flashing done 100%
> >
> > I'd like to keep that, as it helps tell which component is currently
> > being updated. If we drop this, then either I have to manually build
> > strings which include the component name, or we lose this information on
> > display.
> 
> Thanks for pointing that out. My recollection was that ice and netdevsim
> were the only two users, so I thought those could use the full __*
> helper and pass an arg struct. But no strong feelings.

Yea that would work for me :)

Thanks,
Jake
