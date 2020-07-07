Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0F1216A80
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgGGKiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:38:14 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11032 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGGKiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594118292; x=1625654292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ozbUrXV0dyb5Rt/mvrYVy1sz3akHZYnoBX6bcXtjqo4=;
  b=stLo176MAU/VNb3iZv8m1pDxp2+Y1dbHd25tp+9SbeALYD3J0I12v4+E
   Schg4PCUSnlOCSXsM9ruabrTIGQVNWIHChYuzlZtygW2oUdW7RZbm7UWT
   MYoMOcbKJzmXSgOU29Tbhpu9airRhLjX++cEmp6v/gvsB6W1ZunjGguaq
   9ifM6EFXnW9Khqcp4xOlN6gAt+I5gzVD9/kjA9MANp9FQdkaGv48LPKl0
   9iAjr+kleRggO2xLHZAzL07wweHzxAp+SzfcSt3FofQet82MaleZQi3qM
   oSM0w7yuUFv3NCFb15Sk+bjLzHo1aEWl6+XRHzoZDAjW6OdTq8wij1LFU
   Q==;
IronPort-SDR: fkBMoEwKctoC3ZDur5hiyIxKadigUb/M44uhaHsz9VI/9sLnv1n6ne/GBXwhld251q8v9LWXqH
 J8C3pGnLWdsSyDgqaH9jVPHBJ4j6SFamDQLpH/CySSQogepn/VlI+2nrGOT2cuwLCuwMxM8uM3
 oE4criLozyDA2LoRe10fI2Uu9HoOYhFVv6hJxR+VahxKRdeIx/zSnh0XLCwWkgcXSIvIzCWYuH
 T14O7oKmV9u3+NzPuBUYRRQf/lt8FiGoJ3wNJOEhqStO2hDlZN5LhdtfYYL4foUM7suzOu8IJm
 JYQ=
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="82813728"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jul 2020 03:38:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 03:37:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 7 Jul 2020 03:37:47 -0700
Date:   Tue, 7 Jul 2020 12:38:06 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     David Miller <davem@davemloft.net>
CC:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <kuba@kernel.org>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 01/12] switchdev: mrp: Extend switchdev API for
 MRP Interconnect
Message-ID: <20200707103806.wlocq6aasbaf4pty@soft-dev3.localdomain>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
 <20200706091842.3324565-2-horatiu.vultur@microchip.com>
 <20200706.122626.2248567362397969247.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200706.122626.2248567362397969247.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/06/2020 12:26, David Miller wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 6 Jul 2020 11:18:31 +0200
> 
> > +/* SWITCHDEV_OBJ_ID_IN_TEST_MRP */
> > +struct switchdev_obj_in_test_mrp {
> > +     struct switchdev_obj obj;
> > +     /* The value is in us and a value of 0 represents to stop */
> > +     u32 interval;
> > +     u8 max_miss;
> > +     u32 in_id;
> > +     u32 period;
> > +};
>  ...
> > +#define SWITCHDEV_OBJ_IN_TEST_MRP(OBJ) \
> > +     container_of((OBJ), struct switchdev_obj_in_test_mrp, obj)
> > +
> > +/* SWICHDEV_OBJ_ID_IN_ROLE_MRP */
> > +struct switchdev_obj_in_role_mrp {
> > +     struct switchdev_obj obj;
> > +     u16 in_id;
> > +     u32 ring_id;
> > +     u8 in_role;
> > +     struct net_device *i_port;
> > +};
>  ...
> > +#define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
> > +     container_of((OBJ), struct switchdev_obj_in_role_mrp, obj)
> > +
> > +struct switchdev_obj_in_state_mrp {
> > +     struct switchdev_obj obj;
> > +     u8 in_state;
> > +     u32 in_id;
> > +};
> 
> Please arrange these structure members in a more optimal order so that
> the resulting object is denser.  For example, in switchdev_obj_in_role_mrp
> if you order it such that:
> 
> > +     u32 ring_id;
> > +     u16 in_id;
> > +     u8 in_role;
> 
> You'll have less wasted space from padding.
> 
> Use 'pahole' or similar tools to guide you.

Thanks, I will try to use 'pahole' and see how they need to be arranged.

-- 
/Horatiu
