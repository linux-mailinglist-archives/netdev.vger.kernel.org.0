Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84952216A86
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgGGKjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:39:42 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11163 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGGKjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 06:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594118381; x=1625654381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vyP5ul9oKsyKcotv3JQDPSfPwCoHDgatMb5V6gzJi3U=;
  b=dUdjgT+iGzT11kISBRvfocj0Zu+KnjBAUTRc8w+nMgMJOQ54IhbVYeF/
   /eZid8dGFbD2oXQ1CB0RxrSKGV9cpvawznPHAIJtkm+l+qyz7YtaomnHl
   dROQ/6Zn9ea4icXISwVOWHEewyC6fgbQVVFWkvcl7VF2LqgL9/T2GTrU1
   XMSwUCVjFQZZvdfuBwCmHWUZY3q1FsTU3yFDTzbTBb3+m0R5UhJeib17O
   CJ51Z5nA6783JLjrWX9vIyxfDFEYcJd0SzDoh7n8abXCmNanThuHEJKSX
   e786NjeT8KEmFAooDt4/Ib2oVp14o4i4fb6MROOF6gNTj2M9yzDBnyQvD
   w==;
IronPort-SDR: VTytonoJQ8YRJQemsmG1nj232WAsBk9wtIkiUFGByiEsBK+pfvz+q6Uzt9oJYBDBi7G/NAShoX
 FGnS1Wwi1/9QNiGf2Vras6dNjuOXFZc9zmyKaU5Sb1zvGrKdyb+uSq31G/NSICAKY2LaZnWlv4
 q6kDxz+9AYRlkNgoiJSKAvPzk2J0WaHCkV1RkC694dkws1JAQMUTZZsIPnS0iT81lANOOSI7HK
 Qpp32DvNQQu7+6f8XMr+UTDolR6e7tUErCZpAI8OnPnq04EMpU1MQA7Lp+M4QchqyhL8Hdbaks
 W6I=
X-IronPort-AV: E=Sophos;i="5.75,323,1589266800"; 
   d="scan'208";a="82813878"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jul 2020 03:39:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 03:39:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 7 Jul 2020 03:39:40 -0700
Date:   Tue, 7 Jul 2020 12:39:39 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     David Miller <davem@davemloft.net>
CC:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <kuba@kernel.org>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 02/12] bridge: uapi: mrp: Extend MRP attributes
 for MRP interconnect
Message-ID: <20200707103939.basybe2a3haweki2@soft-dev3.localdomain>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
 <20200706091842.3324565-3-horatiu.vultur@microchip.com>
 <20200706.122748.828248704525141203.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200706.122748.828248704525141203.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/06/2020 12:27, David Miller wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 6 Jul 2020 11:18:32 +0200
> 
> > +struct br_mrp_in_state {
> > +     __u16 in_id;
> > +     __u32 in_state;
> > +};
> 
> Put the __u32 first then the __u16.
> 
> > +struct br_mrp_in_role {
> > +     __u16 in_id;
> > +     __u32 ring_id;
> > +     __u32 in_role;
> > +     __u32 i_ifindex;
> > +};
> 
> Likewise.
> 
> > +struct br_mrp_start_in_test {
> > +     __u16 in_id;
> > +     __u32 interval;
> > +     __u32 max_miss;
> > +     __u32 period;
> > +};
> 
> Likewise.
> 
> > +struct br_mrp_in_test_hdr {
> > +     __be16 id;
> > +     __u8 sa[ETH_ALEN];
> > +     __be16 port_role;
> > +     __be16 state;
> > +     __be16 transitions;
> > +     __be32 timestamp;
> > +};
> 
> Likewise.  Put the larger members first.  There is lots of unnecessary
> padding in this structure.

I will do the same here, except for the 'struct br_mrp_in_test_hdr'
because this represents the frame header for InTest frames. And this is
defined in the standard how it has to be. But I will do it for the other
structures.

> 

-- 
/Horatiu
