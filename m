Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E63E274117
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgIVLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:42:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbgIVLlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:41:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MBVKZd029640;
        Tue, 22 Sep 2020 04:40:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pfpt0220; bh=PP2BtTa35HsPOit2soWgIXbF5jpAsVLP7kOQ9lv+kro=;
 b=LB9hdQsWrpRyQ5C0sn+4kjpbGcP4QfcSln3ekDbaK8c3ooeVuY7eTggcIcwNtrlI+tYf
 lZzG1jkrsY/elOr9lSTgK4zJj+af7GsdWL6oCix7eHgm4Q7FMnGJBOEyJbE+9KD2R4IN
 NNYfSFsEaQBjgqisIM+KK4AKdCppSAsJCyrZw00PC/nqbYdLV9z1+SrTIdn3dWFJg9yZ
 KLDRKHNBc++UhhdtaWPlFlBglJo7ZJpvhhO43SG4HIKsCXiKKToRll26r2uYwmRIoMKi
 YIzEaK4HGbPnbzy05z5oGNeQAFQeJt/f9CFH3W/I37z6Vgv8EMPFbBBmzahJD6d4kiEr BQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33nfbpt7ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 04:40:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 04:40:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 04:40:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Sep 2020 04:40:18 -0700
Received: from yoga (unknown [10.95.131.150])
        by maili.marvell.com (Postfix) with ESMTP id E49BE3F7048;
        Tue, 22 Sep 2020 04:40:16 -0700 (PDT)
Date:   Tue, 22 Sep 2020 13:40:15 +0200
From:   Stanislaw Kardach <skardach@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>, <kda@semihalf.com>
Subject: Re: [PATCH net-next v2 3/3] octeontx2-af: add support for custom KPU
 entries
Message-ID: <20200922114014.rvdohzjwjvlukc3p@yoga>
References: <20200921175442.16789-1-skardach@marvell.com>
 <20200921175442.16789-4-skardach@marvell.com>
 <20200921162643.6a52361d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200921162643.6a52361d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_09:2020-09-21,2020-09-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 04:26:43PM -0700, Jakub Kicinski wrote:
> Date: Mon, 21 Sep 2020 16:26:43 -0700
> From: Jakub Kicinski <kuba@kernel.org>
> To: Stanislaw Kardach <skardach@marvell.com>
> Cc: davem@davemloft.net, sgoutham@marvell.com, netdev@vger.kernel.org,
>  kda@semihalf.com
> Subject: Re: [PATCH net-next v2 3/3] octeontx2-af: add support for custom
>  KPU entries
> 
> On Mon, 21 Sep 2020 19:54:42 +0200 Stanislaw Kardach wrote:
> > Add ability to load a set of custom KPU entries via firmware APIs. This
> > allows for flexible support for custom protocol parsing and CAM matching.
> > 
> > The firmware file name is specified by a module parameter (kpu_profile)
> > to allow re-using the same kernel and initramfs package on nodes in
> > different parts of the network where support for different protocols is
> > required.
> > 
> > AF driver will attempt to load the profile from the firmware file and
> > verify if it can fit hardware capabilities. If not, it will revert to
> > the built-in profile.
> > 
> > Next it will read the maximum first KPU_MAX_CST_LT (2) custom entries
> > from the firmware image. Those will be later programmed at the top of
> > each KPU after the built-in profile entries have been programmed.
> > The built-in profile is amended to always contain KPU_MAX_CSR_LT first
> > no-match entries and AF driver will disable those in the KPU unless
> > custom profile is loaded.
> 
> So the driver loads the firmware contents, interprets them and programs
> the device appropriately?
> 
> Real firmware files are not usually interpreted or parsed by the driver.

Correct. I'm using the firmware file as a delivery method for a custom
configuration. There are several reasons why I chose it:

1. The parsing engine (KPU) has to be configured fully at RVU AF device
   probe, before any networking part of that or other RVU devices is
   configured. So I think this rules out devlink, ioctl or sysfs.
2. The configuration is rather extensive so cramping it into module
   parameters doesn't seem right.
3. Adding it to Device Tree in form of custom nodes makes update process
   risky to some users (as opposed to switching firmware file on a
   filesystem).
4. The request_firmware API provides a nice abstraction for the blob data
   source so I thought it might as well be used for fetching data of a
   known structure. Especially that the full layout is visible in the
   kernel and users might create those files themselves by hand.

That said all above might be because I'm unaware of a better interface to
use in such situation. If there is, I would be obliged if you could point
me in the right direction.

Stanislaw Kardach
