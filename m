Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0024A38D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgHSPxf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 11:53:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:24494 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgHSPxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:53:34 -0400
IronPort-SDR: UAjLYH4pREmI4RcxZVmeGNE6hmwTtaHuKuJJS9SppzSCMz12S2eJcP0Cw2mte6hPwIm6hRsq+f
 hmOA14m8mHiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152556324"
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="152556324"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 08:53:34 -0700
IronPort-SDR: kmbpl96Ql5MiSgcIQMESqkLJrCJBDGjoKrCthuungR792E65fRnLdCyN+laBJ/LvepB1LARBUo
 t04yP+VISd4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="400865692"
Received: from fmsmsx601-2.cps.intel.com (HELO fmsmsx601.amr.corp.intel.com) ([10.18.84.211])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2020 08:53:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Aug 2020 08:53:33 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Aug 2020 08:53:33 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.123]) by
 FMSMSX102.amr.corp.intel.com ([169.254.10.17]) with mapi id 14.03.0439.000;
 Wed, 19 Aug 2020 08:53:33 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: RE: [net-next v3 1/4] devlink: check flash_update parameter support
 in net core
Thread-Topic: [net-next v3 1/4] devlink: check flash_update parameter
 support in net core
Thread-Index: AQHWdb+yKS6plKNeTEeW3+DGjk9Bg6k/QEMAgABSEQA=
Date:   Wed, 19 Aug 2020 15:53:32 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8B9BEF6@fmsmsx101.amr.corp.intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-2-jacob.e.keller@intel.com>
 <20200818204540.2a278200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818204540.2a278200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> Sent: Tuesday, August 18, 2020 8:46 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Jonathan Corbet
> <corbet@lwn.net>; Michael Chan <michael.chan@broadcom.com>; Bin Luo
> <luobin9@huawei.com>; Saeed Mahameed <saeedm@mellanox.com>; Leon
> Romanovsky <leon@kernel.org>; Ido Schimmel <idosch@mellanox.com>;
> Danielle Ratson <danieller@mellanox.com>
> Subject: Re: [net-next v3 1/4] devlink: check flash_update parameter support in
> net core
> 
> On Tue, 18 Aug 2020 17:28:15 -0700 Jacob Keller wrote:
> >  struct devlink_ops {
> > +	/**
> > +	 * @supported_flash_update_params:
> > +	 * mask of parameters supported by the driver's .flash_update
> > +	 * implemementation.
> > +	 */
> > +	u32 supported_flash_update_params;
> 
> To be sure - this doesn't generate W=1 warnings?
> 

I didn't see any pop out in devlink.c with an allyesconfig or an allmodconfig.

> Sadly the posting confused patchwork series grouping and my build tester
> (I think it's the iproute patches mixed with the kernel stuff).

Hmm. I split them up but I guess it still threaded them when I sent them. I'll just send them using two separate send-emails in the future.

Thanks,
Jake
