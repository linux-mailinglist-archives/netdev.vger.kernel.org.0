Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC3316673
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhBJMTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:19:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9543 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhBJMQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612959399; x=1644495399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KccJACx3UzbVR7vSn7sUPz8lucKU1UmDl4AZFOnoBwk=;
  b=n76DgecbmO7+ptzQOOzHglLvcMPzPEle7FBizazAyD3QUwPBSn14SoYz
   Fyt9C//Xe8jtFK0mM4T87gE31vpXEfqjVgpEJZ9PE7fbqEQtJXtstwCbI
   gG3djc51UQqOI8AZjlymvZ7nI7ThYO7zeryWjbNY1w9MDSCtGo7yuejcQ
   Gx0k/mIOoAcVHkNsgFzvO/XaIzujgoxJQU8ggNlGQwGjkI0uqCdqdsq/D
   sUNycT+AlvtRVe+Quyi04uwQUpp5XP6P7kLcSgqbKDvigTSCSDUbTOGYH
   HR5ivdYT72Exz93cL6WwDMouL3eDQPu1L0tlf7ssiNFXrdy9ISUzPt4e8
   A==;
IronPort-SDR: 6But5P5zXLp4ILDsM0zJcJXdRBox4KKHdUQHsa3kUKlhKboHKmbenpiLEG025yfVo4p6QS5v5c
 59OoTMuk0fmg5ZYkdAYdE6eWpwtfNWT1xHmLsAA6IMBhA7CymZHtRDnKuIpbkMEpAuwft5fRFx
 WeELxPjiPpU4FnhYO5cy0coHwaUYUAAzkOzfJo/rao2AWj8w0S3SEavYByXY3cKMKoVj5Z8ruv
 LVLSkv5L6ne+9VxWoUTtfNi9EQzaxAKzojg4hPkrX9lCh+OcAOPkc2Zikbn1VOQT8MmB7KgpV8
 FPU=
X-IronPort-AV: E=Sophos;i="5.81,168,1610434800"; 
   d="scan'208";a="103288808"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 05:15:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 05:15:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 10 Feb 2021 05:15:16 -0700
Date:   Wed, 10 Feb 2021 13:15:16 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v3 0/5] bridge: mrp: Extend br_mrp_switchdev_*
Message-ID: <20210210121516.h2whdmshs2pyvuy5@soft-dev3.localdomain>
References: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
 <20210210100831.acnycww3wkeb6imt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210210100831.acnycww3wkeb6imt@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/10/2021 10:08, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Horatiu,
> 
> On Tue, Feb 09, 2021 at 09:21:07PM +0100, Horatiu Vultur wrote:
> > This patch series extends MRP switchdev to allow the SW to have a better
> > understanding if the HW can implement the MRP functionality or it needs
> > to help the HW to run it. There are 3 cases:
> > - when HW can't implement at all the functionality.
> > - when HW can implement a part of the functionality but needs the SW
> >   implement the rest. For example if it can't detect when it stops
> >   receiving MRP Test frames but it can copy the MRP frames to CPU to
> >   allow the SW to determine this.  Another example is generating the MRP
> >   Test frames. If HW can't do that then the SW is used as backup.
> > - when HW can implement completely the functionality.
> >
> > So, initially the SW tries to offload the entire functionality in HW, if
> > that fails it tries offload parts of the functionality in HW and use the
> > SW as helper and if also this fails then MRP can't run on this HW.
> >
> > Also implement the switchdev calls for Ocelot driver. This is an example
> > where the HW can't run completely the functionality but it can help the SW
> > to run it, by trapping all MRP frames to CPU.
> >
> > v3:
> >  - implement the switchdev calls needed by Ocelot driver.
> > v2:
> >  - fix typos in comments and in commit messages
> >  - remove some of the comments
> >  - move repeated code in helper function
> >  - fix issue when deleting a node when sw_backup was true
> >
> > Horatiu Vultur (5):
> >   switchdev: mrp: Extend ring_role_mrp and in_role_mrp
> >   bridge: mrp: Add 'enum br_mrp_hw_support'
> >   bridge: mrp: Extend br_mrp_switchdev to detect better the errors
> >   bridge: mrp: Update br_mrp to use new return values of
> >     br_mrp_switchdev
> >   net: mscc: ocelot: Add support for MRP
> >
> >  drivers/net/ethernet/mscc/ocelot_net.c     | 154 +++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c |   6 +
> >  include/net/switchdev.h                    |   2 +
> >  include/soc/mscc/ocelot.h                  |   6 +
> >  net/bridge/br_mrp.c                        |  43 ++++--
> >  net/bridge/br_mrp_switchdev.c              | 171 +++++++++++++--------
> >  net/bridge/br_private_mrp.h                |  38 +++--
> >  7 files changed, 327 insertions(+), 93 deletions(-)
> >
> > --
> > 2.27.0
> >
> 

Hi Vladimir,

> Which net-next commit can these patches be applied to? On the current
> master I get:

Sorry for this. I had an extra patch when I created these patches. And
based on this I have added the patch series. This extra patch was this
one:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b2bdba1cbc84

Which was already applied to net. And I wanted to have it to be able to
do more complete test of this patch series. Next time I should be more
careful with this.

> 
> Applying: switchdev: mrp: Extend ring_role_mrp and in_role_mrp
> Applying: bridge: mrp: Add 'enum br_mrp_hw_support'
> Applying: bridge: mrp: Extend br_mrp_switchdev to detect better the errors
> error: patch failed: net/bridge/br_mrp_switchdev.c:177
> error: net/bridge/br_mrp_switchdev.c: patch does not apply
> Patch failed at 0004 bridge: mrp: Extend br_mrp_switchdev to detect better the errors
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

-- 
/Horatiu
