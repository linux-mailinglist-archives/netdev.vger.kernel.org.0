Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE36522459A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGQVIF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 17:08:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:24077 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgGQVIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 17:08:04 -0400
IronPort-SDR: xMQLkbb3CCQoxdxb7Yz0LDZ7ZwmWm7oscUxEMK2QBk/NA42JP6BJ+WsaRI0iS2VU1IigDhqAHx
 rGzQNQeb16Sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="137146868"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="137146868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 14:08:04 -0700
IronPort-SDR: xG6r19f/uWWCTGmYOgGHysekqhnQDu8RWyq4WjriYk8Ah6ob3DoQpjMSQZyeTuF4wJxixi7g6X
 ZeVyrIuJcVyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="391500138"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jul 2020 14:08:03 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 17 Jul 2020 14:08:03 -0700
Received: from orsmsx151.amr.corp.intel.com ([169.254.7.24]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.100]) with mapi id 14.03.0439.000;
 Fri, 17 Jul 2020 14:08:03 -0700
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
Thread-Index: AQHWXGkVCyNxIZF1QUWKu5DGKx31NqkMpcoA//+d8vA=
Date:   Fri, 17 Jul 2020 21:08:02 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8ABAA13@ORSMSX151.amr.corp.intel.com>
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

Since the minimum value is zero, I switched the code to use NLA_POLICY_MAX.

Thanks,
Jake
