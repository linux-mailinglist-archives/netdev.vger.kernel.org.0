Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3E30FFBF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBDVyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:54:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:5127 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBDVyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 16:54:20 -0500
IronPort-SDR: 6D0e4ye0gnyGNTT4pfY8AdV4A2B+oNBCNmaWHbMCX4rJ79b6OBjFNAo7Qk9sPdfoGMpC8raJ8U
 6N9hYAkMdseg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="180558418"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="180558418"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 13:53:39 -0800
IronPort-SDR: vGwhRjrvTnJEXCAmOmQRXia8IRDwe7V8Ybb3Bwf7vt5/PUdwPeW26SotEZgzCze2p/Il9GZyCq
 H0LXMQxTuuTw==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393466601"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.103.68]) ([10.209.103.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 13:53:36 -0800
Subject: Re: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
 <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
 <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
Organization: Intel Corporation
Message-ID: <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
Date:   Thu, 4 Feb 2021 13:53:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/2021 11:10 AM, Jacob Keller wrote:
> I'd rather see the right solution designed here, so if this isn't the
> right direction I want to work with the list to figure out what makes
> the most sense. (Even if that's "minimum security should update
> automatically").
>
I want to clarify here based on feedback I received from customer
support engineers: We believe it is not acceptable to update this
automatically, because not all customers want that behavior and would
prefer to have control over when to lock in the minimum security revision.

Previous products have behaved this way and we had significant feedback
when this occurred that many of our customers were unhappy about this,
even after we explained the reasoning.

I do not believe that we can accept an automatic/default update of
minimum security revision.
