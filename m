Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A955229B62
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgGVPaK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 11:30:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:6953 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGVPaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 11:30:09 -0400
IronPort-SDR: 6WM0p49slsEhrH0+V9ZOHqpjG9APop5dQ4Y7eDA2WOCHt83VQDCmnoB/ALmTl2JaMKRepdLbrk
 ehkk3iRQIPdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="129918259"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="129918259"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 08:30:08 -0700
IronPort-SDR: OpfI6sv5i9/gYuJHWizsrOteqggwm26SuIkkq/zAQ84MJls58BbgLyElcoAZSrC2c0wkZiWuJf
 Eh8jntnYSLOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="320322680"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jul 2020 08:30:08 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 08:30:08 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.197]) by
 fmsmsx116.amr.corp.intel.com ([169.254.2.175]) with mapi id 14.03.0439.000;
 Wed, 22 Jul 2020 08:30:06 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: RE: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Thread-Topic: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Thread-Index: AQHWXGkWpIyL0eKMZEaJgkZjv01FKakQuFiAgABflYCAAXFaAIAANSEAgAEqRYD//9a2cA==
Date:   Wed, 22 Jul 2020 15:30:05 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
In-Reply-To: <20200722105139.GA3154@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jiri Pirko
> Sent: Wednesday, July 22, 2020 3:52 AM
> To: Jakub Kicinski <kubakici@wp.pl>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; Tom
> Herbert <tom@herbertland.com>; Jiri Pirko <jiri@mellanox.com>; Jakub Kicinski
> <kuba@kernel.org>; Jonathan Corbet <corbet@lwn.net>; Michael Chan
> <michael.chan@broadcom.com>; Bin Luo <luobin9@huawei.com>; Saeed
> Mahameed <saeedm@mellanox.com>; Leon Romanovsky <leon@kernel.org>;
> Ido Schimmel <idosch@mellanox.com>; Danielle Ratson
> <danieller@mellanox.com>
> Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
> update
> 
> Tue, Jul 21, 2020 at 07:04:06PM CEST, kubakici@wp.pl wrote:
> >On Tue, 21 Jul 2020 15:53:56 +0200 Jiri Pirko wrote:
> >> Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
> >> >On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
> >> >> This looks odd. You have a single image yet you somehow divide it
> >> >> into "program" and "config" areas. We already have infra in place to
> >> >> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
> >> >> You should have 2 components:
> >> >> 1) "program"
> >> >> 2) "config"
> >> >>
> >> >> Then it is up to the user what he decides to flash.
> >> >
> >> >99.9% of the time users want to flash "all". To achieve "don't flash
> >> >config" with current infra users would have to flash each component
> >>
> >> Well you can have multiple component what would overlap:
> >> 1) "program" + "config" (default)
> >> 2) "program"
> >> 3) "config"
> >
> >Say I have FW component and UNDI driver. Now I'll have 4 components?
> >fw.prog, fw.config, undi.prog etc? Are those extra ones visible or just
> 
> Visible in which sense? We don't show components anywhere if I'm not
> mistaken. They are currently very rarely used. Basically we just ported
> it from ethtool without much thinking.
> 

Component names are used in devlink info and displayed to end users along with versions, plus they're names passed by the user in devlink flash update. As far as documented, we shouldn't add new components without associated versions in the info report.

> 
> >"implied"? If they are visible what version does the config have?
> 
> Good question. we don't have per-component version so far. I think it
> would be good to have it alonside with the listing.
> 
> 
> >
> >Also (3) - flashing config from one firmware version and program from
> >another - makes a very limited amount of sense to me.
> >
> >> >one by one and then omit the one(s) which is config (guessing which
> >> >one that is based on the name).
> >> >
> >> >Wouldn't this be quite inconvenient?
> >>
> >> I see it as an extra knob that is actually somehow provides degradation
> >> of components.
> >
> >Hm. We have the exact opposite view on the matter. To me components
> >currently correspond to separate fw/hw entities, that's a very clear
> >meaning. PHY firmware, management FW, UNDI. Now we would add a
> >completely orthogonal meaning to the same API.
> 
> I understand. My concern is, we would have a component with some
> "subparts". Now it is some fuzzy vagely defined "config part",
> in the future it might be something else. That is what I'm concerned
> about. Components have clear api.
> 
> So perhaps we can introduce something like "component mask", which would
> allow to flash only part of the component. That is basically what Jacob
> has, I would just like to have it well defined.
> 
> 

So, we could make this selection a series of masked bits instead of a single enumeration value.
