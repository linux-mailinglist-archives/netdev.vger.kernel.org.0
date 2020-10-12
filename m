Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4728B5B1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgJLNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:13:31 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58116 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgJLNNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508410; x=1634044410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/uHY5C97UGg9fIbk/wKP58Fy+ohxLvbrLp3RjXnau48=;
  b=TtJEk/FRENJAgRXzOiXpEYCkwSPAnJkxkq4TOdLyruDSxepb/CtC1u9A
   uuwnLkiHdkX+pq68XFrOpRWQM1gn5HVKiGiBxm9Vivld65GGyxgKSMYRd
   tBF/VmewBeER1nFgAGiH3QUQ2pWvfG078Obk8cFBla6k4kLS/c+DhvBAc
   ftmgZL/shYFpZPuHJdRyFAqleitL2YHEmSyfvWbVnyHH8H1nacvEcVRM0
   bXjRYB6SDkm6CWpisxB04gnTcvfs0CGk6mHUgdmLFYvZwxqFacleBRwTf
   IDH7JUbSA2HSePn+dT114pdYccYMdAejB+KpaP4pf7exd2c9vCLRNHtSE
   Q==;
IronPort-SDR: SJsfPXhi5E/RWB/+ANmezhdyH1CiejVZgEaHPFFmDpppNaBJL0j3tvhs69yQSBJl09mE0Okl++
 iqazE4UVg7U3qs1/WWXuBmrdR4xbhqCRiXlLsN7k1BUqzqJcyv5fKon05nC0QN5nOlHHOkW7PR
 +73kAs3upoiHsFQWaGiWOKKyvWpsY9bCpRy6kK4jVt7fFZwRWv61nA9+IpB8mkTP6Pjjukyc7f
 3m70Neu9lAVODXn/jOtD50kEZuvmHK+4plaRPkYfaNtzm95UmNOTARf0nCXzT5FarCVtU9ix9S
 32o=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="95011865"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:13:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:13:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:13:30 -0700
Date:   Mon, 12 Oct 2020 13:11:44 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 05/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame TX added.
Message-ID: <20201012131144.rpqcx2iyt7jjkih3@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-6-henrik.bjoernlund@microchip.com>
 <a091e766d38c00ef4d70b3bc003e16dc3747789b.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <a091e766d38c00ef4d70b3bc003e16dc3747789b.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

The 10/09/2020 21:49, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This is the second commit of the implementation of the CFM protocol
> > according to 802.1Q section 12.14.
> >
> > Functionality is extended with CCM frame transmission.
> >
> > Interface is extended with these functions:
> > br_cfm_cc_rdi_set()
> > br_cfm_cc_ccm_tx()
> > br_cfm_cc_config_set()
> >
> > A MEP Continuity Check feature can be configured by
> > br_cfm_cc_config_set()
> >     The Continuity Check parameters can be configured to be used when
> >     transmitting CCM.
> >
> > A MEP can be configured to start or stop transmission of CCM frames by
> > br_cfm_cc_ccm_tx()
> >     The CCM will be transmitted for a selected period in seconds.
> >     Must call this function before timeout to keep transmission alive.
> >
> > A MEP transmitting CCM can be configured with inserted RDI in PDU by
> > br_cfm_cc_rdi_set()
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/cfm_bridge.h |  39 ++++-
> >  net/bridge/br_cfm.c             | 284 ++++++++++++++++++++++++++++++++
> >  net/bridge/br_private_cfm.h     |  54 ++++++
> >  3 files changed, 376 insertions(+), 1 deletion(-)
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 

-- 
/Henrik
