Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F29D24A3AC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgHSQBJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 12:01:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:13762 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgHSQBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:01:06 -0400
IronPort-SDR: b5e4uCjYN1ABdXuOdUW0upiXztncDfcVkIgTPagS4C4mwDmuoiwAIT4ElREnOj7fYrsWhXzOpx
 aArBvgkflGsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239972238"
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="239972238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 09:01:04 -0700
IronPort-SDR: YH6ITDJXazljFOv3u5kX8+PkOv7OtfZUj+i4P3YILMGTNq7X1Ewk5d/QJY4Gc/g/O4qAtzuHPO
 VWKvfSdRKVyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="337003677"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by orsmga007.jf.intel.com with ESMTP; 19 Aug 2020 09:01:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Aug 2020 09:01:03 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Aug 2020 09:01:03 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.123]) by
 FMSMSX157.amr.corp.intel.com ([169.254.14.153]) with mapi id 14.03.0439.000;
 Wed, 19 Aug 2020 09:01:02 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next v3 3/4] devlink: introduce flash update overwrite mask
Thread-Topic: [net-next v3 3/4] devlink: introduce flash update overwrite
 mask
Thread-Index: AQHWdb+yM0bJRueYr0avi83VvTOY76k/QtSAgABTn1A=
Date:   Wed, 19 Aug 2020 16:01:02 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8B9BF18@fmsmsx101.amr.corp.intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-4-jacob.e.keller@intel.com>
 <20200818205451.35191c0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818205451.35191c0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 18, 2020 8:55 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next v3 3/4] devlink: introduce flash update overwrite mask
> 
> On Tue, 18 Aug 2020 17:28:17 -0700 Jacob Keller wrote:
> > +The ``devlink-flash`` command allows optionally specifying a mask indicating
> > +the how the device should handle subsections of flash components when
> 
> remove one 'the'?
> 
> > +updating. This mask indicates the set of sections which are allowed to be
> > +overwritten.
> 
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index ebfc4a698809..74a869fbaa67 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -201,6 +201,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev
> *nsim_dev)
> >  		return PTR_ERR(nsim_dev->ports_ddir);
> >  	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
> >  			    &nsim_dev->fw_update_status);
> > +	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev-
> >ddir,
> > +			    &nsim_dev->fw_update_overwrite_mask);
> 
> Nice to see the test, but netdevsim changes could be separated out :S
> 

Yea I can do that

> >  	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
> >  			   &nsim_dev->max_macs);
> >  	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
> 
> > -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
> > +#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
> > +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
> 
> Since core will check supported flags, I'd be tempted to have a flag
> for each override type. Saves an 'if' in every driver.
> 

Combinations might not be valid (as in ice where identifiers alone isn't supportable) but I suppose I could add something for it.

Would it make sense to just add them to the supported_flash_update_params? This results in a bit offset where the "supported" bits don't match the actual used bits in overwrite_mask, so we could also introduce a separate "supported_overwrite_mask" but that might just be overkill since I doubt we'll need to add more than a handlful of overwrite bits...

> >  struct devlink_region;
> >  struct devlink_info_req;
> > diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> > index cfef4245ea5a..1d8bbe9c1ae1 100644
> > --- a/include/uapi/linux/devlink.h
> > +++ b/include/uapi/linux/devlink.h
> > @@ -228,6 +228,28 @@ enum {
> >  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
> >  };
> >
> > +/* Specify what sections of a flash component can be overwritten when
> > + * performing an update. Overwriting of firmware binary sections is always
> > + * implicitly assumed to be allowed.
> > + *
> > + * Each section must be documented in
> > + * Documentation/networking/devlink/devlink-flash.rst
> > + *
> > + */
> > +enum {
> > +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
> > +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
> 
> IMHO generally a good practice to have 0 be undefined.
> 

Even for bits? I saw that for attribute values 0 was undefined, but that didn't seem right for a bit position. sending the bitfield with zero bit set means the same as not sending the bitfield.

> > +	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
> > +	DEVLINK_FLASH_OVERWRITE_MAX_BIT =
> __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
> > +};
