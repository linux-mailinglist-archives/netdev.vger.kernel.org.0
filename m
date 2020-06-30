Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80620FBF5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgF3SpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:45:13 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:61133 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3SpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593542712; x=1625078712;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gVXFKwkoilJ+WRsAX2ilDSQvX1wsECjHxbakjfFTTiA=;
  b=tGZFtzXvjzO9lbqNel/0gcYL4b4H+zhgg3c4Dnt4UZCgiT2VgKFm448F
   RGSERHcKSG9aisUbyRWvhi6+ZI468HnjmvF3E1JgyUnRKbnINzecotvNV
   EOBBooR4ItH4rowB2QvtgbYMkz1bcCy7xLMV0rO9Dwx6bqajdQKMh+b2L
   XGqHl395ojo/leeoyk+9XOuQBtD9lSMsnJ6YUvx5asBl4v5OEnytjF3Ly
   /K1wxhHF5Nwuo718zhvP0Sd9NUDSUzlw8FgyRuXM6Yzu76Txs66COEgHO
   VOiE17X4BZkO/zmJrQmigt+KPJi1tfg+JJ9Rnk76+rs/yeSjqd6Ey8mcd
   Q==;
IronPort-SDR: B2IzWVA38/w48UWB3itF4A+Rwr6HJm/1RLFOSZ1jh39DRujU3c63OwDplG43A2Tbp2nc5hoNrz
 Q5KdOLy+yOLRAA4y0rrUYrDsk2evMj9CnJcr3+92gd9QLctf+O+80XTKTEiXCSq6hvhrqFw8ep
 6BkF3fRKu6/AGsvBMp7b1qD46yAVTV42KfDZEI657Qbg8LSn/k7C8lyVgszI6rwAjNcnzt0khD
 5HTDUhLIQENl3UyPtxLlx4dmMmgDUmFpeLIffoAg+i1Hm70/VWNsjhmjWEPtGkIxXMilVAzEkc
 YQE=
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="17608615"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2020 11:45:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 11:45:11 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 30 Jun 2020 11:45:11 -0700
Date:   Tue, 30 Jun 2020 20:45:09 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 2/3] bridge: mrp: Add br_mrp_fill_info
Message-ID: <20200630184509.oliwf3ui4gxno756@soft-dev3.localdomain>
References: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
 <20200630134424.4114086-3-horatiu.vultur@microchip.com>
 <20200630091243.124869e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200630091243.124869e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/30/2020 09:12, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 30 Jun 2020 15:44:23 +0200 Horatiu Vultur wrote:
> > Add the function br_mrp_fill_info which populates the MRP attributes
> > regarding the status of each MRP instance.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> This adds warnings when built with W=1 C=1:

The warnings at line 316 will be fixed once net will be merged into
net-next. But I need to fix the others.

> 
> net/bridge/br_mrp_netlink.c:316:9: warning: dereference of noderef expression
> net/bridge/br_mrp_netlink.c:325:36: warning: dereference of noderef expression
> net/bridge/br_mrp_netlink.c:328:36: warning: dereference of noderef expression
> net/bridge/br_mrp_netlink.c:316:9: warning: dereference of noderef expression

-- 
/Horatiu
