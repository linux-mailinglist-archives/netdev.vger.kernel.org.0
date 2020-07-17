Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F860224586
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGQVBM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 17:01:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:50542 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgGQVBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 17:01:12 -0400
IronPort-SDR: zZaPwD7TmLIOkDKJR1VGNlTgV2QDWF9BMLusCutdQlEAseAnoF7Xv9oJZuFVqU65eJvZKwPHvH
 JrBNTrApvh2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="214378917"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="214378917"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 14:00:58 -0700
IronPort-SDR: h+HCofEphvJzpxlu7r4qo56jIMl6b0voYXMA+RMyO0GtwtS5Yqv/jLW2xMdR9X2C+sbE1tx07c
 NrBw2xGnwRUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="270911646"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jul 2020 14:00:58 -0700
Received: from orsmsx151.amr.corp.intel.com ([169.254.7.24]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.169]) with mapi id 14.03.0439.000;
 Fri, 17 Jul 2020 14:00:57 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kubakici@wp.pl>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
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
Subject: RE: [RFC PATCH net-next v2 0/6] introduce PLDM firmware update
 library
Thread-Topic: [RFC PATCH net-next v2 0/6] introduce PLDM firmware update
 library
Thread-Index: AQHWXGkVCyNxIZF1QUWKu5DGKx31NqkMpcoA//+bkxA=
Date:   Fri, 17 Jul 2020 21:00:56 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8ABA9D9@ORSMSX151.amr.corp.intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717125826.1f0b3fbb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200717125826.1f0b3fbb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Friday, July 17, 2020 12:58 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@resnulli.us>; Tom Herbert
> <tom@herbertland.com>; Jiri Pirko <jiri@mellanox.com>; Jakub Kicinski
> <kuba@kernel.org>; Jonathan Corbet <corbet@lwn.net>; Michael Chan
> <michael.chan@broadcom.com>; Bin Luo <luobin9@huawei.com>; Saeed
> Mahameed <saeedm@mellanox.com>; Leon Romanovsky <leon@kernel.org>;
> Ido Schimmel <idosch@mellanox.com>; Danielle Ratson
> <danieller@mellanox.com>
> Subject: Re: [RFC PATCH net-next v2 0/6] introduce PLDM firmware update
> library
> 
> On Fri, 17 Jul 2020 11:35:35 -0700 Jacob Keller wrote:
> > This series goal is to enable support for updating the ice hardware flash
> > using the devlink flash command.
> 
> Looks reasonable.
> 
> You have some left over references to ignore_pending_flash_update in
> comments, and you should use NLA_POLICY_RANGE() for the new attr.
> 

Ah, good point I'll make sure to fix those up, and switch the NLA_POLICY_RANGE.

> Taking and releasing the FW lock may be fun for multi-host devices if
> you ever support those.

Yea. The lib/pldm stuff assumes the driver will manage the locking. I'm not sure how the resource locks work in a multi-host environment at all..

Thanks,
Jake
