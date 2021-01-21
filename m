Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B402FF8A1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAUXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:20:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:56109 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbhAUXTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 18:19:52 -0500
IronPort-SDR: nVX5DdTrDkgzXqJXzVf54VqFrPL4KK9pEgY7Z/Ip6xZNQm2wj8GmdtDzXVMXyvjT5o1TQ82iqg
 zXEXreG9Mn2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="243441034"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="243441034"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:19:09 -0800
IronPort-SDR: dLUa+otTXyjROyoleikc5ecb0unsRidSasWGWQUEobFyzdXDjSJL7xg3K6R1/HeHKlfOmlcu1o
 1PfAo5yrZT1Q==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="392127285"
Received: from amgiffor-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.124.114])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:19:07 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 6/8] igc: Add support for tuning frame
 preemption via ethtool
In-Reply-To: <20210119182352.17635829@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
 <20210119004028.2809425-7-vinicius.gomes@intel.com>
 <20210119182352.17635829@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 21 Jan 2021 15:18:56 -0800
Message-ID: <87v9bpx4in.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 18 Jan 2021 16:40:26 -0800 Vinicius Costa Gomes wrote:
>> +		NL_SET_ERR_MSG(extack, "Invalid value for add-frag-size");
>
> NL_SET_ERR_MSG_MOD

Will fix. Thanks.


Cheers,
-- 
Vinicius
