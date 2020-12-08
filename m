Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC76B2D1EEF
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgLHAYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:24:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:2884 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgLHAYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:24:44 -0500
IronPort-SDR: f329wRf7mhGceRp4WMPq0ahwGcqZk5bROScxaXD4HcmEyIWoWtSWSNTVIzCQmHLxBcXpa/BIZL
 GNTnXCPW/Dyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="170295288"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="170295288"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 16:24:03 -0800
IronPort-SDR: FXZs/AawAe8wQxN5ggxkU3QHCStmZCMzejW+1SZPLuF9dm36FU1ukokTFak3LtgaZX7JZodDXs
 6mV532PeRaQw==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="317457183"
Received: from seherahx-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.17.196])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 16:24:02 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
In-Reply-To: <20201207152126.6f3d1808@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201202045325.3254757-2-vinicius.gomes@intel.com>
 <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87eek11d23.fsf@intel.com>
 <20201207152126.6f3d1808@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 07 Dec 2020 16:24:02 -0800
Message-ID: <87blf5ywkd.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 07 Dec 2020 14:11:48 -0800 Vinicius Costa Gomes wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> >> + * @min_frag_size_mult: Minimum size for all non-final fragment size,
>> >> + * expressed in terms of X in '(1 + X)*64 + 4'  
>> >
>> > Is this way of expressing the min frag size from the standard?
>> >  
>> 
>> The standard has this: "A 2-bit integer value indicating, in units of 64
>> octets, the minimum number of octets over 64 octets required in
>> non-final fragments by the receiver" from IEEE 802.3br-2016, Table
>> 79-7a.
>
> Thanks! Let's drop the _mult suffix and add a mention of this
> controlling the addFragSize variable from the standard. Perhaps 
> it should in fact be called add_frag_size (with an explanation 
> that the "additional" means "above the 64B" which are required in
> Ethernet, and which are accounted for by the "1" in the 1 + X
> formula)?

Sounds good :-) Will add a comment with the standard reference and
change the name to 'add_frag_size'.


Cheers,
-- 
Vinicius
