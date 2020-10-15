Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C6828F15D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgJOLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:34:18 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:27797 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgJOLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761657; x=1634297657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=K5125LgfPLC5YBwpxAqbylzaGWeeFwuMFZBxHzf/rTw=;
  b=bQvRXvcj7pgPbw19sSkA/pzqbm0gH6VVHFa1HA53Ulp6vZZ3HieSUO+b
   WOLr+l0UvFPJThCUdsj4GJDHqMOcu6fJa+YETGfU3wodZfmSGYDWtiPYv
   SQ+klvN7ALMoDD+gSPIRrSJgwPyi3uw2J0NQye8WGYOqPUF1trI/HwjJD
   ewhlPWhXSSCNIkWJjSVGUDQZXD02ELzlYZuDJlXuLw5AJmRueIjtE/lc3
   v7x+1bs39+t5DjsU829+XiCAVcmSP8lrUFIU+ImcZsE0+mevBpfT52lLH
   945J9R0M8vL49CQKl9Jw/3PTBVzgpvT1zpu6Myi+Y50G9SZvUtwbTdzCF
   Q==;
IronPort-SDR: silQg3D64j1zcpKN82/PLWHWwCF4ekn8C/wv8sZGx2x9JRF6qfuKmUb5leQtBeH/ltt6oklf+0
 N/9WE4F1CDSkphzciApwDqc2YTUehlIw6asLkit9bNDvDbIVVDfqyCF22MJLju1yJ6DxPpPLPd
 qhKnnLYfhbxpcObemiO52iFV7ieShceVAXNUdhhCu57wnQZDRWCPWwy2/I7kkhcQNPBgz6FvKb
 uO86zTUoG8aPv2sGpN+KDqN8IiaeXMp3Q81RSU1W1pOlxtN8QVi9Na7rctYjRTPOdA37bWJ1w1
 d8Q=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="29986693"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:34:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:34:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:34:16 -0700
Date:   Thu, 15 Oct 2020 11:32:36 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 00/10] net: bridge: cfm: Add support for
 Connectivity Fault Management(CFM)
Message-ID: <20201015113236.iubkh5brahbkttio@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201014155847.2eb150f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201014155847.2eb150f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 15:58, Jakub Kicinski wrote:> 
> On Mon, 12 Oct 2020 14:04:18 +0000 Henrik Bjoernlund wrote:
> > Connectivity Fault Management (CFM) is defined in 802.1Q section 12.14.
> >
> > Connectivity Fault Management (CFM) comprises capabilities for detecting, verifying,
> > and isolating connectivity failures in Virtual Bridged Networks.
> > These capabilities can be used in networks operated by multiple independent organizations,
> > each with restricted management access to each other’s equipment.
> 
> Please wrap the cover letter and commit messages to 70 chars.
> 

I will do that,

> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> 
> You have two spaces after the name in many tags.

I will change as requested.

-- 
/Henrik
