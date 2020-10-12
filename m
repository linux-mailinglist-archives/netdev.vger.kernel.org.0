Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F3728B5BB
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388681AbgJLNOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:14:47 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:58231 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730444AbgJLNOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508486; x=1634044486;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uXTNY8a8tuZF0KFVmfREJP/EwiyPuPGpWMVASP/6Lpg=;
  b=szOI02t0ZyS7Iu7YiLFHx8A5ILEoHETlaeEUb9ZLxO1dkMLpu2hc5Hsd
   p1yDnHaktl6DQ5+pJaOx9k0lUlpb+yvipyELo+SVwAN54tV0XBzyp7E4G
   KBCcEESt5VMle2BzMd7JAMvR9enKx6sMTej9pKq2yD6ww0xlMeDAV1HLh
   U35la75P+7TZ9H2QsBCZXc3ZpPs7TCtQaGqu7z6aCk6xIq+02WAy6NUFf
   L2Dg5iwfjNzbw4ikLLE4ou0hjChN4wmtIzXosiK/zMbMNcAOpdQNJWgk8
   usAFJZMBW5l30nbjp+mRyO9z3cqUGYHZQ7DXU8vG2ND+xUGFLgEDwzzOD
   w==;
IronPort-SDR: iYsowwes9JlAUw7kme3W4EdixpwaqGu67jeDmGQdyIOqXupMtVoRQifvHPyWOhhbFr2E28J6cC
 lHJoltMTAjk3o6wKxgJnIcCzGObmYBMYG4adk0BqB3KW/PKh+d8f2PZ5zdFvprV4+DRy1iIgbO
 DAL9Sa4H+C19ywkA1QyXjxq+zH08JjefSajosiYuPmFncoksGUnBvksFs+HuTxObadyeQWfJ8Z
 KK1Y9Px8koaf9ZsXL3SCZAyvPbLW3FpauwQPXOmuAoQirDaOBmB12IpcO0FrbXYz+Dlb/7NVAk
 tig=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="95012027"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:14:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:14:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:14:45 -0700
Date:   Mon, 12 Oct 2020 13:13:00 +0000
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
Subject: Re: [PATCH net-next v4 03/10] bridge: uapi: cfm: Added EtherType
 used by the CFM protocol.
Message-ID: <20201012131300.e7moweci4a475qa3@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-4-henrik.bjoernlund@microchip.com>
 <eda6fb9c0535077be89d2ee7dd9f7e12f730ef68.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <eda6fb9c0535077be89d2ee7dd9f7e12f730ef68.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

The 10/09/2020 21:41, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This EtherType is used by all CFM protocal frames transmitted
> > according to 802.1Q section 12.14.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> > ---
> >  include/uapi/linux/if_ether.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

-- 
/Henrik
