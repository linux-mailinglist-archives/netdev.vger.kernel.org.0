Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6A294A5D
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441241AbgJUJTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:19:00 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61420 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437569AbgJUJTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603271939; x=1634807939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+rVpCXr52dnGbmc7Y9HfkgfgWTlzu8JQ4Bcf4/Mlfb4=;
  b=BD4riH1AWyNHwErYYV5N1xuAtNzKOQM5k1N5TmF2fWSCAOO0J7K17N99
   aFHs0WrJsDxErYy5GlM8jKNOvWuIEslaqIfmdjTYXBhJhoyIECZe6C9IO
   S7FN5s3WYF3b4N5FG0j/Ntaxd5XS7LLU5cB0OdDX/PcLHDTdOuE9b+eHS
   CrfxZXAnTE6MwMAKg/ynjH3UhxiekTvYaOP88ax8EWNIUJy+PtGonMc9P
   vFN5ofwWWfCeA/8qu0cNLYVBCzcVsYONYgiZ/oH5/D31F6fjpkfQAldft
   Tmr5Op+zPr+wa6zKyTce+4DjZLFu97POdBzwVXFd0mwPtS1bGHNlFna53
   Q==;
IronPort-SDR: ifd+PM8WlqYDzsrG7H1uCjR08Q9aQWKZa34JgqBZuyNrHqiuXfx8QaadFSmhnks9/QiFDnGJMq
 fdVKydKlRSNg3ZslmwsLCUR7vRZtaI7EzPQJhAbFKpjnKge9rm1hgqGGIZ04L36Nk4xVx4Aa3Z
 /1zVm9SmCs6ckMiZ+r+9IzIUyWbQXcltDRnQ8OanlV7gPrWF/odULI+wBAskxjYpNFF292GTyU
 AvygR5gMmrYYdEou1wSeultoMHMyj6sbHaWxgc4V9sUnDXEQmr+TrAs0QTbQs7ZSaoBk/T6Ero
 DxI=
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="93389639"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Oct 2020 02:18:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 21 Oct 2020 02:18:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 21 Oct 2020 02:18:58 -0700
Date:   Wed, 21 Oct 2020 09:17:29 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v6 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Message-ID: <20201021091729.a6wlccjlin5muejt@soft-test08>
References: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
 <20201015115418.2711454-8-henrik.bjoernlund@microchip.com>
 <20201015103431.25d66c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201019085104.2hkz2za2o2juliab@soft-test08>
 <20201019092143.258cb256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201019092143.258cb256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the review. Comments below.

The 10/19/2020 09:21, Jakub Kicinski wrote:> 
> On Mon, 19 Oct 2020 08:51:04 +0000 Henrik Bjoernlund wrote:
> > Thank you for the review. Comments below.
> >
> > The 10/15/2020 10:34, Jakub Kicinski wrote:
> > >
> > > On Thu, 15 Oct 2020 11:54:15 +0000 Henrik Bjoernlund wrote:
> > > > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]     = {
> > > > +     .type = NLA_U32, .validation_type = NLA_VALIDATE_MAX, .max = 7 },
> > >
> > >         NLA_POLICY_MAX(NLA_U32, 7)
> >
> > I will change as requested.
> >
> > >
> > > Also why did you keep the validation in the code in patch 4?
> >
> > In patch 4 there is no CFM NETLINK so I desided to keep the validation in the
> > code until NETLINK was added that is now doing the check.
> > I this a problem?
> 
> Nothing calls those functions until patch 7, so there's no need for
> that code to be added.

I will change as requested.

-- 
/Henrik
