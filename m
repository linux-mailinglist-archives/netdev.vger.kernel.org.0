Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D288924A4A1
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHSRGj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 13:06:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:60815 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSRGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 13:06:38 -0400
IronPort-SDR: Fy9hItZLrqkCD8MI8ivH9i16R1Xv6znMMYB+arXhKoRJYHydB9dEx9CyhNqI25pz3dTtgKfR3f
 wCPsWJgGpgxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="152768705"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="152768705"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 10:06:36 -0700
IronPort-SDR: a9pJ5hjEUCcpgRMMiANGkcgXBaEvvuzRaEVGL65DFMIdy0AbXZ+1XGyW8xytEyDghTYZY6MEw5
 kwgUgCTp7RZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="497310998"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2020 10:06:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Aug 2020 10:06:36 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Aug 2020 10:06:36 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.123]) by
 fmsmsx121.amr.corp.intel.com ([169.254.6.67]) with mapi id 14.03.0439.000;
 Wed, 19 Aug 2020 10:06:36 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next v3 3/4] devlink: introduce flash update overwrite mask
Thread-Topic: [net-next v3 3/4] devlink: introduce flash update overwrite
 mask
Thread-Index: AQHWdb+yM0bJRueYr0avi83VvTOY76k/QtSAgABTn1CAAH+KAP//lDpQ
Date:   Wed, 19 Aug 2020 17:06:34 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8B9C0F5@fmsmsx101.amr.corp.intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-4-jacob.e.keller@intel.com>
        <20200818205451.35191c0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <02874ECE860811409154E81DA85FBB58C8B9BF18@fmsmsx101.amr.corp.intel.com>
 <20200819093038.2d448fee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819093038.2d448fee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
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
> Sent: Wednesday, August 19, 2020 9:31 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next v3 3/4] devlink: introduce flash update overwrite mask
> 
> On Wed, 19 Aug 2020 16:01:02 +0000 Keller, Jacob E wrote:
> > > > -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
> > > > +#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT
> 	BIT(0)
> > > > +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
> > >
> > > Since core will check supported flags, I'd be tempted to have a flag
> > > for each override type. Saves an 'if' in every driver.
> >
> > Combinations might not be valid (as in ice where identifiers alone
> > isn't supportable) but I suppose I could add something for it.
> 
> I see, looking at the i40e patch it does seem to not matter in practice
> if core checks this or not.
> 

Right, I have it checking to make sure if you don't support the overwrite at all, then the attribute will be rejected but I expect that ultimately drivers will have to check the exact set of combinations they support, and convert them to the driver/firmware-specific values they have.

> > Would it make sense to just add them to the
> > supported_flash_update_params? This results in a bit offset where the
> > "supported" bits don't match the actual used bits in overwrite_mask,
> > so we could also introduce a separate "supported_overwrite_mask" but
> > that might just be overkill since I doubt we'll need to add more than
> > a handlful of overwrite bits...
> >
> > > >  struct devlink_region;
> > > >  struct devlink_info_req;
> > > > diff --git a/include/uapi/linux/devlink.h
> > > > b/include/uapi/linux/devlink.h index cfef4245ea5a..1d8bbe9c1ae1
> > > > 100644 --- a/include/uapi/linux/devlink.h
> > > > +++ b/include/uapi/linux/devlink.h
> > > > @@ -228,6 +228,28 @@ enum {
> > > >  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
> > > >  };
> > > >
> > > > +/* Specify what sections of a flash component can be overwritten
> > > > when
> > > > + * performing an update. Overwriting of firmware binary sections
> > > > is always
> > > > + * implicitly assumed to be allowed.
> > > > + *
> > > > + * Each section must be documented in
> > > > + * Documentation/networking/devlink/devlink-flash.rst
> > > > + *
> > > > + */
> > > > +enum {
> > > > +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
> > > > +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
> > >
> > > IMHO generally a good practice to have 0 be undefined.
> >
> > Even for bits? I saw that for attribute values 0 was undefined, but
> > that didn't seem right for a bit position. sending the bitfield with
> > zero bit set means the same as not sending the bitfield.
> 
> Ah, misread the code, sorry.
