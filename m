Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF828B5C1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388712AbgJLNPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:15:12 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:3087 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388523AbgJLNPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508510; x=1634044510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WbHem3m4Q3i89Pivd83Tm6CpRpEgWOJlMqGFw8xU/Kg=;
  b=gUyuvq1tWYWRvRZxJhzDV2JiqMD8IUhDmMaLn1H78M3tze8K6G6/6fKG
   0Lxhpbd3ii3AL3Pfhx1RffWAaaN5rxfVxQO4GOLLfBjZ9fTY6oEOu+6U+
   8KaZ9SMgwqYj2iEmWFweJ/sEGqagFUxFlp7M6mfxifKrMhse/z91TNnfl
   9C65/+Yir2k7YPD2tmqpYhxA7S3s3V/c3KYGUGx50p2uWRwgGNOFrTzGo
   f3J9Phm3eYKx4MOWVSeLfB6so2/OXrF1Nox1GBKbT8/rYHxujad4GmYfq
   QWOCNUkaznMA3qqHgK2h50nhSZDQ9gWwHg5JE8HSjZserSTY4oWsgfrO7
   Q==;
IronPort-SDR: 2QmRD1kAxMGt5epuEPtKZ6+SMue+ESBgCZTzUgu+x3l00LBicP/QnEE2bVTuoDuQ0wxsis7/oj
 qhyfFREhoczmXFOSRl2sYjpqbfyZ05mpYiTyjVz7kH5Yx2RUWjVPt1mvclfBVK29xT2eTF1eW3
 KpHd0xjMhhzzmVrHvAguZOLm0dkX61a92M+RigBXb48pSDgLXRhYmk0DOZl2WFEdUmBr90g3hy
 AFaL9hJ7NF0fScOpGzP3YJ+2m3fN6o5Xkk7wzJilP4SY3TNM6VVrk2i3P0zbPyua2q4LMbxtTx
 uPE=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="89898620"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:15:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:15:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:15:09 -0700
Date:   Mon, 12 Oct 2020 13:13:24 +0000
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
Subject: Re: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Message-ID: <20201012131324.qlxqxfpamievgrkz@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
 <f3e27f2363bf116ada0f352f263d6cbd051b6a87.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <f3e27f2363bf116ada0f352f263d6cbd051b6a87.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

The 10/09/2020 21:39, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This makes it possible to include or exclude the CFM
> > protocol according to 802.1Q section 12.14.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/Kconfig      | 11 +++++++++++
> >  net/bridge/br_device.c  |  3 +++
> >  net/bridge/br_private.h |  3 +++
> >  3 files changed, 17 insertions(+)
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 

-- 
/Henrik
