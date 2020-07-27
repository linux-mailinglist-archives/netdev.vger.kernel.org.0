Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C570222F76B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgG0SNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:13:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:38502 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgG0SNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:13:14 -0400
IronPort-SDR: Mae2VsacWQ2c182iUELBRe3ztMazVkGL7BAoPkPZv0y8iVgkYf7k8SFOb2r1qJaZwlrC3tGnVN
 F1mJzBu3I8fw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="151074235"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="151074235"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 11:13:14 -0700
IronPort-SDR: bECq3yAHCoAU/A3B+bGqlWk7J/jurYn5BBVzWMj1zhTLHzvpPSuSEjNMYFdDMeB2DL+LaDodWr
 8mXpEJdYxXlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="303553719"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 11:13:13 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
 <20200726071606.GB2216@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <cfbed715-8b01-2f56-bc58-81c7be86b1c3@intel.com>
Date:   Mon, 27 Jul 2020 11:13:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200726071606.GB2216@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/2020 12:16 AM, Jiri Pirko wrote:
> Wed, Jul 22, 2020 at 05:30:05PM CEST, jacob.e.keller@intel.com wrote:
>>
>>
>>> -----Original Message-----
>>> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
>>> Visible in which sense? We don't show components anywhere if I'm not
>>> mistaken. They are currently very rarely used. Basically we just ported
>>> it from ethtool without much thinking.
>>>
>>
>> Component names are used in devlink info and displayed to end users along with versions, plus they're names passed by the user in devlink flash update. As far as documented, we shouldn't add new components without associated versions in the info report.
> 
> Okay. So it is loosely coupled. I think it would be nice to tight those
> 2 togeter so it is not up to the driver how he decides to implement it.
> 
I felt the coupling was quite clear from Jakub's recent documentation
improvements in the devlink-flash.rst doc file.

Are you thinking find some way to tie these two lists more closely in code?

Thanks,
Jake
