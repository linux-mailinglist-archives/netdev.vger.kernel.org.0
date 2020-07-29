Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69B232870
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgG2X7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:59:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:52930 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgG2X7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 19:59:50 -0400
IronPort-SDR: aCygtU7H57cr8DKXFikcb8vewY3RNXb7GsMSvQP8L8PPldUCKHFcTvbqwgElZC6P6qSGH8yBEM
 qLsJuJk0WiSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="149351961"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="149351961"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 16:59:49 -0700
IronPort-SDR: nHQhp1G2jHjFJ6RKOjJdrqRfcLV4g4qvz5XepqyYbBnIiqN2hjD9g/nBFYzyooPNwfxnfMb8q+
 iZMnVWJ4X4Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="304385635"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.162.155]) ([10.212.162.155])
  by orsmga002.jf.intel.com with ESMTP; 29 Jul 2020 16:59:48 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
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
 <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a0994590-f818-43cd-6c28-0cd628be9602@intel.com>
 <20200729161603.1aeeb5cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ac6f072e-e660-8739-d7d2-58cba85d8489@intel.com>
Date:   Wed, 29 Jul 2020 16:59:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200729161603.1aeeb5cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2020 4:16 PM, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 15:49:05 -0700 Jacob Keller wrote:
>> The security revision is tied into the management firmware image and
>> would always be updated when an image is updated, but the minimum
>> revision is only updated on an explicit request request.
> 
> Does it have to be updated during FW flashing? Can't it be a devlink
> param?
> 

Oh, right. I'd forgotten about that type of parameter. Makes sense. I'll
implement the current security revision as a component of flash info (so
that it can be reported via devlink info, and can't be changed) but the
minimum should be able to be a parameter just fine.

Thanks,
Jake
